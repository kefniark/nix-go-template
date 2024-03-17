# Nix Go Template

Small experimentation trying to package a Go Application and multiple CLI commands with nix flakes.

## Goals

- Be able to have a small understandable flake. Most of the one on the net are overly complex for my need.
- Be able to use recent Go (from unstable) with stable dependencies.
- Be able to build cross platform
- Get a nice devShells experience
  - [Just](https://github.com/casey/just) as a command runner
  - All tools installed automatically with right versions

---

## Dev Environment (Dev Shell)

With this template, you can develop your Go Application locally with a reproducible one line setup.

```sh
nix develop .
```

No need to install anything manually (Go, linter, ... or worry about versions).

```sh
# Run our app (alias for go run ...)
dev-app1
dev-app2

# And dev tools based on just
just fmt
just lint
just test
just check
```

## Testing Experience (Nix Shell)

Nix can also be used as a package manager, to build & install our app

```sh
nix shell .

app1 # We can use our app like any installed tool
app2

exit # our app is removed and we get a clean shell
```
