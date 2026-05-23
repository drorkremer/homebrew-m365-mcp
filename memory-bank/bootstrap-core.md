# Bootstrap — homebrew-m365-mcp

Project-specific orientation for fresh agent sessions. Cross-project
m365-mcp ecosystem context lives in the sub-portfolio layer
(`m365-mcp:portfolio-layer`); this file covers only what's unique to
this repo.

## What this project is

The distribution side of the m365-mcp surface: a Homebrew tap formula
(`Formula/`), a Winget manifest (`winget/`), and a PowerShell
installer (`install.ps1`). End users install the CLI from here; the
actual code lives in the sibling `m365-copilot-skill` repo.

## Canonical references

- `README.md` — user-facing install / upgrade / uninstall flow across
  Homebrew, Winget, and the PowerShell one-liner.
- `Formula/` — Homebrew formula. Pin updates here when a new
  `m365-copilot-skill` release ships.
- `winget/` — Winget manifest; same release-pinning discipline.
- `install.ps1` — Windows fall-back installer for users not on Winget.

## Working norms specific to this project

- **Release flow is unidirectional**: `m365-copilot-skill` cuts a
  release → this repo's formula + manifest update to the new version
  + hash → end users `brew upgrade` / `winget upgrade`. Don't edit
  the formula's URL/version without a corresponding upstream release.
- **No source code lives here.** Anything beyond packaging
  descriptors and the install script signals scope creep.

## Promotion notes

- Facts that apply to **both** m365-mcp projects (e.g., a shared
  versioning rule across the CLI and the tap) → promote to
  `m365-mcp:portfolio-layer`.
- Universal principles independent of the M365 ecosystem → surface
  as a candidate for `global`.
