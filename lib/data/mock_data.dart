import '../models/album.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/track.dart';

// Demo audio from SoundHelix (royalty-free, allows testing)
const _baseAudio = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song';
const _baseImg = 'https://picsum.photos/seed';

final mockArtists = [
  const Artist(id: 'a1', name: 'The Midnight', imageUrl: '$_baseImg/artist1/300/300', followers: 1250000),
  const Artist(id: 'a2', name: 'Daft Punk', imageUrl: '$_baseImg/artist2/300/300', followers: 8500000),
  const Artist(id: 'a3', name: 'Tame Impala', imageUrl: '$_baseImg/artist3/300/300', followers: 6200000),
  const Artist(id: 'a4', name: 'Glass Animals', imageUrl: '$_baseImg/artist4/300/300', followers: 4100000),
  const Artist(id: 'a5', name: 'ODESZA', imageUrl: '$_baseImg/artist5/300/300', followers: 3900000),
];

final mockAlbums = [
  Album(
    id: 'al1',
    name: 'Endless Summer',
    imageUrl: '$_baseImg/album1/300/300',
    artist: mockArtists[0],
    year: 2016,
  ),
  Album(
    id: 'al2',
    name: 'Random Access Memories',
    imageUrl: '$_baseImg/album2/300/300',
    artist: mockArtists[1],
    year: 2013,
  ),
  Album(
    id: 'al3',
    name: 'Currents',
    imageUrl: '$_baseImg/album3/300/300',
    artist: mockArtists[2],
    year: 2015,
  ),
  Album(
    id: 'al4',
    name: 'Dreamland',
    imageUrl: '$_baseImg/album4/300/300',
    artist: mockArtists[3],
    year: 2020,
  ),
  Album(
    id: 'al5',
    name: 'A Moment Apart',
    imageUrl: '$_baseImg/album5/300/300',
    artist: mockArtists[4],
    year: 2017,
  ),
];

final mockTracks = [
  Track(
    id: 't1',
    name: 'Sunset',
    audioUrl: '$_baseAudio-1.mp3',
    imageUrl: '$_baseImg/track1/300/300',
    artist: mockArtists[0],
    album: mockAlbums[0],
    duration: const Duration(minutes: 4, seconds: 32),
  ),
  Track(
    id: 't2',
    name: 'Get Lucky',
    audioUrl: '$_baseAudio-2.mp3',
    imageUrl: '$_baseImg/track2/300/300',
    artist: mockArtists[1],
    album: mockAlbums[1],
    duration: const Duration(minutes: 6, seconds: 9),
  ),
  Track(
    id: 't3',
    name: 'The Less I Know The Better',
    audioUrl: '$_baseAudio-3.mp3',
    imageUrl: '$_baseImg/track3/300/300',
    artist: mockArtists[2],
    album: mockAlbums[2],
    duration: const Duration(minutes: 3, seconds: 36),
  ),
  Track(
    id: 't4',
    name: 'Heat Waves',
    audioUrl: '$_baseAudio-4.mp3',
    imageUrl: '$_baseImg/track4/300/300',
    artist: mockArtists[3],
    album: mockAlbums[3],
    duration: const Duration(minutes: 3, seconds: 58),
  ),
  Track(
    id: 't5',
    name: 'Line of Sight',
    audioUrl: '$_baseAudio-5.mp3',
    imageUrl: '$_baseImg/track5/300/300',
    artist: mockArtists[4],
    album: mockAlbums[4],
    duration: const Duration(minutes: 3, seconds: 56),
  ),
  Track(
    id: 't6',
    name: 'Crystalline',
    audioUrl: '$_baseAudio-6.mp3',
    imageUrl: '$_baseImg/track6/300/300',
    artist: mockArtists[0],
    album: mockAlbums[0],
    duration: const Duration(minutes: 5, seconds: 12),
  ),
  Track(
    id: 't7',
    name: 'Instant Crush',
    audioUrl: '$_baseAudio-7.mp3',
    imageUrl: '$_baseImg/track7/300/300',
    artist: mockArtists[1],
    album: mockAlbums[1],
    duration: const Duration(minutes: 5, seconds: 37),
  ),
  Track(
    id: 't8',
    name: 'Let It Happen',
    audioUrl: '$_baseAudio-8.mp3',
    imageUrl: '$_baseImg/track8/300/300',
    artist: mockArtists[2],
    album: mockAlbums[2],
    duration: const Duration(minutes: 7, seconds: 46),
  ),
];

final mockPlaylists = [
  Playlist(
    id: 'p1',
    name: 'Liked Songs',
    description: 'Your liked tracks',
    imageUrl: '$_baseImg/liked/300/300',
    tracks: mockTracks,
    isLiked: true,
  ),
  Playlist(
    id: 'p2',
    name: 'Chill Synthwave',
    description: 'Synthwave & retrowave vibes',
    imageUrl: '$_baseImg/playlist1/300/300',
    tracks: [mockTracks[0], mockTracks[5], mockTracks[4]],
  ),
  Playlist(
    id: 'p3',
    name: 'Workout Mix',
    description: 'High energy tracks',
    imageUrl: '$_baseImg/playlist2/300/300',
    tracks: [mockTracks[1], mockTracks[2], mockTracks[3], mockTracks[7]],
  ),
  Playlist(
    id: 'p4',
    name: 'Focus Mode',
    description: 'Concentration',
    imageUrl: '$_baseImg/playlist3/300/300',
    tracks: mockTracks,
  ),
];

List<Track> get recentlyPlayed => [mockTracks[2], mockTracks[0], mockTracks[4], mockTracks[1], mockTracks[3]];
List<Album> get featuredAlbums => mockAlbums;
List<Playlist> get featuredPlaylists => [mockPlaylists[1], mockPlaylists[2], mockPlaylists[3]];
List<Artist> get popularArtists => mockArtists;

List<Track> searchTracks(String q) {
  final lower = q.toLowerCase();
  return mockTracks
      .where((t) =>
          t.name.toLowerCase().contains(lower) ||
          t.artist.name.toLowerCase().contains(lower) ||
          (t.album?.name.toLowerCase().contains(lower) ?? false))
      .toList();
}

List<Artist> searchArtists(String q) {
  final lower = q.toLowerCase();
  return mockArtists.where((a) => a.name.toLowerCase().contains(lower)).toList();
}

List<Album> searchAlbums(String q) {
  final lower = q.toLowerCase();
  return mockAlbums
      .where((a) =>
          a.name.toLowerCase().contains(lower) ||
          a.artist.name.toLowerCase().contains(lower))
      .toList();
}

List<Playlist> searchPlaylists(String q) {
  final lower = q.toLowerCase();
  return mockPlaylists
      .where((p) =>
          p.name.toLowerCase().contains(lower) ||
          (p.description?.toLowerCase().contains(lower) ?? false))
      .toList();
}
