// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MyLocation {
  int? id;
  int? townId;
  String? townName;

  MyLocation({
    this.id,
    this.townId,
    this.townName,
  });

  MyLocation copyWith({
    int? id,
    int? townId,
    String? townName,
  }) {
    return MyLocation(
      id: id ?? this.id,
      townId: townId ?? this.townId,
      townName: townName ?? this.townName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'townId': townId,
      'townName': townName,
    };
  }

  factory MyLocation.fromMap(Map<String, dynamic> map) {
    return MyLocation(
      id: map['id'] != null ? map['id'] as int : null,
      townId: map['townId'] != null ? map['townId'] as int : null,
      townName: map['townName'] != null ? map['townName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyLocation.fromJson(String source) =>
      MyLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MyLocation(id: $id, townId: $townId, townName: $townName)';
}
