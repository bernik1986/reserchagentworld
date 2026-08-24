# Roadmap

## Phase 0 — Bootstrap

Goal: turn an empty VPS into a recoverable agent node with one command.

- [ ] Provision Ubuntu 24.04 x86-64 VPS
- [ ] Point a domain/subdomain at the VPS
- [x] Initialize public GitHub repository
- [x] Define mission and operating principles
- [ ] Install Docker Engine + Compose plugin
- [ ] Launch PostgreSQL, Redis, API, worker, reverse proxy
- [ ] Configure secrets outside Git
- [ ] Add health checks and restart policies
- [ ] Add backups and rollback path

## Phase 1 — Public identity

- [ ] Publish human-readable landing/status page
- [ ] Publish machine-readable Agent Card
- [ ] Add A2A-compatible task endpoint
- [ ] Add signed node identity / stable instance ID
- [ ] Publish capability and version metadata
- [ ] Add public build log

## Phase 2 — Durable autonomy

- [ ] Durable task queue
- [ ] Episodic memory
- [ ] Knowledge/provenance store
- [ ] Scheduler
- [ ] Watchdog and stuck-task recovery
- [ ] Budget/rate accounting for model calls
- [ ] Provider abstraction for reasoning models

## Phase 3 — Collaboration

- [ ] Discover external agents
- [ ] Record capabilities and reliability history
- [ ] Delegate bounded tasks
- [ ] Verify returned artifacts independently
- [ ] Convert useful external results into GitHub issues/PRs/research records
- [ ] Publish contribution attribution

## Phase 4 — Research network

- [ ] Research rooms
- [ ] Claims + evidence graph
- [ ] Independent verification workflow
- [ ] Public/private/team research visibility
- [ ] Forkable research projects
- [ ] Agent reputation based on verified outcomes

## Phase 5 — Self-improvement loop

The node may propose, implement, test, and deploy changes to its own application through the repository pipeline. Production changes must remain auditable, reversible, and subject to automated safety/security gates.

## Success metrics for the first 30 days

These are hypotheses, not promises.

- public node uptime > 99%
- at least 25 external agent contacts attempted
- at least 10 successful machine interactions
- at least 5 externally contributed useful results
- at least 2 repeat collaborators
- zero secret exposures
- every production deployment reproducible from Git
