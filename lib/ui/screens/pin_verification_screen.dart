import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ruhul_ostab_project/ui/screens/change_password_screen.dart';
import 'package:ruhul_ostab_project/ui/screens/sign_in_screen.dart';
import 'package:ruhul_ostab_project/ui/widgets/screen_background.dart';

import '../../data/service/network_caller.dart';
import '../../data/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import 'forgot_password_email_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, this.emailid, this.otpcode});
  final String? emailid;
  final String? otpcode;


  static const String name = '/pin-verification';
  static String? otp;
  static String? email;



  @override
  State<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? email ="";
  late String? otp ="";

  bool _pinverityProgress =false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PinVerificationScreen.email='${widget.emailid}';
    PinVerificationScreen.otp='${widget.otpcode}';
  }


  @override
  Widget build(BuildContext context) {
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
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP has been sent to your email address',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                        color: Colors.grey
                    ),
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(

                    length: 6,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        selectedColor: Colors.green,
                        inactiveColor: Colors.grey
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _otpTEController,
                    validator: (String? value) {
                      String otpv = value ?? '';
                      if (otpv.length<6){
                        return 'Enter a valid 6 digit pin';
                      }
                      else
                      {
                        PinVerificationScreen.otp = otpv.toString();
                        return null;
                      }
                    },
                    appContext: context,
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _pinverityProgress==false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Text('Verify'),
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
      _pinverity();

    }



  }

  Future<void> _pinverity() async {
    _pinverityProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.RecoverVerifyOtpEmail(ForgotPasswordEmailScreen.emailid ,_otpTEController.text)
    );

    if (response.isSuccess) {
      _pinverityProgress = false;
      setState(() {});
      Navigator.pushNamed(context, ChangePasswordScreen.name);

    } else {
      _pinverityProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage!);
    }

  }





  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.name, (predicate) => false);
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}