import 'artist.dart';
import 'track.dart';

class Album {
  final String id;
  final String name;
  final String imageUrl;
  final Artist artist;
  final int year;
  final List<Track> tracks;

  const Album({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.artist,
    required this.year,
    this.tracks = const [],
  });
}
