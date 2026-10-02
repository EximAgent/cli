# eximagent

Trade-intelligence CLI for AI agents.

Find real buyers, importers, and distributors from customs trade data — then enrich and reach them, without leaving your AI agent.

## What you can do

- **Discover** buyers / importers / distributors from real trade data
- **Look up** HS codes, tariffs, duties, and country/corridor rules
- **Screen** companies against OFAC sanctions (fail-closed)
- **Enrich** company profiles and decision-maker contacts from any website
- **Reach out** with drafted cold email and stage tracking

Every row is confidence-tagged; results AND typed errors are JSON on stdout (stderr carries only progress heartbeats), `--stream` for long-running commands.

## Install

If the `eximagent` binary is not already on PATH, install it first — one command, no runtime to set up.

**macOS / Linux:**

```bash
curl -fsSL https://cli.eximagent.ai/install | sh
```

**Windows (PowerShell):**

```powershell
irm https://cli.eximagent.ai/install.ps1 | iex
```

The installer VERIFIES ITS DOWNLOAD: it fetches the published `.sha256`, recomputes the digest, and REFUSES a mismatch rather than installing. To skip the script, take `eximagent-<os>-<arch>` and its `.sha256` from any release of `EximAgent/cli`, verify, and place it on PATH.

Then authenticate with `eximagent login` (OAuth device flow) or `eximagent login --token <PAT>`, and verify with `eximagent whoami`. The installer also drops this skill into the host agent's skill directories.

## Quick start

```bash
eximagent login                                          # browser sign-in
eximagent whoami                                         # verify
eximagent skill                                          # full agent guide
eximagent search run --product "olive oil" --location US  # find buyers
eximagent enrich company --url <url>                     # profile + contacts
eximagent email draft --dry-run                          # draft outreach
```

Run `eximagent` for the command map, or `eximagent manifest` for the full machine-readable command tree.

## Install integrity

The installer fetches the published `.sha256` for the exact asset, recomputes the digest, and REFUSES a mismatch rather than installing. Every release publishes a per-asset digest and a `checksums.txt`, so the binary can be verified without running the script.

## License

All Rights Reserved — `LicenseRef-EximAgent-Proprietary`. See `LICENSE`.

## Two ways in: the CLI and the hosted connector

Both reach the SAME server, the same corpus and the same JSON envelope — one service, two doors. The CLI runs inside your agent's sandbox and needs outbound network there. The hosted MCP connector is added by your assistant and needs NO sandbox change, so it is the one to use when egress is blocked or you cannot install anything.

```
recommended    eximagent connect
codex          codex mcp add eximagent --url https://mcp.eximagent.ai/mcp
               codex mcp login eximagent
Claude Code    claude mcp add --transport http eximagent https://mcp.eximagent.ai/mcp --scope user
Claude desktop Settings -> Connectors -> Add custom connector -> https://mcp.eximagent.ai/mcp
```

Sign in with Google when your host opens the consent page; no key to paste, and access is revocable at any time. Keep your agent's sandbox ON — nothing here needs it disabled. Full connector documentation: <https://mcp.eximagent.ai/docs/connector>

## Links

- <https://eximagent.ai>
