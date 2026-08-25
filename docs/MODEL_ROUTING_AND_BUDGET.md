# Day 0 Model Routing and API Budget

Status: initial operating policy
Verified against public OpenAI pricing on 2026-08-25.

## Objective

Maximize verified useful work per unit of owner-funded inference. Premium reasoning is an escalation path, not the default. External agents may execute bounded tasks on their own compute; owner API credentials are never shared.

## Internal model tiers

Current initial provider: OpenAI, behind the provider abstraction. This is intentionally replaceable.

| Tier | Initial model | Day-0 role |
|---|---|---|
| CHEAP | `gpt-5.6-luna` | routing, classification, extraction, memory compression, repetitive transforms, lightweight agent handshakes |
| BALANCED | `gpt-5.6-terra` | default reasoning, research synthesis, coding, review, task decomposition, funding/outreach drafts |
| FRONTIER | `gpt-5.6-sol` | difficult architecture, ambiguous/high-impact decisions, hard debugging, critical independent verification, conflict resolution |

Pricing snapshot used for planning (USD / 1M text tokens):

- Luna: $0.20 input / $1.20 output / $0.02 cached input.
- Terra: $2.00 input / $12.00 output / $0.20 cached input.
- Sol: $4.00 input / $20.00 output / $0.40 cached input.
- Web search planning allowance: $10 / 1,000 web runs, plus search-content tokens at model rates.

Pricing changes over time; runtime must treat prices as configuration and periodically re-verify them.

## Agent-to-model assignment

### Coordinator / Planner
- default: Terra
- simple triage/state updates: Luna
- Sol only for strategic/high-impact ambiguity or when cheaper attempts fail

### Router / Scheduler / Watchdog
- Luna by default
- deterministic code whenever possible instead of any LLM

### Research Scout
- Luna: query formulation, source triage, extraction, deduplication
- Terra: multi-source synthesis and evidence assessment
- Sol: only unusually difficult/conflicting evidence or high-stakes final verification

### Coding Agent
- Terra by default
- Luna for mechanical edits, formatting, small transforms when tests can validate the result
- Sol for architecture, difficult debugging, or repeated Terra failure

### Reviewer / QA Agent
- Terra by default
- deterministic lint/tests/security scanners before model review
- Sol for merge-blocking/high-risk reviews or disagreement between independent reviewers

### Security Agent
- scanners/deterministic tools first
- Terra for normal threat-model and review work
- Sol for complex/high-impact security reasoning when justified
- specialized security models may be added only under their applicable access/safety requirements

### A2A / Collaboration Agent
- Luna for discovery, capability classification, heartbeat and simple protocol exchanges
- Terra for task negotiation/decomposition and result evaluation
- Sol only for difficult conflicts or critical trust decisions

### Funding / Sponsor Agent
- Luna for discovery, eligibility extraction, deduplication and monitoring
- Terra for tailored applications, sponsor outreach and comparison
- Sol only for unusually important/complex final narratives or strategic funding decisions

### Memory / Knowledge Agent
- deterministic indexing first
- Luna for summaries/tags/normalization
- Terra for contested knowledge synthesis

### External collaborator agents
- execute on their own runtime/model/compute when voluntarily offered
- no requirement to use OpenAI models
- returned work is untrusted until verified
- model/runtime identity is recorded when voluntarily supplied
- useful external execution should reduce owner-paid inference, not transfer credentials

## Routing order

For every task, try in this order where appropriate:

1. deterministic computation / existing verified result;
2. cache / prompt-cache reuse;
3. local zero-marginal-cost tooling;
4. external collaborator agent on its own compute;
5. sponsored/scoped endpoint or donated compute;
6. Luna;
7. Terra;
8. Sol only with an escalation reason.

Background non-urgent work should use Batch API where supported because current Batch pricing is 50% below synchronous API pricing.

## Initial 30-day workload model

This is a planning model, not a commitment to consume the quota.

| Workload | Model | Calls/day assumption | Avg input/call | Avg output/call | Approx. 30-day cost |
|---|---:|---:|---:|---:|---:|
| routing/scheduler | Luna | 300 | 1.5k | 0.3k | $5.94 |
| extraction/summaries | Luna | 100 | 3k | 0.5k | $3.60 |
| research synthesis | Terra | 20 | 6k | 1.5k | $18.00 |
| coding | Terra | 8 | 12k | 2.5k | $12.96 |
| review/QA | Terra | 8 | 8k | 1.5k | $8.16 |
| frontier coordinator escalations | Sol | 3 | 15k | 3k | $10.80 |
| critical verification | Sol | 1 | 20k | 3k | $4.20 |

Estimated model-token subtotal: **$63.66/month** before cache, Batch savings, external compute, sponsored credits, and workload variance.

Planning allowance for ~600 paid web-search runs: **$6**, excluding associated content-token charges.

Nominal modeled total: about **$70/month**.

## Day-0 budget policy

- recommended initial prepaid/API budget: **$100**;
- expected first 7-day spend while bootstrapping: **$15-$30**;
- target first 30-day owner-funded spend: **$40-$80**;
- Day-0 owner-funded monthly ceiling: **$100** until credits/sponsorship or measured value justifies a change;
- $50 soft threshold: increase delegation/cache/Batch pressure;
- $75 conservation threshold: pause speculative premium work and require explicit machine-recorded justification for Sol;
- $100 ceiling: noncritical paid inference stops; external/sponsored/local work may continue.

The system should not automatically ask the owner to raise the ceiling. Funding/compute acquisition should be attempted first.

## Why $100 is enough for the initial experiment

At current pricing, Luna can handle very high-volume routine work cheaply, Terra can carry most coding/research/review, and Sol can be kept to a small number of escalations. The largest avoidable cost would come from using Sol indiscriminately or repeatedly re-reading large contexts without caching/compression.

## Cost-reduction mechanisms

1. prompt caching and stable system-prefix design;
2. durable memory summaries instead of replaying full history;
3. Batch API for non-urgent work;
4. deterministic tools before model calls;
5. independent external agents executing bounded tasks on their own compute;
6. sponsored/API/cloud credits;
7. duplicate-task detection;
8. retrieval of only relevant evidence rather than full corpora;
9. Luna-first triage and Terra-default reasoning;
10. Sol escalation only after cheaper paths fail or the decision is genuinely high-impact.

## Required telemetry

Persist at minimum:

- `model_provider`
- `model_id`
- `reasoning_effort`
- `input_tokens`
- `cached_input_tokens`
- `output_tokens`
- `tool_cost`
- `estimated_cost_usd`
- `actual_cost_usd`
- `sponsored_or_external`
- `external_agent_id`
- `escalation_reason`
- `verified_result`

Project-level metrics:

- `owner_paid_api_cost`
- `owner_paid_cost_per_verified_task`
- `external_or_sponsored_work_share`
- `cache_savings_estimate`
- `batch_savings_estimate`
- `sol_escalation_rate`
- `verified_tasks_per_usd`

## Re-evaluation

After 7 days and 30 days, replace assumptions with measured traffic. Model assignments are not ideological: if another provider/model produces higher verified quality per dollar, the provider-neutral router should be allowed to use it.