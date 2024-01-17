import 'package:deadline/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final _userKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();

  final _passKey = GlobalKey<FormState>();

  Widget _form(
    String label,
    Key fk,
    TextEditingController controller,
    bool pass,
  ) {
    return Form(
        key: fk,
        child: TextFormField(
          obscureText: pass,
          controller: controller,
          decoration: InputDecoration(labelText: label),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter something';
            }
            return null;
          },
        ));
  }

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUser = TextEditingController();

  Future<void> createUser() async {
    try {
      await Auth().registerUser(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        username: _controllerUser.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        print(errorMessage);
      });
    }
  }

  Widget _title() {
    return const Text('Deadline');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: title),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'hmmm ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_userKey.currentState!.validate() &&
            _emailKey.currentState!.validate() &&
            _passKey.currentState!.validate()) {
          createUser();
        } else {
          print('failed');
        }
      },
      child: const Text('Register'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Color(0xff63f0b3),
                Color(0xff15d281),
                Color(0xff13bf75),
                Color(0xff10a263),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset(
                'images/Deadline.svg',
                semanticsLabel: 'Logo',
                height: 400,
                width: 400,
              ),
              // _entryField('username', _controllerUser),
              _form('username', _userKey, _controllerUser, false),
              _form('email', _emailKey, _controllerEmail, false),
              _form('password', _passKey, _controllerPassword, true),
              const SizedBox(height: 100),
              _submitButton(),
            ],
          )),
    );
  }
}
