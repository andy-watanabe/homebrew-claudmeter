class Claudemeter < Formula
  desc "Menu bar readout of your Claude extra-usage cap and burn-rate pace"
  homepage "https://github.com/andy-watanabe/claudmeter"
  url "https://github.com/andy-watanabe/claudmeter/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "de9e44ec5a370b556d5a4f607c4def280419f60c411cac33e24fe61bd6a09f48"

  # Only swiftc (from the Xcode Command Line Tools) is required to build this --
  # not a full Xcode.app install. Homebrew itself already requires the Command
  # Line Tools to function, so no extra depends_on is needed for that.
  depends_on :macos

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
