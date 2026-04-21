# Guia de Adaptação

Como personalizar o Chief of Staff OS para o seu fluxo de trabalho.

---

## Comece pelo Arquivo de Contexto

Tudo parte do `CHIEF_OF_STAFF_CONTEXT.md`. Antes de ajustar as habilidades, garanta que ele reflita com precisão:

- suas contas de e-mail e a configuração de calendário
- suas preferências de autoridade
- suas horas de trabalho e horas de silêncio
- seu estilo de follow-up e seus contatos VIP
- o mapeamento de contas e integrações conectadas via Composio

A maior parte da personalização acontece aqui, não nos arquivos das habilidades.

## Política de Integrações

O repositório adota um modelo **Composio-first**:

- Hermes continua sendo a camada de agente e orquestração
- Composio é a camada padrão de conexão com serviços externos
- novas integrações devem usar Composio primeiro
- se alguma integração exigir exceção, documente o motivo explicitamente

## Ajustando Níveis de Autoridade

O modelo de autoridade padrão é conservador. Para expandir o que o assistente pode fazer sozinho:

1. Abra `CHIEF_OF_STAFF_CONTEXT.md`.
2. Mova itens de **Elaborar para revisão** para **Agir autonomamente**.
3. Seja específico: “Responder a confirmações de agenda” é melhor do que “cuidar de e-mails rotineiros”.

Comece com prudência e amplie conforme a confiança aumenta.

## Alterando a Cadência de Acompanhamento

A cadência padrão é `2 → 5 → 7` dias. Para mudar:

1. Atualize a seção **Preferências de Acompanhamento** em `CHIEF_OF_STAFF_CONTEXT.md`.
2. A habilidade `gerenciador-relacionamentos` lê isso a cada execução.

Se você precisar de cadências diferentes por tipo de contato, registre as regras na seção **Contexto de Negócios**.

## Modificando o Ritmo Diário

### Alterar a frequência de varredura

Edite o job do cron. Para varreduras menos frequentes:

```bash
hermes cron add "0 9,12,15,18 * * 1-5" "Execute assistente-executivo no modo heartbeat..."
```

### Alterar o horário de preparo de tarefas

Se o preparo das 2h for cedo demais:

```bash
hermes cron add "0 5 * * *" "Execute preparo-tarefas-diario..."
```

### Pular o briefing matutino

Basta não configurar o job correspondente de `chefe-de-gabinete`. As demais habilidades continuam funcionando.

## Adicionando Seções de Tarefas

O formato de `workspace/tasks/current.md` é flexível. Para incluir seções personalizadas:

1. Abra `workspace/tasks/current.md`.
2. Adicione uma nova seção `##` onde fizer sentido.
3. Atualize a seção **Regras** para explicar como a nova seção deve ser usada.
4. Se a nova seção precisar entrar no preparo diário, reflita isso nas instruções da habilidade.

## Adicionando Novas Contas de E-mail

1. Adicione a conta em `CHIEF_OF_STAFF_CONTEXT.md`, em **Contas de e-mail adicionais**.
2. Adicione o calendário correspondente em **Contas de calendário**, se existir.
3. Conecte a conta via Composio.
4. Atualize `workspace/TOOLS.md` com o novo mapeamento de contas e permissões.

## Integrando Ferramentas Externas

As habilidades do CoS descrevem o que fazer, não um transporte específico. Para adicionar uma nova integração:

1. Tente conectar a ferramenta via Composio.
2. Marque a integração em `CHIEF_OF_STAFF_CONTEXT.md`, na seção **Ferramentas Disponíveis**.
3. Registre peculiaridades em `workspace/TOOLS.md`.
4. Se Composio não atender o caso, documente a exceção de forma explícita.

## Construindo Habilidades Personalizadas

As cinco habilidades incluídas cobrem o modelo operacional principal. Para adicionar suas próprias habilidades:

1. Crie um novo diretório em `skills/` com um `SKILL.md`.
2. Use o mesmo padrão de frontmatter YAML.
3. Consulte `CHIEF_OF_STAFF_CONTEXT.md` sempre que precisar de configuração do proprietário.
4. Se a habilidade depender de ferramentas externas, prefira integrações conectadas via Composio.
5. Adicione um job de cron se ela precisar rodar automaticamente.

Exemplos úteis:

- `preparo-reuniao`: gerar briefing antes de reuniões importantes
- `resumo-semanal`: produzir um resumo semanal de atividade
- `calendario-conteudo`: acompanhar cronogramas de publicação
- `desenvolvimento-negocios`: acompanhar pipeline em CRM ou planilha conectada

## Removendo Habilidades que Você Não Precisa

Cada habilidade é independente. Para uma configuração mais enxuta:

- **Mínimo**: `assistente-executivo` e `gerenciador-tarefas-diario`
- **Padrão**: adicione `gerenciador-relacionamentos` e `preparo-tarefas-diario`
- **Completo**: adicione `chefe-de-gabinete`

Remova também os jobs de cron das habilidades que não estiver usando.
