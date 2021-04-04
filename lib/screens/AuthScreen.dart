import 'package:daybook/services/Auth/authentication_service.dart';
import 'package:daybook/utils/custome_icon_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _textEditingControllerEmail;
  TextEditingController _textEditingControllerPassword;
  TextEditingController _textEditingControllerUsername;

  bool signin = true;
  @override
  void initState() {
    // TODO: implement initState
    _textEditingControllerEmail = TextEditingController();
    _textEditingControllerPassword = TextEditingController();
    _textEditingControllerUsername = TextEditingController();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
        child: Scaffold(
      body: Center(
            child: Container(
        height: size.height / 1.8+ (signin ? 0 : 150),
        width: size.width * 0.85,
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 25.0,
              spreadRadius: 5.0,
              offset: Offset(
                15.0,
                15.0,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: this._formKey,
            child: Column(
              children: [
                Text(signin ? "Sign In" : "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 30),
                !signin
                    ? TextFormField(
                        controller: _textEditingControllerUsername,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CustomeIcon.user),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              borderSide: BorderSide(
                                  color: Colors.red, width: 5.0),
                            ),
                            hintText: "UserName",

                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (username) {
                          if (!signin && username.trim() == "") {
                            return "please enter username";
                          }
                        },
                      )
                    : Offstage(),
                !signin ? SizedBox(height: 20) : Offstage(),
                TextFormField(
                  controller: _textEditingControllerEmail,
                  decoration: InputDecoration(
                    
                      prefixIcon: Icon(CustomeIcon.mail_alt),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        borderSide:
                            BorderSide(color: Colors.black, width: 5.0),
                      ),
                      hintText: "Email",
                       hintStyle: TextStyle(color: Colors.grey)),
                  validator: (email) {
                    if (email.trim() == "" ||
                        !email.endsWith("@gmail.com")) {
                      return "please enter a valid email address";
                    }
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: _textEditingControllerPassword,
                  decoration: InputDecoration(
                      prefixIcon: Icon(CustomeIcon.key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide:
                            BorderSide(color: Colors.black, width: 5.0),
                      ),
                      hintText: "password",
                       hintStyle: TextStyle(color: Colors.grey)),
                  validator: (pass) {
                    if (pass.trim() == "" || pass.length < 6) {
                      return "password length must be greater than 6";
                    }
                  },
                ),
                SizedBox(height: 20),
                Container(
                  width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                  color:Colors.purple.shade500,
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: OutlineButton(
                    highlightColor: Colors.purple.shade50,
                    color: Colors.purple,
                    focusColor: Colors.purpleAccent,
                    borderSide:
                        BorderSide.none,
                    
                    onPressed: () async {
                      if (signin) {
                        if (this._formKey.currentState.validate()) {
                          await context
                              .read<AuthenticationService>()
                              .signIn(
                                  _textEditingControllerEmail.text,
                                  _textEditingControllerPassword.text,
                                  _textEditingControllerUsername.text);
                        }
                      } else {
                        if (this._formKey.currentState.validate()) {
                          await context
                              .read<AuthenticationService>()
                              .signup(_textEditingControllerEmail.text,
                                  _textEditingControllerPassword.text);
                        }
                      }
                    },
                    child: Text(signin ? "Sign In" : "Sign Up",
                        style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold)),
                  ),
                ),
                Text("or",style: TextStyle(color: Colors.grey)),
                // ignore: deprecated_member_use
                Container(
                   width: size.width,
                  height: 50,
                  decoration: BoxDecoration(
                  color:Colors.black,
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: OutlineButton(
                    borderSide: BorderSide.none,
                      onPressed: () async {
                        await context
                            .read<AuthenticationService>()
                            .signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(CustomeIcon.google,color: Colors.red),
                          
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Text("Google SignIn",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold)),
                          )
                        ],
                      )),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: signin
                        ? "Don't hav a account ?  "
                        : "Alerdy hav account ",
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: signin ? 'Sign Up' : 'Sign up',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                signin = !signin;
                              });
                            }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ))),
    ));
  }
}
