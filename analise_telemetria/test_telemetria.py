import json
from pathlib import Path
import tempfile
import unittest
from telemetria import analisar, carregar, selecionar, resumir


def partida(versao=1, match=1):
    inputs = 4 if versao == 1 else 9
    return dict(match_id=match, frames_survived=60, player_type='MELEE', bot_mode='LIGADO',
                player_ai_mode='AVALIACAO', player_ai_mode_at_start='AVALIACAO',
                player_ai_mode_changed=False, player_ai_effective_epsilon=0,
                damage_dealt=100, damage_taken=50, kills=2, xp_collected=20,
                player_implementation_version=f'player_v{versao}',
                player_model_id=f'player-{versao}', director_model_id='director-1', ai_director='Q_TABLE',
                player_perception=dict(radius=300, enemy_count_limit=10),
                q_table={'state': [1, 2, 3, 4, 5, 6]},
                player_brain=dict(input_size=inputs, hidden_size=8, output_size=8, ai_epsilon=0.2,
                                  weights_ih=[[0.1]*inputs for _ in range(8)],
                                  weights_ho=[[0.2]*8 for _ in range(8)], bias_h=[0]*8, bias_o=[0]*8))


class TelemetriaTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.pastas = {v: self.root/v for v in ['v1', 'v2']}
        for p in self.pastas.values():
            p.mkdir()

    def tearDown(self):
        self.tmp.cleanup()

    def salvar(self, dados, versao='v1', nome='match.json'):
        p = self.pastas[versao]/nome
        p.write_text(json.dumps(dados), encoding='utf-8-sig')

    def test_duas_versoes_metricas_e_exportacao(self):
        self.salvar(partida()); self.salvar(partida(2), 'v2')
        rows, issues, selected, report = analisar(*self.pastas.values(), self.root/'resultados')
        self.assertEqual(len(selected), 2)
        self.assertEqual(report['erros'], 0)
        self.assertEqual(selected[0]['kills_per_minute'], 2)
        self.assertEqual(selected[0]['survival_seconds'], 60)
        self.assertEqual(selected[0]['q_states'], 1)
        self.assertTrue((self.root/'resultados/resumo.csv').exists())
        self.assertEqual({r['versao'] for r in resumir(selected)}, {'v1', 'v2'})

    def test_erros_json_shape_qtable_e_nao_finitos(self):
        (self.pastas['v1']/'broken.json').write_text('{')
        d = partida(); d['player_brain']['weights_ih'][0] = [1]
        d['q_table']['bad'] = [float('nan')]
        self.salvar(d)
        rows, issues = carregar(self.pastas)
        self.assertFalse(rows[0]['valido'])
        self.assertEqual(selecionar(rows), [])
        self.assertTrue(any('JSON ilegivel' in r['mensagem'] for r in issues))

    def test_duplicatas_e_pasta_errada(self):
        d = partida(); self.salvar(d); self.salvar(d, nome='copy.json'); self.salvar(d, 'v2')
        rows, issues = carregar(self.pastas)
        self.assertEqual(sum(r['duplicado'] for r in rows), 2)
        self.assertEqual(len(selecionar(rows)), 1)
        self.assertTrue(any('contradiz' in r['mensagem'] for r in issues))

    def test_modos_manualmente_mistos_nao_entram(self):
        for i in range(4):
            d = partida(match=i)
            if i == 0: d['bot_mode'] = 'DESLIGADO'
            if i == 1: d['player_ai_mode_changed'] = True
            if i == 2: d['player_ai_mode'] = 'TREINAMENTO'
            if i == 3: d.pop('player_ai_mode')
            self.salvar(d, nome=f'{i}.json')
        rows, _ = carregar(self.pastas)
        self.assertEqual(selecionar(rows), [])

    def test_legado_nao_inventa_metricas_ou_identidade(self):
        d = partida(); d.pop('kills'); d.pop('player_model_id')
        d.pop('player_implementation_version'); d.pop('player_ai_mode_changed')
        for k in ['input_size', 'hidden_size', 'output_size']: d['player_brain'].pop(k)
        self.salvar(d)
        rows, _ = carregar(self.pastas)
        self.assertIsNone(rows[0]['kills']); self.assertIsNone(rows[0]['kills_per_minute'])
        self.assertEqual(rows[0]['player_model_id'], 'NAO_REGISTRADO')
        self.assertEqual(selecionar(rows), [])
        self.assertEqual(len(selecionar(rows, permitir_modo_nao_verificado=True)), 1)

    def test_pastas_vazias_e_sobrepostas(self):
        rows, issues = carregar(self.pastas)
        self.assertEqual(rows, []); self.assertEqual(len(issues), 2)
        with self.assertRaises(ValueError):
            analisar(self.pastas['v1'], self.pastas['v1'], self.root/'resultados')
        with self.assertRaises(ValueError):
            analisar(*self.pastas.values(), self.pastas['v1']/'resultados')


if __name__ == '__main__':
    unittest.main()
