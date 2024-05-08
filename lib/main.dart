import 'dart:async';
import 'dart:convert';

import 'package:fawry_nfc_sdk/model/constants.dart';
import 'package:fawry_nfc_sdk/model/response.dart';
import 'package:flutter/material.dart';

import 'package:fawry_nfc_sdk/fawry_nfc_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FAWRY NFC SCANNER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String printedMessage = '';
  late StreamSubscription? _fawryCallbackResultStream;
  CardType selectedCardType = CardType.ELECT;

  @override
  void initState() {
    super.initState();
    initSDKCallback();
  }
  
    Future<void> initSDKCallback() async {
      try {
        _fawryCallbackResultStream =
            FawryNfcSdk.instance.callbackResultStream().listen((event) {
          setState(() {
            ResponseStatus response = ResponseStatus.fromJson(jsonDecode(event));
            handleResponse(response);
          });
        });

        await FawryNfcSdk.instance.initializeSDK(
          token: 'Will Be Provided By Fawry',
          secretKey: 'Will Be Provided By Fawry',
        );
      } catch (ex) {
        debugPrint(ex.toString());
      }
    }


  void handleResponse(ResponseStatus response) {
    // Debug print the response
    debugPrint(
        '======== Response ========\n$response\n===========================');

    setState(() {
      printedMessage +=
          '\n===========================\n======== Response ========\n$response';
    });
  }

  @override
  void dispose() {
    _fawryCallbackResultStream?.cancel();
    super.dispose();
  }

  // Method to write to NFC card using FawryNfc class
  Future<void> _writeNFC() async {
    try {
      setState(() {
        printedMessage = "Please Put The Card To Write";
      });

      await FawryNfcSdk.instance.writeNFC(
        cardType: selectedCardType, // Use the selected card type
        billEncryptInfoECMC:
            "NTgs/////wAA//8FI817hb9x8hAAAAD/VgD/////kEIRAgAAAAAAAABQFSEAAAAAAAD//////////////3w3NTAsaAV8AJBCEQIAAAAAAAAQJwAAaAABhIv6/wAAAP//LH56EANkAAAALAEAAJABAAAEZUnwSQIAQB8AAFDDAADIMgAAYOoAAIw8AAD4JAEAiPsDACChBwDQBwAA6AMAAAAAAAAAGAAQAAEFQEIPABQW////BwgGigAgAAgCAQAA6AOYGhb///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9oBWgA/QMAAAoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAECcAAJABAABADQMAyAAAADB1AABkAAAAkF8BAASHAQAAAAAAAAAAADAAAAAAAwAAADAAAAAAAP8AAAA+BxYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAfDEzLGgFBgBoAHibSwDRARZ8MTAsARAgAf8EAQAAmXwwLHwxNDYskAB1Qe8RSk4vx5ohbzwHxZkNbL55iHJg37/8ewncFYIhEx2s2dnJP1kmbuDCWDRufwvupv998LhwJSO+/kkTsGmczsw4JMNyV3nRT8wauYZNH5lciggfrDrq+XR+HRIAhja7poA3Ovc59KJ8ze9do4mdYgc8clsvYoOOQK0MU4r9TCDPAOrLkvcCtHfzWQGSdgt8",
        cardMetaData:
            "gABQBxw4OjLoa5t5f3H1fRbpQQlZNIARYIp/eddH/AN9XGV/7SVzagw3Fw7L4U9p+FUSx7+p/bpCwXsD9Tl2kAFPzDLnMMNl8Ac1TAkOGqFEqKWCABR6P9xvnl1D5Z+qQ1H0aXbWAAICAYQAEKSnXQ8Za+mrJZl2d2pbEmk=",
        originalBillingAccount: "000000000000021142900000",
      );
      // Handle success if needed
    } catch (e) {
      // Handle error
      debugPrint('Error writing to NFC: $e');
    }
  }

  // Method to read from NFC card using FawryNfc class
  Future<void> _readNFC() async {
    try {
      setState(() {
        printedMessage = "Please Put The Card To Scan";
      });
      await FawryNfcSdk.instance.readNFC(cardType: selectedCardType); // Use the selected card type
      // Handle success if needed
    } catch (e) {
      // Handle error
      debugPrint('Error reading from NFC: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 8.0),
            DropdownButton<CardType>(
              value: selectedCardType,
              onChanged: (newValue) {
                setState(() {
                  selectedCardType = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: CardType.ELECT,
                  child: Text('ELECTRICITY'),
                ),
                DropdownMenuItem(
                  value: CardType.GAS,
                  child: Text('GAS'),
                ),
                DropdownMenuItem(
                  value: CardType.WSC,
                  child: Text('WATER'),
                ),
              ],
            ),
            const Text(
              'Response Messages:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    printedMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16.0),
          FloatingActionButton.extended(
            onPressed: _readNFC,
            tooltip: 'Read from NFC',
            label: const Text('Scan Card'),
            icon: const Icon(Icons.pageview),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton.extended(
            onPressed: _writeNFC,
            tooltip: 'Write to NFC',
            label: const Text('Write on Card'),
            icon: const Icon(Icons.create),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
