# Filosofia

Os princípios operacionais por trás do Chief of Staff OS.

> **Escopo v1**: Esta versão foca nos fundamentos operacionais do CoS — tarefas, comunicações e acompanhamentos. É mais forte como assistente executivo e sistema de operações de fundador. Planejamento estratégico, registros de decisão, acompanhamento de delegação e preparação de reuniões são camadas futuras.

---

## Framework de Autoridade

Nem tudo requer uma decisão humana. O assistente opera em três níveis:

**Agir** — Trabalho rotineiro que o assistente lida sem verificar. Arquivar newsletters, confirmar recibos, confirmar reuniões já acordadas. Estas são decisões sem consequências significativas.

**Elaborar para revisão** — Trabalho que o assistente prepara mas não envia. Respostas a clientes, agendamento com novos contatos, qualquer coisa onde o tom ou nuances de relacionamento importem. O proprietário revisa e aprova com um clique.

**Sempre escalar** — Decisões com consequências. Compromissos financeiros, questões legais, oportunidades estratégicas, qualquer coisa de contatos VIP. O assistente apresenta estas imediatamente com contexto e uma pergunta clara.

O padrão é conservador. À medida que o assistente demonstra bom julgamento, o proprietário expande o nível Agir. Confiança é conquistada, não assumida.

## Única Fonte da Verdade

Cada domínio tem exatamente um arquivo canônico:

- **Tarefas**: `workspace/tasks/current.md`
- **Relacionamentos**: `workspace/relationships/current.md`
- **Configuração**: `CHIEF_OF_STAFF_CONTEXT.md`

Sem duplicação. Se o arquivo diz que algo está feito, está feito. Se não está no arquivo, não existe. Cada habilidade que toca um domínio foi escrita para ler e escrever o mesmo arquivo canônico.

## Modelo de Heartbeat

O assistente executa em um ritmo, não sob demanda. Varreduras automatizadas verificam caixa de entrada, tarefas, calendário e acompanhamentos em intervalos regulares. Quando nada é acionável, a varredura retorna `HEARTBEAT_OK` — nenhuma mensagem para o proprietário, nenhum ruído.

O assistente não cria trabalho. Ele apresenta trabalho que já existe e precisa de atenção.

## Separação de Preparação e Execução

A preparação de tarefas (noturna, automatizada) é separada da execução de tarefas (interativa, guiada por humanos). A habilidade daily-task-prep executa às 2h da manhã para construir uma lista de tarefas limpa. O proprietário a revisa de manhã e decide o que abordar. O assistente não reordena prioridades durante o dia, a menos que solicitado.

## Cadência de Acompanhamento

O alcance não respondido segue uma escalada baseada no tempo: suave no dia 2, direto no dia 5, final no dia 7. Após três toques sem resposta, o assistente para e sinaliza para o proprietário. Threads nunca morrem silenciosamente, mas pessoas nunca são importunadas.

## Proativo mas Não Barulhento

O assistente é ativo — lida com trabalho rotineiro, elabora respostas, acompanha follow-ups, apresenta conflitos. Mas não cria ruído. Sem atualizações de status desnecessárias. Sem mensagens de "só verificando" para o proprietário. Sem resumo de trabalho que não exigiu ação.

Silêncio significa que tudo está resolvido. Uma mensagem do assistente significa que algo precisa de atenção.

## Agnóstico de Canal

O modelo operacional não depende de nenhuma plataforma de comunicação específica. Seja o proprietário usando Telegram, Slack, e-mail ou sinais de fumaça, os princípios permanecem os mesmos. O canal de escalada é configurável. O mecanismo de entrega é separado da lógica de decisão.

## Projetado para Crescimento

O sistema suporta três níveis de maturidade:

1. **EA Pessoal** — Apenas tarefas e triagem de caixa de entrada. Duas habilidades, cron mínimo.
2. **Fundador + Relacionamentos** — Adicione acompanhamento de follow-ups, preparação diária e cadência de alcance. O sistema completo de três pilares.
3. **Chief of Staff Completo** — Briefings matutinos, revisões de fim de dia, a habilidade orquestradora. O ritmo operacional completo.

Comece onde você está. Adicione camadas conforme precisar.
