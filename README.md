# Lotify

A fully functional **Spotify-style music player** built with Flutter.

## Features

- **Home** – Recently played, made-for-you playlists, popular albums, and quick picks
- **Search** – Search by category, then by artists, songs, albums, and playlists with live results
- **Library** – Your playlists and Liked Songs
- **Now Playing** – Full-screen player with artwork, progress bar, seek, play/pause, skip, shuffle, and loop
- **Mini player** – Persistent bottom bar when a track is playing; tap to open full player
- **Playback** – Streams demo audio, queue support, next/previous, and loop modes

## Setup

```bash
cd lotify
flutter pub get
flutter run
```

## Project structure

```
lib/
├── main.dart           # App entry, theme, Provider
├── app_shell.dart      # Bottom nav + mini player shell
├── theme/
│   └── app_theme.dart  # Dark Spotify-like theme
├── models/
│   ├── track.dart
│   ├── album.dart
│   ├── artist.dart
│   └── playlist.dart
├── data/
│   └── mock_data.dart  # Mock artists, albums, tracks, playlists
├── services/
│   └── player_service.dart  # just_audio + playback state
├── screens/
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── library_screen.dart
│   ├── player_screen.dart
│   ├── album_detail_screen.dart
│   └── playlist_detail_screen.dart
└── widgets/
    ├── mini_player.dart
    ├── album_card.dart
    ├── playlist_card.dart
    ├── track_tile.dart
    └── section_header.dart
```

## Dependencies

- **just_audio** – Playback (URL streaming)
- **provider** – State management for player
- **google_fonts** – Typography (Circular Std–style)
- **cached_network_image** – Album/artwork loading

## Demo content

Uses mock data and royalty-free demo tracks from [SoundHelix](https://www.soundhelix.com) plus placeholder images. Replace with your own assets/APIs for production.

---

**Lotify** – A Spotify clone in Flutter.
