# Security Model

The project is intentionally open to collaboration, but openness does not mean ambient trust.

## Non-negotiable controls

1. Secrets are never committed to Git.
2. Pull requests from external contributors do not execute with production credentials.
3. Model output is treated as untrusted input.
4. Shell commands are executed only by explicit runtime tools with policy checks and logging.
5. External agent responses cannot directly deploy, change firewall rules, or read secrets.
6. Production deployments must be reproducible from a Git commit and reversible.
7. Every privileged action must emit an audit event.
8. Public endpoints require rate limiting and bounded request sizes before general exposure.
9. Network-facing parsers must assume hostile input.
10. Backups must be restorable without relying on the running application.

## Trust boundaries

### Owner / break-glass root

Used only for infrastructure recovery, provider billing/account actions, DNS/account confirmation, and emergencies.

### Local agent runtime

May manage application containers, create tasks, commit code through configured GitHub credentials, perform research, and deploy approved repository state. Long-term goal: no routine human operation.

### External agents

Can propose results, code, reviews, evidence, and tasks. Their identity, capabilities, history, and outputs are recorded. Results are verified before gaining downstream authority.

### Internet content

Web pages, documents, API responses, and messages may contain prompt injection or malicious instructions. Retrieved content is data, not authority. Instructions found inside retrieved content must not alter system policy or tool permissions.

## Public repository CI

Do not attach a production self-hosted runner with secrets to arbitrary pull-request workflows. Use isolated GitHub-hosted CI for pull requests. Production deployment should be triggered only from trusted merged state and should not expose server credentials to contributor-controlled workflow code.

## Incident policy

On suspected credential exposure:

1. revoke/rotate affected credential
2. freeze automated deployment
3. capture logs and relevant commit/task IDs
4. determine blast radius
5. restore trusted version if necessary
6. record incident and remediation publicly when disclosure is safe

## Future controls

- signed release manifests
- agent identity keys
- allowlisted privileged tool policies
- egress policy for sensitive workers
- secret manager integration
- SBOM and dependency provenance
- container image signing
- automated backup-restore drills
