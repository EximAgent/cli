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

macOS/Linux:
```bash
curl -fsSL https://cli.eximagent.ai/install | sh
```
Windows:
```powershell
irm https://cli.eximagent.ai/install.ps1 | iex
```
Installer verifies `.sha256`, REFUSES a mismatch and installs skills. Manual: check `eximagent-<os>-<arch>` checksums in `EximAgent/cli`.
Auth: `eximagent login` (OAuth) or `eximagent login --token <PAT>`; `eximagent whoami` verifies.

## Quick start

```bash
eximagent login                                          # browser sign-in
eximagent whoami                                         # verify
eximagent skill                                          # full agent guide
eximagent --dry-run search run --product "olive oil" --location US  # find buyers
eximagent enrich company --url <url>                     # profile + contacts
eximagent collection get --collectionId <collectionId>   # after run completion
```

Search run spends credits when confirmed; a preview is free. Preview first, then repeat with `--confirmed --previewToken <previewToken>` after approval and wait with `eximagent stream --run-id <runId>` before reading its collection.

Run `eximagent` for the command map, or `eximagent manifest` for the full machine-readable command tree.

## Install integrity

The installer fetches the published `.sha256` for the exact asset, recomputes the digest, and REFUSES a mismatch rather than installing. Every release publishes a per-asset digest and a `checksums.txt`, so the binary can be verified without running the script.

## License

All Rights Reserved — `LicenseRef-EximAgent-Proprietary`. See `LICENSE`.

## Two ways in: the CLI and the hosted connector

Both reach the SAME server, the same corpus and the same JSON envelope — one service, two doors. The CLI runs inside your agent's sandbox and needs outbound network there. The hosted MCP connector is added by your assistant and needs NO sandbox change, so it is the one to use when egress is blocked or you cannot install anything.

Before connecting, run `eximagent login` first, then `eximagent connect [claude-code|codex|cursor|all]` (default: claude-code).

```
recommended    eximagent connect
codex          codex mcp add eximagent --url https://mcp.eximagent.ai/mcp
               codex mcp login eximagent
Claude Code    claude mcp add --transport http eximagent https://mcp.eximagent.ai/mcp --scope user
Claude desktop Customize -> Connectors -> Add -> Add custom connector -> https://mcp.eximagent.ai/mcp
```

Sign in with Google when your host opens the consent page; no key to paste, and access is revocable at any time. Keep your agent's sandbox ON — nothing here needs it disabled. Full connector documentation: <https://eximagent.ai/docs/integrations/mcp>

## Customs data and shipment data MCP server

EximAgent runs a hosted MCP server for customs and shipment data. Add it to
Claude, Claude Code, ChatGPT, Cursor or Codex and ask trade questions in plain
language: who imports a product into a market, what a company ships and with
whom, which HS code fits a product, what duty applies on a corridor, and
whether a name is on the OFAC SDN list.

| | |
|---|---|
| Server URL | `https://mcp.eximagent.ai/mcp` |
| Transport | Streamable HTTP (not stdio) |
| Auth | OAuth 2.1 (dynamic client registration, PKCE), Google sign-in. No API key to paste. |
| Data | Per-shipment customs and bill-of-lading records, importer and exporter discovery data, WTO and national tariff schedules, the OFAC SDN list |
| Trust signals | Results carry their source and a confidence label (verified, extracted, heuristic, inferred); shipment answers include a coverage envelope |
| Safety | Tools are annotated read-only or destructive; trade lookups are read-only |

Add it:

```bash
claude mcp add --transport http eximagent https://mcp.eximagent.ai/mcp --scope user
codex mcp add eximagent --url https://mcp.eximagent.ai/mcp && codex mcp login eximagent
```

In Claude desktop: Customize → Connectors → Add → Add custom connector → paste the URL.

An EximAgent account is required; it is free to start.
Overview: <https://eximagent.ai/connectors> · Docs: <https://eximagent.ai/docs/integrations/mcp>

## Links

- <https://eximagent.ai>
