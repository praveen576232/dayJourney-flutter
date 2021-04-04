import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/screens/Add_journal.dart';
import 'package:daybook/screens/DisplayDayBook.dart';
import 'package:daybook/screens/Profile.dart';
import 'package:daybook/screens/Search.dart';
import 'package:daybook/utils/converter.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/AnimatePageTransition.dart';
import 'package:daybook/widgets/CircleImage.dart';
import 'package:daybook/widgets/ShowDayBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<QuerySnapshot> _subscription;

  List<Map<String, dynamic>> data = [];
  int sizeDoc = 0;
  var user = ValueNotifier(FirebaseAuth.instance.currentUser);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subscription = FirebaseFirestore.instance
        .collection("daybooks")
        .doc(user.value.email)
        .collection(user.value.uid)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((docs) {
      data.clear();
      docs.docs.forEach((element) {
        var feachdata = element.data();
        feachdata['id'] = element.id;
        setState(() {
          sizeDoc = docs.size;
          data.add(feachdata);
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          title: Text("DayBook",
              style: TextStyle(
                  color: utils.appbartext,
                  fontWeight: FontWeight.bold,
                  fontSize: utils.appbartextsize)),
          actions: [
            IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Search(user: user.value, size: size)));
                }),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                    valueListenable: user,
                    builder: (context, currentUser, child) {
                      return CircleImageView(user: user.value);
                    }),
              ),
              onTap: () async {
                Navigator.push(
                        context,
                        AnimatedPageTransition(
                            screen: Profile(
                              user: user.value,
                              totleDocuments: sizeDoc,
                            ),
                            alignment: Alignment.topRight))
                    .then((updatedUser) {
                  if ((updatedUser.displayName != user.value.displayName) ||
                      (updatedUser.photoURL != user.value.photoURL)) {
                    user.value = updatedUser;
                  }
                });
              },
            )
          ]),
      body: Container(
          child: data != null && data.length > 0
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final dayBook = data[index];

                    return ShowDayBook(
                      size: size,
                      dayBook: dayBook,
                    );
                  })
              : Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton(
        backgroundColor: utils.floatingActionButton,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              AnimatedPageTransition(
                  screen: AddJournal(
                      currentDateTime: DateTime.now(),
                      selctedimages: [],
                      selectedTags: [],
                      text: null,
                      update: false,
                      id: null),
                  alignment: Alignment(0.8, 0.9)));
        },
      ),
    );
  }
}
