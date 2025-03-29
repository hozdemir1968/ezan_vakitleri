import 'dart:convert';

class NotificationM {
  int? id;
  bool? setted;
  int? timeInMinutes;

  NotificationM({this.id, this.setted, this.timeInMinutes});

  NotificationM copyWith({int? id, String? name, bool? setted, int? timeInMinutes}) {
    return NotificationM(
      id: id ?? this.id,
      setted: setted ?? this.setted,
      timeInMinutes: timeInMinutes ?? this.timeInMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'setted': setted == true ? 1 : 0,
      'timeInMinutes': timeInMinutes,
    };
  }

  factory NotificationM.fromMap(Map<String, dynamic> map) {
    return NotificationM(
      id: map['id'] != null ? map['id'] as int : null,
      setted: map['setted'] == 1 ? true : false,
      timeInMinutes: map['timeInMinutes'] != null ? map['timeInMinutes'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationM.fromJson(String source) =>
      NotificationM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationM(id: $id, setted: $setted, v: $timeInMinutes)';
  }
}
