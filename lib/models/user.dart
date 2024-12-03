// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userid;
  dynamic fcmid;
  String title;
  String firstname;
  String lastname;
  String othernames;
  String email;
  String phone;
  String gender;
  dynamic modeofops;
  dynamic eplatform;
  dynamic permitno;
  dynamic trainingno;
  dynamic ninattach;
  dynamic residenceattach;
  dynamic stageattach;
  dynamic haspermit;
  dynamic istrained;
  String villageid;
  String parishid;
  String subcountyid;
  String countyid;
  String districtid;
  dynamic nationality;
  dynamic nin;
  dynamic passportno;
  dynamic tin;
  dynamic dateofbirth;
  dynamic photo;
  dynamic revenuesource;
  List<Revenuestream> revenuestreams;
  DateTime datecreated;
  String token;
  String status;

  UserModel({
    required this.userid,
    required this.fcmid,
    required this.title,
    required this.firstname,
    required this.lastname,
    required this.othernames,
    required this.email,
    required this.phone,
    required this.gender,
    this.modeofops,
    this.eplatform,
    required this.permitno,
    required this.trainingno,
    required this.ninattach,
    required this.residenceattach,
    required this.stageattach,
    required this.haspermit,
    required this.istrained,
    required this.villageid,
    required this.parishid,
    required this.subcountyid,
    required this.countyid,
    required this.districtid,
    required this.nationality,
    this.nin,
    this.passportno,
    this.tin,
    this.dateofbirth,
    this.photo,
    this.revenuesource,
    required this.revenuestreams,
    required this.datecreated,
    required this.token,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userid: json["userid"],
        fcmid: json["fcmid"],
        title: json["title"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        othernames: json["othernames"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        modeofops: json["modeofops"],
        eplatform: json["eplatform"],
        permitno: json["permitno"],
        trainingno: json["trainingno"],
        ninattach: json["ninattach"],
        residenceattach: json["residenceattach"],
        stageattach: json["stageattach"],
        haspermit: json["haspermit"],
        istrained: json["istrained"],
        villageid: json["villageid"],
        parishid: json["parishid"],
        subcountyid: json["subcountyid"],
        countyid: json["countyid"],
        districtid: json["districtid"],
        nationality: json["nationality"],
        nin: json["nin"],
        passportno: json["passportno"],
        tin: json["tin"],
        dateofbirth: DateTime.parse(json["dateofbirth"]),
        photo: json["photo"],
        revenuesource: json["revenuesource"],
        revenuestreams: List<Revenuestream>.from(
            json["revenuestreams"].map((x) => Revenuestream.fromJson(x))),
        datecreated: DateTime.parse(json["datecreated"]),
        token: json["token"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "fcmid": fcmid,
        "title": title,
        "firstname": firstname,
        "lastname": lastname,
        "othernames": othernames,
        "email": email,
        "phone": phone,
        "gender": gender,
        "modeofops": modeofops,
        "eplatform": eplatform,
        "permitno": permitno,
        "trainingno": trainingno,
        "ninattach": ninattach,
        "residenceattach": residenceattach,
        "stageattach": stageattach,
        "haspermit": haspermit,
        "istrained": istrained,
        "villageid": villageid,
        "parishid": parishid,
        "subcountyid": subcountyid,
        "countyid": countyid,
        "districtid": districtid,
        "nationality": nationality,
        "nin": nin,
        "passportno": passportno,
        "tin": tin,
        "dateofbirth": dateofbirth.toIso8601String(),
        "photo": photo,
        "revenuesource": revenuesource,
        "revenuestreams":
            List<dynamic>.from(revenuestreams.map((x) => x.toJson())),
        "datecreated": datecreated.toIso8601String(),
        "token": token,
        "status": status,
      };
}

class Revenuestream {
  String id;
  String regreferenceno;
  String sectorid;
  String sectorsubtypeid;
  String tarriffrequency;
  double tarrifamount;
  DateTime lastrenewaldate;
  DateTime nextrenewaldate;
  String revenueactivity;
  String vesseltype;
  String vesselstorage;
  String vesselmaterial;
  String vesselsafetyequip;
  double vessellength;
  String vesselpropulsion;
  double dailyactivehours;
  String companytype;
  String businesstype;
  String regno;
  String vin;
  String tin;
  dynamic brn;
  String businessname;
  String tradingname;
  String establishmenttype;
  int staffcountmale;
  int staffcountfemale;
  int bedcount;
  int roomcount;
  String permitno;
  String color;
  String logbookno;
  double enginehp;
  String engineno;
  String model;
  String ownerid;
  dynamic address;
  dynamic addresslat;
  dynamic addresslong;
  String operatorid;
  String divisionid;
  String stageid;
  dynamic purpose;
  String type;
  DateTime datecreated;
  String createdby;
  dynamic dateupdated;
  dynamic updatedby;
  String status;

  Revenuestream({
    required this.id,
    required this.regreferenceno,
    required this.sectorid,
    required this.sectorsubtypeid,
    required this.tarriffrequency,
    required this.tarrifamount,
    required this.lastrenewaldate,
    required this.nextrenewaldate,
    required this.revenueactivity,
    required this.vesseltype,
    required this.vesselstorage,
    required this.vesselmaterial,
    required this.vesselsafetyequip,
    required this.vessellength,
    required this.vesselpropulsion,
    required this.dailyactivehours,
    required this.companytype,
    required this.businesstype,
    required this.regno,
    required this.vin,
    required this.tin,
    required this.brn,
    required this.businessname,
    required this.tradingname,
    required this.establishmenttype,
    required this.staffcountmale,
    required this.staffcountfemale,
    required this.bedcount,
    required this.roomcount,
    required this.permitno,
    required this.color,
    required this.logbookno,
    required this.enginehp,
    required this.engineno,
    required this.model,
    required this.ownerid,
    required this.address,
    required this.addresslat,
    required this.addresslong,
    required this.operatorid,
    required this.divisionid,
    required this.stageid,
    this.purpose,
    required this.type,
    required this.datecreated,
    required this.createdby,
    required this.dateupdated,
    required this.updatedby,
    required this.status,
  });

  factory Revenuestream.fromJson(Map<String, dynamic> json) => Revenuestream(
        id: json["id"],
        regreferenceno: json["regreferenceno"],
        sectorid: json["sectorid"],
        sectorsubtypeid: json["sectorsubtypeid"],
        tarriffrequency: json["tarriffrequency"],
        tarrifamount: json["tarrifamount"],
        lastrenewaldate: DateTime.parse(json["lastrenewaldate"]),
        nextrenewaldate: DateTime.parse(json["nextrenewaldate"]),
        revenueactivity: json["revenueactivity"],
        vesseltype: json["vesseltype"],
        vesselstorage: json["vesselstorage"],
        vesselmaterial: json["vesselmaterial"],
        vesselsafetyequip: json["vesselsafetyequip"],
        vessellength: json["vessellength"],
        vesselpropulsion: json["vesselpropulsion"],
        dailyactivehours: json["dailyactivehours"],
        companytype: json["companytype"],
        businesstype: json["businesstype"],
        regno: json["regno"],
        vin: json["vin"],
        tin: json["tin"],
        brn: json["brn"],
        businessname: json["businessname"],
        tradingname: json["tradingname"],
        establishmenttype: json["establishmenttype"],
        staffcountmale: json["staffcountmale"],
        staffcountfemale: json["staffcountfemale"],
        bedcount: json["bedcount"],
        roomcount: json["roomcount"],
        permitno: json["permitno"],
        color: json["color"],
        logbookno: json["logbookno"],
        enginehp: json["enginehp"],
        engineno: json["engineno"],
        model: json["model"],
        ownerid: json["ownerid"],
        address: json["address"],
        addresslat: json["addresslat"],
        addresslong: json["addresslong"],
        operatorid: json["operatorid"],
        divisionid: json["divisionid"],
        stageid: json["stageid"],
        purpose: json["purpose"],
        type: json["type"],
        datecreated: DateTime.parse(json["datecreated"]),
        createdby: json["createdby"],
        dateupdated: json["dateupdated"],
        updatedby: json["updatedby"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "regreferenceno": regreferenceno,
        "sectorid": sectorid,
        "sectorsubtypeid": sectorsubtypeid,
        "tarriffrequency": tarriffrequency,
        "tarrifamount": tarrifamount,
        "lastrenewaldate": lastrenewaldate.toIso8601String(),
        "nextrenewaldate": nextrenewaldate.toIso8601String(),
        "revenueactivity": revenueactivity,
        "vesseltype": vesseltype,
        "vesselstorage": vesselstorage,
        "vesselmaterial": vesselmaterial,
        "vesselsafetyequip": vesselsafetyequip,
        "vessellength": vessellength,
        "vesselpropulsion": vesselpropulsion,
        "dailyactivehours": dailyactivehours,
        "companytype": companytype,
        "businesstype": businesstype,
        "regno": regno,
        "vin": vin,
        "tin": tin,
        "brn": brn,
        "businessname": businessname,
        "tradingname": tradingname,
        "establishmenttype": establishmenttype,
        "staffcountmale": staffcountmale,
        "staffcountfemale": staffcountfemale,
        "bedcount": bedcount,
        "roomcount": roomcount,
        "permitno": permitno,
        "color": color,
        "logbookno": logbookno,
        "enginehp": enginehp,
        "engineno": engineno,
        "model": model,
        "ownerid": ownerid,
        "address": address,
        "addresslat": addresslat,
        "addresslong": addresslong,
        "operatorid": operatorid,
        "divisionid": divisionid,
        "stageid": stageid,
        "purpose": purpose,
        "type": type,
        "datecreated": datecreated.toIso8601String(),
        "createdby": createdby,
        "dateupdated": dateupdated,
        "updatedby": updatedby,
        "status": status,
      };
}
