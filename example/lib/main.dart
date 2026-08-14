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

class LocalAssetDemo extends StatelessWidget {
  const LocalAssetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = List.generate(
      18,
          (index) => 'assets/1/${10001 + index}.png',
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
      (index) => 'assets/1/${10001 + index}.png',
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text('Progress:', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Slider(
                        value: _currentProgress,
                        onChanged: (val) => _controller.seekTo(val),
                      ),
                    ),
                    Text(
                      '${(_currentProgress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
