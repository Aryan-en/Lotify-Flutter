import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/track.dart';
import '../services/player_service.dart';
import '../screens/player_screen.dart';
import '../theme/app_theme.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerService>(
      builder: (context, player, _) {
        final track = player.currentTrack;
        if (track == null) return const SizedBox.shrink();

        return Material(
          color: AppTheme.spotifyLightGray,
          elevation: 8,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlayerScreen()),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    _artwork(track),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            track.artist.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        player.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.spotifyWhite,
                        size: 32,
                      ),
                      onPressed: () => player.togglePlayPause(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _artwork(Track track) {
    final url = track.imageUrl ?? track.album?.imageUrl ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: url.isEmpty
          ? Container(
              width: 48,
              height: 48,
              color: AppTheme.spotifyDarkGray,
              child: const Icon(Icons.music_note, color: AppTheme.spotifyGray),
            )
          : CachedNetworkImage(
              imageUrl: url,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 48,
                height: 48,
                color: AppTheme.spotifyDarkGray,
                child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 48,
                height: 48,
                color: AppTheme.spotifyDarkGray,
                child: const Icon(Icons.music_note, color: AppTheme.spotifyGray),
              ),
            ),
    );
  }
}
