import 'dart:convert';

import 'package:entebbe_dramp_terminal/config/base.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/streamsearch.dart';
import '../../reusables/button.dart';
import '../../reusables/text.dart';
import '../../reusables/textinput.dart';

class EnforcementPage extends StatefulWidget {
  const EnforcementPage({super.key});

  @override
  State<EnforcementPage> createState() => _EnforcementPageState();
}

class _EnforcementPageState extends Base<EnforcementPage> {
  TextEditingController nameController = TextEditingController();
  bool _responseLoading = false;
  bool _streamExists = false;
  String streamName = "";
  String paymentStatus = "";
  double amountDue = 0.0;
  DateTime dueDate = DateTime.now();

  //GET WALLET LOGS
  Future<RevenueStreamSearch> getRevenueStream(String streamName) async {
    // var url = Uri.parse(
    //     BASE_URL + "walletlogs/userid/1208163d-a08e-11ec-b77b-58a023a485d9");

    // bool responseStatus = false;
    // String jwt = "";
    // String operatorId = "";
    var returnValue;
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // operatorId = prefs.getString('userid') ?? "";
    // await _authenticate(_username, _password);
    // await authenticate(_email, context, "stay");
    var url =
        Uri.parse(AppConstants.baseUrl + "revenuestreams/name/$streamName");

    debugPrint(url.toString() + "++++++++++++");
    setState(() {
      _responseLoading = true;
    });

    // if (prefs.getString('authToken') != null ||
    //     prefs.getString('authToken') != "") {
    //   print("This is the authToken -- " + prefs.getString('authToken')!);
    //   setState(() {
    //     authToken = prefs.getString('authToken')!;
    //   });

    var response = await http.get(
      url,
      headers: {
        "Content-Type": "Application/json",
        // 'Authorization': 'Bearer $authToken',
      },
    );
    print("This is the response code -- " + response.statusCode.toString());
    setState(() {
      _responseLoading = false;
      nameController.clear();
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      debugPrint(response.body.toString() + "++++++++++++");
      RevenueStreamSearch stream = RevenueStreamSearch.fromJson(items);

      setState(() {
        _streamExists = true;
        streamName = stream.businessname;
        amountDue = stream.tarrifamount;
        dueDate = stream.nextrenewaldate;
        if (dueDate.isBefore(DateTime.now())) {
          paymentStatus = "Default";
        } else {
          paymentStatus = "Compliant";
        }
      });
      // RevenueStreamSearch stream =
      // (items as List).map((data) => WalletLogs.fromJson(data)).toList();

      var transactions = stream;
      returnValue = transactions;
    } else {
      returnValue = [];
      showWarningToast("Revenue Stream does not exist");
    }
    // }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enforcement"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          const ReuseText(
            text:
                'Enter the Reg. No of a vehicle or a business name and search to confirm payment status.',
            color: Colors.black,
            size: 16,
            fWeight: FontWeight.w500,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReuseInput(
                action: TextInputAction.done,
                textInputType: TextInputType.name,
                controller: nameController,
                text: 'Reg No/Business Name',
              ),
            ],
          ),
          SizedBox(
            height: 20,
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
                      getRevenueStream(nameController.text);
                    },
                    child: ReuseButton(
                      radius: 10,
                      height: MediaQuery.of(context).size.height * .04,
                      width: MediaQuery.of(context).size.width * .6,
                      color: AppConstants.primaryColor,
                      child: const ReuseText(
                        text: 'Search',
                        color: Colors.white,
                        size: 18,
                        fWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          SizedBox(height: 30),
          Visibility(
            visible: _streamExists,
            child: paymentStatus == "Default"
                ? Icon(Icons.warning, size: 60, color: Colors.red)
                : Icon(Icons.check_circle, size: 60, color: Colors.green),
          ),
          SizedBox(height: 16),
          // Visibility(
          //   visible: _streamExists,
          //   child: ReuseText(
          //     textAlign: TextAlign.left,
          //     text: 'Name: $streamName',
          //     color: Colors.black,
          //     size: 18,
          //     fWeight: FontWeight.bold,
          //   ),
          // ),
          Visibility(
            visible: _streamExists,
            child: ReuseText(
              text: 'Status: $paymentStatus',
              color: Colors.black,
              size: 18,
              fWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            visible: _streamExists,
            child: ReuseText(
              text: 'Amount Due: $amountDue',
              color: Colors.black,
              size: 18,
              fWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            visible: _streamExists,
            child: ReuseText(
              text: 'Due Date: ${DateFormat('yyyy/MM/dd').format(dueDate)}',
              color: Colors.black,
              size: 18,
              fWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
