# homebrew-tap

Personal Homebrew tap. Not project-specific — any number of formulae live here.

```bash
brew install broilogabriel/tap/<formula>
```

Or `brew tap broilogabriel/tap` and then `brew install <formula>`, or in a
`Brewfile`:

```ruby
tap "broilogabriel/tap"
brew "<formula>"
```

## Formulae

| Formula | What it is | Source |
|---|---|---|
| `spotifymenubar` | Menu-bar controller for the Spotify desktop app | [SpotifyMenuBar](https://github.com/broilogabriel/SpotifyMenuBar) |

## Conventions

**Name formulae so they don't collide with `homebrew/core`.** A tap formula sharing a
name with a core one cannot be installed side-by-side, and unqualified
`brew install <name>` resolves to core — the tap's is then only reachable as
`broilogabriel/tap/<name>`. Prefer a distinctive name over a generic one.

**Unsigned macOS GUI apps must build from source.** Compiled on the target machine a
bundle never receives `com.apple.quarantine`, so Gatekeeper never evaluates it and an
ad-hoc signature suffices. The same bytes delivered as a *download* are refused on
Apple Silicon — which is also why such a project belongs here as a formula rather than
a cask. That is why `spotifymenubar` builds from source; a plain CLI tool needs none
of this reasoning.

## Releasing

**Automated, per project.** Each source repo owns its own release workflow; pushing a
`v*` tag there publishes an immutable release asset and pushes the `url` + `sha256`
bump into this repo over a deploy key. Never edit those two lines by hand.

Every push to `main` and every pull request runs `brew test-bot`
(`.github/workflows/tests.yml`), which styles and audits the whole tap and
build-installs whatever changed. Covering pushes and not just PRs is deliberate: the
release workflows commit straight to `main`.

One deploy key grants write access to this entire repo — keys cannot be scoped to a
path — so any project holding one can rewrite another project's formula. Acceptable
between repos with a single owner; revisit if that stops being true.

## Known rough edges

- The bundle assembly in `Formula/spotifymenubar.rb` repeats four lines of the app
  repo's `build-app.sh`. Sharing it would mean teaching `build-app.sh` a brew-only
  concern (`--disable-sandbox`), so the duplication stands.
