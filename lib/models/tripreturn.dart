// To parse this JSON data, do
//
//     final tripReturnModel = tripReturnModelFromJson(jsonString);

import 'dart:convert';

TripReturnModel tripReturnModelFromJson(String str) =>
    TripReturnModel.fromJson(json.decode(str));

String tripReturnModelToJson(TripReturnModel data) =>
    json.encode(data.toJson());

class TripReturnModel {
  String id;
  String tripnumber;
  String vehicleid;
  String passengerid;
  String startaddress;
  double startlat;
  double startlong;
  String startstageid;
  DateTime starttime;
  String destinationaddress;
  double destinationlat;
  double destinationlong;
  String stopstageid;
  DateTime stoptime;
  double distance;
  double duration;
  double cost;
  String paymentstatus;
  String transporttypeid;
  DateTime datecreated;
  String createdby;
  DateTime dateupdated;
  String updatedby;
  String status;

  TripReturnModel({
    required this.id,
    required this.tripnumber,
    required this.vehicleid,
    required this.passengerid,
    required this.startaddress,
    required this.startlat,
    required this.startlong,
    required this.startstageid,
    required this.starttime,
    required this.destinationaddress,
    required this.destinationlat,
    required this.destinationlong,
    required this.stopstageid,
    required this.stoptime,
    required this.distance,
    required this.duration,
    required this.cost,
    required this.paymentstatus,
    required this.transporttypeid,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory TripReturnModel.fromJson(Map<String, dynamic> json) =>
      TripReturnModel(
        id: json["id"],
        tripnumber: json["tripnumber"],
        vehicleid: json["vehicleid"],
        passengerid: json["passengerid"],
        startaddress: json["startaddress"],
        startlat: json["startlat"]?.toDouble(),
        startlong: json["startlong"]?.toDouble(),
        startstageid: json["startstageid"],
        starttime: DateTime.parse(json["starttime"]),
        destinationaddress: json["destinationaddress"],
        destinationlat: json["destinationlat"]?.toDouble(),
        destinationlong: json["destinationlong"]?.toDouble(),
        stopstageid: json["stopstageid"],
        stoptime: DateTime.parse(json["stoptime"]),
        distance: json["distance"]?.toDouble(),
        duration: json["duration"]?.toDouble(),
        cost: json["cost"]?.toDouble(),
        paymentstatus: json["paymentstatus"],
        transporttypeid: json["transporttypeid"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: DateTime.parse(json["dateupdated"]),
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tripnumber": tripnumber,
        "vehicleid": vehicleid,
        "passengerid": passengerid,
        "startaddress": startaddress,
        "startlat": startlat,
        "startlong": startlong,
        "startstageid": startstageid,
        "starttime": starttime.toIso8601String(),
        "destinationaddress": destinationaddress,
        "destinationlat": destinationlat,
        "destinationlong": destinationlong,
        "stopstageid": stopstageid,
        "stoptime": stoptime.toIso8601String(),
        "distance": distance,
        "duration": duration,
        "cost": cost,
        "paymentstatus": paymentstatus,
        "transporttypeid": transporttypeid,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
