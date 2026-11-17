"""Valida JSONs do GameMaker. CLI: python telemetria.py PASTA_V1 PASTA_V2 --saida resultados."""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import math
import statistics
import unicodedata
from collections import defaultdict

METRICAS = ['survival_seconds', 'damage_dealt', 'damage_taken', 'kills', 'xp_collected',
            'kills_per_minute', 'damage_dealt_per_minute', 'damage_taken_per_minute']


def numero(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value)


def texto(value):
    return ''.join(c for c in unicodedata.normalize('NFD', str(value).upper().strip())
                   if unicodedata.category(c) != 'Mn')


def identificador(value):
    return value if isinstance(value, str) and value.strip() else 'NAO_REGISTRADO'


def carregar(pastas):
    """Retorna partidas e ocorrencias; nao altera os arquivos de origem."""
    linhas, ocorrencias, hashes = [], [], {}
    for versao, pasta in pastas.items():
        raiz = Path(pasta).expanduser().resolve()
        arquivos = sorted(raiz.rglob('*.json')) if raiz.is_dir() else []
        if not arquivos:
            ocorrencias.append(dict(versao=versao, arquivo=str(raiz), nivel='erro', mensagem='Pasta inexistente ou sem JSONs.'))
        for arquivo in arquivos:
            erros = []

            def aviso(mensagem, nivel='aviso'):
                ocorrencias.append(dict(versao=versao, arquivo=str(arquivo), nivel=nivel, mensagem=mensagem))
                if nivel == 'erro':
                    erros.append(mensagem)

            try:
                dados = json.loads(arquivo.read_text(encoding='utf-8-sig'))
                if not isinstance(dados, dict):
                    raise ValueError('Raiz do JSON precisa ser um objeto.')
            except (OSError, ValueError) as exc:
                aviso(f'JSON ilegivel: {exc}', 'erro')
                continue
            digest = hashlib.sha256(json.dumps(dados, sort_keys=True, ensure_ascii=True).encode()).hexdigest()
            duplicado = digest in hashes
            if duplicado:
                aviso(f'Conteudo duplicado de {hashes[digest]}; excluido dos resumos.')
            else:
                hashes[digest] = str(arquivo)

            brain = dados.get('player_brain')
            if not isinstance(brain, dict):
                brain = {}
                aviso('Sem rede neural salva; nao foi possivel validar a arquitetura.')
            esperado = 4 if versao == 'v1' else 9
            dimensoes = [brain.get(k) for k in ['input_size', 'hidden_size', 'output_size']]
            # Arquivos antigos nao registravam as dimensoes, mas podem conter os pesos.
            if any(v is None for v in dimensoes):
                ih, ho = brain.get('weights_ih'), brain.get('weights_ho')
                if isinstance(ih, list) and ih and isinstance(ih[0], list) and isinstance(ho, list):
                    dimensoes = [len(ih[0]), len(ih), len(ho)]
                    aviso('Dimensoes inferidas dos pesos: metadados antigos/incompletos.')
            if brain:
                if not all(numero(v) and v > 0 and int(v) == v for v in dimensoes):
                    aviso('Dimensoes da rede invalidas.', 'erro')
                else:
                    inputs, hidden, outputs = map(int, dimensoes)
                    if (inputs, hidden, outputs) != (esperado, 8, 8):
                        aviso(f'Arquitetura {inputs}-{hidden}-{outputs} difere da esperada para {versao}: {esperado}-8-8.', 'erro')
                    for campo, rows, cols in [('weights_ih', hidden, inputs), ('weights_ho', outputs, hidden)]:
                        matriz = brain.get(campo)
                        if not (isinstance(matriz, list) and len(matriz) == rows and all(
                            isinstance(row, list) and len(row) == cols and all(numero(v) for v in row) for row in matriz)):
                            aviso(f'{campo}: dimensoes ou numeros invalidos.', 'erro')
                    for campo, tamanho in [('bias_h', hidden), ('bias_o', outputs)]:
                        valores = brain.get(campo)
                        if not (isinstance(valores, list) and len(valores) == tamanho and all(numero(v) for v in valores)):
                            aviso(f'{campo}: dimensoes ou numeros invalidos.', 'erro')
                epsilon = brain.get('ai_epsilon')
                if epsilon is not None and not (numero(epsilon) and 0 <= epsilon <= 1):
                    aviso('Epsilon salvo invalido.', 'erro')
            declarado = dados.get('player_implementation_version')
            if declarado and declarado != f'player_{versao}':
                aviso(f'Versao declarada {declarado!r} contradiz a pasta {versao}.', 'erro')
            if not declarado:
                aviso('Versao nao registrada; rotulo da pasta e uma classificacao fornecida pelo pesquisador.')
            if versao == 'v2':
                percepcao = dados.get('player_perception', {})
                if not isinstance(percepcao, dict) or not numero(percepcao.get('radius')) or not numero(percepcao.get('enemy_count_limit')):
                    aviso('Parametros da percepcao v2 ausentes ou invalidos.')

            q = dados.get('q_table')
            q_states, q_actions = None, None
            if isinstance(q, dict):
                q_states = len(q)
                tamanhos = set()
                for estado, valores in q.items():
                    if not isinstance(valores, list) or not valores or not all(numero(v) for v in valores):
                        aviso(f'Q-Table: estado {estado!r} invalido.', 'erro')
                    else:
                        tamanhos.add(len(valores))
                if len(tamanhos) > 1:
                    aviso('Q-Table com quantidades diferentes de acoes por estado.', 'erro')
                q_actions = next(iter(tamanhos), None)
            elif texto(dados.get('ai_director')) == 'Q_TABLE':
                aviso('Diretor Q_TABLE sem tabela salva.')

            modo = texto(dados.get('player_ai_mode', 'DESCONHECIDO'))
            if modo not in ['TREINAMENTO', 'AVALIACAO']:
                modo = 'DESCONHECIDO'
                aviso('Modo nao identificado: nao sera inferido pelo epsilon.')
            mudou = dados.get('player_ai_mode_changed')
            inicio = dados.get('player_ai_mode_at_start')
            mista = (mudou is True or (inicio is not None and texto(inicio) != modo))
            modo_verificado = isinstance(mudou, bool) and inicio is not None
            if not modo_verificado:
                aviso('Nao ha metadados suficientes para garantir modo constante na partida.')
            efetivo = dados.get('player_ai_effective_epsilon')
            if modo == 'AVALIACAO' and efetivo != 0:
                aviso('Avaliacao sem epsilon efetivo zero comprovado.', 'erro')
            personagem = texto(dados.get('player_type', 'DESCONHECIDO')).replace('MEELE', 'MELEE')
            row = dict(versao=versao, arquivo=str(arquivo), match_id=dados.get('match_id'),
                       personagem=personagem, modo=modo, partida_mista=mista, modo_verificado=modo_verificado,
                       bot_ativo=texto(dados.get('bot_mode', 'DESCONHECIDO')) == 'LIGADO',
                       diretor=texto(dados.get('ai_director', 'DESCONHECIDO')),
                       player_model_id=identificador(dados.get('player_model_id', brain.get('model_id'))),
                       director_model_id=identificador(dados.get('director_model_id')),
                       versao_declarada=declarado, input_size=dimensoes[0],
                       epsilon=brain.get('ai_epsilon'), q_states=q_states, q_actions=q_actions,
                       duplicado=duplicado)
            if row['player_model_id'] == 'NAO_REGISTRADO':
                aviso('Sem model_id: nao e possivel determinar execucoes independentes.')
            for metrica in METRICAS[:5]:
                valor = dados.get('survival_seconds', dados.get('frames_survived')) if metrica == 'survival_seconds' else dados.get(metrica)
                if valor is None:
                    aviso(f'Metrica ausente: {metrica}; mantida como ausente, sem substituir por zero.')
                elif not numero(valor) or valor < 0:
                    aviso(f'Metrica invalida: {metrica}.', 'erro')
                    valor = None
                row[metrica] = valor
            duracao = row['survival_seconds']
            for metrica in ['kills', 'damage_dealt', 'damage_taken']:
                valor = row[metrica]
                row[f'{metrica}_per_minute'] = valor * 60 / duracao if numero(valor) and numero(duracao) and duracao > 0 else None
            row['valido'] = not erros
            linhas.append(row)
    return linhas, ocorrencias


