# Robert's workstation state

This repository defines a convergent, inspectable developer workstation. It is
optimized for native Unix tooling, Vim muscle memory, agentic software work,
Keystone development, and a macOS laptop that will also run local ML and data
workloads.

Chezmoi reconciles home-directory state. It does not own packages, secrets,
application data, repositories, or Keystone runtime state.

## Ownership boundaries

| State | Owner | Policy |
| --- | --- | --- |
| Shell, Git, SSH policy, Ghostty, Starship, Atuin config, Finder Quick Actions | Chezmoi | Render and reconcile |
| CLI tools and selected macOS apps | Homebrew Bundle | Explicit plan/apply |
| Private keys and secrets | 1Password | Never copy into this repository |
| Neovim configuration | my.nvim Git repository | Chezmoi manages only the link |
| Keystone binaries | kstoolchain | Managed bin wins PATH resolution |
| AWS profiles and SSO cache | AWS CLI local state | Migrate non-secret profiles manually; never credentials |
| Atuin database and auth | Atuin local state | Preserve; never replace during apply |
| Codex sessions and Keystone memory/runtime state | Their owning tools | Preserve; never import into Chezmoi |
| Large datasets and model artifacts | Future Keystone data control plane | Deliberately out of scope here |

The result is a useful split: Chezmoi answers “what should this home look
like?”, while each stateful system keeps its own data and recovery semantics.

## First-machine workflow

Prerequisites are Git, Homebrew, the 1Password app with its SSH agent enabled,
and a per-machine public key exported under ~/.ssh/<hostname>.pub.

~~~sh
mkdir -p "$HOME/git"
git clone https://github.com/robert-claypool/dotfiles.git "$HOME/git/dotfiles"
brew install chezmoi

cd "$HOME/git/dotfiles"
./bin/dot init
./bin/dot plan
./bin/dot packages apply
git clone https://github.com/robert-claypool/my.nvim.git "$HOME/git/my.nvim"
./bin/check
./bin/dot apply
./bin/dot doctor
exec zsh -l
~~~

On macOS, review the defaults section emitted by `dot plan`, then opt in with
`./bin/dot macos apply`. It remains separate because changing OS preferences is
more consequential than reconciling home-directory files.

dot init prompts for the repository root, Git identity, machine profile, and
per-machine public key. On Robert's standard layout, dot init --defaults uses:

- repository root: ~/git
- profile: workstation
- Git identity: Robert Claypool / robert-claypool@outlook.com
- signing key: ~/.ssh/<lowercase-hostname>.pub

Chezmoi then maintains ~/.config/nvim as a link to that independent checkout.
The first Neovim launch downloads its pinned plugins; that network event is
intentionally not hidden inside workstation apply.

## Normal workflow

~~~sh
dot plan                 # home diff, package drift, and macOS-default drift
dot apply                # home state only
dot packages plan        # Homebrew Bundle check
dot packages apply       # install missing declared packages
dot macos plan           # read-only defaults comparison
dot macos apply          # write only drifted defaults
dot doctor               # invariants, ownership boundaries, disk floor
dot storage              # disk headroom and known high-growth locations
dot bench                # repeatable interactive Zsh startup benchmark
~~~

The wrapper stays thin. Direct commands remain first-class:

~~~sh
chezmoi diff
chezmoi apply ~/.zshrc
brew bundle check --verbose --file "$(dot source)/Brewfile"
~~~

Package apply never performs Homebrew cleanup. macOS apply never restarts the
Dock, Finder, or the login session. Those disruptive actions remain explicit.

## Shell design

Zsh is native: there is no Oh My Zsh and no plugin bootstrap network request.
Homebrew owns autosuggestions, syntax highlighting, and completions. Shell
startup remains readable in home/dot_zshrc.

The environment is loaded from ~/.zshenv, so non-interactive Zsh processes and
agent subprocesses resolve the same toolchain. The kstoolchain managed bin is
the final PATH insertion and therefore wins over stale Go-installed adapters.
Chezmoi preserves kstoolchain's exact managed marker block at the end of
~/.zshrc so workstation reconciliation and Toolchain's PATH doctor converge.

Enhanced tools do not shadow Unix primitives:

