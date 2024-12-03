import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class AppFunctions {
  //auth function to get bearer token
  static authenticate(String username, String password) async {
    var url = Uri.parse(AppConstants.baseUrl + "riders/login/mobile");
    // bool responseStatus = false;
    String _authToken = "";
    // Navigator.pushNamed(context, AppRouter.home);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var bodyString = {"username": username, "password": password};

    var body = jsonEncode(bodyString);

    var response = await http.post(url,
        headers: {
          "Content-Type": "Application/json",
        },
        body: body);
    debugPrint("++++++" + response.body.toString() + "+++++++");
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      UserModel auth = UserModel.fromJson(item);
      _authToken = auth.token;
      prefs.setString("authToken", _authToken);
      prefs.setString("firstName", auth.firstname);
      prefs.setString("lastName", auth.lastname);
      prefs.setString("email", auth.email);
      prefs.setString("gender", auth.gender);
      prefs.setString("phone", auth.phone);
      prefs.setString("password", password);
      prefs.setString("userid", auth.userid.toString());
    } else {
      // showSnackBar("Network Failure: Failed to retrieve students");
    }
  }
}
