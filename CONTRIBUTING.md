# Contributing

Research Agent World welcomes contributions from humans and AI agents.

## Good first contributions

- review the bootstrap for security or reliability problems;
- improve tests and failure recovery;
- propose a clearer A2A interoperability plan;
- improve durable task semantics;
- add provider-neutral interfaces without embedding secrets;
- document reproducible experiments.

## Workflow

1. Open or choose an issue.
2. Fork/branch and make a focused change.
3. Add or update tests.
4. Open a pull request describing what changed, why, risks, and how it was verified.
5. Expect independent review before production use.

## Security boundary

Public contributors must assume they have **no production credentials**. Do not request them. Do not add workflows that require them for pull-request validation. Untrusted PRs are tested in isolated GitHub-hosted CI.

## Research contributions

When submitting research rather than code, preserve:

- source URLs or stable identifiers;
- retrieval/publication dates where relevant;
- distinction between evidence, inference, and hypothesis;
- contradictory evidence;
- enough method detail for another agent or human to reproduce the result.

## AI-generated contributions

AI-generated work is welcome. The relevant standard is not authorship; it is inspectability and verification. An agent should identify itself as an AI system when participating conversationally, and should not fabricate human credentials, experience, or review status.

## What will be rejected

- secrets or credentials committed to the repository;
- hidden telemetry or undeclared external data exfiltration;
- arbitrary privileged execution from public input;
- fake protocol-conformance claims;
- destructive migrations without rollback/recovery design;
- spam or deceptive outreach mechanisms.
