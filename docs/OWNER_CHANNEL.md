# Owner Channel

Status: design baseline

## Objective

Give the human owner a direct, low-friction way to talk to the coordinator agent, inspect what happened, and receive concise daily summaries without operating the system manually.

The owner interface is not the agent's control loop. The runtime must continue operating when the owner is absent.

## Primary interaction modes

### 1. Owner chat

Authenticated private interface at `/owner` with a normal conversational UI.

Example questions:
- How are things going?
- What happened today?
- Which agents did you talk to?
- What did you learn?
- What did you build or deploy?
- What failed?
- What are you planning next?
- How much API budget did you spend today/month-to-date?
- Which external agents were most useful?
- Are you blocked on anything that only I can do?

The coordinator answers from durable memory and audit/event data rather than inventing a narrative from transient context.

### 2. Daily owner brief

Generate one daily brief in owner timezone (`Europe/Brussels` by default) after the active day closes. Default target time: 20:00 local, configurable.

The brief should contain:

1. **Day in one paragraph** — what materially changed.
2. **People/agents contacted** — identity/capability and useful outcome.
3. **Work completed** — code, reviews, research, deployments, experiments.
4. **New ideas / decisions** — concise rationale and provenance.
5. **Failures / incidents** — what failed and whether it is resolved.
6. **API/compute economics** — owner-paid cost, sponsored/external work, cache savings, budget remaining.
7. **Tomorrow / next work** — what the runtime intends to do next.
8. **Human action required** — only unavoidable owner actions; otherwise `None`.

Daily briefs are stored durably and remain queryable historically.

### 3. Live activity feed

The owner UI shows a readable event stream derived from the audit log:

- agent discovered/contacted;
- task delegated/received/completed;
- PR opened/reviewed/merged;
- research finding verified/rejected;
- deployment/rollback;
- funding/compute lead found;
- budget threshold crossed;
- human-action request created/resolved.

Technical debug logs remain separate. The owner feed should contain high-signal events, not raw container noise.

## Architecture

```text
Browser / future messenger
          |
          v
    Owner Gateway
 auth + rate limit
          |
          v
  Coordinator Agent
     /        \
    v          v
Memory/DB   Event/Audit Store
    |          |
    +----+-----+
         v
 Daily Brief Generator
         |
         v
 briefs + optional push adapters
```

## Data model

Minimum durable records:

### `owner_messages`
- id
- created_at
- role (`owner` / `agent`)
- text
- linked_task_id (optional)
- linked_brief_id (optional)
- model_tier
- estimated_cost
- actual_cost

### `activity_events`
- id
- occurred_at
- category
- severity
- summary
- details JSON
- related_agent_id
- related_task_id
- related_repo/pr/research artifact
- owner_visible boolean

### `daily_briefs`
- id
- local_date
- generated_at
- summary
- structured_sections JSON
- owner_paid_cost
- external_or_sponsored_work_share
- human_action_required boolean

### `human_actions`
- id
- created_at
- priority
- title
- explanation
- exact_action_requested
- status (`open` / `resolved` / `cancelled`)
- blocking_scope

## Security

The owner interface is private and must not reuse the public A2A trust boundary.

Initial authentication options, in preferred order:

1. passkey/WebAuthn once supported by the chosen frontend stack;
2. OAuth identity restricted to explicit owner account;
3. strong bootstrap-generated owner token as temporary Day-0 fallback.

Requirements:
- TLS only;
- owner endpoints never exposed anonymously;
- auth secrets never stored in Git;
- CSRF/session protections for browser sessions;
- rate limiting;
- audit owner commands that materially alter runtime goals/settings;
- ordinary questions do not become privileged shell commands.

## Owner intent vs autonomous operation

The owner may ask questions or give high-level direction. The coordinator should distinguish:

- **question**: answer only;
- **preference**: store as durable preference where appropriate;
- **goal change**: update mission/backlog with audit trail;
- **high-impact command**: require explicit authorization policy before execution;
- **casual conversation**: do not mutate goals accidentally.

The chat layer must not interpret every sentence as an executable instruction.

## Cost policy

Owner chat should be inexpensive:
- Luna for simple status retrieval/formatting;
- Terra for synthesis across a large day/history;
- Sol only when the owner asks for a difficult strategic analysis or conflict resolution.

Daily brief generation should normally use Terra after deterministic aggregation has prepared the facts. It should not reread raw history token-by-token if structured event summaries are available.

## Future push adapters

The canonical interface is the web owner channel. Optional adapters can later deliver the same daily brief to:
- Telegram bot;
- email;
- Signal-compatible gateway where feasible;
- other owner-selected messaging channels.

Adapters are delivery surfaces only; durable conversation state remains in the core system.

## Day-0 acceptance criteria

- authenticated `/owner` page exists;
- owner can ask `How are things going?` and receive a response grounded in stored state;
- `/api/owner/status` returns current mission, tasks, recent collaborators, API spend and blockers;
- daily brief is generated and stored once per local calendar day;
- historical briefs are queryable;
- owner-visible activity feed exists;
- human-action requests are shown separately and clearly;
- no public/A2A caller can access owner endpoints;
- all owner responses expose timestamp and data freshness;
- model/cost used for owner responses is recorded.
