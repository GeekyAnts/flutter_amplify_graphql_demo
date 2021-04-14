import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/amplifyconfiguration.dart';

class AmplifyService {
  static configureAmplify() async {
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAPI apiPlugin = AmplifyAPI();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    // AmplifyStorageS3 amplifyStorageS3 = AmplifyStorageS3();
    Amplify.addPlugins([
      // amplifyStorageS3,
      authPlugin,
      apiPlugin,
    ]);

    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(
          "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }
}
