---
name: composio-gmail
description: Resumir Gmail via Composio CLI sem depender de OAuth local do Google Workspace ou do himalaya. Útil quando a conta Gmail já está conectada no Composio e o usuário quer um resumo rápido por janela de tempo.
version: 1.0.0
author: Hermes
license: MIT
metadata:
  hermes:
    tags: [Gmail, Email, Composio, Resumo]
    homepage: https://docs.composio.dev
---

# Gmail summary via Composio CLI

Use esta skill quando o usuário pedir um resumo do Gmail e:

- a conta Gmail estiver conectada no Composio CLI
- a skill `google-workspace` exigir setup local de OAuth
- `himalaya` não estiver instalado

## Quando priorizar esta abordagem

Priorize Composio CLI para Gmail quando o objetivo for apenas leitura e resumo da caixa.

## Fluxo determinístico preferido

Quando `bash`, `python` e `composio` estiverem disponíveis, prefira usar:

```bash
bash skills/composio-gmail/scripts/composio_gmail_summary.sh "conta@exemplo.com"
```

O script calcula a janela padrão, executa o Composio e retorna um JSON resumido. Use esse JSON como fonte primária da resposta. Não refaça a consulta manualmente se o script já retornar os dados necessários.

## Filtros suportados

O script aceita estes filtros por variável de ambiente:

- `LOOKBACK_DAYS`
  - padrão: `7`
  - define quantos dias para trás entram na janela local
- `MAX_RESULTS`
  - padrão: `100`
  - define o limite de mensagens pedidas ao `GMAIL_FETCH_EMAILS`
- `TZ`
  - padrão: `America/Sao_Paulo`
  - define a timezone usada para montar a janela e formatar os destaques

Exemplos:

```bash
LOOKBACK_DAYS=2 bash skills/composio-gmail/scripts/composio_gmail_summary.sh "me"
```

```bash
LOOKBACK_DAYS=14 MAX_RESULTS=200 TZ=America/Sao_Paulo \
bash skills/composio-gmail/scripts/composio_gmail_summary.sh "romeupcampos@gmail.com"
```

## Query efetiva usada pelo script

O script consulta o Gmail com a forma:

```text
in:inbox after:YYYY/MM/DD before:YYYY/MM/DD
```

Notas práticas:

- `after:` e `before:` são montados a partir da janela local calculada pela timezone escolhida
- `before:` é exclusivo
- o filtro principal é sempre `in:inbox`
- a filtragem final também considera o `messageTimestamp` localmente antes de montar o resumo

## Fluxo recomendado

1. Verificar disponibilidade prática:
   - `composio --help`
   - confirmar que `python` está disponível
2. Rodar o script diretamente, preferindo ajustar apenas `LOOKBACK_DAYS`, `MAX_RESULTS` e `TZ` quando necessário
3. Ler o JSON retornado pelo script
4. Montar a resposta final a partir dos campos:
   - `account`
   - `date_range`
   - `query_window_label`
   - `total`
   - `unread`
   - `with_attachments`
   - `top_categories`
   - `highlights`
   - `possible_phishing`
   - `has_next_page`
   - `next_page_token`
   - `note`, se existir
5. Se `total` vier `0`, informar explicitamente que a janela consultada não encontrou emails e sugerir ampliar `LOOKBACK_DAYS`

## Exemplo

```bash
LOOKBACK_DAYS=7 MAX_RESULTS=100 \
bash skills/composio-gmail/scripts/composio_gmail_summary.sh "me"
```

## Campos úteis

- `messageId`
- `threadId`
- `messageTimestamp`
- `sender`
- `subject`
- `preview.body`
- `labelIds`
- `attachmentList`

## Formato de saída recomendado

Sempre responder em texto curto, não em JSON cru, seguindo esta ordem:

1. Título com a janela consultada
2. Conta consultada
3. Total de emails, não lidos e com anexo
4. Categorias principais
5. Destaques com datas explícitas
6. Itens de atenção
7. Paginação, se houver
8. Resumo final em 1 ou 2 frases

Regras de apresentação:

- não mostrar a lista `raw` de mensagens
- não colar JSON bruto como resposta principal
- usar datas explícitas nos destaques
- se `possible_phishing` vier vazio, não inventar alerta
- se `note` vier preenchido, mostrar essa observação em destaque
- se `top_categories` vier vazio, dizer isso explicitamente
- evitar tabela como formato principal

