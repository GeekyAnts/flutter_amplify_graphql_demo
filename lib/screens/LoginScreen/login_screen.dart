import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/components/get_name_bottom_sheet.dart';
import 'package:flutter_amplify_demo/components/google_login_button.dart';
import 'package:flutter_amplify_demo/components/login_text_field.dart';
import 'package:flutter_amplify_demo/components/primary_button.dart';
import 'package:flutter_amplify_demo/components/show_snackbar.dart';
import 'package:flutter_amplify_demo/notifiers/login_with_email_password_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/login_with_google_notifier.dart';
import 'package:flutter_amplify_demo/notifiers/providers.dart';
import 'package:flutter_amplify_demo/routes/routes_path.dart';
import 'package:flutter_amplify_demo/services/get_it_service.dart';
import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:flutter_amplify_demo/services/text_style.dart';
import 'package:flutter_amplify_demo/services/validations.dart';
import 'package:flutter_amplify_demo/theme/colors.dart';
import 'package:flutter_amplify_demo/services/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NavigationService _navigationService =
      get_it_instance_const<NavigationService>();

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 80.toHeight),
                Text(
                  "Let's sign you in.",
                  style: CustomTextStyle.loginTitleStyle,
                ),
                SizedBox(height: 10.toHeight),
                Text(
                  "Welcome back.",
                  style: CustomTextStyle.loginTitleSecondaryStyle,
                ),
                Text(
                  "You've been missed!",
                  style: CustomTextStyle.loginTitleSecondaryStyle,
                ),
                buildEmailLoginForm(),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 20.toHeight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: CustomTextStyle.registerButtonStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigationService.popAllAndReplace(RoutePath.Register);
                      },
                      child: Text(
                        "Register. 😁",
                        style: CustomTextStyle.registerButtonStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.toHeight),
                ProviderListener(
                  onChange: (context, state) async {
                    if (state is LoginWithGoogleSuccess) {
                      bool hasUserName = await context
                          .read(authRepositoryProvider)
                          .hasUsername();
                      if (!hasUserName) {
                        getNameBottomSheet(context);
                      } else {
                        _navigationService.popAllAndReplace(RoutePath.Home);
                      }
                    }
                  },
                  provider: loginWithGoogleProvider.state,
                  child: Consumer(builder: (_, watch, __) {
                    final state = watch(loginWithEmailNotifierProvider.state);
                    if (state is LoginWithGoogleLoading)
                      return Center(child: CircularProgressIndicator());
                    else if (state is LoginWithGoogleInitial)
                      return GoogleButton();
                    return GoogleButton();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Form buildEmailLoginForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 45.toHeight),
          CustomLoginTextField(
            hintTextL: "Email",
            ctrl: emailCtrl,
            validation: Validations.validateEmail,
            type: TextInputType.emailAddress,
          ),
          SizedBox(height: 24.toHeight),
          CustomLoginTextField(
            hintTextL: "Password",
            ctrl: passwordCtrl,
            validation: Validations.valdiatePassword,
            obscureText: true,
            type: TextInputType.text,
          ),
          SizedBox(height: 24.toHeight),
          ProviderListener<LoginWithEmailState>(
            provider: loginWithEmailNotifierProvider.state,
            onChange: (context, state) {
              if (state is LoginWithEmailSuccess) {
                _navigationService.popAllAndReplace(RoutePath.Home);
              } else if (state is LoginWithEmailError) {
                showSnackBar(context, state.error);
              }
            },
            child: Consumer(builder: (_, watch, __) {
              final state = watch(loginWithEmailNotifierProvider.state);
              if (state is LoginWithEmailInitial)
                return buildButton();
              else if (state is LoginWithEmailLoading)
                return Center(child: CircularProgressIndicator());
              return buildButton();
            }),
          )
        ],
      ),
    );
  }

  PrimaryButton buildButton() {
    return PrimaryButton(
      text: "Log in",
      onPress: () async {
        if (!formKey.currentState.validate()) return;
        context.read(loginWithEmailNotifierProvider).login(
              emailCtrl.text,
              passwordCtrl.text,
            );
      },
    );
  }
}
