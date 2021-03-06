import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email = '';
  String password = '';

  void onEmailChange() {
    setState(() {
      email = emailController.text;
    });
  }

  void onPasswordChange() {
    setState(() {
      password = passwordController.text;
    });
  }

  void onSubmitLogin() {
    // make HTTP request with email, password and pass name to profile
    print(this.email);
    print(this.password);
    Navigator.popAndPushNamed(context, '/profile', arguments: this.email);
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(onEmailChange);
    passwordController.addListener(onPasswordChange);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.red[900],
              Colors.red[300],
              Colors.red[100],
            ],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400],
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: 130,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: FlatButton(
                            onPressed: onSubmitLogin,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 18,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.popAndPushNamed(
                                          context, '/register');
                                    },
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ), //
      ),
    );
  }
}
