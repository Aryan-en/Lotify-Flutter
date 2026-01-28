import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.spotifyBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Now playing'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.devices_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.queue_music_outlined), onPressed: () {}),
        ],
      ),
      body: Consumer<PlayerService>(
        builder: (context, player, _) {
          final track = player.currentTrack;
          if (track == null) {
            return const Center(child: Text('No track playing'));
          }
          return Column(
            children: [
              const SizedBox(height: 24),
              _Artwork(track: track),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      track.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track.artist.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.spotifyGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ProgressBar(player: player),
              ),
              const SizedBox(height: 16),
              _Controls(player: player),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  final Track track;

  const _Artwork({required this.track});

  @override
  Widget build(BuildContext context) {
    final url = track.imageUrl ?? track.album?.imageUrl ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: url.isEmpty
              ? Container(
                  color: AppTheme.spotifyLightGray,
                  child: const Center(child: Icon(Icons.music_note, size: 80, color: AppTheme.spotifyGray)),
                )
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: AppTheme.spotifyLightGray,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppTheme.spotifyLightGray,
                    child: const Icon(Icons.music_note, size: 80, color: AppTheme.spotifyGray),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final PlayerService player;

  const _ProgressBar({required this.player});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, posSnap) {
        final pos = posSnap.data ?? player.position;
        final dur = player.duration;
        final secs = dur.inSeconds > 0 ? dur.inSeconds : 1;
        final progress = pos.inSeconds / secs;

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppTheme.spotifyWhite,
                inactiveTrackColor: AppTheme.spotifyGray,
                thumbColor: AppTheme.spotifyWhite,
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (v) => player.seek(Duration(seconds: (v * secs).round())),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_format(pos), style: Theme.of(context).textTheme.bodyMedium),
                  Text(_format(dur), style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _Controls extends StatelessWidget {
  final PlayerService player;

  const _Controls({required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              player.shuffle ? Icons.shuffle : Icons.shuffle,
              color: player.shuffle ? AppTheme.spotifyGreen : AppTheme.spotifyGray,
            ),
            onPressed: () => player.setShuffle(!player.shuffle),
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, size: 40),
            onPressed: player.skipToPrevious,
          ),
          Material(
            color: AppTheme.spotifyWhite,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: player.state == PlaybackState.loading
                  ? null
                  : () => player.togglePlayPause(),
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 64,
                height: 64,
                child: player.state == PlaybackState.loading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: AppTheme.spotifyBlack,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        player.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.spotifyBlack,
                        size: 48,
                      ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, size: 40),
            onPressed: player.skipToNext,
          ),
          IconButton(
            icon: Icon(
              _loopIcon(player.loopMode),
              color: player.loopMode != LoopMode.off ? AppTheme.spotifyGreen : AppTheme.spotifyGray,
            ),
            onPressed: () => player.cycleLoopMode(),
          ),
        ],
      ),
    );
  }

  IconData _loopIcon(LoopMode mode) {
    switch (mode) {
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
      case LoopMode.off:
        return Icons.repeat;
    }
  }
}
