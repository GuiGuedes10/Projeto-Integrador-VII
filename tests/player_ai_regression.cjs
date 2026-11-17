// Executa a logica dos arquivos GML com a API do motor simulada.
// Este subconjunto compativel com JavaScript nao substitui a compilacao GameMaker.
// Uso: node tests/player_ai_regression.cjs
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const read = name => fs.readFileSync(path.join(root, name), 'utf8');
const resetSource = read('scripts/Script_player_ai_reset/Script_player_ai_reset.gml');
const actions = Object.fromEntries(resetSource.match(/enum player_ai_action\s*\{([^}]+)\}/)[1]
    .split(',').map(s => s.trim()).filter(Boolean).map((name, i) => [name, i]));
const identitySource = read('scripts/Script_model_identity/Script_model_identity.gml');
const identityConstants = Object.fromEntries([...identitySource.matchAll(/#macro (\w+) "([^"]+)"/g)].map(([, name, value]) => [name, value]));
const constants = Object.fromEntries([...resetSource.matchAll(/#macro (\w+) (\d+(?:\.\d+)?)/g)]
    .map(([, name, value]) => [name, Number(value)]));

function translate(source) {
    source = source.replace(/#macro[^\n]*/g, '').replace(/enum player_ai_action\s*\{[^}]+\}/, '');
    const marker = 'with (Object_enemy) {';
    const start = source.indexOf(marker);
    if (start >= 0) {
        let end = start + marker.length, depth = 1;
        while (depth && end < source.length) {
            if (source[end] === '{') depth++;
            if (source[end] === '}') depth--;
            end++;
        }
        source = source.slice(0, start) + 'for (const enemy of world.enemies) { with (enemy) {' +
            source.slice(start + marker.length, end) + '}' + source.slice(end);
    }
    // As funcoes de IA ja sao vinculadas ao contexto da instancia simulada.
    return source.replace(/with \(Object_player_ai\) /g, '').replace(/\bexit;/g, 'return;');
}

function load(env, context, source, names) {
    const factory = new Function('env', 'context',
        `with (env) { with (context) { ${translate(source)}; return {${names.join(',')}}; } }`);
    const result = factory(env, context);
    Object.assign(env, result);
    return result;
}

function fixture() {
    const player = {x: 0, y: 0, life: 500, max_life: 500, dash_cooldown: 0,
        dash_started: false, total_damage_dealt: 0, total_damage_taken: 0,
        total_kills: 0, total_healing_received: 0, total_potions_collected: 0, total_levels_gained: 0, total_xp_pickups: 0, total_xp_collected: 0, xp: 0,
        death_processed: false, object_index: 'melee', ai_mode_at_start: 'TREINAMENTO', ai_mode_changed: false};
    const enemy = {x: 100, y: 0, life: 100};
    enemy.id = enemy;
    const world = {player, enemies: [enemy], potions: [], xp: []};
    const contextKeys = new Set([
        'episode_player', 'episode_finished', 'last_damage_dealt', 'last_damage_taken',
        'last_kills', 'last_xp_pickups', 'last_healing_received', 'last_levels_gained', 'input_left', 'input_right', 'input_top',
        'input_down', 'input_mb_left', 'input_shift', 'input_confirm', 'player_walk',
        'input_aim_direction', 'input_dash_direction'
    ]);
    // Simula variaveis de instancia ausentes, sem inicializa-las no proprio teste.
    const context = new Proxy({}, {
        has: (target, key) => contextKeys.has(key) || Reflect.has(target, key),
        get: (target, key) => {
            if (contextKeys.has(key) && !Object.hasOwn(target, key)) {
                throw new ReferenceError(`Variavel de instancia nao inicializada: ${key}`);
            }
            return Reflect.get(target, key);
        }
    });
    const training = [], saved = [], files = new Map();
    let preferred = actions.approach, randomValue = 0.99, randomIndex = 0;
    function NeuralNetwork(inputs, hidden, outputs) {
        this.input_size = inputs; this.hidden_size = hidden; this.output_size = outputs;
        this.weights_ih = Array.from({length: hidden}, () => Array(inputs).fill(0.1));
        this.weights_ho = Array.from({length: outputs}, () => Array(hidden).fill(0.2));
        this.bias_h = Array(hidden).fill(0); this.bias_o = Array(outputs).fill(0);
        this.forward = () => Array.from({length: outputs}, (_, i) => i === preferred ? 10 : 0);
        this.train = (inputs, target, rate) => {
            training.push({inputs: [...inputs], target: [...target], rate});
            this.bias_o[0] = training.length;
        };
    }
    const global = {game_paused: false, bot_mode: 'LIGADO', ai_epsilon: 0.5,
        ia_director: 'FSM', ai_brain: new NeuralNetwork(constants.PLAYER_AI_INPUT_SIZE, constants.PLAYER_AI_HIDDEN_SIZE, actions.count)};
    const env = {...constants, ...identityConstants, player_ai_action: actions, world, global, NeuralNetwork, id: context,
        game_get_speed: () => 60, gamespeed_fps: 0, noone: -4, infinity: Infinity, Object_player: 'player', Object_enemy: 'enemy',
        Object_life_potion: 'potion', Object_Xp: 'xp', Object_player_ai: 'ai', Object_player_meele: 'melee', Object_player_ranged: 'ranged', Object_death_menu: 'death_menu',
        Object_game: {survival_time: 10}, Object_input: {input_toggle_bot: false, input_toggle_ai_training: false}, current_time: 123,
        instance_find: type => type === 'player' && world.player ? world.player : -4,
        instance_nearest: (x, y, type) => { const items = type === 'potion' ? world.potions : world.xp; return [...items].sort((a,b) => Math.hypot(a.x-x,a.y-y)-Math.hypot(b.x-x,b.y-y))[0] ?? -4; },
        instance_exists: value => value === 'player' ? !!world.player :
            value === 'ai' || world.enemies.includes(value),
        array_length: value => value.length, array_push: (a, value) => a.push(value),
        is_array: Array.isArray, is_real: value => typeof value === 'number',
        is_struct: value => value !== null && typeof value === 'object' && !Array.isArray(value),
        struct_exists: (s, key) => Object.hasOwn(s, key),
        variable_global_exists: key => Object.hasOwn(global, key),
        variable_instance_exists: (instance, key) => Object.hasOwn(instance, key),
        floor: Math.floor, abs: Math.abs, min: Math.min, max: Math.max, clamp: (n, lo, hi) => Math.min(hi, Math.max(lo, n)),
        point_distance: (x1, y1, x2, y2) => Math.hypot(x2-x1, y2-y1),
        point_direction: (x1, y1, x2, y2) => (Math.atan2(y1-y2, x2-x1) * 180/Math.PI + 360) % 360,
        lengthdir_x: (r, d) => r * Math.cos(d*Math.PI/180),
        lengthdir_y: (r, d) => -r * Math.sin(d*Math.PI/180),
        random: () => randomValue, irandom: upper => {
            assert(randomIndex <= upper, 'exploracao deve abranger o indice solicitado');
            return randomIndex;
        },
        date_current_datetime: () => 1234, date_datetime_string: () => '2026-11-15 12:00:00',
        get_timer: () => 100000, variable_struct_get: (obj, key) => obj[key],
        string_char_at: (s, index) => s.charAt(index-1), string_pos: (part, s) => s.indexOf(part)+1,
        is_string: value => typeof value === 'string', string_length: value => value.length,
        string: String, show_debug_message: () => {}, json_parse: JSON.parse,
        json_stringify: JSON.stringify, file_exists: name => files.has(name),
        file_text_open_read: name => ({text: files.get(name), done: false}),
        file_text_eof: handle => handle.done,
        file_text_read_string: handle => { handle.done = true; return handle.text; },
        file_text_readln: () => {}, file_text_close: () => {},
        file_text_open_write: name => ({name}),
        file_text_write_string: (handle, text) => { files.set(handle.name, text); saved.push(JSON.parse(text)); },
        room_restart: () => {}, instance_create_layer: () => {}, instance_destroy: () => {}
    };
    load(env, {}, identitySource, ['Script_model_identity', 'Script_model_identity_from_save', 'Script_telemetry_filename']);
    for (const name of ['reset', 'observe', 'learn', 'update']) {
        const fn = `Script_player_ai_${name}`;
        load(env, context, read(`scripts/${fn}/${fn}.gml`), [fn]);
    }
    load(env, {}, read('scripts/Script_enemy_take_damage/Script_enemy_take_damage.gml'), ['Script_enemy_take_damage']);
    load(env, {}, read('scripts/Script_load_ai_telemetry/Script_load_ai_telemetry.gml'),
        ['Script_load_ai_telemetry', 'Script_player_ai_model_valid']);
    load(env, player, read('scripts/Script_death/Script_death.gml'), ['Script_death']);
    load(env, context, `function tick() {${read('objects/Object_player_ai/Step_1.gml')}}`, ['tick']);
    load(env, context, `function toggle() {${read('objects/Object_player_ai/Step_2.gml')}}`, ['toggle']);
    load(env, context, `function createAI() {${read('objects/Object_player_ai/Create_0.gml')}}`, ['createAI']);
    env.createAI();
    assert.equal(context.episode_player, player, 'Create deve inicializar o episodio real');
    return {env, context, player, enemy, world, global, training, saved, files,
        prefer: action => { preferred = action; },
        explore: index => { randomValue = 0; randomIndex = index; }};
}

let passed = 0;
function test(name, run) { run(); passed++; console.log(`OK ${name}`); }
const near = (actual, expected) => assert(Math.abs(actual - expected) < 1e-8, `${actual} != ${expected}`);

test('Create inicializa estado antes do primeiro Step, inclusive apos recriar a IA', () => {
    const f = fixture();
    assert.equal(f.context.episode_finished, false);
    assert.equal(f.context.last_damage_dealt, 0);
    assert.equal(f.context.input_aim_direction, 0);
    f.env.tick();
    delete f.context.episode_player;
    f.env.tick(); // Protecao adicional para instancias com estado antigo.
    assert.equal(f.context.episode_player, f.player);
    const project = JSON.parse(read('Projeto Integrador VII.yyp').replace(/,(?=\s*[}\]])/g, ''));
    for (const name of ['reset', 'observe', 'learn']) {
        assert(project.resources.some(r => r.id.name === `Script_player_ai_${name}`));
    }
    for (const name of ['total_damage_dealt', 'total_damage_taken', 'total_kills', 'total_xp_pickups']) {
        assert(read('objects/Object_player/Create_0.gml').includes(`${name} = 0;`));
    }
});

test('todas as oito acoes sao exploraveis e executaveis', () => {
    assert.equal(actions.count, 10);
    for (let action = 0; action < actions.seek_potion; action++) {
        const f = fixture(); f.explore(action); f.env.tick();
        assert.equal(f.global.ai_current_action, action);
        assert.equal(f.context.input_mb_left, [5, 6, 7].includes(action));
        assert.equal(f.context.input_shift, [3, 4].includes(action));
        assert.equal(f.context.input_right, [0, 7].includes(action));
        assert.equal(f.context.input_left, [1, 5].includes(action));
    }
});

test('dash usa cooldown do jogador e preserva direcao de fuga', () => {
    const f = fixture(); f.context.dash_cooldown = 99;
    assert.equal(f.env.Script_player_ai_observe(f.player).inputs[3], 1);
    f.prefer(actions.dash_away); f.env.tick();
    near(f.context.input_aim_direction, 0); near(f.context.input_dash_direction, 180);
    f.player.dash_cooldown = 10;
    const observation = f.env.Script_player_ai_observe(f.player);
    assert.equal(observation.inputs[3], 0);
    assert(!observation.actions.includes(actions.dash_away));
    assert(!observation.actions.includes(actions.dash_toward));
    f.global.ai_timer = 0; f.env.tick();
    assert.notEqual(f.global.ai_current_action, actions.dash_away);
});

test('trocar de alvo nao gera recompensa e inimigos mortos sao ignorados', () => {
    const f = fixture(); f.env.tick();
    const other = {x: 50, y: 0, life: 10}; other.id = other;
    f.world.enemies.push(other); f.env.tick();
    near(f.global.ai_accumulated_reward, 20/60);
    other.life = 0;
    assert.equal(f.env.Script_player_ai_observe(f.player).enemy, f.enemy);
});

test('dano real, overkill e eliminacao sao contabilizados uma unica vez', () => {
    const f = fixture(); f.env.tick();
    near(f.env.Script_enemy_take_damage(f.enemy, 40), 40);
    near(f.env.Script_enemy_take_damage(f.enemy, 500), 60);
    near(f.env.Script_enemy_take_damage(f.enemy, 500), 0);
    assert.equal(f.player.total_damage_dealt, 100); assert.equal(f.player.total_kills, 1);
    f.world.enemies = []; f.env.tick();
    near(f.global.ai_accumulated_reward, 7 + 20/60);
    f.env.tick(); near(f.global.ai_accumulated_reward, 7 + 40/60);
});

test('XP e recompensado por coleta, sem repetir nem perder recompensa no level up', () => {
    const f = fixture(); f.env.tick();
    const pickup = {other: f.player, xp_valor: 20};
    load(f.env, pickup, `function collect() {${read('objects/Object_Xp/Collision_Object_player.gml')}}`, ['collect']);
    f.env.collect(); f.player.xp = 0; f.env.tick();
    near(f.global.ai_accumulated_reward, 5 + 20/60);
    f.env.tick(); near(f.global.ai_accumulated_reward, 5 + 40/60);
    assert.equal(f.player.total_xp_collected, 20);
});

test('dano recebido usa contador real e recompensa nao e duplicada', () => {
    const f = fixture(); f.env.tick();
    f.player.total_damage_taken += 50; f.player.life -= 50; f.env.tick();
    near(f.global.ai_accumulated_reward, -30 + 20/60);
});

test('pausa congela treinamento e recompensa e limpa comandos', () => {
    const f = fixture(); f.env.tick();
    const timer = f.global.ai_timer, epsilon = f.global.ai_epsilon;
    f.global.game_paused = true; f.env.tick(); f.env.tick();
    assert.equal(f.global.ai_timer, timer); assert.equal(f.global.ai_epsilon, epsilon);
    assert.equal(f.global.ai_accumulated_reward, 0); assert.equal(f.training.length, 0);
    assert.equal(f.context.player_walk, false); assert.equal(f.context.input_shift, false);
});

test('morte sem inimigos treina uma vez, sem bootstrap, antes de salvar', () => {
    const f = fixture(); f.env.tick(); f.world.enemies = []; f.player.life = 0;
    f.env.Script_death();
    assert.equal(f.training.length, 1);
    near(f.training[0].target[actions.approach], -300);
    assert.equal(f.saved.length, 1); assert.equal(f.saved[0].player_brain.bias_o[0], 1);
    f.env.Script_death(); f.env.tick();
    assert.equal(f.training.length, 1); assert.equal(f.saved.length, 1);
});

test('alternar modo e reiniciar partida descartam transicao sem apagar pesos', () => {
    const f = fixture(); f.env.tick();
    const brain = f.global.ai_brain, epsilon = f.global.ai_epsilon;
    f.env.Object_input.input_toggle_bot = true; f.env.toggle();
    assert.equal(f.global.bot_mode, 'DESLIGADO');
    f.player.total_damage_dealt += 100; f.env.tick();
    assert.equal(f.training.length, 0); f.env.toggle(); f.env.tick();
    assert.equal(f.training.length, 0); assert.equal(f.global.ai_accumulated_reward, 0);
    f.env.Script_player_ai_reset();
    assert.equal(f.global.ai_brain, brain); assert(f.global.ai_epsilon <= epsilon);
    assert.equal(f.global.ai_player_last_action, -1);
});

test('carregamento aceita modelo salvo e recusa arquitetura, versao ou matrizes invalidas', () => {
    const f = fixture(); f.env.tick(); f.player.life = 0; f.env.Script_death();
    const valid = f.saved[0];
    f.files.set('valid.json', JSON.stringify(valid));
    assert(f.env.Script_load_ai_telemetry('valid.json'));
    assert.equal(f.global.ai_brain.output_size, actions.count);
    for (const modify of [
        m => { m.output_size = 4; }, m => { delete m.model_version; },
        m => { m.action_version = 999; }, m => { m.weights_ih[0].pop(); },
        m => { m.weights_ho[0][0] = 'invalid'; }
    ]) {
        const invalid = structuredClone(valid); modify(invalid.player_brain);
        const brain = f.global.ai_brain;
        f.files.set('bad.json', JSON.stringify(invalid));
        assert.equal(f.env.Script_load_ai_telemetry('bad.json'), false);
        assert.equal(f.global.ai_brain, brain);
    }
    f.files.set('broken.json', '{');
    assert.equal(f.env.Script_load_ai_telemetry('broken.json'), false);
});

test('captura fisica permanece separada e IA nao movimenta o cursor', () => {
    const input = read('objects/Object_input/Step_1.gml');
    assert(!/global\.|NeuralNetwork|Script_player_ai/.test(input));
    assert(input.includes('input_confirm = keyboard_check_pressed'));
    for (const name of ['update', 'observe', 'learn', 'reset']) {
        assert(!read(`scripts/Script_player_ai_${name}/Script_player_ai_${name}.gml`).includes('window_mouse_set'));
    }
});

test('bootstrap ignora dash indisponivel e permite retornos negativos', () => {
    const f = fixture(); f.env.tick();
    f.prefer(actions.dash_away); f.player.dash_cooldown = 10;
    f.player.total_damage_taken = 50; f.global.ai_timer = 0;
    f.env.tick();
    near(f.training[0].target[actions.approach], -30 + 20/60);
});

test('modelo antigo do player nao impede restaurar Q-Table compativel do diretor', () => {
    const f = fixture(), brain = f.global.ai_brain;
    f.files.set('old.json', JSON.stringify({player_brain: {}, q_table: {state: [1, 2, 3]}}));
    assert(f.env.Script_load_ai_telemetry('old.json'));
    assert.equal(f.global.ai_brain, brain);
    assert.deepEqual(f.global.ai_q_table, {state: [1, 2, 3]});
    f.files.set('empty.json', '{}');
    assert.equal(f.env.Script_load_ai_telemetry('empty.json'), false);
});

test('avaliacao congela pesos e epsilon e nao consulta o sorteio de exploracao', () => {
    const f = fixture();
    f.env.Object_input.input_toggle_ai_training = true; f.env.toggle();
    assert.equal(f.global.player_ai_training, false);
    const weights = JSON.stringify(f.global.ai_brain), epsilon = f.global.ai_epsilon;
    f.env.random = () => { throw new Error('Avaliacao nao deve explorar'); };
    f.prefer(actions.idle_attack);
    for (let i = 0; i < 30; i++) f.env.tick();
    assert.equal(f.global.ai_current_action, actions.idle_attack);
    assert.equal(f.global.ai_epsilon, epsilon);
    assert.equal(f.training.length, 0);
    assert.equal(JSON.stringify(f.global.ai_brain), weights);
    f.world.enemies = []; f.player.life = 0; f.env.Script_death();
    assert.equal(f.training.length, 0);
    assert.equal(JSON.stringify(f.global.ai_brain), weights);
    assert.equal(f.saved[0].player_ai_mode, 'AVALIACAO');
    assert.equal(f.saved[0].player_ai_effective_epsilon, 0);
    assert.equal(f.saved[0].player_ai_mode_changed, true);
    assert.equal(f.saved[0].player_brain.ai_epsilon, epsilon);
});

test('retomar treinamento preserva epsilon e descarta transicao da avaliacao', () => {
    const f = fixture(); f.env.tick();
    const epsilon = f.global.ai_epsilon;
    f.env.Object_input.input_toggle_ai_training = true; f.env.toggle();
    f.player.total_damage_dealt += 100; f.env.tick();
    f.env.toggle();
    assert.equal(f.global.player_ai_training, true);
    assert.equal(f.global.ai_epsilon, epsilon);
    assert.equal(f.global.ai_player_last_action, -1);
    f.env.tick(); assert.equal(f.training.length, 0);
    for (let i = 0; i < 12; i++) f.env.tick();
    assert.equal(f.training.length, 1);
    assert(f.global.ai_epsilon < epsilon);
});

test('bloqueio de avaliacao protege inclusive chamadas diretas ao aprendizado', () => {
    const f = fixture(); f.env.tick(); f.global.player_ai_training = false;
    f.env.Script_player_ai_learn(f.env.Script_player_ai_observe(f.player), false);
    f.env.Script_player_ai_learn(f.env.Script_player_ai_observe(f.player), true);
    assert.equal(f.training.length, 0);
    const epsilon = f.global.ai_epsilon;
    f.env.createAI();
    assert.equal(f.global.player_ai_training, false);
    assert.equal(f.global.ai_epsilon, epsilon);
});

test('IDs persistem entre partidas e salvamento/carregamento dos dois agentes', () => {
    const f = fixture();
    const playerId = f.global.player_model_id;
    f.env.createAI(); assert.equal(f.global.player_model_id, playerId);
    f.global.ia_director = 'Q_TABLE'; f.global.ai_q_table = {state: [1, 2]};
    f.global.director_model_id = f.env.Script_model_identity('director-q');
    f.env.tick(); f.player.life = 0; f.env.Script_death();
    const saved = f.saved[0];
    assert.equal(saved.player_model_id, playerId);
    assert.equal(saved.player_brain.model_id, playerId);
    assert.equal(saved.player_implementation_version, identityConstants.PLAYER_AI_IMPLEMENTATION_VERSION);
    f.files.set('ids.json', JSON.stringify(saved));
    f.global.player_model_id = 'other-player'; f.global.director_model_id = 'other-director';
    assert(f.env.Script_load_ai_telemetry('ids.json'));
    assert.equal(f.global.player_model_id, saved.player_model_id);
    assert.equal(f.global.director_model_id, saved.director_model_id);
    delete f.global.ai_brain; f.env.createAI();
    assert.notEqual(f.global.player_model_id, playerId);
});

test('IDs nao usam RNG e arquivos antigos recebem identificacao explicita de origem', () => {
    const f = fixture(); f.env.random = () => { throw new Error('ID nao deve consumir RNG'); };
    assert.notEqual(f.env.Script_model_identity('player'), f.env.Script_model_identity('player'));
    assert.equal(f.env.Script_model_identity_from_save({}, 'player_model_id', 'player', 'old.json'), 'legacy-player-old.json');
    assert.equal(f.env.Script_model_identity_from_save({player_model_id: ''}, 'player_model_id', 'player', 'old.json'), 'legacy-player-old.json');
});

test('percepcao retorna dezesseis entradas e distingue os quatro setores', () => {
    const f = fixture();
    const enemy = (x, y, life = 100) => { const e = {x, y, life}; e.id = e; return e; };
    const radius = constants.PLAYER_AI_PERCEPTION_RADIUS;
    f.world.enemies = [enemy(0, -radius/4), enemy(0, radius/2), enemy(-radius/5, 0), enemy(radius*0.75, 0), enemy(radius*0.9, 0)];
    const inputs = f.env.Script_player_ai_observe(f.player).inputs;
    assert.equal(inputs.length, 16);
    near(inputs[4], 5/constants.PLAYER_AI_ENEMY_COUNT_LIMIT);
    [0.75, 0.5, 0.8, 0.25].forEach((value, i) => near(inputs[5+i], value));
    assert(inputs.every(value => value >= 0 && value <= 1));
});

test('percepcao ignora mortos e fora do raio; fronteira conta uma vez e quantidade satura', () => {
    const f = fixture(), radius = constants.PLAYER_AI_PERCEPTION_RADIUS;
    const enemy = (x, y, life = 100) => { const e = {x, y, life}; e.id = e; return e; };
    f.world.enemies = [enemy(0, -1, 0), enemy(radius+1, 0), enemy(radius, 0)];
    let inputs = f.env.Script_player_ai_observe(f.player).inputs;
    near(inputs[4], 1/constants.PLAYER_AI_ENEMY_COUNT_LIMIT);
    assert.deepEqual(inputs.slice(5, 9), [0, 0, 0, 0]);
    f.world.enemies = [enemy(30, -30)];
    inputs = f.env.Script_player_ai_observe(f.player).inputs;
    near(inputs[4], 1/constants.PLAYER_AI_ENEMY_COUNT_LIMIT);
    assert.equal(inputs[5], 0); assert(inputs[8] > 0);
    f.world.enemies = Array.from({length: constants.PLAYER_AI_ENEMY_COUNT_LIMIT+5}, () => enemy(0, 0));
    inputs = f.env.Script_player_ai_observe(f.player).inputs;
    assert.equal(inputs[4], 1); assert.equal(inputs[8], 1);
    f.world.enemies = [];
    assert.deepEqual(f.env.Script_player_ai_observe(f.player).inputs.slice(4, 9), [0, 0, 0, 0, 0]);
});

test('telemetria identifica player_v5 e parametros; carregamento recusa versao e raio antigos', () => {
    const f = fixture(); f.env.tick(); f.player.life = 0; f.env.Script_death();
    const saved = f.saved[0];
    assert.equal(saved.player_implementation_version, 'player_v5');
    assert.equal(saved.player_brain.model_version, 5);
    assert.equal(saved.player_brain.input_size, 16);
    assert.equal(saved.player_agent_variant, 'shared_character_resources');
    assert.equal(saved.player_perception.radius, constants.PLAYER_AI_PERCEPTION_RADIUS);
    for (const change of [m => {m.model_version = 1; m.input_size = 4;}, m => {m.perception_radius++;}]) {
        const old = structuredClone(saved); change(old.player_brain);
        f.files.set('old-schema.json', JSON.stringify(old));
        const brain = f.global.ai_brain;
        assert.equal(f.env.Script_load_ai_telemetry('old-schema.json'), false);
        assert.equal(f.global.ai_brain, brain);
    }
});

test('personagem muda apenas a decima entrada e compartilha pesos e exploracao', () => {
    const f = fixture(), brain = f.global.ai_brain;
    const melee = f.env.Script_player_ai_observe(f.player).inputs;
    f.env.tick(); assert.equal(f.global.ai_melee_training_decisions, 1);
    f.player.object_index = 'ranged'; f.global.ai_timer = 0;
    const ranged = f.env.Script_player_ai_observe(f.player).inputs;
    assert.deepEqual(melee.slice(0, 9), ranged.slice(0, 9));
    assert.equal(melee[9], 0); assert.equal(ranged[9], 1);
    f.env.tick(); assert.equal(f.global.ai_ranged_training_decisions, 1);
    assert.equal(f.global.ai_training_decisions, 2); assert.equal(f.global.ai_brain, brain);
});

test('epsilon chega ao minimo em 9000 decisoes e o progresso e restaurado do JSON', () => {
    const f = fixture();
    for (let i = 0; i < 4500; i++) {f.global.ai_timer = 0; f.env.tick();}
    near(f.global.ai_epsilon, 0.275);
    const epsilon = f.global.ai_epsilon;
    f.world.enemies = []; f.global.ai_timer = 0; f.env.tick();
    near(f.global.ai_epsilon, epsilon); assert.equal(f.global.ai_training_decisions, 4500);
    f.world.enemies = [f.enemy]; f.global.player_ai_training = false;
    f.global.ai_timer = 0; f.env.tick(); near(f.global.ai_epsilon, epsilon);
    assert.equal(f.global.ai_training_decisions, 4500);
    f.global.player_ai_training = true;
    for (let i = 0; i < 4501; i++) {f.global.ai_timer = 0; f.env.tick();}
    near(f.global.ai_epsilon, 0.05);
    f.player.life = 0; f.env.Script_death();
    f.files.set('schedule.json', JSON.stringify(f.saved[0]));
    f.global.ai_training_decisions = 0;
    assert(f.env.Script_load_ai_telemetry('schedule.json'));
    assert.equal(f.global.ai_training_decisions, 9001);
    assert.equal(f.global.ai_melee_training_decisions, 9001);
    assert.equal(f.global.ai_ranged_training_decisions, 0);
    near(f.global.ai_epsilon, 0.05);
    assert.equal(f.saved[0].player_exploration.decay_per_combat_decision, 0.00005);
});

test('salvamento preserva arquivos quando contador e identificador da sessao repetem', () => {
    const f = fixture(); f.global.ia_director = 'Q_TABLE';
    f.env.tick(); f.player.life = 0; f.env.Script_death();
    const first = f.saved[0], contents = f.files.get(first.telemetry_file);
    assert(first.telemetry_file.includes('player_v5_MELEE_Q_TABLE'));
    assert(/^[a-zA-Z0-9_-]+\.json$/.test(first.telemetry_file));
    f.player.death_processed = false; f.global.match_counter = 1;
    // Reproduz a mesma data, timer e contador de uma nova execucao.
    f.global.model_identity_counter--;
    f.env.Script_death();
    assert.notEqual(f.saved[1].telemetry_file, first.telemetry_file);
    assert.equal(f.files.get(first.telemetry_file), contents);
    assert.equal(f.files.size, 2);
    assert.equal(f.saved[1].player_model_id, first.player_model_id);
    f.player.death_processed = false; f.player.object_index = 'ranged';
    f.env.Script_death();
    assert(f.saved[2].telemetry_file.includes('RANGED'));
    assert.equal(f.files.size, 3);
});

test('recursos sao percebidos no raio e criam acoes de busca mesmo sem inimigos', () => {
    const f = fixture(); f.world.enemies = [];
    f.world.potions = [{x: -150, y: 0}]; f.world.xp = [{x: 0, y: 75}];
    f.player.life = 400;
    let o = f.env.Script_player_ai_observe(f.player);
    assert.equal(o.inputs.length, 16);
    near(o.inputs[10], 0.5); near(o.inputs[11], -0.5); near(o.inputs[12], 0);
    near(o.inputs[13], 0.75); near(o.inputs[14], 0); near(o.inputs[15], 0.25);
    assert(o.actions.includes(actions.seek_potion)); assert(o.actions.includes(actions.seek_xp));
    f.prefer(actions.seek_potion); f.env.tick(); assert(f.context.input_left);
    f.prefer(actions.seek_xp); f.global.ai_timer = 0; f.env.tick(); assert(f.context.input_down);
    f.player.life = f.player.max_life;
    assert(!f.env.Script_player_ai_observe(f.player).actions.includes(actions.seek_potion));
    f.world.potions[0].x = 301; f.world.xp[0].y = 301;
    o = f.env.Script_player_ai_observe(f.player);
    assert.deepEqual(o.inputs.slice(10), [0,0,0,0,0,0]);
    assert.deepEqual(o.actions, [actions.idle]);
});

test('pocao limita vida, nao e gasta com vida cheia e recompensa apenas cura real uma vez', () => {
    const f = fixture(); f.env.tick();
    let consumed = 0; f.env.instance_destroy = () => { consumed++; };
    load(f.env, {other: f.player, life_points: 100}, `function collectPotion() {${read('objects/Object_life_potion/Collision_Object_player.gml')}}`, ['collectPotion']);
    f.env.collectPotion(); assert.equal(consumed, 0);
    f.player.life = 480; f.env.collectPotion();
    assert.equal(f.player.life, 500); assert.equal(f.player.total_healing_received, 20);
    assert.equal(f.player.total_potions_collected, 1); assert.equal(consumed, 1);
    f.env.tick(); near(f.global.ai_accumulated_reward, 10 + 20/60);
    f.env.tick(); near(f.global.ai_accumulated_reward, 10 + 40/60);
    f.global.game_paused = true; f.player.life = 400; f.env.collectPotion();
    assert.equal(consumed, 1);
});

test('bonus de nivel ocorre uma vez e resets nao reaproveitam recompensas anteriores', () => {
    const f = fixture(); f.env.tick(); f.player.total_levels_gained = 1;
    f.env.tick(); near(f.global.ai_accumulated_reward, 20 + 20/60);
    f.env.tick(); near(f.global.ai_accumulated_reward, 20 + 40/60);
    f.env.Script_player_ai_reset(); f.env.tick(); assert.equal(f.training.length, 0);
    f.env.tick(); near(f.global.ai_accumulated_reward, 20/60);
    f.player.life = 0; f.env.Script_death();
    assert.equal(f.saved[0].levels_gained, 1);
    assert.equal(f.saved[0].player_brain.output_size, 10);
});

console.log(`${passed} testes de regressao passaram.`);
