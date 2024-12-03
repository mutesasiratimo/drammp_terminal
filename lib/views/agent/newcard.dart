import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:entebbe_dramp_terminal/config/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nfc_classic_mifare/nfc_classic_mifare.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../reusables/text.dart';
import '../../reusables/textinput.dart';

class NewCardPage extends StatefulWidget {
  const NewCardPage({super.key});

  @override
  State<NewCardPage> createState() => _NewCardPageState();
}

class _NewCardPageState extends Base<NewCardPage> {
  bool responseLoading = false;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    initializeNfcListening();
    super.initState();
  }

  showSuccessDialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: 'Card Added Successfully.',
        title: 'Success',
        lottieBuilder: Lottie.asset(
          'assets/cong_example.json',
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [
          IconsButton(
            onPressed: () {},
            text: 'Claim',
            iconData: Icons.done,
            color: Colors.blue,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  initializeNfcListening() async {
    List<String> _sector = await NfcClassicMifare.readSector(sectorIndex: 0);
    _sector.length > 0
        ? {FlutterBeep.beep(), setState(() {})}
        : showWarningToast("Invalid card!");
  }

  linkCardToUser(String cardid, String userid, String fname, String lname,
      String email, String phone) async {
    var url = Uri.parse(AppConstants.baseUrl + "users/linkcard");
    // bool responseStatus = false;
    String authToken = "";
    String userid = "";
    // String fcmid = "";
    // int verificationCode = 0;
    // Navigator.pushNamed(context, AppRouter.home);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken") ?? "";
    userid = prefs.getString("userid") ?? "";
    // fcmid = prefs.getString("fcmid") ?? "";

    var bodyString = {
      "id": "string",
      "userid": userid,
      "cardid": cardid,
      "firstname": fname,
      "lastname": lname,
      "phone": phone,
      "email": email,
      "ismycard": true,
      "createdby": "08291870-9eed-11ef-bf99-42010a800002",
      "datecreated": "2024-11-11T05:22:36.580Z",
      "dateupdated": "2024-11-11T05:22:36.580Z",
      "updatedby": "string",
      "status": "1"
    };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Card"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReuseText(
              text:
                  "Place your card to after filling in the form to link card to user.",
              size: 16.0,
              fWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.height * .7,
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ReuseInput(
                              controller: firstNameController,
                              textInputType: TextInputType.text,
                              text: 'Firstname',
                              action: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ReuseInput(
                              controller: lastNameController,
                              textInputType: TextInputType.text,
                              text: 'Lastname',
                              action: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ReuseInput(
                              controller: emailController,
                              textInputType: TextInputType.emailAddress,
                              text: 'email',
                              action: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 8.0),
                            width: MediaQuery.of(context).size.width * .8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                // print(number.phoneNumber);
                                setState(() {
                                  this.number = number;
                                });
                              },
                              onInputValidated: (bool value) {
                                // print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                useBottomSheetSafeArea: true,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              hintText: " 770 123456",
                              autoFocus: false,
                              inputDecoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              formatInput: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: false),
                              inputBorder: OutlineInputBorder(),
                              onSaved: (PhoneNumber number) {
                                // print('On Saved: $number');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      responseLoading
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.secondaryColor),
                              ),
                            )
                          : AvatarGlow(
                              glowColor: Colors.deepPurple.shade400,
                              endRadius: 60.0,
                              child: Material(
                                // Replace this child with your own
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: AppConstants.primaryColor,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.wifi_tethering_sharp,
                                        color: Color(0xffB59410),
                                      ),
                                      onPressed: () async {
                                        if (firstNameController.text
                                            .trim()
                                            .isEmpty) {
                                          showSnackBar(
                                              'Your first name is required');
                                        } else if (lastNameController.text
                                            .trim()
                                            .isEmpty) {
                                          showSnackBar(
                                              'Your last name is required');
                                        } else if (emailController.text
                                            .trim()
                                            .isEmpty) {
                                          showSnackBar(
                                              'Your email is required');
                                        } else if (phoneController.text
                                            .trim()
                                            .isEmpty) {
                                          showSnackBar(
                                              'Your phone number is required');
                                        } else if (number.phoneNumber == null) {
                                          showSnackBar(
                                              'Correct your phone number');
                                        } else {
                                          List<String> _sector =
                                              await NfcClassicMifare.readSector(
                                                  sectorIndex: 0);
                                          _sector.length > 0
                                              ? {
                                                  FlutterBeep.beep(),
                                                  linkCardToUser(
                                                      _sector[0].toString(),
                                                      "",
                                                      firstNameController.text,
                                                      lastNameController.text,
                                                      emailController.text,
                                                      number.phoneNumber!),
                                                }
                                              : showWarningToast(
                                                  "Invalid card!");
                                        }
                                      }),
                                  radius: 30.0,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
