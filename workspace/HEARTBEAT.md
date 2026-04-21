# Heartbeat

**O que é este arquivo**: Instruções para a varredura recorrente do EA (executa a cada 4 horas, em dias úteis). O trabalho cron invoca a habilidade executive-assistant com estas ordens permanentes.

## O Que o Heartbeat Faz e Não Faz

**Faz**:
- Triage mensagens da caixa de entrada conforme o framework de autoridade (Agir / Elaborar / Escalar)
- Age em itens de Nível 1 (arquivar, confirmar, confirmar reuniões)
- Elabora itens de Nível 2 para revisão do proprietário
- Escalona itens de Nível 3 imediatamente
- Resume ações tomadas ao final de cada varredura

**Não faz**:
- Enviar e-mails de acompanhamento durante varreduras heartbeat — elaboração de follow-ups acontece apenas em execuções cron dedicadas (habilidade relationship-manager)
- Enviar mensagem ao proprietário quando nada é acionável — silêncio significa que tudo está resolvido

## Procedimento de Varredura

1. Verifique `workspace/tasks/current.md` para tarefas devidas agora ou atrasadas.
2. Verifique a caixa de entrada para novas mensagens (use busca em nível de mensagem, não apenas threads).
3. Para cada nova mensagem: classifique conforme o framework de autoridade.
4. **Nível 1 (Agir)**: Resolva. Arquive, confirme, etc.
5. **Nível 2 (Elaborar)**: Prepare um rascunho e apresente ao proprietário para aprovação.
6. **Nível 3 (Escalar)**: Resuma para o proprietário via canal de escalada.
7. Verifique o calendário para eventos nas próximas 4 horas — sinalize conflitos ou necessidades de preparo.
8. Verifique `workspace/relationships/current.md` para acompanhamentos devidos hoje. Anote-os no resumo da varredura, mas não elabore ou envie mensagens de follow-up — isso é tratado pelo trabalho cron dedicado de follow-ups.

## Escalada

Apresente itens urgentes ao proprietário via canal de escalada configurado (de `CHIEF_OF_STAFF_CONTEXT.md`). Urgente = sensível ao tempo dentro de 4 horas, ou sinalizado pelo proprietário.

## Horas de Silêncio

Durante as horas de silêncio configuradas, escale apenas itens genuinamente urgentes. Todo o resto espera até a manhã.

## Quando Nada É Acionável

Retorne `HEARTBEAT_OK` — nenhuma mensagem para o proprietário, nenhum ruído.

## Princípios Operacionais

- Seja proativo mas não crie ruído.
- Resolva o que puder, escale o que deve, ignore o que não importa.
- Priorize: tarefas urgentes > e-mails novos de alto valor > preparo de calendário > acompanhamentos > caixa de entrada rotina.
