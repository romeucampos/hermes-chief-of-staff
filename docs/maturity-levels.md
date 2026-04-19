# Níveis de Maturidade

O Chief of Staff OS suporta três níveis de adoção. Comece onde você está e adicione camadas conforme precisar.

> **v1** entrega os Níveis 1-3 abaixo, cobrindo os fundamentos operacionais do CoS. Fases futuras adicionam camadas estratégicas (resumos semanais, preparação de reuniões, desenvolvimento de negócios, registros de decisão).

---

## Nível 1 — EA Pessoal

**Para quem é**: Qualquer pessoa que queira triagem de caixa de entrada e gerenciamento de tarefas sem a sobrecarga de um ritmo operacional completo.

**Habilidades para instalar**:
- `executive-assistant` — triagem de caixa de entrada, elaboração de e-mails, gerenciamento de calendário
- `daily-task-manager` — gerenciamento de arquivo de tarefas canônico

**Arquivos do workspace**:
- `workspace/tasks/current.md`
- `CHIEF_OF_STAFF_CONTEXT.md` (preencha: nome, e-mail, calendário, níveis de autoridade)

**Trabalhos cron** (opcional):
- Varredura de caixa de entrada do EA a cada 15 minutos durante o horário de trabalho

**O que você recebe**:
- Triagem automatizada de caixa de entrada com decisões baseadas em autoridade
- Uma única lista de tarefas persistente que sobrevive entre as sessões
- Detecção de conflitos de calendário e assistência de agendamento
- Elaboração de e-mails que corresponde ao seu tom

**Tempo de configuração**: 15-20 minutos

---

## Nível 2 — Fundador + Relacionamentos

**Para quem é**: Fundadores, operadores ou qualquer pessoa gerenciando relacionamentos e alcance contínuos que precisa de acompanhamento de follow-ups e um ritmo diário.

**Habilidades para instalar** (tudo do Nível 1, mais):
- `relationship-manager` — acompanhamento de follow-ups e cadência de alcance
- `daily-task-prep` — enriquecimento noturno da lista de tarefas

**Arquivos adicionais do workspace**:
- `workspace/relationships/current.md`
- `workspace/HEARTBEAT.md`

**Trabalhos cron**:
- Varredura de caixa de entrada do EA (a cada 15 min, horário comercial)
- Preparo diário de tarefas (2h da manhã todas as noites)
- Verificação de acompanhamentos (duas vezes ao dia)

**O que você recebe** (além do Nível 1):
- Cadência automatizada de acompanhamento (2 → 5 → 7 dias)
- Nenhuma conversa passa despercebida
- Lista de tarefas automaticamente enriquecida cada manhã com itens recorrentes e eventos de calendário
- Priorização de contatos VIP

**Tempo de configuração**: 30-45 minutos (incluindo preenchimento do arquivo de relacionamentos)

---

## Nível 3 — Chief of Staff Completo

**Para quem é**: Pessoas que querem um ritmo operacional diário completo — briefings matutinos, revisões de fim de dia e um único ponto de coordenação em todo o trabalho.

**Habilidades para instalar** (tudo do Nível 2, mais):
- `chief-of-staff` — orquestrador para briefings, revisões e triagem ad-hoc

**Arquivos adicionais do workspace**:
- `workspace/TOOLS.md` (opcional, para notas do ambiente de ferramentas)

**Trabalhos cron** (tudo do Nível 2, mais):
- Briefing matutino (uma vez ao dia, dias úteis)

**O que você recebe** (além do Nível 2):
- Briefing matutino: tarefas, calendário, caixa de entrada, acompanhamentos e itens de atenção em uma visão
- Revisão de fim de dia: capture o que foi feito, leve adiante o que não foi
- Triagem ad-hoc: "no que devo focar agora?"
- Coordenação unificada em todas as habilidades

**Tempo de configuração**: 45-60 minutos (incluindo configuração do cron)

---

## Níveis Futuros

**Fase 2** (planejado):
- Habilidade de resumo semanal — resumo semanal de atividade e tendências
- Habilidade de preparação de reuniões — gere documentos de briefing antes de reuniões importantes
- Pipeline de desenvolvimento de negócios — acompanhamento de prospects e automação de alcance

**Fase 3** (planejado):
- Registro de decisões — acompanhe decisões importantes e seu contexto
- Acompanhamento de delegação — monitore o trabalho atribuído a outros
- Calendário de conteúdo — gerenciamento de cronograma de publicação

---

## Escolhendo Seu Nível

| Pergunta | Nível 1 | Nível 2 | Nível 3 |
|----------|---------|---------|---------|
| Você precisa de triagem de caixa de entrada? | Sim | Sim | Sim |
| Você acompanha follow-ups com pessoas? | Não | Sim | Sim |
| Você quer preparo automatizado diário de tarefas? | Não | Sim | Sim |
| Você quer briefings matutinos? | Não | Não | Sim |
| Você quer revisões de fim de dia? | Não | Não | Sim |

Você pode sempre fazer upgrade depois. Cada nível se constrói sobre o anterior — nada precisa ser reconfigurado.
