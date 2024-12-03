import 'dart:convert';
import 'package:entebbe_dramp_terminal/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config/base.dart';
import '../../config/constants.dart';
import '../../models/user.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../../reusables/textinput.dart';
import 'resetpassword.dart';
// import 'resetpassword.dart';
// import 'signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends Base<SignInPage> {
  String? identify;
  String? password;
  String? phoneNumber;
  TextEditingController identifyController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _responseLoading = false;
  bool? passOb;
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');

  _login(String username, String password) async {
    isConnected().then((isInternet) async {
      if (isInternet) {
        var url = Uri.parse("${AppConstants.baseUrl}operators/login/mobile");
        // bool responseStatus = false;
        String _authToken = "";
        debugPrint("++++++ OPERATOR LOGIN FUNCTION+++++++");
        // Navigator.pushNamed(context, AppRouter.home);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          _responseLoading = true;
        });
        var bodyString = {"username": username, "password": password};

        var body = jsonEncode(bodyString);
        debugPrint(
            "++++++${body.toString()}+++++++++++++++++++++++++++++++++++++");
        var response = await http.post(url,
            headers: {
              "Content-Type": "Application/json",
            },
            body: body);
        debugPrint("++++++${response.body}+++++++");
        if (response.statusCode == 200) {
          final item = json.decode(response.body);
          UserModel user = UserModel.fromJson(item);
          _authToken = user.token;
          prefs.setString("authToken", _authToken);
          prefs.setString("username", "${user.firstname} ${user.lastname}");
          prefs.setString("firstName", user.firstname);
          prefs.setString("lastName", user.lastname);
          prefs.setString("email", user.email);
          prefs.setString("gender", user.gender);
          prefs.setString("phone", user.phone);
          prefs.setString("password", password);
          prefs.setString("userid", user.userid.toString());
          // prefs.setString("dateJoined", user.datecreated.toIso8601String());

          //Convert list of vehicles to string that will be decoded for later use.
          String encodedAutomobiles = jsonEncode(user.revenuestreams);
          prefs.setString("revenuestreams", encodedAutomobiles);
          // prefs.setBool("isadmin", user.isadmin);
          // prefs.setBool("issuperadmin", user.issuperadmin);
          setState(() {
            _responseLoading = false;
          });
          pushAndRemoveUntil(HomePage(
            revenuestreams: user.revenuestreams,
          ));
        } else if (response.statusCode == 409) {
          setState(() {
            _responseLoading = false;
          });
          showWarningToast("User account not activated.");
        } else {
          setState(() {
            _responseLoading = false;
          });
          showErrorToast("Authentication Failure: Invalid credentials.");
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passOb = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
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
                          child: Image.asset("assets/images/entebbemlogo.png"),
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
                                phoneNumber = number.phoneNumber;
                              });
                            },
                            onInputValidated: (bool value) {
                              // print(value);
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReuseInput(
                          action: TextInputAction.done,
                          textInputType: TextInputType.url,
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
                                  child: const Icon(Icons.visibility_off)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        push(ResetPasswordPage());
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            ReuseText(
                              text: '',
                              color: Colors.black,
                              size: 14,
                              fWeight: FontWeight.w400,
                            ),
                            ReuseText(
                              text: 'Forgot password?',
                              color: AppConstants.primaryColor,
                              size: 14,
                              fWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
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
                                _login(
                                    number.phoneNumber!
                                        .toString()
                                        .replaceAll("+", ""),
                                    passwordController.text.trim());
                                // pushAndRemoveUntil(const HomePage());
                              },
                              child: ReuseButton(
                                radius: 10,
                                height:
                                    MediaQuery.of(context).size.height * .04,
                                width: MediaQuery.of(context).size.width * .6,
                                color: AppConstants.primaryColor,
                                child: const ReuseText(
                                  text: 'Sign In',
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
                            text: 'Don’t know how to register? ',
                            color: Colors.black,
                            size: 14,
                            fWeight: FontWeight.w400,
                          ),
                          GestureDetector(
                            onTap: () {
                              // pushReplacement(const RegisterPage());
                            },
                            child: const ReuseText(
                              text: 'Find out here',
                              color: AppConstants.primaryColor,
                              size: 14,
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
    );
  }
}
