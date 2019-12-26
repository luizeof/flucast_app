import 'package:dart_pod/dart_pod.dart';

// The Podcast Object
Podcast myPodcast;
// The Current Episode
Episode currentEpisode;

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
