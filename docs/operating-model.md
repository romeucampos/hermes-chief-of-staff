# Modelo Operacional

Como o Chief of Staff OS funciona de ponta a ponta.

---

## O Ritmo Diário

O sistema opera em um ciclo diário previsível:

**2:00 da manhã — Preparo de Tarefas** (automatizado)  
A habilidade `preparo-tarefas-diario` executa via cron. Ela lê o arquivo de tarefas canônico, adiciona itens recorrentes de dias úteis, promove itens com vencimento e puxa os eventos de calendário de amanhã. O proprietário começa o dia com uma lista já preparada.

**7:57 da manhã — Briefing Matutino** (automatizado)  
A habilidade `chefe-de-gabinete` produz um briefing diário com tarefas de hoje, calendário, destaques da caixa de entrada, acompanhamentos devidos e itens que exigem atenção.

**8:17, 12:17, 16:17 e 20:17 — Varreduras Heartbeat** (automatizado, a cada 4 horas em dias úteis)  
A habilidade `assistente-executivo` roda no modo heartbeat. Cada varredura verifica tarefas atrasadas, triagem de novas mensagens, conflitos de calendário nas próximas horas e acompanhamentos que precisam de atenção. Quando nada é acionável, retorna `HEARTBEAT_OK`.

**9:47 e 14:47 — Verificações de Acompanhamento** (automatizado)  
A habilidade `gerenciador-relacionamentos` verifica follow-ups atrasados e prepara o próximo toque conforme a cadência definida.

**Fim do Dia — Revisão EOD** (manual, acionada pelo proprietário)  
A habilidade `chefe-de-gabinete` revisa o que foi concluído, o que continua em aberto e o que precisa ser carregado para o próximo dia.

## Como as Habilidades Interagem

```text
chefe-de-gabinete (orquestrador)
├── lê → workspace/tasks/current.md
├── lê → workspace/relationships/current.md
├── lê → caixa de entrada (via integração conectada)
├── direciona para → assistente-executivo
├── direciona para → gerenciador-tarefas-diario
└── direciona para → gerenciador-relacionamentos

assistente-executivo
├── lê → CHIEF_OF_STAFF_CONTEXT.md
├── lê/escreve → workspace/tasks/current.md
├── escreve → workspace/relationships/current.md
└── lê → workspace/HEARTBEAT.md

preparo-tarefas-diario
├── lê → CHIEF_OF_STAFF_CONTEXT.md
├── lê/escreve → workspace/tasks/current.md
└── lê → calendário (via integração conectada)

gerenciador-tarefas-diario
└── lê/escreve → workspace/tasks/current.md

gerenciador-relacionamentos
├── lê → CHIEF_OF_STAFF_CONTEXT.md
├── lê/escreve → workspace/relationships/current.md
└── lê → workspace/tasks/current.md
```

## Fluxo de Dados

**E-mail recebido → tarefa**: `assistente-executivo` tria uma mensagem que exige ação, cria ou atualiza uma tarefa em `workspace/tasks/current.md` e, quando necessário, também registra um acompanhamento.

**Acompanhamento devido → rascunho**: `gerenciador-relacionamentos` detecta um follow-up atrasado e prepara a próxima mensagem conforme a cadência.

**Evento de calendário → tarefa**: `preparo-tarefas-diario` consulta os calendários conectados e transforma compromissos relevantes em blocos de trabalho ou contexto no arquivo de tarefas.

**Tarefa concluída → histórico**: `gerenciador-tarefas-diario` move itens concluídos para a seção apropriada com carimbo de data e hora.

## Integrações no Modelo

O repositório assume um modelo **Composio-first**:

- Hermes é a camada de agente e coordenação
- Composio é a camada padrão de conexão com e-mail, calendário e demais serviços externos
- o contexto do proprietário define quais contas e calendários devem ser usados
- `workspace/TOOLS.md` registra o estado prático das conexões, permissões e restrições

As habilidades devem pensar em termos de **integração conectada**, e não em termos de mecanismos legados de transporte.

## O Framework de Autoridade na Prática

Cada mensagem recebida passa por três perguntas:

1. Isso é algo que posso resolver com segurança? → **Agir**
2. Isso é algo que devo preparar, mas não enviar? → **Elaborar para revisão**
3. Isso é algo que o proprietário precisa ver imediatamente? → **Escalar**

`CHIEF_OF_STAFF_CONTEXT.md` define esses limites. À medida que a confiança aumenta, a zona de ação autônoma pode se expandir.

## HEARTBEAT_OK

A varredura heartbeat foi desenhada para ser silenciosa por padrão. Se uma varredura não encontrar nada acionável — nenhum e-mail urgente, nenhuma tarefa atrasada, nenhum conflito de calendário e nenhum acompanhamento vencido — ela retorna `HEARTBEAT_OK`.

Isso é intencional. Ausência de mensagem significa que tudo está sob controle. Quando o assistente fala, é porque existe algo que merece atenção.
