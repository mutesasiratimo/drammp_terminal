// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:entebbe_dramp_terminal/models/user.dart';
import 'package:entebbe_dramp_terminal/views/agent/agent.dart';
import 'package:entebbe_dramp_terminal/views/reports/financialreports.dart';
import 'package:entebbe_dramp_terminal/views/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slider_button/slider_button.dart';
import '../../config/base.dart';
import '../../config/constants.dart';
import 'package:weather/weather.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:nfc_classic_mifare/nfc_classic_mifare.dart';
import 'package:http/http.dart' as http;
import '../../config/functions.dart';
import '../../models/tripreturn.dart';
import '../auth/signin.dart';

class HomePage extends StatefulWidget {
  final List<Revenuestream> revenuestreams;
  const HomePage({super.key, required this.revenuestreams});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends Base<HomePage> {
  late ScrollController scrollController;

  ///The controller of sliding up panel
  SlidingUpPanelController panelController = SlidingUpPanelController();
  Timer? timer;
  WeatherFactory wf = WeatherFactory(AppConstants.weatherApiKey);
  bool responseLoading = false;
  bool scanNfcCardStatus = true;
  double minBound = 0.45;
  double upperBound = 0.45;
  String address = "Kampala, Uganda";
  LatLng currentLocationCoords = const LatLng(0.347596, 32.582520);
  Weather? weather;
  Location currentLocation = Location();
  String salutation = "";
  String hash = "This 32 char key have 256 bits..";
  double tripDistance = 0.0;
  double tripDuration = 0.0;
  double tripFare = 0.0;
  double durationRate = 200.0;
  double baseFare = 1000.0;
  double kmRate = 600;
  String driverId = "";
  String nfcCardId = "";
  String numberPlate = "";
  String vehicleMake = "";
  String vehicleId = "";
  String transportType = "";
  StreamSubscription<LocationData>? locationSubscription;

  List<dynamic> gridItems = [
    {
      "title": "QR Code",
      "icon": Icon(
        Icons.qr_code,
        size: 60,
        color: Colors.green,
      )
    },
    {
      "title": "Reports",
      "icon": Icon(
        Icons.auto_graph_rounded,
        size: 60,
        color: Colors.blue,
      )
    },
    {
      "title": "Top Up",
      "icon": Icon(
        Icons.payments_sharp,
        size: 60,
        color: AppConstants.secondaryColor,
      )
    },
    {
      "title": "Settings",
      "icon": Icon(
        Icons.settings,
        size: 60,
        color: Colors.blueGrey.shade600,
      )
    },
  ];

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  void getLocation() async {
    locationSubscription =
        currentLocation.onLocationChanged.listen((LocationData loc) async {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(loc.latitude ?? 0.0, loc.longitude ?? 0.0);

      setState(() {
        var first = placemarks.first;
        address = ' ${first.street}, ${first.subLocality}.';
        // address =
        //     ' ${first.street}, ${first.subLocality}, ${first.locality}, ,${first.country}';
        // debugPrint(address);
        currentLocationCoords =
            LatLng(loc.latitude ?? 0.347596, loc.longitude ?? 32.582520);
      });
    });
  }

  getWeather() async {
    weather = await wf.currentWeatherByLocation(
        currentLocationCoords.latitude, currentLocationCoords.longitude);
    // debugPrint(weather!.humidity.toString() +
    //     " ++++++++++++++++++++++++++++++++++++++");
    timer = Timer.periodic(
      Duration(hours: 1),
      (Timer t) async => weather = await wf.currentWeatherByLocation(
          currentLocationCoords.latitude, currentLocationCoords.longitude),
    );

    return weather;
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  String decryptWithAES(String key, encrypt.Encrypted encryptedData) {
    final cipherKey = encrypt.Key.fromUtf8(key);
    final encryptService = encrypt.Encrypter(encrypt.AES(cipherKey,
        mode: encrypt.AESMode.cbc)); //Using AES CBC encryption
    final initVector = encrypt.IV.fromUtf8(key.substring(0,
        16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);
  }

  ///Encrypts the given plainText using the key. Returns encrypted data
  encrypt.Encrypted encryptWithAES(String key, String plainText) {
    final cipherKey = encrypt.Key.fromUtf8(key);
    final encryptService =
        encrypt.Encrypter(encrypt.AES(cipherKey, mode: encrypt.AESMode.cbc));
    final initVector = encrypt.IV.fromUtf8(key.substring(0,
        16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    encrypt.Encrypted encryptedData =
        encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  final isAvailable = NfcClassicMifare.availability;
  // await  NfcClassicMifare.writeRawHexToBlock(blockIndex: _blockIndex,message: rawHex,password:password);

  Future<void> scanQrCode() async {
    String qrCodeRes;
    try {
      qrCodeRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );
      // debugPrint(" +++ THE QR CODE USER ID IS ${qrCodeRes}");
      String decryptedText =
          decryptWithAES(hash, encrypt.Encrypted.fromBase64(qrCodeRes));
      _tripQueryViaQrCode(decryptedText);
      debugPrint(" +++ THE DECRYPTED QR CODE USER ID IS ${decryptedText}");
    } on PlatformException {
      qrCodeRes = "Failed";
    }
  }

  _tripQueryViaQrCode(String userid) async {
    var url = Uri.parse("${AppConstants.baseUrl}trips/update/user_id");
    var urlDeduct = Uri.parse("${AppConstants.baseUrl}/wallet/deduct");
    // bool responseStatus = false;
    String _authToken = "";
    String username = "";
    String password = "";
    // debugPrint("++++++ TRIP QUERY FUNCTION+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    driverId = prefs.getString("userid")!;
    username = prefs.getString("phone")!;
    password = prefs.getString("password")!;
    context.loaderOverlay.show();
    // await AppFunctions.authenticate(username, password);

    var bodyString = {
      "id": "",
      "tripnumber": "",
      "userid": userid,
      "vehicleid": vehicleId,
      "destinationaddress": address,
      "destinationlat": currentLocationCoords.latitude,
      "destinationlong": currentLocationCoords.longitude,
      "startstageid": "",
      "stopstageid": "",
      "transporttypeid": transportType,
      "stoptime": "2024-08-26T02:55:57.660Z",
      "dateupdated": "2024-08-26T02:55:57.660Z",
      "updatedby": "string",
      "status": "0"
    };

    var body = jsonEncode(bodyString);
    debugPrint("++++++${body.toString()}+++++++++++++++++++++++++++++++++++++");
    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          // "Bearer Token": _authToken,
        },
        body: body);
    debugPrint("++ STATUS BODY++++${response.body}+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      TripReturnModel trip = TripReturnModel.fromJson(item);
      if (trip.status == "0") {
        showSuccessToast("Trip started.");
        FlutterBeep.beep(true);
      } else if (trip.status == "1") {
        double lat1 = trip.startlat;
        double lon1 = trip.startlong;
        double lat2 = trip.destinationlat;
        double lon2 = trip.destinationlong;
        DateTime startTime = trip.starttime;
        DateTime stopTime = trip.stoptime;
        tripDistance = trip.distance;
        tripDuration = trip.duration;
        tripFare = trip.cost;
        //Alert Dialog
        Dialogs.materialDialog(
            color: Colors.white,
            msgStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            msg:
                "Trip ended successfully \nDuration: $tripDuration seconds \nDistance: $tripDistance km \nFare: ${tripFare.round()} UGX",
            title: 'Success',
            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            lottieBuilder: Lottie.asset('assets/cong_example.json',
                fit: BoxFit.contain, repeat: true, height: 80, width: 80),
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  pushAndRemoveUntil(
                      HomePage(revenuestreams: widget.revenuestreams));
                },
                text: 'Print',
                iconData: Icons.print,
                color: AppConstants.primaryColor,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              IconsButton(
                onPressed: () {
                  pushAndRemoveUntil(
                      HomePage(revenuestreams: widget.revenuestreams));
                },
                text: 'DONE',
                iconData: Icons.done,
                color: Colors.green.shade900,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);

        FlutterBeep.beep();
        setState(() {
          tripFare = 0.0;
          tripDuration = 0.0;
          tripDistance = 0.0;
        });
      }
      setState(() {
        responseLoading = false;
      });
    } else if (response.statusCode == 204) {
      setState(() {
        responseLoading = false;
      });
      FlutterBeep.beep(false);
      showSnackBar("Error: QR Code not linked to user.");
    } else {
      final item = json.decode(response.body);
      setState(() {
        responseLoading = false;
      });
      FlutterBeep.beep(false);
      showErrorToast(
          "${response.statusCode}: Application error: ${item["detail"]}.");
    }
    context.loaderOverlay.hide();
  }

  _tripQuery(String cardid) async {
    var url = Uri.parse("${AppConstants.baseUrl}trips/update/user_card");
    var urlDeduct = Uri.parse("${AppConstants.baseUrl}/wallet/deduct");
    // bool responseStatus = false;
    String _authToken = "";
    String username = "";
    String password = "";
    // debugPrint("++++++ TRIP QUERY FUNCTION+++++++");
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    driverId = prefs.getString("userid")!;
    username = prefs.getString("phone")!;
    password = prefs.getString("password")!;
    context.loaderOverlay.show();
    await AppFunctions.authenticate(username, password);

    var bodyString = {
      "id": "",
      "tripnumber": "",
      "cardid": cardid,
      "vehicleid": vehicleId,
      "destinationaddress": address,
      "destinationlat": currentLocationCoords.latitude,
      "destinationlong": currentLocationCoords.longitude,
      "startstageid": "",
      "stopstageid": "",
      "transporttypeid": transportType,
      "stoptime": "2024-08-26T02:55:57.660Z",
      "dateupdated": "2024-08-26T02:55:57.660Z",
      "updatedby": "string",
      "status": "0"
    };

    var body = jsonEncode(bodyString);
    debugPrint("++++++${body.toString()}+++++++++++++++++++++++++++++++++++++");
    var response = await http.put(url,
        headers: {
          "Content-Type": "Application/json",
          // "Bearer Token": _authToken,
        },
        body: body);
    debugPrint("++ STATUS BODY++++${response.body}+++++++");
    debugPrint("++ STATUS CODE++++${response.statusCode}+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      TripReturnModel trip = TripReturnModel.fromJson(item);
      if (trip.status == "0") {
        showSuccessToast("Trip started.");
        FlutterBeep.beep(true);
      } else if (trip.status == "1") {
        double lat1 = trip.startlat;
        double lon1 = trip.startlong;
        double lat2 = trip.destinationlat;
        double lon2 = trip.destinationlong;
        DateTime startTime = trip.starttime;
        DateTime stopTime = trip.stoptime;
        tripDistance = trip.distance;
        tripDuration = trip.duration;
        tripFare = trip.cost;
        Dialogs.materialDialog(
            color: Colors.white,
            msgStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            msg:
                "Trip ended successfully \nDuration: $tripDuration seconds \nDistance: $tripDistance km \nFare: ${tripFare.round()} UGX",
            title: 'Success',
            titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            lottieBuilder: Lottie.asset('assets/cong_example.json',
                fit: BoxFit.contain, repeat: true, height: 80, width: 80),
            context: context,
            actions: [
              IconsButton(
                onPressed: () {
                  pushAndRemoveUntil(
                      HomePage(revenuestreams: widget.revenuestreams));
                },
                text: 'Print',
                iconData: Icons.print,
                color: AppConstants.primaryColor,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
              IconsButton(
                onPressed: () {
                  pushAndRemoveUntil(
                      HomePage(revenuestreams: widget.revenuestreams));
                },
                text: 'DONE',
                iconData: Icons.done,
                color: Colors.green.shade900,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);

        FlutterBeep.beep();
        setState(() {
          tripFare = 0.0;
          tripDuration = 0.0;
          tripDistance = 0.0;
        });
      }
      setState(() {
        responseLoading = false;
      });
    } else if (response.statusCode == 204) {
      setState(() {
        responseLoading = false;
      });
      FlutterBeep.beep(false);
      showErrorToast("Error: Travel Card not linked to user.");
    } else {
      final item = json.decode(response.body);
      setState(() {
        responseLoading = false;
      });
      FlutterBeep.beep(false);
      showErrorToast(
          "${response.statusCode}: Application error: ${item["detail"]}.");
    }
    initializeScanNfc();
    context.loaderOverlay.hide();
  }

  toggleCardScan(bool nfcAvailble) async {
    context.loaderOverlay.show();
    setState(() {
      scanNfcCardStatus = nfcAvailble;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("nfcAvailble", nfcAvailble);
    context.loaderOverlay.hide();
    nfcAvailble
        ? showSuccessToast("Toggled NFC ${nfcAvailble}")
        : showWarningToast("Toggled NFC ${nfcAvailble}");
  }

  getScanNfcCardStatus() async {
    bool nfcAvailble = false;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("nfcAvailble") != null) {
      setState(() {
        scanNfcCardStatus = nfcAvailble;
      });
    } else {
      prefs.setBool("nfcAvailble", nfcAvailble);
    }
    debugPrint("THE STATUS OFF SCAN CARD ${prefs.getBool("nfcAvailble")}");
  }

  void getAutomobiles() async {
    context.loaderOverlay.show();
    debugPrint(
        "+++++++++ VEHICLES COUNT ${widget.revenuestreams.length} +++++++++++++");
    if (widget.revenuestreams.isEmpty) {
      showSnackBar("No vehicle attached to driver/rider.");
      pushAndRemoveUntil(SignInPage());
    } else if (widget.revenuestreams.length == 1) {
      setState(() {
        numberPlate = widget.revenuestreams.first.regno;
        vehicleMake = widget.revenuestreams.first.model;
        vehicleId = widget.revenuestreams.first.id;
      });
      loadStatisticsHome(widget.revenuestreams.first.id);
    } else if (widget.revenuestreams.length >= 2) {
      setState(() {
        numberPlate = widget.revenuestreams.first.regno;
        vehicleMake = widget.revenuestreams.first.model;
        vehicleId = widget.revenuestreams.first.id;
      });
      loadStatisticsHome(widget.revenuestreams.first.id);
    }
    context.loaderOverlay.hide();
  }

  loadStatisticsHome(String vehicleId) {
    //load from API endpoint, reload when vehicle changed.
  }

  updateFcmid() async {
    var url = Uri.parse(AppConstants.baseUrl + "operators/updatefcmid");
    // bool responseStatus = false;
    String authToken = "";
    String userid = "";
    String fcmid = "";
    // int verificationCode = 0;
    // Navigator.pushNamed(context, AppRouter.home);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
    userid = prefs.getString("userid") ?? "";
    fcmid = prefs.getString("fcmid") ?? "";

    var bodyString = {"userid": userid, "fcmid": fcmid};

    var body = jsonEncode(bodyString);
    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
          "Authorization": "Bearer $authToken"
        },
        body: body);
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final item = json.decode(response.body);
      debugPrint("FCM Update Success.");
    } else {
      debugPrint("FCM Update Failure.");
    }
  }

  initializeScanNfc() async {
    List<String> _sector = await NfcClassicMifare.readSector(sectorIndex: 0);
    if (_sector.length > 0) {
      _tripQuery(_sector[0]);
    } else {
      showWarningToast("Invalid card/device");
    }
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    getLocation();
    getScanNfcCardStatus();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    salutation = greeting();
    getAutomobiles();
    updateFcmid();
    initializeScanNfc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: AppConstants.primaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 16,
                      bottom: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 8.0,
                          ),
                          width: width * 0.5,
                          child: Text(
                            "Good $salutation",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: width * .3,
                          height: 50,
                          child: FutureBuilder<dynamic>(
                            future: getWeather(), // async work
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Text('');
                                default:
                                  if (snapshot.hasError)
                                    return Text('');
                                  else
                                    return Row(
                                      children: [
                                        Text(
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                          snapshot.data!.temperature.celsius
                                                  .round()
                                                  .toString() +
                                              "°C",
                                        ),
                                        CachedNetworkImage(
                                            imageUrl:
                                                'http://openweathermap.org/img/w/${snapshot.data!.weatherIcon}.png'),
                                      ],
                                    );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      // top: height * 0.08,
                      bottom: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 8.0,
                          ),
                          width: width * 0.5,
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.only(
                                  right: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                child: Icon(
                                  color: AppConstants.primaryColor,
                                  Icons.home,
                                  size: 30,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$numberPlate",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "$vehicleMake",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          height: height * 0.15,
                          width: width * 0.9,
                          child: SizedBox(
                            width: width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Lottie.asset('assets/travel.json',
                                    fit: BoxFit.contain,
                                    repeat: true,
                                    height: 80,
                                    width: 100),
                                // Container(
                                //   margin: EdgeInsets.symmetric(
                                //     horizontal: 8.0,
                                //   ),
                                //   height: 60,
                                //   width: 60,
                                //   child: Image.asset(
                                //       "assets/images/card_payment.jpeg"),
                                // ),
                                // ToggleSwitch(
                                //   minWidth: 50.0,
                                //   cornerRadius: 20.0,
                                //   activeBgColors: [
                                //     [Colors.green[800]!],
                                //     [Colors.red[800]!]
                                //   ],
                                //   activeFgColor: Colors.white,
                                //   inactiveBgColor: Colors.grey,
                                //   inactiveFgColor: Colors.white,
                                //   initialLabelIndex: scanNfcCardStatus ? 0 : 1,
                                //   totalSwitches: 2,
                                //   labels: ['ON', 'OFF'],
                                //   radiusStyle: true,
                                //   onToggle: (index) {
                                //     (index == 0)
                                //         ? toggleCardScan(true)
                                //         : toggleCardScan(false);
                                //   },
                                // ),
                                // Expanded(
                                //   child: SliderButton(
                                //     height: 60,
                                //     width: 150,
                                //     action: () async {
                                ///Do something here OnSlide
                                // return true;
                                // },
                                //     label: Text(
                                //       "Slide to start",
                                //       style: TextStyle(
                                //           color: Color(0xff4a4a4a),
                                //           fontWeight: FontWeight.w500,
                                //           fontSize: 17),
                                //     ),
                                //     icon: Text(
                                //       "x",
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.w400,
                                //         fontSize: 44,
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SlidingUpPanelWidget(
            controlHeight: 20.0,
            anchor: 0.55,
            minimumBound: minBound,
            upperBound: upperBound,
            panelStatus: SlidingUpPanelStatus.anchored,
            panelController: panelController,
            onTap: () {
              ///Customize the processing logic
              if (SlidingUpPanelStatus.expanded == panelController.status) {
                panelController.collapse();
              } else {
                panelController.expand();
              }
            }, //Pass a onTap callback to customize the processing logic when user click control bar.
            enableOnTap: false, //Enable the onTap callback for control bar.
            dragDown: (details) {
              print('dragDown');
            },
            dragStart: (details) {
              print('dragStart');
            },
            dragCancel: () {
              print('dragCancel');
            },
            dragUpdate: (details) {
              print(
                  'dragUpdate,${panelController.status == SlidingUpPanelStatus.dragging ? 'dragging' : ''}');
            },
            dragEnd: (details) {
              print('dragEnd');
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        color: const Color(0x11000000))
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(18.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 16.0, // spacing between rows
                      crossAxisSpacing: 16.0, // spacing between columns
                    ),
                    padding: EdgeInsets.all(8.0), // padding around the grid
                    itemCount: gridItems.length, // total number of items
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (gridItems[index]["title"]) {
                            case "QR Code":
                              scanQrCode();
                            case "Reports":
                              push(FinancialReportsPage());
                            case "Top Up":
                              push(AgentPage());
                            default:
                              push(SettingsPage());
                          }
                        },
                        child: Card(
                          child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  gridItems[index]["icon"],
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    gridItems[index]["title"],
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
