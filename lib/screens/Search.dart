import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/widgets/ShowDayBook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:daybook/utils/utils.dart';

class Search extends StatefulWidget {
  User user;
  Size size;
  Search({@required this.user, @required this.size});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Map<String, dynamic>> databook = [];
  TextEditingController _textEditingController = TextEditingController();
  bool loading = false;
  getSearchResult(String text) {
    FirebaseFirestore.instance
        .collection("daybooks")
        .doc(widget.user.email)
        .collection(widget.user.uid)
        .orderBy('dayNote')
        .startAt([text])
        .snapshots()
        .listen((docs) {
          databook.clear();
          docs.docs.forEach((element) {
            print(element.id);
            setState(() {
              databook.add(element.data());
            });
          });
        });
    _textEditingController.text = "";
  }

  searchByDate(DateTime date) {
    // data.clear();
    FirebaseFirestore.instance
        .collection("daybooks")
        .doc(widget.user.email)
        .collection(widget.user.uid)
        .where('dateTime',
            isGreaterThanOrEqualTo: firebase.Timestamp.fromDate(date))
        .orderBy("dateTime", descending: true)
        .snapshots()
        .listen((docs) {
      databook.clear();
      docs.docs.forEach((element) {
        print(element.id);
        var mydata = element.data();
        print(mydata);
        if (mydata != null) {
          setState(() {
            databook.add(mydata);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: TextField(
            controller: _textEditingController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (text) {
              getSearchResult(text);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.black),
                onPressed: () async {
                  var date = DateTime.now();
                  var selectdate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(date.year - 5),
                      lastDate: date);
                  searchByDate(selectdate);
                })
          ],
        ),
        body: databook != null
            ? Container(
                height: widget.size.height,
                width: widget.size.width,
                child: ListView.builder(
                    itemCount: databook.length,
                    itemBuilder: (context, index) {
                      print(databook[0]['dateTime']);
                      final dayBook = databook[index];
                      return ShowDayBook(
                        size: widget.size,
                        dayBook: dayBook,
                      );
                    }),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
