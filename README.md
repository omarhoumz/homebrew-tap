# omarhoumz/homebrew-tap

Homebrew formulae for my projects.

```sh
brew install omarhoumz/tap/portwho
```

## Formulae here are generated, not written

[dist](https://github.com/axodotdev/cargo-dist) renders each formula from a fixed
template and force-pushes it on every release, so edits to `Formula/*.rb` survive
exactly one version.

`.github/workflows/add-completions.yml` works around the one thing the template
cannot do: install shell completions. It reacts to a push touching `Formula/*.rb`
and inserts a `generate_completions_from_executable` call, so the patch
re-applies itself on every release instead of being overwritten by it. The script
lives at `.github/patch-formula.py` and is idempotent.

It cannot loop — pushes made with `GITHUB_TOKEN` do not trigger workflows.

Consequence: **do not hand-edit a formula here.** Fix it upstream in the project's
`dist-workspace.toml`, or extend the patch script.
