# Guia de Adaptação

Como personalizar o Chief of Staff OS para seu fluxo de trabalho.

---

## Comece com o Arquivo de Contexto

Tudo flui do `CHIEF_OF_STAFF_CONTEXT.md`. Antes de ajustar as habilidades, certifique-se de que seu arquivo de contexto reflita com precisão:
- Suas contas de e-mail e configuração de calendário
- Suas preferências de autoridade (o que o assistente pode fazer sem perguntar)
- Suas horas de trabalho e horas de silêncio
- Seu estilo de follow-up e contatos VIP

A maioria das personalizações acontece aqui, não nos arquivos de habilidades.

## Ajustando Níveis de Autoridade

O framework de autoridade padrão é conservador — o assistente elabora a maioria das respostas para sua revisão. Para expandir o que ele lida autonomamente:

1. Abra seu `CHIEF_OF_STAFF_CONTEXT.md`
2. Mova itens de "Elaborar para revisão" para "Agir autonomamente"
3. Seja específico: "Responder a confirmações de agendamento" é melhor do que "lidar com e-mails rotineiros"

Comece conservador. Expanda à medida que constrói confiança.

## Alterando a Cadência de Acompanhamento

A cadência padrão é 2 → 5 → 7 dias. Para alterar:

1. Atualize a seção "Preferências de Acompanhamento" em `CHIEF_OF_STAFF_CONTEXT.md`
2. A habilidade relationship-manager lê isso em cada execução

Para cadências diferentes por tipo de contato, adicione notas na seção de Contexto de Negócios.

## Modificando o Ritmo Diário

### Alterar frequência de varredura
Edite o agendamento cron. Para varreduras menos frequentes:
```bash
hermes cron add "0 9,12,15,18 * * 1-5" "Execute executive-assistant no modo heartbeat..."
```

### Alterar horário de preparo de tarefas
Se você é uma pessoa noturna e o preparo das 2h é cedo demais:
```bash
hermes cron add "0 5 * * *" "Execute daily-task-prep..."
```

### Pular o briefing matutino
Simplesmente não configure o trabalho cron de briefing matutino. As outras habilidades funcionam independentemente.

## Adicionando Seções de Tarefas

O formato do arquivo de tarefas é flexível. Para adicionar seções personalizadas:

1. Abra `workspace/tasks/current.md`
2. Adicione uma nova seção `##` onde fizer sentido
3. Atualize a seção "Regras" para explicar a nova seção
4. Se a seção deve ser verificada pelo daily-task-prep, anote isso no procedimento da habilidade

## Adicionando Novas Contas de E-mail

1. Adicione a conta ao CHIEF_OF_STAFF_CONTEXT.md em "Contas de e-mail adicionais"
2. Adicione o calendário correspondente em "Contas de calendário"
3. Configure o servidor MCP para a nova conta em `~/.hermes/config.yaml`

## Integrando Ferramentas Externas

As habilidades do CoS são agnósticas de ferramentas — descrevem o que fazer, não qual ferramenta específica usar. Para adicionar integrações:

1. Configure o servidor MCP em `~/.hermes/config.yaml`
2. Marque a caixa no CHIEF_OF_STAFF_CONTEXT.md em "Ferramentas Disponíveis"
3. Adicione notas em `workspace/TOOLS.md` sobre quaisquer peculiaridades

## Construindo Habilidades Personalizadas

As cinco habilidades incluídas cobrem o modelo operacional principal. Para adicionar as suas próprias:

1. Crie um novo diretório em `skills/` com um `SKILL.md`
2. Use o mesmo padrão de frontmatter YAML (nome, descrição, versão, autor, licença)
3. Referencie `CHIEF_OF_STAFF_CONTEXT.md` se precisar de configuração do proprietário
4. Adicione um agendamento cron se deve executar automaticamente

Exemplos de habilidades que você pode adicionar:
- **preparo-reuniao**: Gere documentos de briefing antes de reuniões importantes
- **resumo-semanal**: Produza um resumo semanal de atividade
- **calendario-conteudo**: Acompanhe cronogramas de publicação
- **desenvolvimento-negocios**: Acompanhamento de pipeline com Google Sheets

## Removendo Habilidades que Não Precisa

Cada habilidade é independente. Para executar uma configuração mais leve:

- **Mínimo (apenas EA)**: Mantenha apenas `executive-assistant` e `daily-task-manager`
- **Padrão (3 pilares)**: Adicione `relationship-manager` e `daily-task-prep`
- **CoS Completo**: Adicione o orquestrador `chief-of-staff`

Remova os trabalhos cron para habilidades que você não está usando.
