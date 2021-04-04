import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/utils/custome_icon_icons.dart';
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
    if (utils.tags.contains(text)) {
      FirebaseFirestore.instance
          .collection("daybooks")
          .doc(widget.user.email)
          .collection(widget.user.uid)
          .where('tags', arrayContains: text)
          .orderBy('dateTime')
          .snapshots()
          .listen((docs) {
        databook.clear();
        docs.docs.forEach((element) {
          var feachdata = element.data();
          feachdata['id'] = element.id;
          setState(() {
            databook.add(feachdata);
          });
        });
      });
      _textEditingController.text = "";
    } else {
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
              var feachdata = element.data();
              feachdata['id'] = element.id;
              setState(() {
                databook.add(feachdata);
              });
            });
          });
      _textEditingController.text = "";
    }
  }

  searchByDate(DateTime date) {
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
        var feachdata = element.data();
        feachdata['id'] = element.id;

        if (feachdata != null) {
          setState(() {
            databook.add(feachdata);
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
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Search by Text/Tag"),
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (text) {
              getSearchResult(text);
            },
          ),
          actions: [
            IconButton(
                icon: Icon(CustomeIcon.calendar, color: Colors.grey),
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
