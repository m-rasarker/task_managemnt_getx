import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ruhul_ostab_project/ui/controllers/change_password_controller.dart';
import 'package:ruhul_ostab_project/ui/screens/sign_in_screen.dart';
import 'package:ruhul_ostab_project/ui/widgets/screen_background.dart';
import 'package:get/get.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, this.emailid, this.otpcode});
  final String? emailid;
  final String? otpcode;


  static const String name = '/change-password';
  static String? email;
  static String? otpCode;


  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ChangePasswordController _changePasswordController = Get.find<ChangePasswordController>();
  late String? email;
  late String? otpCode;
  bool _changePasswordProgress=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

     email = args['emailid'];
    otpCode = args['otpcode'];

  //  print(email.toString() + '  ' +  otpCode.toString());

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Password should be more than 6 letters.',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                        hintText: 'Password'
                    ),
                    validator: (String? value) {
                      if ((value?.length ?? 0) <= 6) {
                        return 'Enter a valid password';
                      }
                      ChangePasswordScreen.email=email.toString();
                      ChangePasswordScreen.otpCode=otpCode;

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password'
                    ),
                    validator: (String? value) {
                      if ((value ?? '') != _passwordTEController.text) {
                        return "Confirm password doesn't match";
                      }
                      ChangePasswordScreen.email=email.toString();
                      ChangePasswordScreen.otpCode=otpCode;

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _changePasswordProgress==false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Text('Confirm'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                            recognizer:
                            TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _changePassword();


    }
  }




  Future<void> _changePassword() async {
    final bool isSuccess = await _changePasswordController.ChangePassword('$email', '$otpCode', _confirmPasswordTEController.text.trim());

    // Map<String, String> requestBody = {
    //   "email": ChangePasswordScreen.email.toString(),
    //   "OTP": ChangePasswordScreen.otpCode.toString(),
    //   "password":_confirmPasswordTEController.text.toString()
    // };


    Map<String, String> requestBody = {
      "email": email.toString(),
      "OTP": otpCode.toString(),
      "password":_confirmPasswordTEController.text.toString()
    };


    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.RecoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      if(mounted) {
        showSnackBarMessage(context, "Password Changed Successfully");
      }
      Navigator.pushReplacementNamed(context, SignInScreen.name);
    } else {
      if (mounted)
      {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
  }




  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.name, (predicate) => false);
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}