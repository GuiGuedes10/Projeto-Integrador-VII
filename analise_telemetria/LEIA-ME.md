# Comparar telemetrias no Google Colab

1. Faça uma cópia dos JSONs de cada versão e coloque no Drive em `telemetrias/v1` e `telemetrias/v2`.
2. Abra `Comparar_Telemetrias_Colab.ipynb` no Colab (upload de notebook).
3. Ajuste os dois caminhos na primeira célula. O padrão analisa TREINAMENTO, adequado aos testes iniciais de 30 minutos. Para testes com pesos congelados, selecione AVALIACAO.
4. Execute as células em ordem e autorize o acesso ao seu Drive quando solicitado pelo Colab.
5. Examine o relatório de validação antes dos gráficos. Baixe o ZIP na última célula.

O notebook é autossuficiente: não precisa enviar o arquivo `.py`. Este é uma alternativa para execução local:

```text
python telemetria.py CAMINHO_V1 CAMINHO_V2 --saida resultados --modo TREINAMENTO
```

A análise é somente leitura nos JSONs originais. Resultados devem ficar fora das pastas de entrada. Arquivos duplicados são excluídos dos resumos, arquivos malformados são relatados, dados ausentes não são zerados e modos/personagens/diretores não são misturados.

Campos antigos sem versão ou IDs são sinalizados. O rótulo da pasta não é prova da versão: uma arquitetura incompatível é um erro. Não são inferidas independência entre partidas, significância estatística, causalidade ou superioridade de uma IA. O contador match_id e o current_time não permitem reconstruir com segurança a ordem entre várias sessões.

Documentação oficial de arquivos no Colab: https://colab.research.google.com/notebooks/io.ipynb
