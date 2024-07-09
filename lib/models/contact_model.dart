import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String fullname;
  String phoneNumber;
  String uid;
  Timestamp? timestamp;

  Contact({
    required this.fullname,
    required this.phoneNumber,
    required this.uid,
    this.timestamp,
  });

  Contact.fromJson(Map<String, Object?> json)
      : this(
          fullname: json["fullname"]! as String,
          phoneNumber: json["phoneNumber"]! as String,
          uid: json["uid"]! as String,
          timestamp: json["timestamp"]! as Timestamp,
        );

  Contact copyWith({
    String? fullname,
    String? phoneNumber,
    String? uid,
    Timestamp? timestamp,
  }) {
    return Contact(
      fullname: fullname ?? this.fullname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'timestamp': timestamp,
    };
  }
}
