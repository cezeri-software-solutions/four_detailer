import 'package:json_annotation/json_annotation.dart';

class DurationConverter implements JsonConverter<Duration, String> {
  const DurationConverter();

  @override
  Duration fromJson(String json) {
    final parts = json.split(':').map(int.parse).toList();
    return Duration(
      hours: parts[0],
      minutes: parts[1],
      seconds: parts[2],
    );
  }

  @override
  String toJson(Duration object) {
    final hours = object.inHours.toString().padLeft(2, '0');
    final minutes = (object.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (object.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
