# Referência de Formato de Arquivo de Relacionamentos

O arquivo de rastreamento de relacionamentos (`workspace/relationships/current.md`) usa entradas em bullet estruturadas agrupadas em três seções. Cada pessoa recebe um título `###` com campos como bullets abaixo.

## Acompanhamentos Ativos

Para contatos com uma thread aberta aguardando resposta.

Formato:

```
### Nome da Pessoa
- Contexto: Breve descrição do relacionamento ou thread
- Último contato: AAAA-MM-DD
- Próximo acompanhamento: AAAA-MM-DD
- Toque #: 1, 2, ou 3
- Status: Aguardando resposta / Reunião agendada / Respondeu / Escalado para proprietário
- Notas: Qualquer contexto adicional
```

Campos:
- **Contexto**: Sobre o que é o alcance (ex: "Discussão de parceria," "Introdução de vendas do Mike").
- **Último contato**: Data do alcance ou resposta mais recente.
- **Próximo acompanhamento**: Quando o próximo acompanhamento é devido.
- **Toque #**: Qual tentativa de acompanhamento é esta (1, 2 ou 3).
- **Status**: Estado atual da thread.
- **Notas**: Opcional. Qualquer detalhe relevante que o assistente deva saber.

## Nutrição

Para contatos que não precisam de acompanhamento ativo mas devem ser verificados periodicamente.

Formato:

```
### Nome da Pessoa
- Contexto: Descrição do relacionamento
- Último contato: AAAA-MM-DD
- Frequência: Semanal / Mensal / Trimestral
- Próximo check-in: AAAA-MM-DD
- Notas: Qualquer contexto adicional
```

Campos:
- **Frequência**: Com que frequência fazer check-in.
- **Próximo check-in**: Quando o próximo check-in é devido.

## Arquivados

Acompanhamentos concluídos ou fechados. Mantenha para referência.

Formato:

```
### Nome da Pessoa
- Contexto: Sobre o que foi o alcance
- Resolvido: AAAA-MM-DD
- Resultado: O que aconteceu
```

## Regras

- Uma entrada por pessoa por thread ativa (uma pessoa pode ter múltiplos acompanhamentos ativos se forem sobre tópicos diferentes).
- Datas sempre no formato AAAA-MM-DD.
- Quando um acompanhamento for resolvido, mova a entrada para Arquivados com o resultado.
- Quando todos os 3 toques forem esgotados sem resposta, mova para Arquivados com status "Sem resposta — escalado."
