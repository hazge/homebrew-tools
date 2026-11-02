# homebrew-tools

Homebrew tap with small tools.

```
brew install --cask hazge/tools/voxlock-mic
```

## VoxLock Mic

A menu bar app for macOS that removes other people's voices from your microphone on calls. It runs the open-source [VoxLock](https://huggingface.co/arbazsiddiqui/voxlock) model locally on the CPU and sends the cleaned audio to **VoxLock Microphone**, a virtual microphone you pick in Zoom or any other call app. Audio never leaves the Mac.

It targets background voices, such as a colleague talking next to you in an open space. For steady noise like fans or keyboards, the call app's own noise suppression is usually enough.

### Install

```
brew install --cask hazge/tools/voxlock-mic
```

The cask installs **VoxLock Mic.app**, the `voxlock-mic` command, [uv](https://github.com/astral-sh/uv) and the [BlackHole](https://github.com/ExistentialAudio/BlackHole) 2ch loopback driver. Then:

1. Reboot once after the first install so BlackHole appears.
2. Open VoxLock Mic from Applications or Spotlight. The app is not notarized, so the first time macOS blocks it: press **Done**, open System Settings → Privacy & Security, press **Open Anyway** and confirm, then open VoxLock Mic again. Open Anyway only allows the app; it does not start it. A reinstall needs the same steps.
3. The first start installs the Python dependencies and downloads the model (about 74 MB), which takes a minute; then 🗣️ appears in the menu bar and the app creates the VoxLock Microphone device.
4. When asked, record a 10-second sample of your voice: press Record and read the text shown, alone, in your normal voice. Allow microphone access for VoxLock Mic when macOS asks.
5. In Zoom: Settings → Audio → Microphone: **VoxLock Microphone**, microphone mode **Original sound for musicians**, so Zoom does not process the audio a second time.

### How it works

With **Turn on during calls** checked, VoxLock Mic starts as soon as an app opens VoxLock Microphone and stops 10 seconds after the call ends, so your real microphone stays free between calls. **Turn on now** starts it by hand.

**Microphone → Automatic** picks, in order: a Bluetooth microphone, the MacBook microphone if the lid is open, a USB microphone, then any other. Each microphone needs its own voice sample, saved in `~/.config/voxlock/`; the app asks for one the first time a microphone is used. **Open at login** starts the app when you log in.

### Command line

```
voxlock-mic                     open the menu bar app
voxlock-mic --list              list audio devices and voice samples
voxlock-mic --enroll --mic "…"  record a voice sample from a microphone
voxlock-mic --console           run in the terminal instead of the menu bar
voxlock-mic --remove-device     remove the VoxLock Microphone device
```

The log is `~/Library/Logs/voxlock-mic.log`.

### Limits

- Two or more other people talking at the same time are removed much less than one.
- A voice that sounds like yours is removed less than a different one.
- After an upgrade macOS may ask for microphone access again.

### Uninstall

```
brew uninstall --cask voxlock-mic
```

Uninstalling, and upgrading, removes the VoxLock Microphone device; the app creates it again when it starts. `brew uninstall --zap` also deletes the voice samples, the log and the login item. BlackHole stays installed: remove it with `brew uninstall --cask blackhole-2ch`.
