
import 'package:daybook/services/Auth/authentication_service.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
        child: Scaffold(
      body: Center(
          child: Container(
              height: size.height / 2,
              width: size.width * 0.85,
              decoration: new BoxDecoration(
                color: Colors.white, //background color of box
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 25.0, // soften the shadow
                    spreadRadius: 5.0, //extend the shadow
                    offset: Offset(
                      15.0, // Move to right 10  horizontally
                      15.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(signin ? "Sign In" : "Sign Up"),
                    SizedBox(height: 30),
                    !signin
                        ? TextField(
                               controller: _textEditingControllerUsername,
                          
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5.0),
                                ),
                                hintText: "UserName",
                                hintStyle: TextStyle(color: Colors.red)),
                          )
                        : Offstage(),
                    !signin ? SizedBox(height: 20) : Offstage(),
                    TextField(
                      controller: _textEditingControllerEmail,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5.0),
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.red)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _textEditingControllerPassword,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5.0),
                          ),
                          hintText: "password",
                          hintStyle: TextStyle(color: Colors.red)),
                    ),
                    FlatButton(
                      color: Colors.purple,
                      onPressed: () async {
                        if(signin){

                        var name = await context
                            .read<AuthenticationService>()
                            .signIn(_textEditingControllerEmail.text,
                                _textEditingControllerPassword.text,
                                _textEditingControllerUsername.text
                                );
                        }else{
                          var name = await context
                            .read<AuthenticationService>()
                            .signup(_textEditingControllerEmail.text,
                                _textEditingControllerPassword.text);
                        }
                      
                      },
                      child: Text(signin ? "sign in" : "Sign up",
                          style: TextStyle(color: Colors.red)),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: signin
                            ? "Don't hav a account "
                            : "Alerdy hav acount",
                        style: TextStyle(color: Colors.red),
                        children: <TextSpan>[
                          TextSpan(
                              text: signin ? 'Sign Up?' : 'Sign up',
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
              ))),
    ));
  }
}
