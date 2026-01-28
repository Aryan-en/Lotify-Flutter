import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../models/track.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../widgets/track_tile.dart';
import 'player_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final tracks = playlist.tracks;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    playlist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppTheme.spotifyLightGray),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppTheme.spotifyBlack.withValues(alpha: 0.8)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlist.name, style: Theme.of(context).textTheme.headlineMedium),
                  if (playlist.description != null) ...[
                    const SizedBox(height: 4),
                    Text(playlist.description!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      if (tracks.isNotEmpty) {
                        context.read<PlayerService>().playQueue(tracks, 0);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.spotifyGreen,
                      foregroundColor: AppTheme.spotifyBlack,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final t = tracks[i];
                return TrackTile(
                  track: t,
                  index: i + 1,
                  onTap: () {
                    context.read<PlayerService>().playQueue(tracks, i);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                  },
                );
              },
              childCount: tracks.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
