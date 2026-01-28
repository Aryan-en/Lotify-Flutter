import 'album.dart';
import 'artist.dart';

class Track {
  final String id;
  final String name;
  final String audioUrl;
  final String? imageUrl;
  final Artist artist;
  final Album? album;
  final Duration duration;

  const Track({
    required this.id,
    required this.name,
    required this.audioUrl,
    this.imageUrl,
    required this.artist,
    this.album,
    required this.duration,
  });
}
