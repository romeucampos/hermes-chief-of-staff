# OS Chefe de Gabinete

Habilidades de IA que ajudam a gerir o dia a dia: caixa de entrada, tarefas, acompanhamentos e o ritmo operacional que mantém tudo em movimento.

Criado para [Hermes Agent](https://hermes-agent.nousresearch.com/). Inspirado por [clawchief](https://github.com/snarktank/clawchief).

---

## O Que É

Este repositório transforma o Hermes em um Chief of Staff operacional. Ele ajuda a:

- triar a caixa de entrada
- acompanhar tarefas em um arquivo persistente
- manter follow-ups ativos
- consolidar o ritmo diário em briefings e revisões

## Habilidades

| Habilidade | O que faz |
|------------|-----------|
| `assistente-executivo` | Triagem de caixa de entrada, elaboração de e-mails, gestão de calendário e agendamento |
| `gerenciador-tarefas-diario` | Arquivo canônico de tarefas: adicionar, concluir, priorizar e revisar |
| `preparo-tarefas-diario` | Automação noturna para enriquecer a lista de amanhã com recorrências, prazos e calendário |
| `gerenciador-relacionamentos` | Follow-ups, cadência de contato e saúde de relacionamentos |
| `chefe-de-gabinete` | Orquestrador para briefing matutino, revisão de fim de dia e triagem ad hoc |

## Política de Integrações

O repositório adota um modelo **Composio-first**:

- Hermes é a camada de agente e orquestração
- Composio é a camada padrão de conexão com e-mail, calendário e demais serviços externos
- novas integrações devem usar Composio primeiro
- exceções devem ser raras e documentadas explicitamente

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
```

Depois:

1. instale e autentique o Composio CLI
2. conecte Gmail e Google Calendar via Composio
3. valide o acesso em uma sessão do Hermes
4. configure seus jobs de cron

Veja [INSTALL.md](INSTALL.md) para o fluxo completo.

## Como Funciona

O sistema opera em um ritmo diário:

1. `preparo-tarefas-diario` prepara a lista de amanhã
2. `chefe-de-gabinete` entrega o briefing matutino
3. `assistente-executivo` faz varreduras periódicas da caixa de entrada
4. `gerenciador-relacionamentos` verifica follow-ups pendentes
5. `chefe-de-gabinete` pode consolidar a revisão de fim de dia

Quando nada exige atenção, o sistema permanece em silêncio com `HEARTBEAT_OK`.

Veja [docs/operating-model.md](docs/operating-model.md) para a visão completa.

## Escolha Seu Nível

| Nível | Habilidades | O que você recebe |
|-------|-------------|-------------------|
| **EA Pessoal** | `assistente-executivo`, `gerenciador-tarefas-diario` | Triagem de caixa de entrada + gestão de tarefas |
| **Fundador** | + `gerenciador-relacionamentos`, `preparo-tarefas-diario` | + follow-ups + preparo diário |
| **CoS Completo** | + `chefe-de-gabinete` | + briefing matutino + revisão de fim de dia |

Veja [docs/maturity-levels.md](docs/maturity-levels.md) para detalhes.

## Configuração

As preferências do proprietário ficam concentradas em `CHIEF_OF_STAFF_CONTEXT.md`. Esse arquivo define:

- nome, cargo e fuso horário
- contas de e-mail e calendários
- níveis de autoridade
- horas de trabalho
- preferências de acompanhamento
- integrações e mapeamento de contas

Arquivos úteis:

- [templates/CHIEF_OF_STAFF_CONTEXT.example.md](templates/CHIEF_OF_STAFF_CONTEXT.example.md) — modelo para preencher
- [templates/CHIEF_OF_STAFF_CONTEXT.demo.md](templates/CHIEF_OF_STAFF_CONTEXT.demo.md) — exemplo preenchido
- [workspace/TOOLS.md](workspace/TOOLS.md) — referência operacional para contas, permissões e ambiente

## Documentação

- [INSTALL.md](INSTALL.md) — guia passo a passo
- [docs/recommended-founder-setup.md](docs/recommended-founder-setup.md) — caminho mais rápido para uma configuração funcional
- [docs/operating-model.md](docs/operating-model.md) — modelo operacional de ponta a ponta
- [docs/adaptation-guide.md](docs/adaptation-guide.md) — como personalizar o fluxo
- [docs/maturity-levels.md](docs/maturity-levels.md) — progressão de adoção
- [docs/composio-migration.md](docs/composio-migration.md) — migração de setups legados para o modelo Composio-first
- [cron/README.md](cron/README.md) — cronogramas recomendados
- [PHILOSOPHY.md](PHILOSOPHY.md) — princípios operacionais
- [docs/example-outputs.md](docs/example-outputs.md) — exemplos de saídas esperadas

## Sobre

Criado por [Craig Hewitt](https://twitter.com/croighewitt). Portado do modelo operacional [clawchief](https://github.com/snarktank/clawchief) para [Hermes Agent](https://hermes-agent.nousresearch.com/).

## Licença

MIT
