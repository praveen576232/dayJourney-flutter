import 'package:daybook/services/Auth/authentication_service.dart';
import 'package:daybook/utils/converter.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/ProfileImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  User user;
  int totleDocuments;

  Profile({@required this.user, @required this.totleDocuments});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _textEditingController;

  var readOnly = ValueNotifier(true);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    String intialdata =
        widget.user.displayName != null && widget.user.displayName.trim() != ""
            ? widget.user.displayName
            : widget.user.email.split("@")[0];

    _textEditingController.text = intialdata;
  }

  Converter converter = Converter();
  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.user);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: utils.appbgcolor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context, widget.user);
                }),
            actions: [
              FlatButton(
                  onPressed: () async {
                    await context.read<AuthenticationService>().signout();
                    Navigator.pop(context);
                  },
                  child: Text("Sign out", style: TextStyle(color: Colors.red)))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Container(
              width: size.width,
              height: size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImage(
                      user: widget.user,
                      updateUser: (updateduser) {
                        widget.user = updateduser;
                      },
                    ),
                    Container(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: readOnly,
                                builder: (context, read, child) {
                                  return Center(
                                    child: Container(
                                      width: size.width - 100,
                                      child: TextField(
                                        controller: _textEditingController,
                                        keyboardType: TextInputType.name,
                                        textAlign: TextAlign.center,
                                        textInputAction: TextInputAction.done,
                                        readOnly: read,
                                        autofocus: read,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(0.0),
                                            border: InputBorder.none),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 35),
                                        onSubmitted: (myname) {
                                         if(myname!=null && myname.trim()!=""){
                                            widget.user
                                              .updateProfile(displayName: myname);
                                          setState(() {
                                            widget.user = FirebaseAuth
                                                .instance.currentUser;
                                          });
                                         }
                                        },
                                      ),
                                    ),
                                  );
                                }),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  readOnly.value = !readOnly.value;
                                })
                          ],
                        ),
                      ),
                    ),
                    Text(widget.user.email,
                        style: TextStyle(color: Colors.grey)),
                    Text(
                        "craete account at " +
                            widget.user.metadata.creationTime.day.toString() +
                            " " +
                            converter.convertNumberToMonthName(
                                widget.user.metadata.creationTime.month),
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(height: size.height * 0.15),
                    Text("Number of Daybook added",
                        style: TextStyle(fontSize: 20)),
                    Text(widget.totleDocuments.toString(),
                        style: TextStyle(fontSize: 60))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
