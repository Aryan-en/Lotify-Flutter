import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../widgets/playlist_card.dart';
import '../widgets/track_tile.dart';
import 'playlist_detail_screen.dart';
import 'player_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Your Library'),
          actions: [
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterChips(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Playlists',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: mockPlaylists.length,
                  itemBuilder: (context, i) {
                    final p = mockPlaylists[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: PlaylistCard(
                        playlist: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaylistDetailScreen(playlist: p),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Liked Songs',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ...mockPlaylists
                  .where((p) => p.isLiked)
                  .expand((p) => p.tracks)
                  .take(10)
                  .map((t) => TrackTile(
                        track: t,
                        onTap: () {
                          final list = mockPlaylists
                              .where((p) => p.isLiked)
                              .expand((p) => p.tracks)
                              .toList();
                          final i = list.indexWhere((x) => x.id == t.id);
                          if (i >= 0) {
                            context.read<PlayerService>().playQueue(list, i);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PlayerScreen()),
                            );
                          }
                        },
                      )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatefulWidget {
  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final labels = ['Playlists', 'Artists', 'Albums', 'Downloaded'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(labels[i]),
              selected: _selected == i,
              onSelected: (_) => setState(() => _selected = i),
              selectedColor: AppTheme.spotifyLightGray,
              checkmarkColor: AppTheme.spotifyGreen,
              side: BorderSide(
                color: _selected == i ? AppTheme.spotifyGreen : AppTheme.spotifyGray,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
