// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModel {
  String id;
  String startaddress;
  double startlat;
  double startlong;
  String startstageid;
  String vehicleid;
  String passengerid;
  DateTime starttime;
  String destinationaddress;
  double destinationlat;
  double destinationlong;
  String stopstageid;
  DateTime stoptime;
  String transporttypeid;
  DateTime datecreated;
  String createdby;
  DateTime dateupdated;
  String updatedby;
  String status;

  TripModel({
    required this.id,
    required this.startaddress,
    required this.startlat,
    required this.startlong,
    required this.startstageid,
    required this.vehicleid,
    required this.passengerid,
    required this.starttime,
    required this.destinationaddress,
    required this.destinationlat,
    required this.destinationlong,
    required this.stopstageid,
    required this.stoptime,
    required this.transporttypeid,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"],
        startaddress: json["startaddress"],
        startlat: json["startlat"],
        startlong: json["startlong"],
        startstageid: json["startstageid"],
        vehicleid: json["vehicleid"],
        passengerid: json["passengerid"],
        starttime: DateTime.parse(json["starttime"]),
        destinationaddress: json["destinationaddress"],
        destinationlat: json["destinationlat"],
        destinationlong: json["destinationlong"],
        stopstageid: json["stopstageid"],
        stoptime:
            DateTime.parse(json["stoptime"] ?? "2024-08-26T04:42:40.915839"),
        transporttypeid: json["transporttypeid"],
        datecreated:
            DateTime.parse(json["datecreated"] ?? "2024-08-26T04:42:40.915839"),
        createdby: json["createdby"],
        dateupdated:
            DateTime.parse(json["dateupdated"] ?? "2024-08-26T04:42:40.915839"),
        updatedby: json["updatedby"] ?? "",
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startaddress": startaddress,
        "startlat": startlat,
        "startlong": startlong,
        "startstageid": startstageid,
        "vehicleid": vehicleid,
        "passengerid": passengerid,
        "starttime": starttime.toIso8601String(),
        "destinationaddress": destinationaddress,
        "destinationlat": destinationlat,
        "destinationlong": destinationlong,
        "stopstageid": stopstageid,
        "stoptime": stoptime.toIso8601String(),
        "transporttypeid": transporttypeid,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated.toIso8601String(),
        "updatedby": updatedby,
        "status": status,
      };
}
