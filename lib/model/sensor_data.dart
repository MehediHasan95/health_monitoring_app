import 'dart:convert' show json;

List<SensorData> sensorDataFromJson(String str) =>
    List<SensorData>.from(json.decode(str).map((x) => SensorData.fromJson(x)));

String sensorDataToJson(List<SensorData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SensorData {
  SensorData({
    this.bodyTempC,
    this.bodyTempF,
    this.roomTempC,
    this.roomTempF,
    this.bpm,
    this.spo2,
  });

  double? bodyTempC;
  double? bodyTempF;
  double? roomTempC;
  double? roomTempF;
  double? bpm;
  double? spo2;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        bodyTempC: json["bodyTempC"].toDouble(),
        bodyTempF: json["bodyTempF"].toDouble(),
        roomTempC: json["roomTempC"].toDouble(),
        roomTempF: json["roomTempF"].toDouble(),
        bpm: json["bpm"].toDouble(),
        spo2: json["spo2"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bodyTempC": bodyTempC,
        "bodyTempF": bodyTempF,
        "roomTempC": roomTempC,
        "roomTempF": roomTempF,
        "bpm": bpm,
        "spo2": spo2,
      };
}
