import 'dart:convert';
import 'package:entebbe_dramp_terminal/models/user.dart';
import 'package:entebbe_dramp_terminal/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusables/text.dart';
import 'views/auth/signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    opacity = Tween<double>(begin: 0.8, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get user ID
    // String? checkUserName = prefs.getString('username');
    String? checkUserId = prefs.getString('userid');
    String? automobiles = prefs.getString("revenuestreams");

    if ((checkUserId != null && checkUserId != '' && automobiles != null)) {
      final items = json.decode(automobiles);
      List<Revenuestream> automobilesList =
          (items as List).map((data) => Revenuestream.fromJson(data)).toList();
      debugPrint("+++++++ THE VEHICLES ARE $automobiles ++++++++++++++++++");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => HomePage(
                revenuestreams: automobilesList,
              )));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SignInPage()));
    }
  }

  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color.fromRGBO(248, 221, 7, 0.6),
        //     Color.fromRGBO(237, 30, 36, 0.1),
        //   ],
        // )),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: Opacity(
                            opacity: opacity.value,
                            child:
                                Image.asset('assets/images/entebbemlogo.png')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 200,
                  padding: EdgeInsets.only(
                    top: 50,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: const ReuseText(
                            textAlign: TextAlign.center,
                            text:
                                'Digital Revenue Assurance & \n Mobility Management Platform',
                            color: Colors.black,
                            size: 18,
                            fWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          child: const ReuseText(
                            textAlign: TextAlign.center,
                            text: 'Driver App.',
                            color: Colors.black,
                            size: 22,
                            fWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
