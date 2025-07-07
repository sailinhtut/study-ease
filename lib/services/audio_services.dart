import 'package:audioplayers/audioplayers.dart';
import 'package:nb_utils/nb_utils.dart';

class AudioService {
  static AudioService? _instance;

  AudioService._private();

  static AudioService get instance => _instance ??= AudioService._private();

  late AssetSource dingSound;
  late AssetSource arrowSound;

  Future<void> init() async {
    dingSound = AssetSource("ding.mp3");
    arrowSound = AssetSource("arrow.wav");
  }

  Future<void> ding() async {
    AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop)
      ..play(dingSound)
      ..dispose();
      
  }

  Future<void> unding() async {
    AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop)
      ..play(arrowSound)
      ..dispose();
  }
}
