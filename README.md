# OS Chefe de Gabinete

Habilidades de IA que gerenciam seu dia — caixa de entrada, tarefas, acompanhamentos e o ritmo operacional que mantém tudo junto.

Criado para [Hermes Agent](https://hermes-agent.nousresearch.com/). Inspirado por [clawchief](https://github.com/snarktank/clawchief).

---

## O Que É Isso

Um conjunto de habilidades do Hermes que transformam seu agente de IA em um Chief of Staff. Ele gerencia sua caixa de entrada, acompanha suas tarefas, faz follow-up em conversas e fornece um briefing diário — para que nada passe despercebido.

Três pilares:
- **Tarefas** — Um arquivo de tarefas canônico que permanece atualizado entre as sessões
- **Comunicações** — Triagem de caixa de entrada com decisões baseadas em autoridade
- **Acompanhamentos** — Cadência de follow-up baseada no tempo para que nenhuma conversa morra silenciosamente

## Habilidades

| Habilidade | O Que Faz |
|------------|-----------|
| `assistente-executivo` | Triagem de caixa de entrada, elaboração de e-mails, gerenciamento de calendário, agendamento |
| `gerenciador-tarefas-diario` | Arquivo de tarefas canônico — adicionar, concluir, priorizar, revisar |
| `preparo-tarefas-diario` | Automação noturna — enriquece as tarefas de amanhã com itens recorrentes, prazos e calendário |
| `gerenciador-relacionamentos` | Acompanhamento de follow-ups, cadência de contato, saúde de relacionamentos |
| `chefe-de-gabinete` | Orquestrador — briefings matutinos, revisões de fim de dia, triagem ad-hoc |

## Início Rápido

```bash
# Clone o repositório
git clone https://github.com/TheCraigHewitt/hermes-chief-of-staff.git

# Copie as habilidades para sua instalação do Hermes
cp -r hermes-chief-of-staff/skills/* ~/.hermes/skills/

# Copie os arquivos do workspace para seu projeto
cp -r hermes-chief-of-staff/workspace/ ~/your-project/workspace/

# Copie e preencha o arquivo de contexto
cp hermes-chief-of-staff/templates/CHIEF_OF_STAFF_CONTEXT.example.md ~/your-project/CHIEF_OF_STAFF_CONTEXT.md

# (Opcional) Configure a personalidade do CoS
cp hermes-chief-of-staff/templates/SOUL.example.md ~/.hermes/SOUL.md
```

Depois preencha o `CHIEF_OF_STAFF_CONTEXT.md` com seus detalhes. Veja [INSTALL.md](INSTALL.md) para o guia completo de configuração.

## Como Funciona

O sistema opera em um ritmo diário:

1. **2h da manhã** — `preparo-tarefas-diario` prepara a lista de tarefas de amanhã
2. **8h da manhã** — `chefe-de-gabinete` entrega um briefing matutino
3. **O dia todo** — `assistente-executivo` varre a caixa de entrada a cada 15 minutos
4. **Duas vezes ao dia** — `gerenciador-relacionamentos` verifica follow-ups pendentes
5. **Fim do dia** — `chefe-de-gabinete` revisa o que foi feito e captura o que vem a seguir

Quando nada precisa de atenção, o sistema fica em silêncio (`HEARTBEAT_OK`). Cada mensagem significa que algo precisa da sua atenção.

Veja [docs/operating-model.md](docs/operating-model.md) para a visão completa.

## Escolha Seu Nível

Você não precisa usar tudo. Escolha o nível que se encaixa:

| Nível | Habilidades | O Que Você Recebe |
|-------|-------------|-------------------|
| **EA Pessoal** | assistente-executivo, gerenciador-tarefas-diario | Triagem de caixa de entrada + gerenciamento de tarefas |
| **Fundador** | + gerenciador-relacionamentos, preparo-tarefas-diario | + acompanhamento de follow-ups + preparo diário |
| **CoS Completo** | + chefe-de-gabinete | + briefings matutinos + revisões de fim de dia |

Veja [docs/maturity-levels.md](docs/maturity-levels.md) para detalhes.

## Escopo da v1

A v1 foca nos fundamentos operacionais do CoS: tarefas, comunicações e acompanhamentos. É mais forte como assistente executivo e sistema de operações de fundador. Planejamento estratégico, registros de decisão, acompanhamento de delegação e preparação de reuniões são camadas futuras (veja [docs/maturity-levels.md](docs/maturity-levels.md)).

## Configuração

Todas as configurações específicas do proprietário residem em um único arquivo: `CHIEF_OF_STAFF_CONTEXT.md`. Cada habilidade foi escrita para ler este arquivo no início das execuções relevantes — é a configuração canônica do proprietário. Sem configuração dispersa, sem variáveis de ambiente para gerenciar.

O arquivo de contexto cobre: seu nome, contas de e-mail, contas de calendário, níveis de autoridade (o que o assistente pode fazer sem perguntar), horas de trabalho, preferências de follow-up e ferramentas disponíveis.

- [templates/CHIEF_OF_STAFF_CONTEXT.example.md](templates/CHIEF_OF_STAFF_CONTEXT.example.md) — Modelo para preencher
- [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](templates/CHIEF_OF_STAFF_CONTEXT.demo.md) — Exemplo preenchido com dados fictícios

## Documentação

- [INSTALL.md](INSTALL.md) — Guia de configuração passo a passo
- [docs/recommended-founder-setup.md](docs/recommended-founder-setup.md) — Caminho mais rápido para uma configuração funcional
- [PHILOSOPHY.md](PHILOSOPHY.md) — Princípios operacionais
- [docs/operating-model.md](docs/operating-model.md) — Como o sistema funciona de ponta a ponta
- [docs/example-outputs.md](docs/example-outputs.md) — Como deve ser uma boa saída
- [docs/adaptation-guide.md](docs/adaptation-guide.md) — Como personalizar para seu fluxo de trabalho
- [docs/maturity-levels.md](docs/maturity-levels.md) — Progressão de EA Pessoal a CoS Completo
- [cron/README.md](cron/README.md) — Cronogramas recomendados

## Sobre

Criado por [Craig Hewitt](https://twitter.com/croighewitt). Portado do modelo operacional [clawchief](https://github.com/snarktank/clawchief), reconstruído para [Hermes Agent](https://hermes-agent.nousresearch.com/).

## Licença

MIT
