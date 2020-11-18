import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants.dart';
import 'package:flutter_music_app/model/song_info.dart';
import 'package:flutter_music_app/widgets/carrousal_image_view.dart';
import 'package:flutter_music_app/widgets/song_widget.dart';

class AudioPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(child: _audioPlayerWidget()),
    );
  }

  Widget _audioPlayerWidget() {
    List<SongInfo> songs = [SongInfo(songTitle: 'Music 1', song: 'sample1.mp3', artist: 'Ed sheeran', image: 'assets/panda.jpg'),
      SongInfo(songTitle: 'Music 2', song: 'sample2.mp3', artist: 'Ed Sheeran', image: 'assets/music.jpg'),
      SongInfo(songTitle: 'Music 3', song: 'sample3.mp3', artist: 'Ed Sheeran', image: 'assets/teddy.jpg')];
    return Column(
      children: [
        //CarrousalImageView(),
        SongWidget(
        songList: songs,
        )
      ],
    );
  }
}
