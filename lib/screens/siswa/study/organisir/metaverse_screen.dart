import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MetaverseScreen extends StatefulWidget {
  const MetaverseScreen({super.key});

  @override
  State<MetaverseScreen> createState() => _MetaverseScreenState();
}

class _MetaverseScreenState extends State<MetaverseScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller video
    _controller = VideoPlayerController.asset('assets/video/metaverse.mp4');
    
    // Setup listener untuk perubahan ukuran video
    _controller.addListener(() {
      if (_controller.value.hasError) {
        print("Error video: ${_controller.value.errorDescription}");
      }
    });
    
    // Initialize the controller and store the Future for later use
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized
      setState(() {});
    });
    
    // Set video untuk loop
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources
    _controller.dispose();
    super.dispose();
  }

  // Toggle antara layar penuh dan normal
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: !_isFullScreen,
        bottom: !_isFullScreen,
        child: Column(
          children: [
            // App bar (hanya ditampilkan jika tidak dalam mode full screen)
            if (!_isFullScreen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.black,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Metaverse Experience",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: _toggleFullScreen,
                    ),
                  ],
                ),
              ),
            
            // Video player
            Expanded(
              child: Center(
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // Jika video sudah terinisialisasi, tampilkan preview
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          
                          // Overlay controls
                          Positioned.fill(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: AnimatedOpacity(
                                    opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      radius: 30,
                                      child: Icon(
                                        _controller.value.isPlaying 
                                            ? Icons.pause 
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Progress indicator
                          if (_controller.value.isBuffering)
                            const Positioned(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                        ],
                      );
                    } else {
                      // Tampilkan loading indicator sambil menunggu inisialisasi
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    }
                  },
                ),
              ),
            ),
            
            // Controls (hanya ditampilkan jika tidak dalam mode full screen)
            if (!_isFullScreen)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Column(
                  children: [
                    // Video progress slider
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFF00707E),
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Rewind button
                        IconButton(
                          icon: const Icon(Icons.replay_10, color: Colors.white),
                          onPressed: () {
                            final newPosition = _controller.value.position - 
                                const Duration(seconds: 10);
                            _controller.seekTo(newPosition);
                          },
                        ),
                        
                        // Play/Pause button
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying 
                                ? Icons.pause 
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                        ),
                        
                        // Forward button
                        IconButton(
                          icon: const Icon(Icons.forward_10, color: Colors.white),
                          onPressed: () {
                            final newPosition = _controller.value.position + 
                                const Duration(seconds: 10);
                            _controller.seekTo(newPosition);
                          },
                        ),
                        
                        // Fullscreen button
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: _toggleFullScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}