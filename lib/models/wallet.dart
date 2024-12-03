// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Wallets walletFromJson(String str) => Wallets.fromJson(json.decode(str));

String walletToJson(Wallets data) => json.encode(data.toJson());

class Wallets {
  String id;
  String benefactorid;
  String userid;
  double availablebalance;
  double currentbalance;
  double totalincoming;
  double totaloutgoing;
  String fcmid;
  String title;
  String firstname;
  String lastname;
  String email;
  String phone;
  dynamic photo;
  double balance;
  DateTime datecreated;
  String status;

  Wallets({
    required this.id,
    required this.benefactorid,
    required this.userid,
    required this.availablebalance,
    required this.currentbalance,
    required this.totalincoming,
    required this.totaloutgoing,
    required this.fcmid,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.photo,
    required this.balance,
    required this.datecreated,
    required this.status,
  });

  factory Wallets.fromJson(Map<String, dynamic> json) => Wallets(
        id: json["id"],
        benefactorid: json["benefactorid"],
        userid: json["userid"],
        availablebalance: json["availablebalance"],
        currentbalance: json["currentbalance"],
        totalincoming: json["totalincoming"],
        totaloutgoing: json["totaloutgoing"],
        fcmid: json["fcmid"],
        title: json["title"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        photo: json["photo"],
        balance: json["balance"],
        datecreated: DateTime.parse(json["datecreated"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "benefactorid": benefactorid,
        "userid": userid,
        "availablebalance": availablebalance,
        "currentbalance": currentbalance,
        "totalincoming": totalincoming,
        "totaloutgoing": totaloutgoing,
        "fcmid": fcmid,
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "photo": photo,
        "balance": balance,
        "datecreated": datecreated.toIso8601String(),
        "status": status,
      };
}
