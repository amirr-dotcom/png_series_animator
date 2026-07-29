import 'dart:async';
import 'package:flutter/material.dart';

/// Signature for a function that builds a transition between two frames
/// in a [PngSeriesAnimator].
///
/// The [currentFrame] and [nextFrame] are widgets representing the images,
/// and [progress] is a value from 0.0 to 1.0 representing how far along
/// the animation is between these two specific frames.
typedef PngSeriesTransitionBuilder = Widget Function(
  BuildContext context,
  Widget currentFrame,
  Widget nextFrame,
  double progress,
);

/// A widget that animates a series of PNG images as a frame-by-frame animation,
/// with support for custom transitions between frames.
class PngSeriesAnimator extends StatefulWidget {
  /// The list of asset paths for the PNG images in the animation series.
  final List<String> imagePaths;

  /// The total duration of one animation cycle (from the first to the last frame).
  final Duration duration;

  /// Whether the animation should repeat (loop) automatically.
  final bool repeat;

  /// Whether the animation is currently active and playing.
  final bool isPlaying;

  /// How the images should be inscribed into the box.
  final BoxFit fit;

  /// If non-null, requires the image to have this width.
  final double? width;

  /// If non-null, requires the image to have this height.
  final double? height;

  /// An optional builder to customize the transition between consecutive frames.
  ///
  /// If null, a step transition (flipbook style) is used by default.
  final PngSeriesTransitionBuilder? transitionBuilder;

  /// Callback triggered when the animation completes.
  ///
  /// This is only called when [repeat] is false and the animation reaches the end.
  final VoidCallback? onCompleted;

  /// Creates a [PngSeriesAnimator].
  ///
  /// The [imagePaths] parameter must not be empty.
  const PngSeriesAnimator({
    super.key,
    required this.imagePaths,
    this.duration = const Duration(seconds: 2),
    this.repeat = true,
    this.isPlaying = true,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.transitionBuilder,
    this.onCompleted,
  }) : assert(imagePaths.length > 0, 'imagePaths cannot be empty');

  @override
  State<PngSeriesAnimator> createState() => _PngSeriesAnimatorState();
}

class _PngSeriesAnimatorState extends State<PngSeriesAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _precached = false;
  bool _shouldTriggerCompleted = false;
  final Map<String, ImageProvider> _imageProviders = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addStatusListener((status) {
      debugPrint('PngSeriesAnimator status: $status, repeat: ${widget.repeat}, shouldTrigger: $_shouldTriggerCompleted');
      if (status == AnimationStatus.completed) {
        if (_shouldTriggerCompleted && widget.onCompleted != null) {
          debugPrint(
            'PngSeriesAnimator animation completed. Calling onCompleted...',
          );
          _shouldTriggerCompleted = false; // Reset to prevent double triggers
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onCompleted!();
            }
          });
        }
      }
    });

    // Initialize all ImageProviders so they are cached/reused.
    for (final path in widget.imagePaths) {
      _imageProviders[path] = AssetImage(path);
    }

    _updateAnimationState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precacheImages();
    }
  }

  Future<void> _precacheImages() async {
    for (final provider in _imageProviders.values) {
      try {
        await precacheImage(provider, context);
      } catch (e) {
        debugPrint('Error precaching image: $e');
      }
    }
    if (mounted) {
      setState(() {
        _precached = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PngSeriesAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.isPlaying != widget.isPlaying ||
        oldWidget.repeat != widget.repeat) {
      _updateAnimationState();
    }
  }

  void _updateAnimationState() {
    if (widget.isPlaying) {
      if (widget.repeat) {
        _shouldTriggerCompleted = false;
        _controller.repeat();
      } else {
        _shouldTriggerCompleted = true;
        if (_controller.value == 1.0) {
          _controller.forward(from: 0.0);
        } else {
          _controller.forward();
        }
      }
    } else {
      _shouldTriggerCompleted = false;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_precached) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;
        final int totalFrames = widget.imagePaths.length;

        if (totalFrames == 1) {
          return _buildImage(widget.imagePaths.first);
        }

        // Map value (0.0 -> 1.0) to frame index range (0 -> totalFrames - 1)
        final double exactFrame = value * (totalFrames - 1);

        // If no transition builder is provided, step transition (flipbook style) is used by default.
        if (widget.transitionBuilder == null) {
          final int roundedFrameIndex = exactFrame.round().clamp(0, totalFrames - 1);
          return _buildImage(widget.imagePaths[roundedFrameIndex]);
        }

        final int currentFrameIndex = exactFrame.floor();
        final int nextFrameIndex = (currentFrameIndex + 1) < totalFrames
            ? currentFrameIndex + 1
            : currentFrameIndex;
        final double progressToNextFrame = exactFrame - currentFrameIndex;

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.transitionBuilder!(
            context,
            _buildImage(widget.imagePaths[currentFrameIndex]),
            _buildImage(widget.imagePaths[nextFrameIndex]),
            progressToNextFrame,
          ),
        );
      },
    );
  }

  Widget _buildImage(String path) {
    final provider = _imageProviders[path];
    if (provider == null) {
      return const SizedBox.shrink();
    }
    return Image(
      image: provider,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      gaplessPlayback: true,
    );
  }
}
