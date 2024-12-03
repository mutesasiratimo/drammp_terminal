import 'dart:convert';
import 'package:entebbe_dramp_terminal/config/base.dart';
import 'package:entebbe_dramp_terminal/reusables/text.dart';
import 'package:entebbe_dramp_terminal/views/agent/newcard.dart';
import 'package:entebbe_dramp_terminal/views/agent/topup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/constants.dart';
import '../../models/walletlogs.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends Base<AgentPage> {
  Future<List<WalletLogs>>? _transactionLogs;
  bool balancePending = true;

  @override
  void initState() {
    _transactionLogs = _getTransactionLogs();
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

  //GET WALLET LOGS
  Future<List<WalletLogs>> _getTransactionLogs() async {
    // var url = Uri.parse(
    //     BASE_URL + "walletlogs/userid/1208163d-a08e-11ec-b77b-58a023a485d9");

    // bool responseStatus = false;
    // String jwt = "";
    String operatorId = "";
    var returnValue;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    operatorId = prefs.getString('userid') ?? "";
    // await _authenticate(_username, _password);
    // await authenticate(_email, context, "stay");
    var url = Uri.parse(AppConstants.baseUrl + "walletlogs/userid/$operatorId");

    debugPrint(url.toString() + "++++++++++++");
    setState(() {
      balancePending = true;
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
      balancePending = false;
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body);
      debugPrint(response.body.toString() + "++++++++++++");
      List<WalletLogs> list =
          (items as List).map((data) => WalletLogs.fromJson(data)).toList();

      var transactions = list;
      returnValue = transactions;
    } else if (response.statusCode == 404) {
      returnValue = [];
      // showSnackBar("Info: No transaction history available");
    } else {
      returnValue = [];
      // showSnackBar("Error: Failed to load transaction logs");
    }
    // }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "UGX",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    "220,000",
                    style: TextStyle(
                      fontSize: 40,
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              AppConstants.primaryColor),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      side: BorderSide(
                                          color: AppConstants.primaryColor)))),
                      onPressed: () => push(TopUpPage()),
                      child: Text(
                        'Top Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                          elevation: WidgetStateProperty.all<double>(8.0),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      side: BorderSide(
                                          width: 1.5,
                                          color: AppConstants.primaryColor)))),
                      onPressed: () => push(NewCardPage()),
                      child: Text(
                        'New Card',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ReuseText(
                    text: "Recent Transactions",
                    size: 18.0,
                    fWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: FutureBuilder<List<dynamic>>(
                  future: _transactionLogs,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (!snapshot.hasError) {
                        if (snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, index) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd  kk:mm').format(
                                        snapshot.data![index].datecreated);
                                return Column(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot
                                                      .data![index].description,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                      fontSize: 15.0),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text(
                                                      "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 11),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      formattedDate,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data![index].amount
                                                      .round()
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: snapshot
                                                                  .data![index]
                                                                  .type ==
                                                              "IN"
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 16.0),
                                                ),
                                                Text(
                                                  snapshot.data![index].type,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey[700],
                                                      fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                if (snapshot
                                                        .data![index].type ==
                                                    "IN")
                                                  const Icon(
                                                    Icons.download_outlined,
                                                    color: Colors.green,
                                                  ),
                                                if (snapshot
                                                        .data![index].type ==
                                                    "OUT")
                                                  const Icon(
                                                    Icons.upload_outlined,
                                                    color: Colors.red,
                                                  ),
                                                if (snapshot
                                                        .data![index].type ==
                                                    "CREATED")
                                                  const Icon(
                                                    Icons
                                                        .wallet_membership_outlined,
                                                    color: Colors.black,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                      // color: Colors.grey,
                                      )
                                ]);
                              });
                        } else if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("No Transaction Logs Found!"),
                          );
                        }
                      } else {
                        return const Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              Icon(
                                Icons.warning_amber_outlined,
                                color: AppConstants.primaryColor,
                              ),
                              Text(
                                "Failed to load Transaction Logs!",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return new Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                                highlightColor: AppConstants.primaryColor),
                            child: new CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
