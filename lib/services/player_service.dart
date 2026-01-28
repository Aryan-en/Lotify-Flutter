import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track.dart';

enum PlaybackState { idle, loading, playing, paused, stopped, error }

class PlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Track? _currentTrack;
  List<Track> _queue = [];
  int _currentIndex = 0;
  PlaybackState _state = PlaybackState.idle;
  bool _shuffle = false;
  LoopMode _loopMode = LoopMode.off;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Track? get currentTrack => _currentTrack;
  List<Track> get queue => List.unmodifiable(_queue);
  int get currentIndex => _currentIndex;
  PlaybackState get state => _state;
  bool get shuffle => _shuffle;
  LoopMode get loopMode => _loopMode;
  bool get isPlaying => _state == PlaybackState.playing;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  PlayerService() {
    _playerStateSub = _player.playerStateStream.listen(_onPlayerStateChanged);
  }

  void _onPlayerStateChanged(PlayerState s) {
    if (s.processingState == ProcessingState.loading ||
        s.processingState == ProcessingState.buffering) {
      _state = PlaybackState.loading;
    } else if (s.processingState == ProcessingState.ready) {
      _state = s.playing ? PlaybackState.playing : PlaybackState.paused;
    } else if (s.processingState == ProcessingState.completed) {
      _state = PlaybackState.paused;
      _handleCompletion();
    } else if (s.processingState == ProcessingState.idle) {
      _state = PlaybackState.idle;
    } else {
      _state = PlaybackState.error;
    }
    notifyListeners();
  }

  void _handleCompletion() {
    if (_loopMode == LoopMode.one) return;
    if (_currentIndex < _queue.length - 1) {
      skipToNext();
    } else if (_loopMode == LoopMode.all) {
      skipToIndex(0);
      play();
    }
  }

  Future<void> playTrack(Track track, {List<Track>? queue, int? index}) async {
    _currentTrack = track;
    _queue = queue ?? [track];
    _currentIndex = index ?? 0;

    _state = PlaybackState.loading;
    notifyListeners();

    try {
      await _player.setUrl(track.audioUrl);
      await _player.play();
      _state = PlaybackState.playing;
    } catch (e) {
      _state = PlaybackState.error;
    }
    notifyListeners();
  }

  Future<void> playQueue(List<Track> tracks, int startIndex) async {
    if (tracks.isEmpty) return;
    final track = tracks[startIndex];
    await playTrack(track, queue: tracks, index: startIndex);
  }

  Future<void> play() async {
    if (_currentTrack == null) return;
    await _player.play();
    _state = PlaybackState.playing;
    notifyListeners();
  }

  Future<void> pause() async {
    await _player.pause();
    _state = PlaybackState.paused;
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_state == PlaybackState.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
    notifyListeners();
  }

  Future<void> skipToNext() async {
    if (_queue.isEmpty) return;
    final next = _currentIndex + 1;
    if (next < _queue.length) {
      await playTrack(_queue[next], queue: _queue, index: next);
    }
  }

  Future<void> skipToPrevious() async {
    if (_queue.isEmpty) return;
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      notifyListeners();
      return;
    }
    final prev = _currentIndex - 1;
    if (prev >= 0) {
      await playTrack(_queue[prev], queue: _queue, index: prev);
    } else {
      await _player.seek(Duration.zero);
      notifyListeners();
    }
  }

  Future<void> skipToIndex(int index) async {
    if (index < 0 || index >= _queue.length) return;
    await playTrack(_queue[index], queue: _queue, index: index);
  }

  void setShuffle(bool value) {
    _shuffle = value;
    notifyListeners();
  }

  void setLoopMode(LoopMode mode) {
    _loopMode = mode;
    _player.setLoopMode(mode);
    notifyListeners();
  }

  void cycleLoopMode() {
    switch (_loopMode) {
      case LoopMode.off:
        setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        setLoopMode(LoopMode.off);
        break;
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }
}
