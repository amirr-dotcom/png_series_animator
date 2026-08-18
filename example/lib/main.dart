import 'package:flutter/material.dart';
import 'package:png_series_animator/png_series_animator.dart';
import 'package:png_series_animator/utils/image_cache_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNG Series Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PNG Series Animator'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MenuButton(
              title: 'Audio Synchronization',
              subtitle: 'Animation synced with music/voice',
              icon: Icons.audiotrack,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AudioSyncDemo()),
              ),
            ),
            const SizedBox(height: 20),
            _MenuButton(
              title: 'Subtitles & Highlighting',
              subtitle: 'Multi-language synced captions',
              icon: Icons.closed_caption,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubtitleDemo()),
              ),
            ),
            const SizedBox(height: 20),
            _MenuButton(
              title: 'Controller Demo',
              subtitle: 'Programmatic play/pause/seek',
              icon: Icons.settings_remote,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ControllerDemo()),
              ),
            ),
            const SizedBox(height: 20),
            _MenuButton(
              title: 'Local Asset Series',
              subtitle: 'Animation from bundled PNGs',
              icon: Icons.folder_open,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LocalAssetDemo()),
              ),
            ),
            const SizedBox(height: 20),
            _MenuButton(
              title: 'Network URL Series',
              subtitle: 'Animation with persistent caching',
              icon: Icons.cloud_download,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NetworkAssetDemo()),
              ),
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () async {
                await ImageCacheManager().clearCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Persistent storage cleared')),
                  );
                }
              },
              icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
              label: const Text('Clear Persistent Storage', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.cyan),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class SubtitleDemo extends StatefulWidget {
  const SubtitleDemo({super.key});

  @override
  State<SubtitleDemo> createState() => _SubtitleDemoState();
}

class _SubtitleDemoState extends State<SubtitleDemo> {
  late final PngSubtitleController _subtitleController;

  @override
  void initState() {
    super.initState();
    _subtitleController = PngSubtitleController(
      data: {
        'en': [
          SubtitleSegment(
            start: 0.0,
            end: 1.0,
            text: 'Welcome to PNG Series Animator',
            words: [
              SubtitleWord(start: 0.0, end: 0.3, text: 'Welcome'),
              SubtitleWord(start: 0.3, end: 0.5, text: 'to'),
              SubtitleWord(start: 0.5, end: 0.7, text: 'PNG'),
              SubtitleWord(start: 0.7, end: 0.8, text: 'Series'),
              SubtitleWord(start: 0.8, end: 1.0, text: 'Animator'),
            ],
          ),
          SubtitleSegment(
            start: 1.0,
            end: 2.0,
            text: 'Experience high performance animations',
            words: [
              SubtitleWord(start: 1.0, end: 1.3, text: 'Experience'),
              SubtitleWord(start: 1.3, end: 1.5, text: 'high'),
              SubtitleWord(start: 1.5, end: 1.7, text: 'performance'),
              SubtitleWord(start: 1.7, end: 2.0, text: 'animations'),
            ],
          ),
        ],
        'es': [
          SubtitleSegment(
            start: 0.0,
            end: 1.0,
            text: 'Bienvenido al Animador de Series PNG',
            words: [
              SubtitleWord(start: 0.0, end: 0.5, text: 'Bienvenido'),
              SubtitleWord(start: 0.5, end: 0.7, text: 'al'),
              SubtitleWord(start: 0.7, end: 1.0, text: 'Animador'),
            ],
          ),
          SubtitleSegment(
            start: 1.0,
            end: 2.0,
            text: 'Experimente animaciones de alto rendimiento',
            words: [
              SubtitleWord(start: 1.0, end: 1.5, text: 'Experimente'),
              SubtitleWord(start: 1.5, end: 2.0, text: 'animaciones'),
            ],
          ),
        ],
        'ar': [
          SubtitleSegment(
            start: 0.0,
            end: 2.0,
            text: 'مرحباً بكم في محرك صور PNG المتحركة',
            words: [
              SubtitleWord(start: 0.0, end: 0.5, text: 'مرحباً'),
              SubtitleWord(start: 0.5, end: 1.0, text: 'بكم'),
              SubtitleWord(start: 1.0, end: 1.5, text: 'في'),
              SubtitleWord(start: 1.5, end: 2.0, text: 'المحرك'),
            ],
          ),
        ],
      },
      initialLanguage: 'en',
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = List.generate(
      18,
      (index) => 'assets/1/${20001 + index}.png',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subtitles Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _subtitleController.cycleLanguage(),
          ),
        ],
      ),
      body: Center(
        child: PngSeriesAnimator.videoPlayer(
          imagePaths: images,
          duration: const Duration(seconds: 2),
          subtitleController: _subtitleController,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo> {
  late final PngSeriesController _controller;
  double _currentProgress = 0.0;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = PngSeriesController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = List.generate(
      18,
      (index) => 'assets/1/${20001 + index}.png',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Controller Demo')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PngSeriesAnimator(
                imagePaths: images,
                controller: _controller,
                duration: const Duration(seconds: 2),
                isPlaying: _isPlaying,
                onPlayStateChanged: (playing) {
                  setState(() => _isPlaying = playing);
                },
                onSeek: (progress) {
                  setState(() => _currentProgress = progress);
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => _controller.seekTo(0.0),
                      icon: const Icon(Icons.skip_previous),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filled(
                      iconSize: 48,
                      onPressed: () {
                        if (_isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      },
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filledTonal(
                      onPressed: () => _controller.seekTo(1.0),
                      icon: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSlider(
                  label: 'Progress',
                  value: _currentProgress,
                  onChanged: (val) => _controller.seekTo(val),
                  trailing: '${(_currentProgress * 100).toStringAsFixed(0)}%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required String trailing,
  }) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))),
        Expanded(
          child: Slider(
            value: value.clamp(0.0, 1.0),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            trailing,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ),
      ],
    );
  }
}

class LocalAssetDemo extends StatelessWidget {
  const LocalAssetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = List.generate(
      18,
      (index) => 'assets/1/${20001 + index}.png',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Local Assets')),
      body: Center(
        child: PngSeriesAnimator.videoPlayer(
          imagePaths: images,
          duration: const Duration(seconds: 2),
          heroTag: 'local_hero',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class NetworkAssetDemo extends StatelessWidget {
  const NetworkAssetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a more reliable set of placeholder images for the demo
    final List<String> networkImages = List.generate(
      30,
      (index) => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 71}.png',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Network Assets')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Fetching and caching network sequence...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Center(
              child: PngSeriesAnimator.videoPlayer(
                imagePaths: networkImages,
                duration: const Duration(seconds: 10),
                heroTag: 'network_hero',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AudioSyncDemo extends StatelessWidget {
  const AudioSyncDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = List.generate(
      18,
      (index) => 'assets/1/${20001 + index}.png',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Synchronization')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'This animation is automatically synced with the audio file. The duration is determined by the audio track.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            PngSeriesAnimator.videoPlayer(
              imagePaths: images,
              // Use a public sample audio for the demo
              audioPath: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
