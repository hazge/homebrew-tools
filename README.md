# homebrew-tools

Homebrew tap with small command-line tools.

```
brew install --cask hazge/tools/voxlock-mic
```

## voxlock-mic

Removes other people's voices from your microphone on calls, on macOS. It runs the open-source [VoxLock](https://huggingface.co/arbazsiddiqui/voxlock) model locally on the CPU and sends the cleaned audio to the [BlackHole](https://github.com/ExistentialAudio/BlackHole) virtual device, which you pick as the microphone in Zoom or any other app. Audio never leaves the machine.

It targets background voices, such as colleagues in an open space. For steady noise like fans or keyboards, the app's own noise suppression is usually enough.

### Install

```
brew install --cask hazge/tools/voxlock-mic
```

The cask installs [uv](https://github.com/astral-sh/uv) and BlackHole 2ch. Reboot once after the first install so BlackHole appears. The Python dependencies are declared inside the script and installed by uv on the first run; the VoxLock version is pinned.

### Use

1. Record a sample of your voice, once per microphone. Talk normally for the whole 10 seconds, alone:
   ```
   voxlock-mic --list
   voxlock-mic --enroll --mic "<your microphone>"
   ```
   Samples are saved to `~/.config/voxlock/<microphone>.wav`; the first one is also saved as `default.wav`, used for microphones without their own sample.
2. In Zoom: Settings → Audio → Microphone: **BlackHole 2ch**, microphone mode **Original sound for musicians**, so Zoom does not process the audio a second time.
3. Before your calls, run `voxlock-mic` and keep it running. While it is not running, the app hears nothing.

Without `--mic` it uses the system input. If the system input is BlackHole itself, it picks the connected microphone whose sample was recorded last, so BlackHole can be the system microphone for every app.

### Notes

- macOS asks for microphone access for your terminal on the first run.
- With the MacBook lid closed the built-in microphone is off; use headphones or a webcam.
- Without a sample, or with `--live`, it learns your voice from the first 3 seconds of speech and passes audio through until then. A loud neighbour in those seconds gets learned instead of you, so record a sample.
