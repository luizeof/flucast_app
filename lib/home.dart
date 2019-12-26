import 'package:flutter/material.dart';
import 'package:flucast_app/global.dart';
import 'package:dart_pod/dart_pod.dart';
import 'package:audioplayer/audioplayer.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer;
  PlayerState playerState = PlayerState.stopped;
  Duration duration;
  Duration position;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  bool isMuted = false;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';
  get positionNum => position != null ? position.inSeconds : 0;
  get durationNum => duration != null ? duration.inSeconds : 0;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  double playerProgress() {
    try {
      if (positionNum > 0 && durationNum > 0) {
        return ((durationNum * (positionNum / 100)) / durationNum) / 100;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(currentEpisode.url.toString());
    setState(() {
      playerState = PlayerState.playing;
    });
    print("play..." + currentEpisode.title.toString());
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
    print("pause...");
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
    print("stop...");
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
    print("mute...");
  }

  Widget _buildEpisodeTitle(Episode __episode) {
    if (currentEpisode != null) {
      if (currentEpisode.title == __episode.title) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              __episode.title,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        );
      } else {
        return Text(
          __episode.title,
          softWrap: true,
        );
      }
    } else {
      return Text(
        __episode.title,
        softWrap: true,
      );
    }
  }

  Icon _episodeIcon() {
    return Icon(
      (isPlaying == true ? Icons.pause : Icons.play_arrow),
      color: Colors.green,
      size: 50,
    );
  }

  Widget _buildDefaultEpisode(Podcast __podcast, Episode __episode) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Image(
              image: NetworkImage(__podcast.logoUrl),
              fit: BoxFit.cover,
            ),
            title: _buildEpisodeTitle(__episode),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  __episode.pubDate.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
            trailing: Icon(
              Icons.play_circle_outline,
            ),
            onTap: () {
              setState(
                () {
                  currentEpisode = __episode;
                },
              );
              if (isPlaying) {
                stop();
                play();
              } else {
                play();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeRow(Podcast __podcast, Episode __episode) {
    if (__podcast.episodes.isNotEmpty) {
      if (currentEpisode != null) {
        if (currentEpisode.title == __episode.title) {
          return Center(
            child: Card(
              shape: new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 30,
                      bottom: 30,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentEpisode = __episode;
                        });
                        if (isPlaying) {
                          pause();
                        } else {
                          if (currentEpisode == null) {
                            stop();
                          } else {
                            play();
                          }
                        }
                      },
                      onDoubleTap: () {
                        setState(() {
                          currentEpisode = null;
                        });
                        if (isPlaying) {
                          stop();
                        }
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                _episodeIcon(),
                                Expanded(
                                  child: _buildEpisodeTitle(__episode),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(),
                                Center(
                                  child: Text(
                                    __episode.pubDate.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Divider(),
                                LinearProgressIndicator(
                                  value: playerProgress(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        positionText.toString(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        durationText.toString(),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return _buildDefaultEpisode(__podcast, __episode);
        }
      } else {
        return _buildDefaultEpisode(__podcast, __episode);
      }
    } else {
      return Center(
        child: Icon(
          Icons.audiotrack,
          size: 55,
          color: Colors.greenAccent,
        ),
      );
    }
  }

  Widget _podcastDetails() {
    if (myPodcast.runtimeType == Podcast) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          myPodcast.logoUrl,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    semanticContainer: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            myPodcast.description.toString(),
                            style: TextStyle(fontSize: 17),
                            strutStyle: StrutStyle(
                              fontSize: 34,
                              height: .65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Icon(
          Icons.cast,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  Widget _podcatEpisodesList() {
    int _num =
        (myPodcast.runtimeType == Podcast ? myPodcast.episodes.length : 0);

    if (_num > 0) {
      return Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              itemCount: _num,
              itemBuilder: (
                BuildContext ctxt,
                int i,
              ) {
                return _buildEpisodeRow(
                  myPodcast,
                  myPodcast.episodes[i],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Icon(
          Icons.list,
          color: Colors.grey,
          size: 99,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              (myPodcast.runtimeType == Podcast ? myPodcast.title : "FluCast")),
          bottom: TabBar(
            tabs: <Tab>[
              Tab(text: 'Sobre'),
              Tab(text: 'Episódios'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _podcastDetails(),
            _podcatEpisodesList(),
          ].toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              myPodcast = myPodcast;
            });
          },
          tooltip: 'Update Feed',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
