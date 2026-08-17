# png_series_animator

A premium, highly customizable Flutter widget that animates a series of PNG images as a high-performance frame-by-frame animation, with built-in support for custom transition builders between frames.

It works like a programmatic flipbook but adds smooth interpolations, crossfades, slides, zooms, and custom effects between frame boundaries.

---

## Showcase Animation Sequence

Below is a conceptual layout of the programmatically generated bouncing energy orb animation sequence featured in the example application:

![Neon Energy Orb Animation Sequence](doc/images/showcase_animation.png)

---

## Features

- ⚡ **High Performance Caching**: Automatically pre-caches and registers all image providers to prevent flickering during playback.
- 🎵 **Built-in Audio Sync**: Simply provide an `audioPath` to synchronize your animation with an audio file automatically.
- 💬 **Subtitles & RTL Support**: Multi-language subtitles with word-level highlighting and full RTL support for languages like Arabic or Hebrew.
- 🎮 **Programmatic Control**: New `PngSeriesController` to play, pause, and seek from anywhere in your code.
- 🔄 **Looping Controls**: Easily toggle between single playback (`repeat: false`) and infinite looping (`repeat: true`).
- 🛠️ **Custom Transitions**: Build complex inter-frame transitions (e.g. crossfading, sliding, rotating, zooming) using the dynamic `PngSeriesTransitionBuilder`.
- 📊 **Flexible Sizing**: Define layout dimensions using `width`, `height`, and `fit` (supports all standard `BoxFit` types).
- 🔔 **Callbacks**: Listen to play state changes, seek events, and completion hooks for perfect audio-visual sync.
- 🎯 **Gapless Playback**: Employs Flutter's gapless playback configuration to prevent frame flashes.

---

## Getting Started

Add the package dependency to your `pubspec.yaml`:

```yaml
dependencies:
  png_series_animator: ^1.4.0
```

Define your animation assets folder in your project's `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/your_animation_folder/
```

---

## Usage

Here is a simple example of using `PngSeriesAnimator` in your project:

```dart
import 'package:flutter/material.dart';
import 'package:png_series_animator/png_series_animator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: PngSeriesAnimator(
            imagePaths: List.generate(
              18,
              (index) => 'assets/animation/${10001 + index}.png',
            ),
            duration: const Duration(milliseconds: 1500),
            repeat: true,
            isPlaying: true,
            fit: BoxFit.contain,
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
```

### Programmatic Control

You can now use `PngSeriesController` to control the animation externally:

```dart
final myController = PngSeriesController();

// Later in your code...
myController.play();
myController.pause();
myController.seekTo(0.5); // Seek to 50% progress

PngSeriesAnimator(
  imagePaths: myImagePaths,
  controller: myController,
  onPlayStateChanged: (isPlaying) => print('Playing: $isPlaying'),
  onSeek: (progress) => print('Seeked to: $progress'),
)
```

### Audio Synchronization

You can now pass an `audioPath` (Asset or Network) to automatically synchronize the animation with audio playback. The animator will automatically adjust its duration to match the audio.

```dart
PngSeriesAnimator(
  imagePaths: myImagePaths,
  audioPath: 'assets/audio/voiceover.mp3', // Or a URL
  showControls: true,
)
```

### Subtitles & Word-Level Highlighting

`PngSeriesAnimator` now supports complex subtitle metadata, including multi-language support and word-level timing for karaoke-style highlighting.

```dart
final subtitleController = PngSubtitleController(
  data: {
    'en': [
      SubtitleSegment(
        start: 0.0,
        end: 2.0,
        text: 'Hello world',
        words: [
          SubtitleWord(start: 0.0, end: 1.0, text: 'Hello'),
          SubtitleWord(start: 1.0, end: 2.0, text: 'world'),
        ],
      ),
    ],
  },
  initialLanguage: 'en',
);

PngSeriesAnimator(
  imagePaths: myImagePaths,
  subtitleController: subtitleController,
  // Optional: Custom subtitle builder
  subtitleBuilder: (context, segment, currentTime) {
    return Center(
      child: Text(segment?.text ?? ''),
    );
  },
)
```

#### JSON Subtitle Format

You can also load subtitles from a JSON file or API response. The structure should be a Map of languages containing lists of segments with word-level timing:

```json
{
  "en": [
    {
      "start": 0.0,
      "end": 2.5,
      "text": "The quick brown fox",
      "words": [
        {"start": 0.0, "end": 0.5, "text": "The"},
        {"start": 0.5, "end": 1.0, "text": "quick"},
        {"start": 1.0, "end": 1.5, "text": "brown"},
        {"start": 1.5, "end": 2.5, "text": "fox"}
      ]
    }
  ],
  "ar": [
    {
      "start": 0.0,
      "end": 2.5,
      "text": "الثعلب البني السريع",
      "words": [
        {"start": 0.0, "end": 0.8, "text": "الثعلب"},
        {"start": 0.8, "end": 1.5, "text": "البني"},
        {"start": 1.5, "end": 2.5, "text": "السريع"}
      ]
    }
  ]
}
```

### Adding Custom Transitions

By default, the animator performs a flipbook-style step transition. You can supply a `transitionBuilder` to blend consecutive frames together.

For example, to crossfade frames at the boundary of each step:

```dart
PngSeriesAnimator(
  imagePaths: myImagePaths,
  transitionBuilder: (context, currentFrame, nextFrame, progress) {
    // Cross-fade frames during the last 15% of each frame's duration
    double nextOpacity = 0.0;
    const double transitionWindow = 0.15;
    if (progress > (1.0 - transitionWindow)) {
      nextOpacity = (progress - (1.0 - transitionWindow)) / transitionWindow;
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        currentFrame,
        if (nextOpacity > 0.0)
          Opacity(
            opacity: nextOpacity,
            child: nextFrame,
          ),
      ],
    );
  },
)
```

---

## Example App

Check the `/example` directory for a full, premium showcase application that includes 6 different custom transition styles:
1. **Quick Crossfade**
2. **Ghost Trail**
3. **Horizontal Slide**
4. **Vertical Slide**
5. **Scale Zoom**
6. **Spin Flip**
7. **Blur Dissolve**

---

## Contact & Support

For questions, issues, or suggestions, feel free to reach out:
- **GitHub**: [amirr-dotcom](https://github.com/amirr-dotcom)
- **Email**: shaizeeabbas.sa@gmail.com

