// import 'dart:convert';
import 'package:entebbe_dramp_terminal/views/auth/updatepassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
// import '../../models/signup.dart';
import 'signin.dart';

class OtpPage extends StatefulWidget {
  final String userId;
  final String phone;
  final String otp;
  const OtpPage({
    Key? key,
    required this.userId,
    required this.phone,
    required this.otp,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends Base<OtpPage> {
  bool responseLoading = false;
  String userId = "";
  String otp = "";

  @override
  void initState() {
    super.initState();
    // _generateOtp();
    setState(
      () {
        debugPrint(widget.userId.toString());
        userId = widget.userId;
      },
    );
  }

  _checkOtp() {}
  // _generateOtp() async {
  //   var url = Uri.parse(AppConstants.getOtpUrl);
  //   bool responseStatus = false;
  //   String _authToken = "";
  //   // Navigator.pushNamed(context, AppRouter.home);
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     responseLoading = true;
  //   });
  //   var bodyString = {
  //     "api_id": "API27709903398",
  //     "api_password": "Kcc@2022",
  //     "brand": "KLA CONNECT",
  //     "phonenumber": widget.user.phone.toString().replaceAll("+", ""),
  //     "sender_id": "KCCA",
  //   };

  //   var body = jsonEncode(bodyString);

  //   var response = await http.post(url,
  //       headers: {
  //         "Content-Type": "Application/json",
  //       },
  //       body: body);
  //   print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final item = json.decode(response.body);
  //     VeirfyOtp otpObj = VeirfyOtp.fromJson(item);
  //     if (otpObj.status == "S") {
  //       showSnackBar("OTP sent via SMS");
  //       prefs.setInt("verificationid", otpObj.verficationId);
  //     } else {
  //       showSnackBar("OTP Failure: Failed to send OTP.");
  //     }
  //   } else {
  //     setState(() {
  //       responseLoading = false;
  //     });
  //     showSnackBar("Verification Failure: Failed to send OTP.");
  //   }
  // }

  // _verifyOtp(String otpCode) async {
  //   var url = Uri.parse(AppConstants.verifyOtpUrl);
  //   bool responseStatus = false;
  //   String _authToken = "";
  //   int verificationCode = 0;
  //   // Navigator.pushNamed(context, AppRouter.home);
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     responseLoading = true;
  //     if (prefs.getInt("verificationid") != null) {
  //       verificationCode = prefs.getInt("verificationid")!;
  //     }
  //   });

  //   var bodyString = {
  //     "verfication_id": verificationCode,
  //     "verfication_code": otpCode,
  //   };

  //   var body = jsonEncode(bodyString);

  //   var response = await http.post(url,
  //       headers: {
  //         "Content-Type": "Application/json",
  //       },
  //       body: body);
  //   print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final item = json.decode(response.body);
  //     VeirfyOtp otpObj = VeirfyOtp.fromJson(item);
  //     if (otpObj.status == "V") {
  //       Future.delayed(const Duration(seconds: 2), () {
  //         pushAndRemoveUntil(const SignInPage());
  //       });
  //       showSnackBar("Verification Successful: Activating User ...");
  //       _activateUser();
  //     } else {
  //       showSnackBar("Verification Failure: Invalid OTP.");
  //     }
  //   } else {
  //     setState(() {
  //       responseLoading = false;
  //     });
  //     showSnackBar("Verification Failure: Invalid OTP.");
  //   }
  // }

  _activateUser() async {
    // bool responseStatus = false;
    // String _authToken = "";
    // String userId = "";
    // Navigator.pushNamed(context, AppRouter.home);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
    var url = Uri.parse(AppConstants.baseUrl + "users/activate/$userId");
    debugPrint("THE ACTIVATE URL IS ++++++" + url.toString());
    var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "Application/json",
      // },
    );
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final item = json.decode(response.body);
      showSuccessToast("Success: User activated successfully. Sign In");
      pushAndRemoveUntil(const SignInPage());
    } else {
      setState(() {
        responseLoading = false;
      });
      showErrorToast("Activation Failure: Contact Support.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Verify Number"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .7,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .8,
                        child: RichText(
                          text: TextSpan(
                            text: 'We have sent a verification code to ' +
                                widget.phone +
                                '.',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppConstants.primaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      ),
                      Center(
                        child: RichText(
                          text: const TextSpan(
                            text: 'Enter Code',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .03,
                      ),
                      Center(
                        child: OtpTextField(
                          numberOfFields: 4,
                          borderColor: const Color.fromRGBO(237, 33, 36, 1),
                          keyboardType: TextInputType.text,
                          focusedBorderColor:
                              const Color.fromRGBO(237, 33, 36, 1),
                          showFieldAsBox: true,
                          fillColor: Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          onCodeChanged: (String code) {},
                          onSubmit: (String verificationCode) async {
                            // _verifyOtp(verificationCode);
                            if (widget.otp == verificationCode) {
                              // await _activateUser();
                              push(
                                UpdatePasswordPage(
                                  phone: widget.phone,
                                  userId: widget.userId,
                                  otp: otp,
                                ),
                              );
                            } else {
                              showInfoToast("Invalid OTP");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