def selecionar(linhas, modo='AVALIACAO', permitir_modo_nao_verificado=False):
    return [r for r in linhas if r['valido'] and not r['duplicado'] and r['bot_ativo']
            and not r['partida_mista'] and r['modo'] == modo
            and (r['modo_verificado'] or permitir_modo_nao_verificado)]


def resumir(linhas, por_modelo=False):
    grupos = defaultdict(list)
    campos = ['versao', 'personagem', 'modo', 'diretor'] + (['player_model_id', 'director_model_id'] if por_modelo else [])
    for row in linhas:
        grupos[tuple(row[k] for k in campos)].append(row)
    resumo = []
    for chave, grupo in sorted(grupos.items()):
        for metrica in METRICAS:
            valores = [r[metrica] for r in grupo if numero(r[metrica])]
            resumo.append(dict(zip(campos, chave), metrica=metrica, partidas=len(grupo), n=len(valores),
                               media=statistics.mean(valores) if valores else None,
                               mediana=statistics.median(valores) if valores else None,
                               desvio_padrao=statistics.stdev(valores) if len(valores)>1 else None,
                               minimo=min(valores) if valores else None, maximo=max(valores) if valores else None))
    return resumo


def csv_salvar(caminho, rows):
    rows = list(rows)
    if not rows:
        Path(caminho).write_text('', encoding='utf-8-sig')
        return
    campos = list(dict.fromkeys(k for row in rows for k in row))
    with Path(caminho).open('w', encoding='utf-8-sig', newline='') as f:
        writer = csv.DictWriter(f, campos)
        writer.writeheader()
        writer.writerows(rows)


