# Modelo Operacional

Como o Chief of Staff OS funciona de ponta a ponta.

---

## O Ritmo Diário

O sistema executa em um ciclo diário previsível:

**2:00 da manhã — Preparo de Tarefas** (automatizado)
A habilidade `preparo-tarefas-diario` executa via cron. Ela lê o arquivo de tarefas canônico, adiciona itens recorrentes de dias úteis, promove itens de backlog com data de vencimento e puxa eventos de calendário de amanhã. O proprietário acorda com uma lista de tarefas pronta.

**7:57 da manhã — Briefing Matutino** (automatizado)
A habilidade `chefe-de-gabinete` produz um briefing diário: tarefas de hoje, calendário, destaques da caixa de entrada, acompanhamentos devidos e qualquer coisa que precise de atenção. Entregue no canal de escalada do proprietário.

**8:00 da manhã - 21:00 — Varreduras Heartbeat** (automatizado, a cada 15 min)
A habilidade `assistente-executivo` executa no modo heartbeat. Cada varredura: verifica tarefas atrasadas, tria novas mensagens da caixa de entrada (agindo no Nível 1, elaborando Nível 2, escalando Nível 3), sinaliza conflitos de calendário nas próximas 2 horas e anota acompanhamentos devidos. A elaboração de follow-ups acontece no cron dedicado de follow-ups, não durante as varreduras heartbeat. Retorna `HEARTBEAT_OK` quando nada precisa de atenção.

**9:47 e 14:47 — Verificações de Acompanhamento** (automatizado)
A habilidade `gerenciador-relacionamentos` verifica acompanhamentos atrasados e elabora o próximo toque na cadência.

**Fim do Dia — Revisão EOD** (manual, acionado pelo proprietário)
A habilidade `chefe-de-gabinete` revisa o que foi feito, o que ainda está aberto e captura qualquer coisa nova. Atualiza o arquivo de tarefas para amanhã.

## Como as Habilidades Interagem

```
chefe-de-gabinete (orquestrador)
├── lê → workspace/tasks/current.md
├── lê → workspace/relationships/current.md
├── lê → caixa de entrada (via MCP)
├── direciona para → assistente-executivo (para ações de e-mail)
├── direciona para → gerenciador-tarefas-diario (para alterações de tarefas)
└── direciona para → gerenciador-relacionamentos (para acompanhamentos)

assistente-executivo
├── lê → CHIEF_OF_STAFF_CONTEXT.md (autoridade, contas)
├── lê/escreve → workspace/tasks/current.md (cria tarefas de e-mails)
├── escreve → workspace/relationships/current.md (cria acompanhamentos)
└── lê → workspace/HEARTBEAT.md (instruções de varredura)

preparo-tarefas-diario
├── lê → CHIEF_OF_STAFF_CONTEXT.md (fuso horário, calendários)
├── lê/escreve → workspace/tasks/current.md
└── lê → calendário (via MCP)

gerenciador-tarefas-diario
└── lê/escreve → workspace/tasks/current.md

gerenciador-relacionamentos
├── lê → CHIEF_OF_STAFF_CONTEXT.md (cadência, VIPs)
├── lê/escreve → workspace/relationships/current.md
└── lê → workspace/tasks/current.md (adiciona acompanhamentos como tarefas)
```

## Fluxo de Dados

**E-mail recebido → Tarefa**: O assistente-executivo tria um e-mail que requer ação. Ele cria uma tarefa em workspace/tasks/current.md e opcionalmente uma entrada de acompanhamento em workspace/relationships/current.md.

**Acompanhamento devido → Rascunho**: O gerenciador-relacionamentos detecta um acompanhamento atrasado. Ele elabora o próximo toque conforme a cadência e o apresenta para revisão (ou envia, se autorizado).

**Evento de calendário → Tarefa**: A habilidade preparo-tarefas-diario puxa as reuniões de amanhã e as adiciona como itens com tempo bloqueado no arquivo de tarefas.

**Tarefa concluída → Concluído**: O gerenciador-tarefas-diario move itens concluídos para a seção Concluídos com um carimbo de data/hora. A revisão EOD do chefe-de-gabinete captura qualquer coisa perdida.

## O Framework de Autoridade na Prática

Cada mensagem recebida passa por três perguntas:
1. Isso é algo que posso lidar sem risco? → **Agir**
2. Isso é algo que devo preparar mas não enviar? → **Elaborar para revisão**
3. Isso é algo que o proprietário precisa ver imediatamente? → **Escalar**

O arquivo CHIEF_OF_STAFF_CONTEXT.md do proprietário define os limites. Com o tempo, à medida que o assistente prova ser confiável, o nível Agir expande e o nível Elaborar encolhe.

## HEARTBEAT_OK

A varredura heartbeat foi projetada para ser silenciosa por padrão. Se uma varredura não encontrar nada acionável — nenhum e-mail urgente novo, nenhuma tarefa atrasada, nenhum conflito de calendário, nenhum acompanhamento devido — ela retorna `HEARTBEAT_OK` e o proprietário não ouve nada.

Isso é intencional. A ausência de mensagem significa que tudo está resolvido. Uma mensagem do assistente sempre significa que algo precisa de atenção. Isso previne fadiga de notificação e constrói confiança de que cada sinal importa.
