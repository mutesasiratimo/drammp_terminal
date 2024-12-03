// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutterwave_standard_smart/flutterwave.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../../config/base.dart';
import '../../config/constants.dart';
import '../../config/functions.dart';
import '../../models/wallet.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends Base<TopUpPage> {
  // final TextEditingController cardMobileNoController = TextEditingController();
  final cardNoController = MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController amountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String initialCountry = 'UG';
  PhoneNumber number = PhoneNumber(isoCode: 'UG');
  String selectedCurrency = "UGX";
  bool responseLoading = false;
  bool obscurePassword = true;
  double availableBalance = 0.0;
  double currentBalance = 0.0;
  double totalIncoming = 0.0;
  double totalOutgoing = 0.0;
  bool isTestMode = false;
  String selectedFundsSource = "Select Funds Source";
  List<Map<String, dynamic>> fundsSources = [
    {"name": "Mobile Money"},
    {"name": "Debit/Credit Card Number"}
  ];
  List<Wallets> wallets = [];
  Wallets? selectedWallet;

  getWalletData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList('wallets');

    if (jsonStringList != null) {
      // debugPrint("++++++++ CARDS LIST ${jsonStringList}");

      setState(() {
        wallets = jsonStringList
            .map((jsonString) => Wallets.fromJson(jsonDecode(jsonString)))
            .toList();
        selectedWallet = wallets.first;
      });
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
      email: selectedWallet == null
          ? "mutestimo72@gmail.com"
          : selectedWallet!.email,
      name: selectedWallet == null
          ? ""
          : "${selectedWallet!.firstname} ${selectedWallet!.lastname}",
      phoneNumber: number.phoneNumber!.replaceAll("+", ""),
    );

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: AppConstants.fwPublicKey,
        currency: "UGX",
        redirectUrl: 'https://facebook.com',
        txRef: Uuid().v1(),
        amount: amountController.text.toString().trim(),
        customer: customer,
        paymentOptions: "card, payattitude, barter, bank transfer, ussd",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTestMode);
    final ChargeResponse response = await flutterwave.charge();
    if (response.toJson()["status"] == "successful") {
      topUpWallet(
        response.toJson()["transaction_id"],
        double.tryParse(amountController.text.toString().trim())!,
      );
    } else {
      showErrorToast("Flutterwave transaction failed. Contact Support");
    }
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Flutterwave Response"),
    //         content: Text(response.toString()),
    //       );
    //     });
    print("${response.toJson()}");
  }

  Future<dynamic> topUpWallet(String transactionId, double amount) async {
    var url = Uri.parse(AppConstants.baseUrl + "wallet/topup");
    bool responseStatus = false;
    String jwt = "";
    String userId = "";
    String phone = "";
    String password = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone') ?? "";
    String? walletId = selectedWallet!.id;
    availableBalance = selectedWallet!.availablebalance;
    currentBalance = selectedWallet!.currentbalance;
    totalIncoming = selectedWallet!.totalincoming;
    totalOutgoing = selectedWallet!.totaloutgoing;
    if (walletId != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_bottom,
                            size: 40,
                            color: AppConstants.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Please Wait",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Platform.isIOS
                              ? const CupertinoActivityIndicator(
                                  animating: true,
                                )
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor),
                                ),
                          const Text(
                            "Topping up your wallet .......",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
      print("+++++++ GETTING SESSION DATA +++++++");
      // await _getSessionData();
      await AppFunctions.authenticate(phone, password);
      // setState(() {
      //   _balancePending = true;
      // });

      if (prefs.getString('userid') != null ||
          prefs.getString('userid') != "") {
        print("This is the user id -- " + prefs.getString('userid')!);
        setState(() {
          userId = prefs.getString('userid')!;
        });
      }

      if (prefs.getString('authToken') != null ||
          prefs.getString('authToken') != "") {
        print("This is the authToken -- " + prefs.getString('authToken')!);
        setState(() {
          jwt = prefs.getString('authToken')!;
        });

        var bodyString = {
          "id": walletId,
          "amount": amount,
          "userid": "$userId",
          "userwalletid": walletId,
          "type": "IN",
          "description":
              "Wallet Topup (FlutterWave-$selectedFundsSource) Trans ID: $transactionId",
          "availablebalance": availableBalance + amount,
          "currentbalance": currentBalance + amount,
          "totalincoming": totalIncoming + amount,
          "totaloutgoing": totalOutgoing + amount,
          "dateupdated": "2022-04-06T06:12:24.264Z",
          "updatedby": "$userId",
          "status": "1"
        };

        var body = jsonEncode(bodyString);
        print(body);

        var response = await http.put(
          url,
          body: body,
          headers: {
            "Content-Type": "Application/json",
            'Authorization': 'Bearer $jwt',
          },
        );
        print("This is the response code -- " + response.statusCode.toString());
        if (response.statusCode == 200) {
          final items = json.decode(response.body);

          setState(() {
            responseLoading = false;
          });
          await AppFunctions.authenticate(phone, password);
          pushReplacement(TopUpPage());
        } else {
          showErrorToast(
              "Failed wallet top up: Please check your internet connection.");
        }
      }
    } else {
      showErrorToast("Failed to identify wallet, contact support.");
    }
  }

  @override
  void initState() {
    getWalletData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Up Funds"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Image.asset("assets/images/Illustration 4@2x.png"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          "Source of Funds",
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Container(
                          decoration: customDecoration(),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Text(
                                    selectedFundsSource,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              items: fundsSources.map((item) {
                                return new DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      new Text(
                                        item["name"],
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                List itemsList = fundsSources.map((item) {
                                  if (item == newVal) {
                                    setState(() {
                                      selectedFundsSource = item["name"];
                                      debugPrint(selectedFundsSource);
                                    });
                                  }
                                }).toList();
                              },
                              // value: _mySelection,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          "Beneficiary (Pay to)",
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Container(
                          decoration: customDecoration(),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Text(
                                    "${selectedWallet!.firstname} ${selectedWallet!.lastname}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              items: wallets.map((item) {
                                return new DropdownMenuItem(
                                  child: Row(
                                    children: [
                                      new Text(
                                        "${item.firstname} ${item.lastname}",
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (newVal) {
                                List itemsList = wallets.map((item) {
                                  if (item == newVal) {
                                    setState(() {
                                      selectedWallet = item;
                                      debugPrint(
                                          selectedWallet!.phone.toString());
                                    });
                                  }
                                }).toList();
                              },
                              // value: _mySelection,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: selectedFundsSource != "Debit/Credit Card Number",
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            "Mobile Number",
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: SizedBox(
                            height: 48,
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  this.number = number;
                                });
                                // print(number.phoneNumber);
                              },
                              onInputValidated: (bool value) {
                                // print(value);
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                useBottomSheetSafeArea: true,
                              ),
                              inputDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey.shade500,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: AppConstants.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                hintText: "Phone Number",
                                fillColor: Colors.white70,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              formatInput: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              inputBorder: OutlineInputBorder(),
                              onSaved: (PhoneNumber number) {
                                print('On Saved: $number');
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: selectedFundsSource == "Debit/Credit Card Number",
              //   child: SizedBox(
              //     height: 30,
              //   ),
              // ),
              Visibility(
                visible: selectedFundsSource == "Debit/Credit Card Number",
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            "Debit/Credit Card Number",
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: SizedBox(
                            height: 45,
                            child: TextField(
                              controller: cardNoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.grey.shade500,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: AppConstants.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                hintText: "**** **** **** ****",
                                fillColor: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: Text(
                            "Topup Amount",
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: Colors.grey.shade500,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.0,
                                  color: AppConstants.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              hintText: "Amount",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Top Up", style: TextStyle(fontSize: 16)),
                        style: ButtonStyle(
                            // padding: WidgetStateProperty.all(
                            //     EdgeInsets.all(8.0)),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                AppConstants.primaryColor),
                            shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(
                                        color: AppConstants.primaryColor)))),
                        onPressed: () {
                          _handlePaymentInitialization();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
