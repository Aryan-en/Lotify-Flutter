import 'track.dart';

class Playlist {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final List<Track> tracks;
  final bool isLiked;

  const Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    this.tracks = const [],
    this.isLiked = false,
  });
}