- ls, cat, and grep retain standard semantics.
- ll, la, lt, lg, and bcat opt into enhanced views.
- del moves files to Trash; rmd is the visually explicit real-rm escape hatch.

Atuin is local-first with automatic cloud sync disabled. Ctrl-R uses Atuin;
arrow keys keep ordinary history behavior.

## Local overlays

These paths are intentionally unmanaged and survive every apply:

- ~/.config/shell/local.sh — machine/job-specific shell additions, not secrets
- ~/.config/git/local — optional Git overrides
- ~/.ssh/config.d/*.conf — additional private SSH hosts
- ~/.config/ghostty/local — machine-local Ghostty experiments and font override
- ~/.config/workspaces/local/*.sh — private workspace URLs and profile mappings

Use 1Password references plus direnv/op run for secrets. Do not create a global
shell secrets file.

The concrete biometric sign-in, scoped secret-injection, SSH-agent, and Git
signature-verification workflows are documented in
[docs/identity-and-secrets.md](docs/identity-and-secrets.md).

## Git and SSH

The workstation profile signs commits and tags with the machine-specific SSH
key through 1Password. GitHub and Pineapple use that same explicit public key,
with IdentitiesOnly enabled; the private key stays in the 1Password agent.
Chezmoi renders Git's allowed-signers file from that public key so local
signature verification uses the same machine identity.

Each machine gets its own key. Wasabi must never reuse Pineapple's machine key.
SSH agent forwarding is disabled by default.

## Python, AWS, and PostgreSQL

Python environments belong to their projects. Use `uv` with a declared
`requires-python` range and a checked-in lockfile; do not install a global set
of ML packages or make the newest Homebrew Python an implicit compatibility
promise. `uv` may download a compatible interpreter when a project needs one.

AWS profiles and SSO sessions are deliberately machine-local. It is safe to
copy `~/.aws/config` after inspection, but never copy `~/.aws/credentials`.
Prefer `aws sso login --profile <name>` and keep account selection explicit.

Homebrew's keg-only `libpq` supplies `psql` and client libraries without
starting a local PostgreSQL server. Shell configuration derives the client path
from the detected Homebrew prefix without force-linking, while preserving
Postgres.app as an optional fallback.

## Android

Homebrew owns the command-line tools, platform tools, and Temurin 17. The shell
discovers either the conventional `~/Library/Android/sdk` or Homebrew's SDK
root, while Java 26 remains the general workstation default. Android projects
should select JDK 17 through their Gradle wrapper or project command rather
than changing global `JAVA_HOME`.

`~/.androidrc` disables Android CLI metrics. SDK platforms and build-tools are
project demands rather than global package-manifest entries; install only the
versions named by the project and let Gradle's checked-in wrapper own Gradle.
Emulators and system images are intentionally absent until a real workflow
requires them.

## macOS defaults

macos/defaults.sh owns a deliberately small set:

- fast key repeat and no press-and-hold accent chooser
- visible file extensions and Finder path/status context
- stable list view and Spaces ordering
- the chosen Dock size/visibility behavior
- suppression of .DS_Store on network and USB volumes

Run dot macos plan before every apply. The program reports current and desired
values and does not rewrite Dock contents.

The Finder `Copy Path` Quick Action is managed as home-directory state rather
than a macOS default. It copies selected items as newline-separated POSIX paths
and contracts the home-directory prefix to `~`. Finder's native
Option-Command-C remains available when an unmodified absolute path is needed.

## Storage posture

dot doctor reports free disk and warns below either 200 GiB or 15% free.
`dot storage` provides the detailed, size-sorted view of known developer state,
including language caches, Android and Apple SDK data, and any model or
container stores that actually exist. Neither command evicts caches or data.

This is an early warning only. Dataset/model materialization, checksums, pins,
leases, receipts, eviction, and reconciliation belong in Keystone's future data
control plane, backed by replaceable storage engines.

## Quality gates

~~~sh
bin/check
~~~

The gate validates shell syntax/style, Starship and Ghostty config, Chezmoi
rendering, an isolated-home apply, and second-apply idempotence. Testing never
needs to overwrite the live home directory.

bootstrap.sh remains only as a compatibility alias for dot init. New automation
should call bin/dot explicitly.

Workspace and Stream Deck details remain in docs/streamdeck-workspaces.md.
