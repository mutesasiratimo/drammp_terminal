import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../models/otpverify.dart';
import '../../models/signup.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../../reusables/textinput.dart';
import 'otp.dart';
import 'signin.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends Base<RegisterPage> {
  String? identify;
  String? password;
  bool responseLoading = false;
  bool? passOb;
  bool? repassOb;
  String _validatedphoneNumber = "";
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  String _countryCode = "256";
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  String _otp = "";

  _generateOtp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
    Random random = Random();
    setState(() {
      _otp = (random.nextInt(9999) + 1000).toString();
    });

    prefs.setString("otp", _otp);
    String phoneNumber = _validatedphoneNumber.replaceAll("+", "");
    String message = "Your Entebbe DRAMMP registration OTP is: " + _otp;

    debugPrint(phoneNumber + "=====================================");

    var url = Uri.parse(
        "https://sms.dmarkmobile.com/v2/api/send_sms/?spname=spesho@dmarkmobile.com&sppass=t4x1sms&numbers=$phoneNumber&msg=$message&type=json");

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
      },
    );
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      OtpVerify otpObj = OtpVerify.fromJson(item);
      if (otpObj.submitted == 1) {
        showSnackBar("OTP sent via SMS");
      } else {
        showSnackBar("OTP Failure: Failed to send OTP.");
      }
    } else {
      setState(() {
        responseLoading = false;
      });
      showSnackBar("Verification Failure: Failed to send OTP.");
    }
  }

  String _validateMobile(String countrycode, phoneNumber) {
    String nonzeropattern = r'(^[1-9]{1}[0-9]{8}$)';
    String zeropattern = r'(^[0]{1}[1-9]{1}[0-9]{8}$)';
    RegExp nonzeroregExp = new RegExp(nonzeropattern);
    RegExp zeroregExp = new RegExp(zeropattern);
    if (phoneNumber.length == 10 && zeroregExp.hasMatch(phoneNumber)) {
      print('WITH ZERO NUMBER MATCHED');
      _validatedphoneNumber = countrycode + phoneNumber.substring(1);
    } else if (phoneNumber.length == 9 && nonzeroregExp.hasMatch(phoneNumber)) {
      print('NON ZERO NUMBER MATCHED');
      _validatedphoneNumber = countrycode + phoneNumber;
    } else {
      print('FAILED');
    }
    print("This is the validated number: " + _validatedphoneNumber);
    return _validatedphoneNumber;
  }

  Future<void> _register(String firstname, String lastname, String email,
      String phone, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "users/signup");
    // bool responseStatus = false;
    // String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseLoading = true;
      _validatedphoneNumber = _validateMobile(_countryCode, phone);
      // print("++++++ VALIDATED PHONE NUMBER ++++" + _validatedphoneNumber);
    });
    var bodyString = {
      "id": "0",
      "title": "",
      "firstname": firstname,
      "lastname": lastname,
      "phone": _validatedphoneNumber,
      "mobile": "",
      "email": email,
      "password": password,
      "gender": "M",
      "photo": "",
      "dateofbirth": "1990-03-23",
      "isadmin": false,
      "isclerk": false,
      "cardid": "610ff347da080400626364566676869",
      "issuperadmin": false,
      "status": "1"
    };

    var body = jsonEncode(bodyString);
    print(url);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("THE REG RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        responseLoading = false;
      });
      final item = json.decode(response.body);
      SignUpModel userModel = SignUpModel.fromJson(item);
      print("++++THE USER IS +++" + item["id"].toString());
      // await _createWallet(userModel.id);
      await _generateOtp();
      push(OtpPage(
        userId: userModel.id,
        phone: userModel.photo,
        otp: _otp,
      ));
    } else if (response.statusCode == 409) {
      setState(() {
        responseLoading = false;
      });
      showSnackBar("User already exists with this email.");
    } else {
      setState(() {
        responseLoading = false;
      });
      showSnackBar("Registration Failure: Invalid data.");
    }
  }

  @override
  void initState() {
    super.initState();
    passOb = true;
    repassOb = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 9,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: GestureDetector(
                      onTap: (() {
                        pushAndRemoveUntil(SignInPage());
                      }),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(140, 139, 138, 0.8),
                              ],
                            )),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const ReuseText(
                    text: 'Register',
                    color: Colors.black,
                    fWeight: FontWeight.w700,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .8,
                alignment: Alignment.bottomCenter,
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
                              width: 110,
                              margin: const EdgeInsets.only(right: 10),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(
                                      "CODE: " + number.phoneNumber.toString());
                                  setState(() {
                                    _countryCode =
                                        number.phoneNumber.toString();
                                  });
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                initialValue: number,
                                textFieldController: countryCodeController,
                                formatInput: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                inputBorder: OutlineInputBorder(),
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                            Expanded(
                              child: ReuseInput(
                                controller: phoneController,
                                textInputType: TextInputType.text,
                                text: '770123123',
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
                                action: TextInputAction.done,
                                textInputType: TextInputType.text,
                                controller: passwordController,
                                obscureText: passOb!,
                                text: 'Password',
                                last: passOb!
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            passOb = !passOb!;
                                          });
                                        },
                                        child: const Icon(Icons.visibility))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            passOb = !passOb!;
                                          });
                                        },
                                        child:
                                            const Icon(Icons.visibility_off)),
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
                                action: TextInputAction.done,
                                textInputType: TextInputType.text,
                                controller: confirmPasswordController,
                                obscureText: repassOb!,
                                text: 'Confirm Password',
                                last: repassOb!
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            repassOb = !repassOb!;
                                          });
                                        },
                                        child: const Icon(Icons.visibility))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            repassOb = !repassOb!;
                                          });
                                        },
                                        child:
                                            const Icon(Icons.visibility_off)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .05,
                        ),
                        responseLoading
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    _register(
                                        firstNameController.text.trim(),
                                        lastNameController.text.trim(),
                                        emailController.text.trim(),
                                        phoneController.text.trim(),
                                        passwordController.text.trim());
                                  } else {
                                    showSnackBar("Passwords do not match!");
                                  }
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: ReuseButton(
                                    radius: 10,
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                    width:
                                        MediaQuery.of(context).size.width * .6,
                                    color: AppConstants.primaryColor,
                                    child: const ReuseText(
                                      text: 'Register',
                                      color: Colors.white,
                                      size: 14,
                                      fWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
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
                                size: 12,
                                fWeight: FontWeight.w400,
                              ),
                              GestureDetector(
                                onTap: () {
                                  pushReplacement(const SignInPage());
                                },
                                child: ReuseText(
                                  text: 'Sign In',
                                  color: AppConstants.primaryColor,
                                  size: 12,
                                  fWeight: FontWeight.w400,
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
            ],
          ),
        ),
      ),
    );
  }
}
