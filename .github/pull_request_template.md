# Title
<!-- Imperative mood. E.g., "Add JWT auth to API" -->

## Linked Issue
<!-- e.g., Closes #123 -->

## Narrated Summary (author → Sarah)
<!-- Write to Sarah directly in your voice:
"Sarah, I did this. You need to do this. This is what we have now. This is what I thought at the time. This still needs to be done." -->

## Job to Be Done (JTBD)
**When** [situation] **I want to** [intent] **so I can** [outcome].

## Problem Statement (Double Diamond: Define)
Precise user/system friction we’re removing.

## Scope & Non-Goals
- In: …
- Out: …

## Solution Exploration (Double Diamond: Develop)
Options considered (A/B/C), tradeoffs, chosen approach, rationale.

## C4 Delta (Architecture impact)
Describe what changed at each relevant level:
- **Context**: …
- **Container**: …
- **Component**: …
- **Code**: …
(If diagrams are helpful, commit Mermaid files under `docs/diagrams/` and link them: `docs/diagrams/container.mmd`, `component.mmd`.)

## Testing & Validation
- Unit: …
- Integration: …
- E2E/manual: …
- Post-merge signals/metrics: …

## Security / Privacy
Auth/ACL, secrets/config, PII/telemetry notes.

## Performance / Reliability
Load/latency expectation, timeouts/retries/backoff, SLO/SLI impact.

## Rollout & Rollback
Feature flag/staged deploy, safe rollback steps.

## Documentation
README/docs/diagrams/CHANGELOG updated.

## Checklist
- [ ] Narrated summary written in author voice to Sarah
- [ ] JTBD written
- [ ] Problem defined; scope bounded
- [ ] Options compared; approach justified
- [ ] C4 delta captured (and diagrams linked if used)
- [ ] Tests added/updated; CI green
- [ ] Docs & changelog updated
- [ ] Reviewer(s) tagged
