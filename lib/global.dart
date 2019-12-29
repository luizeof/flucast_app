//  global.dart
//
//  This file is a part of the dart_pod project.
//
//  FluCast is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This porogram is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flucast_app/episode.dart';
import 'package:flucast_app/podcast.dart';

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
      return (((positionNum / durationNum) - 1.00)) + 1.00;
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

  Icon episodeIcon() {
    return Icon(
      (isPlaying == true ? Icons.pause : Icons.play_arrow),
      color: Colors.green,
      size: 50,
    );
  }