## Exemplo de saída

Use este formato como referência. Os valores são ilustrativos, mas a estrutura da resposta deve seguir este padrão.

```text
Resumo do Gmail (20/04 até 22/04):

- Conta confirmada: romeu.campos@bitpreco.com
- Emails encontrados: 34
- Não lidos: 11
- Com anexo: 0
- Próxima página: não há (nextPageToken vazio)

Principais remetentes/categorias
- Financeiro / relatórios operacionais — 12 emails
- Segurança de conta — 4 emails
- Infraestrutura / faturamento — 2 emails
- Mobilidade / despesas — 3 emails
- Parceiros / comunicados — 2 emails
- Newsletters / promoções — 11 emails

Destaques
- 20/04 10:09 — cobranca@provedorexemplo.com — Fatura de infraestrutura disponível
- 20/04 10:13 — alertas@segurancaexemplo.com — Novo acesso detectado em dispositivo Windows
- 20/04 12:15 — financeiro@empresaexemplo.com — Transferência recebida na conta operacional
- 20/04 15:28 — operacoes@empresaexemplo.com — Nova liquidação disponível para conferência
- 20/04 17:45 — parceiros@plataformaexemplo.com — Atualização semanal de indicadores
- 20/04 21:33 — comunicacao@fornecedorexemplo.com — Novas funcionalidades liberadas para o time
- 21/04 07:10 — relatorios@empresaexemplo.com — Resumo diário de receitas e saídas
- 21/04 11:03 — cobranca@provedorexemplo.com — Confirmação de pagamento processado
- 21/04 12:10 — financeiro@empresaexemplo.com — Relatório consolidado de saldos

Observações
- A caixa está bem concentrada em operacional e financeiro da BitPreço, com vários relatórios automáticos do Data Studio.
- Há um alerta de segurança do Google em 20/04 às 12:15 — vale conferir se o login foi seu.

Resumo final
Sua caixa do Gmail está majoritariamente operacional e financeira, com vários relatórios automáticos, liquidações, transferências e faturamento. O único item que merece atenção extra é o alerta de segurança do Google.

Se quiser, eu posso refazer a consulta com uma janela maior ou focar só nos não lidos.
```

## Quando mostrar filtro na resposta

Inclua o filtro usado quando isso ajudar a interpretar o resultado:

- sempre mencionar o intervalo consultado
- mencionar `LOOKBACK_DAYS` quando o usuário pedir janela curta ou longa
- mencionar `MAX_RESULTS` apenas se houver risco de truncamento ou paginação
- mencionar a timezone quando a interpretação das datas for relevante

Exemplo curto:

```text
Filtro usado: inbox, janela local de 7 dias, timezone America/Sao_Paulo, até 100 mensagens.
```

## Heurísticas úteis

- `UNREAD` em `labelIds` → não lido
- `attachmentList` vazio → sem anexo
- `CATEGORY_PROMOTIONS` → promoções
- `CATEGORY_SOCIAL` → social
- `CATEGORY_UPDATES` → updates
- `CATEGORY_PERSONAL` → pessoal
- `CATEGORY_FORUMS` → fóruns

## Limitações e aprendizados práticos

- `google-workspace` pode estar indisponível por falta de setup local; para leitura rápida, Composio pode ser a rota mais curta
- `himalaya` pode não existir no ambiente e não é pré-requisito desta skill
- `GMAIL_FETCH_EMAILS` pode retornar `nextPageToken`; avise que há mais resultados
- o script já aplica ajuste local por timezone na montagem e na filtragem dos timestamps
- `verbose=false` e `include_payload=false` são os defaults atuais do script para resumo rápido e leve
- resultado vazio normalmente significa janela estreita demais ou ausência real de emails na inbox nesse período

## Checklist final

- [ ] Intervalo informado explicitamente
- [ ] Filtro usado explicado quando necessário
- [ ] Datas explícitas nos destaques
- [ ] Total e não lidos informados
- [ ] Categorias e resumo prático incluídos
- [ ] Próxima página mencionada se existir
- [ ] Sem afirmar phishing sem indício claro
