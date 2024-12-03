import 'dart:convert';

import 'package:entebbe_dramp_terminal/views/auth/otp.dart';
import 'package:entebbe_dramp_terminal/views/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends Base<ResetPasswordPage> {
  String? identify;
  String? password;
  TextEditingController identifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _responseLoading = false;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');

  _resetPassword(String phoneNumberString) async {
    var url = Uri.parse(
        AppConstants.baseUrl + "operators/resetpassword/$phoneNumberString");
    // bool responseStatus = false;
    String userid = "";
    print("++++++" + "RESET DRIVER PASSWORD FUNCTION" + "+++++++");

    setState(() {
      _responseLoading = true;
    });

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
      },
    );
    print("++++++" + response.body.toString() + "+++++++");
    print("++++++ CODE IS" + response.statusCode.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      var otp = item["otp"];
      userid = item["userid"];
      setState(() {
        _responseLoading = false;
      });
      pushAndRemoveUntil(OtpPage(
        otp: otp,
        userId: userid,
        phone: phoneNumberString,
      ));
    } else if (response.statusCode == 204) {
      setState(() {
        _responseLoading = false;
      });
      showInfoToast("Account with this email does not exist.");
    } else {
      setState(() {
        _responseLoading = false;
      });
      showErrorToast("Failed to reset password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child:
                                Image.asset("assets/images/entebbemlogo.png"),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ReuseText(
                            text:
                                'Digital Revenue Assurance & \n Mobility Management Platform.',
                            color: Colors.black,
                            size: 16,
                            fWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ReuseText(
                            text: 'Driver Application',
                            color: Colors.black,
                            size: 20,
                            fWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              textFieldController: identifyController,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                      ),
                      _responseLoading
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor),
                              ),
                            )
                          : SizedBox(
                              height: 45,
                              width: MediaQuery.of(context).size.width * .8,
                              child: GestureDetector(
                                onTap: () {
                                  if (number.phoneNumber != null) {
                                    _resetPassword(number.phoneNumber!
                                        .replaceAll("+", ""));
                                  } else {
                                    showWarningToast(
                                        "Please enter a valid phone number");
                                  }

                                  // pushAndRemoveUntil(const HomePage());
                                },
                                child: ReuseButton(
                                  radius: 10,
                                  height:
                                      MediaQuery.of(context).size.height * .04,
                                  width: MediaQuery.of(context).size.width * .6,
                                  color: AppConstants.primaryColor,
                                  child: const ReuseText(
                                    text: 'Reset Password',
                                    color: Colors.white,
                                    size: 18,
                                    fWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ReuseText(
                              text: 'Already have an account? ',
                              color: Colors.black,
                              size: 14,
                              fWeight: FontWeight.w400,
                            ),
                            GestureDetector(
                              onTap: () {
                                pushReplacement(const SignInPage());
                              },
                              child: const ReuseText(
                                text: 'Sign In',
                                color: AppConstants.primaryColor,
                                size: 16,
                                fWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
