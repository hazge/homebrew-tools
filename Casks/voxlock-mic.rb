cask "voxlock-mic" do
  version "0.0.3"
  sha256 "ddcb0838ab7680b948b7cbd18876b5106ea626df6d5a08477c6d028fd171a6a5"

  url "https://github.com/hazge/homebrew-tools/releases/download/voxlock-mic-#{version}/VoxLock-Mic-#{version}.zip"
  name "VoxLock Mic"
  desc "Menu bar app that removes background voices from the microphone"
  homepage "https://github.com/hazge/homebrew-tools"

  depends_on cask: "blackhole-2ch"
  depends_on formula: "uv"
  depends_on macos: :sonoma

  app "VoxLock Mic.app"
  binary "#{appdir}/VoxLock Mic.app/Contents/Resources/voxlock-mic"

  uninstall launchctl: "com.hazge.voxlock-mic",
            quit:      "com.hazge.voxlock-mic",
            delete:    "~/Library/LaunchAgents/com.hazge.voxlock-mic.plist"

  zap trash: [
    "~/.config/voxlock",
    "~/Library/Logs/voxlock-mic.log",
  ]

  caveats <<~EOS
    Reboot once after the first install of blackhole-2ch so the BlackHole device appears.
    VoxLock Mic is not notarized: on its first launch open
    System Settings → Privacy & Security and press "Open Anyway".
    The first start installs Python packages and downloads the model, which takes a minute.
    In your call app pick "VoxLock Microphone" as the microphone.
    Before uninstalling, remove the device with: voxlock-mic --remove-device
    Details: https://github.com/hazge/homebrew-tools#voxlock-mic
  EOS
end
