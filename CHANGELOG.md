## 1.5.2

* Fixed example app compilation errors by aligning with the latest widget API.
* Fixed broken asset paths in example and documentation.
* Refined `PngSeriesController` for improved playback synchronization.

## 1.5.1

* Fixed example app asset paths to match repository assets.
* Refined `PngSeriesController` synchronization logic.
* Minor documentation updates for better clarity.

## 1.5.0

* **Playback Speed Control**: Added `playbackSpeed` support (0.25x to 2.0x) for both animation frames and synchronized audio.
* **Volume Control**: Introduced `volume` control for audio-enabled sequences.
* **Controller Upgrades**: Added `setPlaybackSpeed` and `setVolume` to `PngSeriesController` for programmatic adjustments.
* **Performance**: Optimized `ValueNotifier` updates when changing playback speeds.
* **Full-Screen**: Improved transition stability and UI consistency in full-screen mode.

## 1.4.0

* **Audio Engine Migration**: Switched from `audioplayers` to `just_audio` and `audio_session` for superior cross-platform audio-visual synchronization and lower latency.
* **Performance Optimization**:
    *   Replaced full-widget rebuilds with `ValueNotifier<int>` and `ValueListenableBuilder` for frame updates, drastically reducing CPU usage during playback.
    *   Simplified image building logic to minimize overhead.
    *   Set `imageCache.maximumSizeBytes` to 100MB to improve stability on memory-constrained devices.
* **Advanced Synchronization**:
    *   Implemented drift detection logic that automatically re-syncs animation frames to the audio position if they diverge by more than 100ms.
    *   Introduced `PngPlaybackState` enum (Playing, Paused, Buffering, Seeking) for more granular state management.
* **Controller Enhancements**:
    *   Improved `PngSeriesController` with explicit `onPlay`, `onPause`, and `onSeek` hooks for robust external synchronization.
* **Branding & Cleanup**:
    *   Updated project bundle identifiers to `com.ctamir`.
    *   Removed legacy CocoaPods integration in favor of modern Swift Package Manager support in the iOS project.

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
