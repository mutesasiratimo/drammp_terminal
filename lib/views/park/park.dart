import 'package:avatar_glow/avatar_glow.dart';
import 'package:entebbe_dramp_terminal/config/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:nfc_classic_mifare/nfc_classic_mifare.dart';

import '../../config/constants.dart';

class ParkManagement extends StatefulWidget {
  const ParkManagement({super.key});

  @override
  State<ParkManagement> createState() => _ParkManagementState();
}

class _ParkManagementState extends Base<ParkManagement> {
  Future<void> scanQrCode() async {
    String qrCodeRes;
    try {
      qrCodeRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );
      debugPrint(" +++ THE QR CODE DRIVER ID IS ${qrCodeRes}");
      // String decryptedText =
      //     decryptWithAES(hash, encrypt.Encrypted.fromBase64(qrCodeRes));
    } on PlatformException {
      qrCodeRes = "Failed";
    }
  }

  initializeScanNfc() async {
    List<String> _sector = await NfcClassicMifare.readSector(sectorIndex: 0);
    if (_sector.length > 0) {
      showSuccessToast("UBB747G Funds deducted. Opening Toll gate.");
    } else {
      showWarningToast("Invalid card/device");
    }
    initializeScanNfc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    initializeScanNfc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Park Access Control"),
        actions: [
          IconButton(onPressed: scanQrCode, icon: Icon(Icons.qr_code_2))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AvatarGlow(
              glowColor: AppConstants.primaryColor,
              endRadius: 130.0,
              child: Material(
                // Replace this child with your own
                elevation: 8.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  // maxRadius: 110,
                  // minRadius: 120,
                  backgroundColor: AppConstants.primaryColor,
                  child: IconButton(
                      icon: Icon(
                        size: 80,
                        Icons.wifi_tethering_sharp,
                        color: Color(0xffB59410),
                      ),
                      onPressed: () async {
                        FlutterBeep.beep();
                      }),
                  radius: 80.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text("Tap Driver's card to access Taxi Park")
        ],
      ),
    );
  }
}
