import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../services/player_service.dart';
import '../theme/app_theme.dart';
import '../widgets/album_card.dart';
import '../widgets/playlist_card.dart';
import '../widgets/track_tile.dart';
import 'album_detail_screen.dart';
import 'playlist_detail_screen.dart';
import 'player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  List<Track> _tracks = [];
  List<Artist> _artists = [];
  List<Album> _albums = [];
  List<Playlist> _playlists = [];
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _query = _controller.text.trim();
        if (_query.isEmpty) {
          _tracks = [];
          _artists = [];
          _albums = [];
          _playlists = [];
          _searched = false;
        } else {
          _tracks = searchTracks(_query);
          _artists = searchArtists(_query);
          _albums = searchAlbums(_query);
          _playlists = searchPlaylists(_query);
          _searched = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Search'),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Artists, songs, or albums',
                hintStyle: TextStyle(color: AppTheme.spotifyGray),
                prefixIcon: const Icon(Icons.search, color: AppTheme.spotifyGray),
                filled: true,
                fillColor: AppTheme.spotifyLightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: const TextStyle(color: AppTheme.spotifyWhite),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
        ),
        if (_query.isEmpty && !_searched) _buildCategories(context),
        if (_query.isNotEmpty || _searched) _buildResults(context),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    const categories = [
      ('Pop', '🎵'),
      ('Workout', '💪'),
      ('Chill', '😌'),
      ('Rock', '🎸'),
      ('Podcasts', '🎙️'),
      ('Jazz', '🎷'),
    ];
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final (name, emoji) = categories[i];
            return Material(
              color: AppTheme.spotifyLightGray,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => _controller.text = name,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: categories.length,
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final hasResults = _tracks.isNotEmpty || _artists.isNotEmpty || _albums.isNotEmpty || _playlists.isNotEmpty;
    if (!hasResults && _query.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: AppTheme.spotifyGray),
              const SizedBox(height: 16),
              Text('No results for "$_query"', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_tracks.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Songs', style: Theme.of(context).textTheme.headlineMedium),
            ),
            ..._tracks.take(5).map((t) => TrackTile(
                  track: t,
                  onTap: () {
                    context.read<PlayerService>().playTrack(t, queue: _tracks);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerScreen()));
                  },
                )),
            const SizedBox(height: 24),
          ],
          if (_artists.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Artists', style: Theme.of(context).textTheme.headlineMedium),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _artists.length,
                itemBuilder: (context, i) {
                  final a = _artists[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(a.imageUrl),
                            onBackgroundImageError: (_, __) {},
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 64,
                            child: Text(
                              a.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (_albums.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Albums', style: Theme.of(context).textTheme.headlineMedium),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _albums.length,
                itemBuilder: (context, i) {
                  final a = _albums[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AlbumCard(
                      album: a,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlbumDetailScreen(album: a),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (_playlists.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Playlists', style: Theme.of(context).textTheme.headlineMedium),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _playlists.length,
                itemBuilder: (context, i) {
                  final p = _playlists[i];
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
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
