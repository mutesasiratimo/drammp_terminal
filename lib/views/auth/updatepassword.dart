import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../../reusables/textinput.dart';
import 'signin.dart';

class UpdatePasswordPage extends StatefulWidget {
  final String otp;
  final String phone;
  final String userId;
  const UpdatePasswordPage({
    Key? key,
    required this.phone,
    required this.otp,
    required this.userId,
  }) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends Base<UpdatePasswordPage> {
  bool responseLoading = false;
  String userId = "";
  String otp = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      userId = widget.userId;
    });
  }

  _activateUser() async {
    // bool responseStatus = false;
    // String _authToken = "";
    // String userId = "";
    // Navigator.pushNamed(context, AppRouter.home);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
    var url = Uri.parse(AppConstants.baseUrl + "operators/activate/$userId");

    var response = await http.get(
      url,
      // headers: {
      //   "Content-Type": "Application/json",
      // },
    );
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final item = json.decode(response.body);
      showSuccessToast("Password Updated: Head to Sign Up");
      Future.delayed(const Duration(seconds: 2), () {
        pushAndRemoveUntil(const SignInPage());
      });
    } else {
      setState(() {
        responseLoading = false;
      });
      showErrorToast("Verification Failure: User not activated.");
    }
  }

  _updatePassword(String phone, String newPassword) async {
    var url = Uri.parse(AppConstants.baseUrl + "operators/updatepassword");
    // bool responseStatus = false;
    // String _authToken = "";
    // int verificationCode = 0;
    // Navigator.pushNamed(context, AppRouter.home);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      responseLoading = true;
    });

    var bodyString = {"phone": phone, "password": newPassword};

    var body = jsonEncode(bodyString);
    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    print("THE RESPONSE IS ++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final item = json.decode(response.body);

      await _activateUser();
    } else {
      setState(() {
        responseLoading = false;
      });
      showSnackBar("Update Failure: Invalid OTP.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
      ),
      key: scaffoldKey,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xffF5F5F5),
        ),
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    text: 'Enter your new password.',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Row(
                  children: [
                    Expanded(
                      child: ReuseInput(
                        action: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        text: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
                child: Row(
                  children: [
                    Expanded(
                      child: ReuseInput(
                        action: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: confirmPasswordController,
                        obscureText: true,
                        text: 'Confirm Password',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
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
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (passwordController.text ==
                                  confirmPasswordController.text) {
                                _updatePassword(widget.phone,
                                    passwordController.text.trim());
                              } else {
                                showErrorToast(
                                    "Passwords do not match. Try again.");
                              }
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * .6,
                              child: ReuseButton(
                                radius: 8,
                                height:
                                    MediaQuery.of(context).size.height * .04,
                                width: MediaQuery.of(context).size.width * .6,
                                color: AppConstants.primaryColor,
                                child: const ReuseText(
                                  text: 'Update Password',
                                  color: Colors.white,
                                  size: 16,
                                  fWeight: FontWeight.bold,
                                ),
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
    );
  }
}
