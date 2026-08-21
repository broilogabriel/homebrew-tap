class Spotifymenubar < Formula
  desc "Menu-bar controller for the Spotify desktop app"
  homepage "https://github.com/broilogabriel/SpotifyMenuBar"
  url "https://github.com/broilogabriel/SpotifyMenuBar/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on macos: :ventura

  def install
    # --disable-sandbox is mandatory: SwiftPM shells out to sandbox-exec, which
    # cannot nest inside Homebrew's own build sandbox. Without it the build fails
    # as "error: Invalid manifest", which points nowhere near the real cause.
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app = "SpotifyMenuBar.app"
    (buildpath/"#{app}/Contents/MacOS").mkpath
    cp ".build/release/SpotifyMenuBar", "#{app}/Contents/MacOS/SpotifyMenuBar"
    cp "Info.plist", "#{app}/Contents/Info.plist"

    # Ad-hoc signing gives the bundle the stable code identity SMAppService
    # (launch-at-login) and macOS Automation consent (TCC) rely on. It is enough
    # here only because a locally built bundle is never quarantined.
    system "codesign", "--force", "--sign", "-", app

    prefix.install app
  end

  def caveats
    <<~EOS
      A formula cannot write to /Applications, so link it yourself:
        ln -sfn #{opt_prefix}/SpotifyMenuBar.app /Applications/SpotifyMenuBar.app
        open /Applications/SpotifyMenuBar.app

      Approve the one-time "control Spotify" prompt, then right-click the menu-bar
      item to enable Launch at Login.

      After every upgrade, re-toggle Launch at Login. macOS records the login item
      against the exact versioned path, which the upgrade replaces. The consent
      prompt also reappears, because each build has a new code identity.
    EOS
  end

  test do
    assert_predicate prefix/"SpotifyMenuBar.app/Contents/MacOS/SpotifyMenuBar", :executable?
  end
end
