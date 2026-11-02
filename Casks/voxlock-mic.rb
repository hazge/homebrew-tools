cask "voxlock-mic" do
  version "0.0.4"
  sha256 "94bdd9cddc4f2a86725b8fbc96809f87081bd78938ee748d94597b00bafed6ff"

  url "https://github.com/hazge/homebrew-tools/releases/download/voxlock-mic-#{version}/VoxLock-Mic-#{version}.zip"
  name "VoxLock Mic"
  desc "Menu bar app that removes background voices from the microphone"
  homepage "https://github.com/hazge/homebrew-tools"

  depends_on cask: "blackhole-2ch"
  depends_on formula: "uv"
  depends_on macos: :sonoma

  app "VoxLock Mic.app"
  binary "#{appdir}/VoxLock Mic.app/Contents/Resources/voxlock-mic"

  uninstall early_script: {
              executable:   "#{appdir}/VoxLock Mic.app/Contents/MacOS/launcher",
              args:         ["--remove-device"],
              must_succeed: false,
            },
            quit:         "com.hazge.voxlock-mic"

  zap launchctl: "com.hazge.voxlock-mic",
      trash:     [
        "~/.config/voxlock",
        "~/Library/LaunchAgents/com.hazge.voxlock-mic.plist",
        "~/Library/Logs/voxlock-mic.log",
      ]

  caveats <<~EOS
    Reboot once after the first install of blackhole-2ch so the BlackHole device appears.
    VoxLock Mic is not notarized: on its first launch, and after an upgrade, open
    System Settings → Privacy & Security and press "Open Anyway".
    The first start installs Python packages and downloads the model, which takes a minute.
    In your call app pick "VoxLock Microphone" as the microphone.
    Details: https://github.com/hazge/homebrew-tools#voxlock-mic
  EOS
end
