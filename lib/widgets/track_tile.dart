import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/track.dart';
import '../theme/app_theme.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final int? index;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const TrackTile({
    super.key,
    required this.track,
    this.index,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: SizedBox(
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: _buildArtwork(track.imageUrl ?? track.album?.imageUrl),
        ),
      ),
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artist.name,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatDuration(track.duration),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onMoreTap != null)
            IconButton(
              icon: const Icon(Icons.more_horiz, color: AppTheme.spotifyGray),
              onPressed: onMoreTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  Widget _buildArtwork(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        width: 52,
        height: 52,
        color: AppTheme.spotifyLightGray,
        child: const Icon(Icons.music_note, color: AppTheme.spotifyGray),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: AppTheme.spotifyLightGray,
        child: const Icon(Icons.music_note, color: AppTheme.spotifyGray),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppTheme.spotifyLightGray,
        child: const Icon(Icons.music_note, color: AppTheme.spotifyGray),
      ),
    );
  }
}
