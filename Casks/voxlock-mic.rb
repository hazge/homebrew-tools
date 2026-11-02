cask "voxlock-mic" do
  version "1.0.0"
  sha256 "3fa55a34140d6136923b5aa0efcd53b89dd454d6a4922d7611be1e9abd406c91"

  url "https://raw.githubusercontent.com/hazge/homebrew-tools/voxlock-mic-#{version}/voxlock-mic/voxlock-mic"
  name "voxlock-mic"
  desc "Removes background voices from the microphone with the VoxLock model"
  homepage "https://github.com/hazge/homebrew-tools"

  depends_on cask: "blackhole-2ch"
  depends_on formula: "uv"

  binary "voxlock-mic"

  caveats <<~EOS
    Reboot once after the first install of blackhole-2ch so the BlackHole device appears.
    Then record your voice sample and pick BlackHole 2ch as the microphone in your call app:
      voxlock-mic --list
      voxlock-mic --enroll --mic "<your microphone>"
    Details: https://github.com/hazge/homebrew-tools#voxlock-mic
  EOS
end
