import 'package:dart_pod/dart_pod.dart';

// The Podcast Feed Url
final feedurl =
    'https://feeds.soundcloud.com/users/soundcloud:users:3359843144/sounds.rss';

// The Podcast Object
Podcast myPodcast;

// The Current Episode
Episode currentEpisode;

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }
