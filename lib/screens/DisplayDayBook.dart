import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daybook/screens/Add_journal.dart';
import 'package:daybook/utils/converter.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/carousel/carousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayDayBook extends StatelessWidget {
  var images;
  var tags;
  DateTime dateTime;
  String text;
  String id;

  DisplayDayBook({
    @required this.images,
    @required this.tags,
    @required this.dateTime,
    @required this.id,
    @required this.text,
  });

  Widget displayTag(String tagName) {
    return Container(
        padding: EdgeInsets.all(8.0),
        height: 30,
        decoration: BoxDecoration(
            color: utils.tagbgColor,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Text(tagName, style: TextStyle(color: utils.tagTextColor)));
  }

  Widget header() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: dateTime?.day.toString() + " ",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: dateTime != null
                          ? converter.convertNumberToMonthName(dateTime?.month)
                          : "",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Text(
                "  " +
                    dateTime.year.toString() +
                    " " +
                    converter.convertNumberToWeekDayName(dateTime.weekday),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
        Text(converter.convert24To12(dateTime.hour, dateTime.minute),
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ))
      ],
    ));
  }

  Converter converter = Converter();
  List<Widget> getImage(Size size, var _images) {
    List<Widget> widgets = [];

    for (var item in _images) {
      widgets.add(Image.network(Map.from(item)['url']));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          title: header(),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black)),
          actions: [
            IconButton(
                icon: Icon(Icons.mode_edit, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddJournal(
                              currentDateTime: dateTime,
                              selctedimages:
                                  images != null ? List.from(images) : null,
                              selectedTags:
                                  tags != null ? List.from(tags) : null,
                              text: text,
                              update: true,
                              id: id)));
                }),
            IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text('Do you what to delete permanently?'),
                          actions: [
                            FlatButton(
                                onPressed: () async {
                                  User user = FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    FirebaseFirestore.instance
                                        .collection("daybooks")
                                        .doc(user.email)
                                        .collection(user.uid)
                                        .doc(id)
                                        .delete()
                                        .whenComplete(() {
                                      int count = 0;
                                      Navigator.of(context)
                                          .popUntil((_) => count++ >= 2);
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('yes')),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('cancel')),
                          ],
                        );
                      });
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              width: size.width,
              padding: EdgeInsets.only(top: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  tags != null
                      ? Container(
                          child: Wrap(
                          spacing: 5.0,
                          children: List.from(tags)
                              .map((tag) => displayTag(tag))
                              .toList(),
                        ))
                      : Offstage(),
                  images != null && images.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                          child: Carousel(
                            items: getImage(size, images),
                            autoScroll: true,
                            indicatorBarColor: Colors.black45.withOpacity(0.5),
                            autoScrollDuration: Duration(seconds: 1),
                          ),
                        )
                      : Offstage(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              )),
        ));
  }
}
