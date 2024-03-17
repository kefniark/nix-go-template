# Nix Go Template

Small experimentation trying to package a Go Application with nix flakes

## Goals

- Be able to have a small understandable flake
- Be able to use recent Go (from unstable) and keep stable dependencies for everything else
- Get a nice dev experience
  - All tools installed automatically with right versions
  - [Just](https://github.com/casey/just) as a command runner
  - And some preconfigured alias to make our life easier
- Get a simple build
  - Reproducible with [gomod2nix](https://github.com/nix-community/gomod2nix)
  - Work fine even with multiple CLI
  - Cross platform

---

## Dev Environment (Dev Shell)

With this template, you can develop your Go Application locally with a reproducible one line setup.

```sh
nix develop .
```

No need to install anything manually, everything comes from nix (Go, formatter, linter, ...).

```sh
# Run our app during development (alias for go run ...)
dev-app1
dev-app2

# Use dev tools based on just
just fmt
just lint
just test
just check
```

## Testing Experience (Nix Shell)

Nix can also be used as a package manager, to build & install our app

```sh
nix shell .

# We can use our app like any installed tool
app1
app2

# our app is removed and we get a clean shell
exit
```

You can even test without even cloning the repo `nix shell github:kefniark/nix-go-template`
