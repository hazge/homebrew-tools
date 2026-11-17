cask "mouser" do
  arch intel: "-intel"

  version "3.7.3"
  sha256 arm:   "030841812b004a4e2416ac3c177c4de60bc17cb08910b9402d72d9b174ed2da7",
         intel: "7780a3255dd9a611c138f8f3e953a88bcd169fd1732a66586d5ed396342e55ca"

  url "https://github.com/TomBadash/Mouser/releases/download/v#{version}/Mouser-macOS#{arch}.zip"
  name "Mouser"
  desc "Local button remapper for Logitech HID++ mice, an alternative to Logi Options+"
  homepage "https://github.com/TomBadash/Mouser"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Mouser.app"

  uninstall launchctl: "io.github.tombadash.mouser",
            quit:      "io.github.tombadash.mouser"

  zap trash: [
    "~/Library/Application Support/Mouser",
    "~/Library/LaunchAgents/io.github.tombadash.mouser.plist",
  ]

  caveats <<~EOS
    Quit Logi Options+ first: both apps need the mouse over HID++ and only one can own it.
    Mouser is not notarized: when macOS blocks its first launch, press "Done", open
    System Settings → Privacy & Security, press "Open Anyway", then open Mouser again.
    Grant Accessibility to Mouser when asked; the Back and Forward buttons need it.
  EOS
end
