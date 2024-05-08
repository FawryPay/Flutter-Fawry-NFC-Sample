
## Fawry NFC SDK Documentation

### Overview

The Fawry NFC SDK allows developers to integrate Fawry's NFC capabilities into their Flutter applications seamlessly. This SDK facilitates tasks such as reading and writing to NFC cards, with a focus on utility bill payments like electricity, gas, and water.

### Features

1. **Read NFC Card**: Enables scanning NFC cards to retrieve relevant information.
2. **Write to NFC Card**: Allows encoding data onto NFC cards for various purposes.

### Prerequisites

Before using the Fawry NFC SDK, ensure the following prerequisites are met:

- Flutter development environment is set up.
- Fawry NFC SDK is successfully integrated into your project.

To integrate the SDK, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  fawry_nfc_sdk: ^version_number
```

Replace `^version_number` with the latest version of the Fawry NFC SDK.

### Android Setup

To integrate with Android, update the minimum SDK version to 21 or higher in your `build.gradle` file:

```groovy
android {
    compileSdkVersion flutter.compileSdkVersion
    minSdkVersion 21
    // ...
}
```

In your `build.gradle`, add the following code to the `buildscript` and `allprojects` blocks:

```groovy
repositories {
    google()   
    mavenCentral()
    maven { 
        url 'YOU WILL RECEIVE THIS FROM FAWRY SUPPORT ALONG WITH CREDENTIALS' 
            credentials {
                username = "YOU WILL RECEIVE THIS FROM FAWRY SUPPORT"
                password = "YOU WILL RECEIVE THIS FROM FAWRY SUPPORT"
            }
    }
}
```

### iOS Setup

As of the current version, the Fawry NFC SDK does not support iOS. However, the development team is actively working on extending compatibility to iOS devices in future updates.


### Usage

1. **Initialize SDK Callback**

   Create an `initSDKCallback()` function to initialize the callback mechanism to receive responses from the Fawry NFC SDK. It sets up a stream listener to handle callback results.

   ```dart
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
          token: 'YOUR TOKEN',
          secretKey: 'YOUR SECRET KEY',
        );
      } catch (ex) {
        debugPrint(ex.toString());
      }
    }
   ```

2. **Handle Responses**

   Create a `handleResponse()` function to process responses received from the Fawry NFC SDK. It can -for example -log the response details and updates the UI with the response message.

   ```dart
   void handleResponse(ResponseStatus response) {
     debugPrint(
         '======== Response ========\n$response\n===========================');

     setState(() {
       printedMessage +=
           '\n===========================\n======== Response ========\n$response';
     });
   }
   ```

   Access any response properties as needed. The `ResponseStatus` class contains the status of a response from the Fawry NFC SDK, including:
   - `status`: Indicates the response status.
   - `message`: Provides additional information about the response.
   - `data`: Includes the data returned from the card.

3. **Select Card Type**

   Choose a card type for scanning or writing. For example:

   ```dart
   CardType selectedCardType = CardType.ELECT;
   ```

   Available card types are:

   ```dart
    CardType.WSC // WATER CARDS
    CardType.ELECT // ELECTRICITY CARDS
    CardType.GAS // GAS CARDS
   ```

4. **Read from NFC Card**

   Use the `_readNFC()` function to start scanning an NFC card. This function prompts the Fawry NFC SDK to retrieve data from the NFC card when the "Scan Card" action is triggered.

   ```dart
   Future<void> _readNFC() async {
     try {
      setState(() {
        printedMessage = "Please Put The Card To Scan";
      });
       await FawryNfcSdk.instance.readNFC(cardType: selectedCardType);
     } catch (e) {
       debugPrint('Error reading from NFC: $e');
     }
   }
   ```

5. **Write to NFC Card**

   Utilize the `_writeNFC()` function to encode data onto an NFC card. This function is triggered by pressing the "Write on Card" action, and it encodes the provided information onto the NFC card.

   ```dart
   Future<void> _writeNFC() async {
     try {
       setState(() {
         printedMessage = "Please Put The Card To Write";
       });

       await FawryNfcSdk.instance.writeNFC(
         cardType: selectedCardType, 
         billEncryptInfoECMC: "<billEncryptInfoECMC>",
         cardMetaData: "<cardMetaData>",
         originalBillingAccount: "<originalBillingAccount>",
       );
     } catch (e) {
       debugPrint('Error writing to NFC: $e');
     }
   }
   ```

### Additional Resources

You can explore a sample Flutter application that utilizes the Fawry NFC SDK on GitHub. This sample app provides examples and demonstrations of various functionalities offered by the SDK. You can find the sample app at the following repository:

[Flutter Fawry NFC Sample](https://github.com/FawryPay/Flutter-Fawry-NFC-Sample)

Feel free to explore the sample app to understand how to integrate and utilize the Fawry NFC SDK effectively in your Flutter projects.