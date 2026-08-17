## 1.3.0

* Introduced built-in synchronized audio support via the `audioPath` property.
* Added RTL (Right-to-Left) support for subtitles in `PngSubtitleController`.
* Enhanced audio-visual synchronization logic using `audioplayers`.
* Automatic duration detection based on the provided audio file.
* Fixed several minor UI bugs in full-screen mode.
* Enhanced documentation with JSON subtitle format examples.

## 1.2.0

* Introduced `PngSubtitleController` for multi-language subtitles and captions.
* Added support for word-level highlighting within subtitles.
* Added `subtitleBuilder` for custom subtitle rendering.
* Enhanced `PngSeriesController` for better external synchronization.
* Improved full-screen implementation using a persistent `OverlayEntry`.
* Added `onPlayStateChanged` and `onSeek` callbacks for easier integration with audio players.
* Internal optimizations for frame loading and buffering states.

## 1.1.0

* Introduced `PngSeriesController` for programmatic control over playback, pausing, and seeking.
* Added `onPlayStateChanged` and `onSeek` callbacks to `PngSeriesAnimator`.
* Improved full-screen implementation using `OverlayEntry` for a more seamless transition.
* Enhanced orientation handling in full-screen mode (auto-landscape for wide sequences).
* Optimized frame loading and buffering state management.

## 1.0.1

* Improved full-screen orientation exit logic to reliably restore portrait mode and system UI.
* Enhanced code formatting and indentation for better maintainability.

## 1.0.0

* Initial stable release.
* High-performance PNG sequence animation with frame-by-frame control.
* Support for custom transition builders between frames (fade, slide, zoom, etc.).
* Built-in pre-caching and memory management.
* Optional video-player-like controls and full-screen mode.
* Support for local assets and network image sequences.
