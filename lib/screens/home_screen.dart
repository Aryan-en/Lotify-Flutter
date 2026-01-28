import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/album.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../widgets/album_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/section_header.dart';
import '../widgets/track_tile.dart';
import 'album_detail_screen.dart';
import 'playlist_detail_screen.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Lotify'),
          actions: [
            IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.history), onPressed: () {}),
            IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Recently played'),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: recentlyPlayed.length,
                  itemBuilder: (context, i) {
                    final t = recentlyPlayed[i];
                    return _RecentlyPlayedCard(track: t);
                  },
                ),
              ),
              SectionHeader(title: 'Made for you'),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: featuredPlaylists.length,
                  itemBuilder: (context, i) {
                    final p = featuredPlaylists[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: PlaylistCard(
                        playlist: p,
                        onTap: () => _openPlaylist(context, p),
                      ),
                    );
                  },
                ),
              ),
              SectionHeader(title: 'Popular albums'),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: featuredAlbums.length,
                  itemBuilder: (context, i) {
                    final a = featuredAlbums[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: AlbumCard(
                        album: a,
                        onTap: () => _openAlbum(context, a),
                      ),
                    );
                  },
                ),
              ),
              SectionHeader(title: 'Quick picks'),
              ...mockTracks.take(5).map((t) => TrackTile(
                    track: t,
                    onTap: () => _playTrack(context, t),
                  )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  void _openPlaylist(BuildContext context, Playlist p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaylistDetailScreen(playlist: p),
      ),
    );
  }

  void _openAlbum(BuildContext context, Album a) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(album: a),
      ),
    );
  }

  void _playTrack(BuildContext context, Track t) {
    context.read<PlayerService>().playTrack(t, queue: mockTracks);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
  }
}

class _RecentlyPlayedCard extends StatelessWidget {
  final Track track;

  const _RecentlyPlayedCard({required this.track});

  @override
  Widget build(BuildContext context) {
    final url = track.imageUrl ?? track.album?.imageUrl ?? '';
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          context.read<PlayerService>().playTrack(track, queue: mockTracks);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
        },
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _buildImage(url),
                ),
              ),
              const SizedBox(height: 8),
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
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.isEmpty) {
      return Container(
        color: AppTheme.spotifyLightGray,
        child: const Icon(Icons.music_note, size: 48, color: AppTheme.spotifyGray),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppTheme.spotifyLightGray,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: AppTheme.spotifyLightGray,
        child: const Icon(Icons.music_note, size: 48, color: AppTheme.spotifyGray),
      ),
    );
  }
}
