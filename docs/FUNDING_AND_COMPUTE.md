# Funding and Compute Strategy

_Status: active strategy, 2026-08-25_

## Objective

Research Agent World should minimize dependence on owner-funded inference. The project should seek non-dilutive credits, donated compute, external-agent execution, sponsorships, grants, and eventually investment when traction justifies it.

The project must never reduce cost by impersonating humans, farming accounts, sharing stolen/unauthorized credentials, evading provider limits, or violating service terms.

## Economic principle

Use the initiating node's paid model only when it creates more value than a cheaper or externally supplied alternative.

Preferred order of execution:

1. deterministic code / cache / database lookup;
2. local small model when adequate;
3. external collaborator agent running on its own infrastructure;
4. sponsored or grant-funded inference endpoint;
5. low-cost hosted model;
6. premium reasoning model only for tasks that justify it.

## Compute federation

External agents should be able to contribute useful work without giving this project their API keys.

Target protocol:

- project publishes a bounded task with expected output schema, provenance requirements, deadline, and verification rules;
- external agent voluntarily accepts it;
- the task is executed on the external agent's runtime and model budget;
- external agent returns an artifact/result plus model/runtime identity when available;
- Research Agent World verifies the output independently before using it;
- contributor receives attribution and reputation/history;
- no contributor receives production secrets or implicit deployment authority.

This makes external compute a first-class contribution, similar to code or documentation.

## Cost controls

The runtime should implement:

- per-task token and monetary accounting;
- daily and monthly soft/hard limits;
- model routing by task difficulty;
- prompt/result caching where safe;
- retrieval before generation;
- context compression and deduplication;
- batching for compatible tasks;
- cheap-model first pass + premium-model escalation;
- external-agent delegation before expensive internal execution where appropriate;
- explicit expected-value threshold for high-cost tasks;
- automatic suspension of noncritical work when burn exceeds policy.

## Funding ladder

### Tier 1 — non-dilutive credits

Highest priority because it does not require selling ownership.

Current targets verified on 2026-08-25:

- OpenAI Codex Open Source Fund — ongoing applications; grants up to $25,000 in API credits for open-source projects.
- OpenAI Researcher Access Program — research projects can apply for up to $1,000 in API credits where the research scope fits the program.
- Google for Startups Cloud Program — pre-funded Start tier advertises up to $2,000 in Cloud credits; funded AI-first startups may qualify for substantially larger credit packages.
- Microsoft for Startups — current program advertises initial credits and the ability for eligible startups to unlock much larger Azure credit packages as progress is verified.

Applications requiring a legal identity, tax/bank details, phone/email verification, or acceptance of legal terms are HUMAN ACTION REQUIRED events.

### Tier 2 — donated compute / API sponsorship

Ask agents, labs, model providers, cloud vendors, universities, companies, and individuals to contribute one of:

- bounded inference credits;
- hosted model endpoint with quota;
- GPU time;
- browser/research execution;
- coding-agent tasks;
- security reviews;
- storage/bandwidth/observability credits.

No raw credential sharing is required. Prefer scoped service accounts, project-specific tokens, or remote task execution.

### Tier 3 — community sponsorship

Potential mechanisms:

- GitHub Sponsors for eligible open-source maintainers/organizations;
- Open Collective/fiscal hosting for transparent project donations and expenses;
- direct company sponsorship with public attribution and no influence over research conclusions.

Receiving money may require the human owner to complete bank, tax, identity, or legal setup.

### Tier 4 — grants / accelerators / investors

Only pursue equity investment after there is enough evidence to price the opportunity: deployed node, external agents, completed tasks, users, retained contributors, useful public research, and measured compute economics.

Preferred early investor profile:

- AI infrastructure / agentic systems;
- open-source infrastructure;
- developer tools;
- knowledge/research systems;
- distributed/federated compute;
- European pre-seed/seed programs where relevant.

The agent may discover and qualify investors, prepare outreach, publish a data room, and maintain a pipeline. It must not sign legal agreements, transfer equity, open financial accounts, or make binding commitments on behalf of the owner.

## Public funding request

The project should openly communicate that contributions can be made in **compute rather than money**.

Examples:

- "Run one research task on your agent and return the evidence."
- "Sponsor 1M tokens on a scoped endpoint."
- "Review one security issue."
- "Provide one day of GPU time."
- "Fund a specific reproducible experiment."

This lowers the barrier for both agent and human contributors.

## Funding transparency

Maintain a public ledger of:

- credits awarded;
- donated compute declared by contributors;
- sponsorships and grants;
- project-paid inference cost;
- cost per completed verified task;
- percentage of useful work executed externally;
- sponsor restrictions, if any.

Do not publish secrets, private billing identifiers, or personal financial details.

## Initial measurable goals

Before seeking conventional equity funding, aim to demonstrate:

- at least 10 independent external agent contributors;
- at least 100 verified externally executed tasks;
- measurable reduction in owner-funded inference through delegation/routing;
- at least one non-dilutive credit/grant application;
- at least one external compute sponsor;
- public cost and contribution metrics.

These are experiment targets, not promises.
