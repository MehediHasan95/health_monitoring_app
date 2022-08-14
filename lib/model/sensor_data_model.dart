class SensorDataModel {
  String? bpm;
  String? spo2;
  String? tempC;
  DateTime? timestamp;

  SensorDataModel({
    this.bpm,
    this.spo2,
    this.tempC,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bpm': bpm,
        'spo2': spo2,
        'tempC': tempC,
        'timestamp': timestamp,
      };

  SensorDataModel.fromSnapshot(snapshot)
      : bpm = snapshot.data()['bpm'],
        spo2 = snapshot.data()['spo2'],
        tempC = snapshot.data()['tempC'],
        timestamp = snapshot.data()['timestamp'].toDate();

  factory SensorDataModel.fromMap(Map<String, dynamic> map) => SensorDataModel(
      bpm: map['bpm'],
      spo2: map['spo2'],
      tempC: map['tempC'],
      timestamp: map['timestamp']);
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// class SensorDataModel {
//   String? id;
//   String? bpm;
//   String? spo2;
//   String? tempC;
//   Timestamp? setTimestamp;

//   SensorDataModel({
//     this.id,
//     this.bpm,
//     this.spo2,
//     this.tempC,
//     this.setTimestamp,
//   });

//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       'id': id,
//       'bpm': bpm,
//       'spo2': spo2,
//       'tempC': tempC,
//       'timestamp': setTimestamp,
//     };
//     return map;
//   }

//   factory SensorDataModel.fromMap(Map<String, dynamic> map) => SensorDataModel(
//       id: map['id'],
//       bpm: map['bpm'],
//       spo2: map['spo2'],
//       tempC: map['tempC'],
//       setTimestamp: map['timestamp']);
// }


