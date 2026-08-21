# homebrew-tap

Personal Homebrew tap.

```bash
brew install broilogabriel/tap/spotifymenubar
```

## Formulae

- **spotifymenubar** — menu-bar controller for the Spotify desktop app
  ([source](https://github.com/broilogabriel/SpotifyMenuBar))

## Why these build from source

`spotifymenubar` is ad-hoc signed, not notarized. Compiled on the target machine it
never receives `com.apple.quarantine`, so Gatekeeper never evaluates it and the
ad-hoc signature is sufficient. The same bytes delivered as a *download* would be
refused on Apple Silicon, which is also why this is a formula and not a cask.

## Releasing

**Automated.** Pushing a `v*` tag in the app repo runs its `release.yml` workflow,
which builds a source tarball, publishes it as an immutable release asset, and
pushes the `url` + `sha256` bump here using a deploy key. Do not edit those two
lines by hand.

Known duplication: the bundle assembly in `Formula/spotifymenubar.rb` repeats four
lines of the app repo's `build-app.sh`. Sharing it would mean teaching
`build-app.sh` to pass `--disable-sandbox`, which is a brew-only concern.
