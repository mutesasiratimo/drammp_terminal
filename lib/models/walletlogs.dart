// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

WalletLogs walletlogFromJson(String str) =>
    WalletLogs.fromJson(json.decode(str));

String walletlogToJson(WalletLogs data) => json.encode(data.toJson());

class WalletLogs {
  WalletLogs({
    required this.id,
    required this.userid,
    required this.userwalletid,
    required this.amount,
    required this.type,
    required this.description,
    required this.datecreated,
    this.createdby,
    required this.status,
  });

  String id;
  String userid;
  String userwalletid;
  double amount;
  String type;
  String description;
  DateTime datecreated;
  String? createdby;
  String status;

  factory WalletLogs.fromJson(Map<String, dynamic> json) => WalletLogs(
        id: json["id"],
        userid: json["userid"],
        userwalletid: json["userwalletid"],
        amount: json["amount"].toDouble(),
        type: json["type"],
        description: json["description"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "userwalletid": userwalletid,
        "amount": amount,
        "type": type,
        "description": description,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "status": status,
      };
}
