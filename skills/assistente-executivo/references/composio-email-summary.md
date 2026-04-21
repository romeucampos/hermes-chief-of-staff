# Resumo de E-mail via Composio

Use esta referência quando o pedido for resumir uma caixa de entrada conectada via Composio, independentemente do provedor.

## Quando usar

- o usuário quer um resumo rápido da inbox
- a conta já está conectada via Composio
- o foco é leitura, triagem ou visão geral, e não envio

## Saída recomendada

Sempre que possível, retornar:

1. intervalo consultado
2. quantidade total de e-mails encontrados
3. quantidade de não lidos, se disponível
4. principais remetentes ou categorias
5. destaques com data explícita em cada item
6. itens de atenção
7. resumo final curto

## Regras práticas

- sempre mostrar datas explícitas nos destaques
- deixar claro quando houver paginação ou mais resultados disponíveis
- sinalizar possíveis tentativas de phishing apenas quando houver indícios concretos
- preferir respostas curtas, práticas e em tópicos
- respeitar o fuso horário do contexto do usuário ao interpretar datas

## Campos úteis para resumir

- remetente
- assunto
- data e hora de recebimento
- status de leitura
- anexos
- prévia do corpo
- importância ou labels, se disponíveis

## Observações

- trate diferenças de provedor como detalhes de implementação, não como mudança de lógica de negócio
- quando o provedor for Gmail, consulte `composio-gmail.md`
- quando o provedor for Outlook/Hotmail, consulte `composio-outlook.md`
