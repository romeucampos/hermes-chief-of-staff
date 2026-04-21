# Gmail via Composio

Use esta referência quando a caixa consultada for Gmail.

## Abordagem recomendada

- priorize Composio quando a conta já estiver conectada
- para resumos rápidos, prefira consultas leves e sem payload completo quando isso for suficiente
- trate filtros de data do Gmail com cuidado, porque `after:` e `before:` podem exigir ajuste conforme o fuso do usuário

## O que observar

- `UNREAD` pode indicar não lido
- categorias como `CATEGORY_PROMOTIONS`, `CATEGORY_SOCIAL`, `CATEGORY_UPDATES`, `CATEGORY_FORUMS` e `CATEGORY_PERSONAL` ajudam a organizar o resumo
- `nextPageToken` indica que há mais resultados
- anexos e labels podem ajudar a separar itens operacionais de ruído

## Boas práticas

- usar uma janela de busca simples e depois refinar mentalmente ou logicamente pela data local do usuário
- mencionar explicitamente quando houver mais resultados além da primeira página
- não depender de alternativas locais como `himalaya` se o objetivo for apenas resumir via Composio
