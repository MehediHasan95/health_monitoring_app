import 'dart:convert' show json;

List<SensorData> sensorDataFromJson(String str) =>
    List<SensorData>.from(json.decode(str).map((x) => SensorData.fromJson(x)));

String sensorDataToJson(List<SensorData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SensorData {
  SensorData({
    this.bodyTempC,
    this.bodyTempF,
    this.bpm,
    this.spo2,
    this.avgBpm,
    this.avgSpo2,
    this.avgBodyTempC,
    this.avgBodyTempF,
  });

  double? bodyTempC;
  double? bodyTempF;
  double? bpm;
  double? spo2;
  double? avgBpm;
  double? avgSpo2;
  double? avgBodyTempC;
  double? avgBodyTempF;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        bodyTempC: json["bodyTempC"].toDouble(),
        bodyTempF: json["bodyTempF"].toDouble(),
        bpm: json["bpm"].toDouble(),
        spo2: json["spo2"].toDouble(),
        avgBpm: json["avgBpm"].toDouble(),
        avgSpo2: json["avgSpo2"].toDouble(),
        avgBodyTempC: json["avgBodyTempC"].toDouble(),
        avgBodyTempF: json["avgBodyTempF"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bodyTempC": bodyTempC,
        "bodyTempF": bodyTempF,
        "bpm": bpm,
        "spo2": spo2,
        "avgBpm": avgBpm,
        "avgSpo2": avgSpo2,
        "avgBodyTempC": avgBodyTempC,
        "avgBodyTempF": avgBodyTempF,
      };
}
