import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:dart_pod/dart_pod.dart';

// The Podcast Object
Podcast myPodcast;
// The Current Episode
Episode currentEpisode;

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

AudioPlayer audioPlayer;

PlayerState playerState = PlayerState.stopped;

Duration duration;

Duration position;

StreamSubscription positionSubscription;

StreamSubscription audioPlayerStateSubscription;

bool isMuted = false;

get isPlaying => playerState == PlayerState.playing;
get isPaused => playerState == PlayerState.paused;
get durationText =>
    duration != null ? duration.toString().split('.').first : '';
get positionText =>
    position != null ? position.toString().split('.').first : '';
get positionNum => position != null ? position.inSeconds : 0;
get durationNum => duration != null ? duration.inSeconds : 0;

double playerProgress() {
  try {
    if (positionNum > 0 && durationNum > 0) {
      return ((durationNum * (positionNum / 100)) / durationNum) / 10;
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}
