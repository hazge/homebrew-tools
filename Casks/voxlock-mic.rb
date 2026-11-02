cask "voxlock-mic" do
  version "0.0.2"
  sha256 "db6f249904f0a0bf222a491c011e5929ba2fedc60a33c974b23657856246899f"

  url "https://raw.githubusercontent.com/hazge/homebrew-tools/voxlock-mic-#{version}/voxlock-mic/voxlock-mic"
  name "voxlock-mic"
  desc "Removes background voices from the microphone with the VoxLock model"
  homepage "https://github.com/hazge/homebrew-tools"

  depends_on cask: "blackhole-2ch"
  depends_on formula: "uv"

  binary "voxlock-mic"

  caveats <<~EOS
    Reboot once after the first install of blackhole-2ch so the BlackHole device appears.
    Then record your voice sample and start it; the first start creates the VoxLock Microphone device:
      voxlock-mic --list
      voxlock-mic --enroll --mic "<your microphone>"
      voxlock-mic
    In your call app pick VoxLock Microphone as the microphone.
    Before uninstalling, remove the device with: voxlock-mic --remove-device
    Details: https://github.com/hazge/homebrew-tools#voxlock-mic
  EOS
end
