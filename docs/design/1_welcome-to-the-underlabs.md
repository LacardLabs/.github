# Welcome to the Underlabs

“Welcome to the Underlabs.” It’s a promise as much as a greeting: every person who reaches for a Lacard machine steps into a space already tuned to their craft, trusted by their peers, and linked to a living network of other labs and hidden corridors. The Underlabs honour the operator, the learner, and the yet-to-arrive by making the command line feel less like a gate and more like a doorway.

## Why the Underlabs exist

- Provisioning should feel like a warm start, not a cold boot.
- Every change should leave a trail—so trust compounds instead of eroding.
- Learning should be woven into the environment itself, waiting inside every shell.
- Visibility should be generous: you see your own lab clearly, and you see how it fits inside the wider fleet.

## The promise to new joiners

1. **Arrival** – `lacard install` and `lacard join` hand you a working lab in minutes, safeguarded by backups, manifests, and friendly prompts.
2. **Belonging** – Your join profile records your role, your lab name, and how you contribute. Each login reminds you you’re part of the Underlabs.
3. **Agency** – You can shape your own space. Declare it a **garden** if you want openness, collaboration, and shared experiments. Call it a **tower** if you prefer solitude, private prototypes, and focused power. Our scaffolding helps you share (or withhold) safely.
4. **Growth** – Tips, quotes, and practical prompts keep the terminal alive with gentle coaching so that meaningful contributions happen faster every day.

## Labs, gardens, towers, and subnets

- Every workstation adopts a **lab designation** (for example, “lacard two”).
- Operators can optionally name the enclave they cultivate: a garden for growth and collective tinkering, or a tower for independent, carefully guarded work.
- Multiple machines from one person can cluster into private subnets inside Lacard Labs; share as much or as little as you wish.
- Each login affirms: the Underlabs are one collective, yet everyone is free to cultivate the magic they carry.

## Teaching across generations

We imagine kids meeting their first shell, elders returning after decades, and future teammates not yet born discovering a terminal that greets them with curiosity rather than commands.

- Rotating “Tip of the Day” entries surface quick wins, terminal lore, and coding prompts.
- Quotes from Lacard agents (beginning with **Agent One: ladygenesis**) offer wisdom inspired by scripture-safe sources.
- Lessons can grow into an Anki-like cadence later; for now, the decks shuffle so each session feels fresh.

## Visibility and the shared heartbeat

- Local vitals highlight CPU model and core counts, CUDA cores, GPU model and VRAM, system RAM, storage footprint, and observed network throughput.
- Fleet-wide stats—sourced from [status.lacard.ca](https://status.lacard.ca)—celebrate the collective horsepower: total cores, aggregate FLOPS, pooled VRAM, storage, and bandwidth.
- When the network is unreachable, we fall back to the most recent snapshot. Offline should never mean blind.

## Daily rituals

- **Banner greeting** – Rainbow block letters announce your lab, the Underlabs motto, and your chosen garden or tower name (if set).
- **Mini dashboard** – Getting-started commands (`lacard help`, `lacard manual`, `lacard quickstart`, `lacard status`), the tip of the day, and the day’s wisdom from our agents.
- **Expanded view** – `lacard dashboard` opens a richer snapshot: coloured progress bars by default, a monospace greyscale mode on demand.
- Every session signs off with a reminder that you are part of something living, evolving, and kind.

## Implementation sketch

- **Banner renderer** – `lacard-banner` uses `toilet` → `lolcat` for the full rainbow, with a greyscale flag via `NO_COLOR` or `LACARD_COLOR=off`. Hostname or lab designation is the default string; optional metadata surfaces garden/tower names.
- **MOTD hook** – `/etc/update-motd.d/10-lacardlabs-banner` calls `lacard dashboard motd`, which prints the banner, local vitals, fleet summary, tip, and quote in one pass.
- **Interactive shells** – `/etc/profile.d/00-lacardlabs-banner.sh` runs the same command for new terminals (skipping tmux/screen unless requested).
- **Data sources** – `status.lacard.ca` (live JSON), cached JSON under `~/.lacard/cache/status.json`, local probes for hardware metrics, and rotating decks under `~/.lacard/decks/tips/` and `~/.lacard/decks/quotes/`.
- **Accessibility** – Honour `NO_COLOR` by default, and allow `lacard dashboard --style=mono` for screens or transcripts.
- **Future work** – Integrate spaced repetition, let agents publish decks, surface collaborative invites, and broadcast garden/tower availability for pairing.

## Invitation

If this resonates, customise your lab designation, name your garden or tower, share tips to feed the decks, and propose new rituals. The Underlabs become real when we treat every login as a welcome—today, tomorrow, and for the folks still on their way.