def analisar(pasta_v1, pasta_v2, saida, modo='AVALIACAO', permitir_modo_nao_verificado=False):
    destino = Path(saida).resolve()
    # Impede que uma nova execucao leia seus proprios resultados como telemetria.
    for origem in [Path(pasta_v1).resolve(), Path(pasta_v2).resolve()]:
        if destino == origem or origem in destino.parents:
            raise ValueError('A pasta de resultados precisa ficar fora das duas pastas de entrada.')
    a, b = Path(pasta_v1).resolve(), Path(pasta_v2).resolve()
    if a == b or a in b.parents or b in a.parents:
        raise ValueError('As pastas v1 e v2 precisam ser separadas, sem uma conter a outra.')
    linhas, ocorrencias = carregar({'v1': a, 'v2': b})
    usadas = selecionar(linhas, modo, permitir_modo_nao_verificado)
    destino.mkdir(parents=True, exist_ok=True)
    csv_salvar(destino/'partidas.csv', linhas)
    csv_salvar(destino/'verificacao.csv', ocorrencias)
    csv_salvar(destino/'resumo.csv', resumir(usadas))
    csv_salvar(destino/'resumo_por_modelo.csv', resumir(usadas, True))
    report = {'arquivos_lidos': len(linhas), 'arquivos_validos': sum(r['valido'] for r in linhas),
              'duplicados': sum(r['duplicado'] for r in linhas), 'partidas_selecionadas': len(usadas),
              'modo_selecionado': modo, 'erros': sum(o['nivel']=='erro' for o in ocorrencias),
              'avisos': sum(o['nivel']=='aviso' for o in ocorrencias),
              'notas': [
                  'frames_survived do projeto representa segundos, nao frames.',
                  'timestamp e current_time do jogo, nao data/hora; nao reconstrua 30 minutos por esse campo.',
                  'Resultados de treinamento sao descritivos, nao avaliacao com politica congelada.',
                  'Partidas de um mesmo treinamento nao sao replicas independentes.',
                  'model_id identifica uma linhagem; diferentes checkpoints podem compartilhar o mesmo ID.',
                  'numero de estados na Q-Table mede cobertura, nao qualidade do diretor.',
                  'Nao ha teste de significancia nem afirmacao automatica de superioridade.',
                  'JSONs sobrescritos pelo jogo nao podem ser recuperados por esta analise.']}
    (destino/'relatorio.json').write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf-8')
    return linhas, ocorrencias, usadas, report


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('v1'); parser.add_argument('v2')
    parser.add_argument('--saida', default='resultados_telemetria')
    parser.add_argument('--modo', choices=['AVALIACAO', 'TREINAMENTO'], default='AVALIACAO')
    args = parser.parse_args()
    print(json.dumps(analisar(args.v1, args.v2, args.saida, args.modo)[3], ensure_ascii=False, indent=2))
