class Claudemeter < Formula
  desc "Menu bar readout of your Claude extra-usage cap and burn-rate pace"
  homepage "https://github.com/andy-watanabe/claudmeter"
  url "https://github.com/andy-watanabe/claudmeter/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "451cac83488ff134d7f6dbc2d5d3fee0928e2b4e343621edcb43f7edd62330e9"

  depends_on :macos
  depends_on xcode: :build

  # Builds from source rather than shipping a prebuilt binary, same as this
  # tap's sibling install.sh: nothing to notarize, nothing for Gatekeeper to
  # quarantine, and it's obvious exactly what's running on your machine.
  def install
    system "swiftc", "-O", "main.swift", "-o", "claudemeter", "-framework", "Cocoa"
    bin.install "claudemeter"
  end

  def caveats
    <<~EOS
      ClaudeMeter is a menu bar app, so `claudemeter` won't return on its own —
      run it in the background to start it now:

        claudemeter &

      To keep it running after you log in again, launch it once, click the
      menu bar icon, and toggle "Start at Login" from its menu.
    EOS
  end

  test do
    # --dump exercises the same read path as the menu bar without needing a
    # GUI session. It's expected to succeed (real usage data present) or fail
    # gracefully (no Claude Desktop log on this machine) -- either is a pass;
    # a crash or unexpected output is not.
    output = `#{bin}/claudemeter --dump 2>&1`
    assert_match(/used:|no usage data/, output)
  end
end
