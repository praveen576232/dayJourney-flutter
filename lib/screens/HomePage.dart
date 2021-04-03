import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/screens/Add_journal.dart';
import 'package:daybook/screens/DisplayDayBook.dart';
import 'package:daybook/screens/Search.dart';
import 'package:daybook/utils/converter.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/ShowDayBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({@required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<QuerySnapshot> _subscription;

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _subscription = FirebaseFirestore.instance
        .collection("daybooks")
        .doc(widget.user.email)
        .collection(widget.user.uid)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((docs) {
      data.clear();
      docs.docs.forEach((element) {
        var feachdata = element.data();
        feachdata['id'] = element.id;
        setState(() {
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
                              Search(user: widget.user, size: size)));
                }),
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreenAccent,
                ),
                child: widget.user.photoURL != null
                    ? Image.network(widget.user.photoURL)
                    : Center(
                  child: Text(widget.user.email[0],
                          style: TextStyle(
                            fontSize: 25,
                              color: Colors.white, fontWeight: FontWeight.bold)),
                ))
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
              MaterialPageRoute(
                  builder: (context) => AddJournal(
                      currentDateTime: DateTime.now(),
                      selctedimages: [],
                      selectedTags: [],
                      text: null,
                      update: false,
                      id: null)));
        },
      ),
    );
  }
}
