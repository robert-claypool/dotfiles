# Identity and Secrets

This workstation uses 1Password as the private-key and secret control plane.
Chezmoi owns policy and public identity material; it never owns a private key or
secret value.

## 1Password CLI integration

In the unlocked 1Password app, open **Settings > Developer**, enable **Integrate
with 1Password CLI**, and enable Touch ID in 1Password. Then verify the supported
desktop integration without creating a long-lived session token:

```sh
op whoami
```

The 1Password SSH agent remains independent of CLI sign-in. SSH host policy
selects Wasabi's public key explicitly, while signing calls 1Password's
`op-ssh-sign` program. Chezmoi renders `~/.config/git/allowed_signers` from the
configured public key and limits it to the Git signature namespace.

Useful non-secret checks:

```sh
ssh -T git@github.com
ssh pineapple true
git verify-commit HEAD
```

## Project-scoped secret injection

Keep secret values out of shell startup, dotfiles, repositories, command
history, and long-lived agent environments. A project can let direnv expose only
1Password references, then resolve their values for one trusted child process.

Use a local, ignored `.env.op`:

```dotenv
SERVICE_TOKEN=op://vault/item/field
```

Load only the opaque reference from a reviewed `.envrc`:

```sh
dotenv_if_exists .env.op
```

Add `.env.op`, `.env`, and `.direnv/` to the project's ignore policy when their
metadata is private. After reviewing the file, run `direnv allow`. Resolve the
reference only at the command boundary:

```sh
op run -- your-command --flag
```

For commands that should not inherit the project's ordinary environment, pass
the reference file directly:

```sh
op run --env-file=.env.op -- your-command --flag
```

Only wrap commands whose code and subprocess behavior are trusted: the child
receives the actual values. Do not use `op item get --reveal`, print resolved
values, dump the child environment, or promote `.env.op` into a global secrets
file. Prefer narrowly scoped service accounts for unattended automation rather
than borrowing a human desktop session.

Official references:

- [1Password desktop app integration](https://www.1password.dev/cli/app-integration)
- [Load secrets into scripts](https://www.1password.dev/cli/secrets-scripts)
