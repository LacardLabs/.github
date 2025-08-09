# Title
<!-- Imperative mood. E.g., "Add JWT auth to API" -->

## Linked Issue
<!-- e.g., Closes #123 -->

## Job to Be Done (JTBD)
**When** [situation] **I want to** [motivation/intent] **so I can** [expected outcome].

## Problem Statement (Double Diamond: Define)
What is the precise problem? What user/system friction are we removing?

## Scope & Non-Goals
- In: …
- Out: …

## Solution Exploration (Double Diamond: Develop)
- Options considered: A / B / C (tradeoffs)
- Chosen approach: …
- Rationale: …

## C4 Delta (Architecture impact)
**Context/Container/Component/Code**: What changed? Any new boundaries, contracts, or risks?

<details>
<summary>Mermaid (optional)</summary>

```mermaid
%% Container view (example)
flowchart LR
  browser[Web App] --> api[(API Service)]
  api --> db[(Postgres)]
