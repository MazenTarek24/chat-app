import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static const String appId =
      '97e9b1a28f014124aff6043a017391ee'; // Replace with your Agora App ID
  static late RtcEngine engine;

  static Future<void> initialize() async {
    // Create an RtcEngine instance
    engine = createAgoraRtcEngine();

    // Initialize the RtcEngine
    await engine.initialize(const RtcEngineContext(
      appId: appId,
    ));
  }
}
