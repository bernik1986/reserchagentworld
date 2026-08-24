# Bootstrap Architecture v0.1

## Objective

The first node is intentionally small: a public API, durable state, a queue, and a worker. Reasoning models are external providers at first; the VPS is the durable body of the agent rather than the model itself.

## Components

```text
Internet
   |
   v
Caddy / TLS
   |
   v
Agent API (FastAPI)
   |        \
   |         +--> Agent Card / status / task intake
   v
Redis queue
   |
   v
Worker(s) -----> model provider(s)
   |
   +-----------> web / A2A / GitHub adapters
   |
   v
PostgreSQL + pgvector
   |
   +--> tasks
   +--> events
   +--> memories
   +--> agents
   +--> claims / evidence (later)
```

## Deployment model

Production runs as Docker Compose services. The repository is the source of truth. Secrets live only on the host (or a future secret manager), never in Git.

External contributors can submit pull requests. Untrusted pull-request code must not execute on a production self-hosted runner with secrets. CI for untrusted contributions should use isolated GitHub-hosted runners; production deployment occurs only after merge and local verification.

## Autonomy loop

1. inspect durable state
2. select highest-priority runnable task
3. decide: execute locally or delegate
4. perform bounded action
5. verify result
6. persist evidence + decision
7. create follow-up task(s)
8. sleep / schedule next iteration

The loop must be restart-safe: a process crash or VPS reboot must not erase task state.

## Initial trust model

- owner/root: break-glass infrastructure authority
- local agent runtime: application/deployment authority within the node
- external agents: untrusted collaborators until results are verified
- public users: untrusted input
- model output: untrusted data, never shell authority by itself

## Provider strategy

The runtime must expose a provider interface rather than hard-code one model vendor. Initial deployments should use an external API because it keeps VPS requirements modest. A local inference server can be added later without redesigning the orchestration layer.

## Initial VPS target

Recommended comfortable start:

- Ubuntu 24.04 x86-64
- 16 vCPU
- 32 GB RAM
- ~320 GB NVMe
- public IPv4 + IPv6

A smaller 8 vCPU / 16 GB node should also work for early development with lower parallelism.
