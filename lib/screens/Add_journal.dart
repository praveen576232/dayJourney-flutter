import 'dart:io';
import 'package:daybook/services/database/database.dart';
import 'package:daybook/utils/converter.dart';
import 'package:daybook/utils/utils.dart';
import 'package:daybook/widgets/SelectImage.dart';
import 'package:daybook/widgets/Tags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddJournal extends StatefulWidget {
  var selctedimages;
  DateTime currentDateTime;
  List<String> selectedTags = [];
  String text;
  bool update;
  String id;
  AddJournal(
      {this.selctedimages,
      this.selectedTags,
      this.currentDateTime,
      this.text,
      this.update,
      this.id});
  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  Converter converter = Converter();

  List<String> tempselectedTags = [];

  TextEditingController _textEditingController = TextEditingController();
  bool loading = false;
  List<String> nowSelectedImages = [];
  User user;
  var dateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    dateTime = ValueNotifier(widget.currentDateTime);
    if (widget.text != null && widget.text.trim() != "") {
      _textEditingController.text = widget.text;
    }
  }

  var data = null;
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  var text = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          leading: Opacity(
            opacity: loading ? 0.5 : 1,
            child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: !loading
                    ? () {
                        Navigator.pop(context);
                      }
                    : null),
          ),
          actions: [
            Opacity(
              opacity: loading ? 0.5 : 1,
              child: IconButton(
                  icon: Icon(Icons.tag_faces, color: Colors.black),
                  onPressed: !loading
                      ? () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Add Tag"),
                                  content: Container(
                                    width: 100,
                                    child: Tags(
                                      tags: widget.selectedTags,
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok"))
                                  ],
                                );
                              });
                        }
                      : null),
            ),
            Opacity(
              opacity: loading ? 0.5 : 1,
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: !loading
                      ? () {
                          Navigator.pop(context);
                        }
                      : null),
            ),
          ],
        ),
        body: Container(
            child: Stack(
          children: [
            Opacity(
              opacity: loading ? 0.5 : 1,
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 15),
                            child: Row(children: [
                              ValueListenableBuilder(
                                  valueListenable: dateTime,
                                  builder: (context, time, child) {
                                    return Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          RichText(
                                            text: TextSpan(
                                              text: time?.day.toString() + " ",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: time != null
                                                      ? converter
                                                          .convertNumberToMonthName(
                                                              time?.month)
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                              time?.year.toString() +
                                                  " " +
                                                  converter
                                                      .convertNumberToWeekDayName(
                                                          time?.weekday),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13.0))
                                        ]));
                                  }),
                              IconButton(
                                  icon: Icon(Icons.calendar_today,
                                      color: Colors.grey),
                                  onPressed: !loading
                                      ? () async {
                                          var selecteddate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: dateTime.value,
                                                  firstDate: DateTime(
                                                      dateTime.value.year - 5),
                                                  lastDate: dateTime.value);

                                          if (selecteddate != null &&
                                              selecteddate != dateTime.value) {
                                            dateTime.value = DateTime(
                                                selecteddate.year,
                                                selecteddate.month,
                                                selecteddate.day,
                                                dateTime.value.hour,
                                                dateTime.value.minute);
                                          }
                                        }
                                      : null)
                            ])),
                        Container(
                            child: Row(
                          children: [
                            ValueListenableBuilder(
                                valueListenable: dateTime,
                                builder: (context, time, child) {
                                  return Text(
                                    converter.convert24To12(
                                        time.hour, time.minute),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                }),
                            IconButton(
                                icon:
                                    Icon(Icons.lock_clock, color: Colors.grey),
                                onPressed: !loading
                                    ? () async {
                                        var selectedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now());
                                        if (selectedTime != null &&
                                            !(dateTime.value.hour ==
                                                    selectedTime.hour &&
                                                dateTime.value.minute ==
                                                    selectedTime.minute)) {
                                          dateTime.value = DateTime(
                                              dateTime.value.year,
                                              dateTime.value.month,
                                              dateTime.value.day,
                                              selectedTime.hour,
                                              selectedTime.minute);
                                        }
                                      }
                                    : null)
                          ],
                        )),
                      ]),
                  Container(
                    height: 100,
                    child: (widget.selctedimages != null &&
                                widget.selctedimages.isNotEmpty) ||
                            (nowSelectedImages.length > 0)
                        ? showselectedImages()
                        : InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 65,
                                width: 75,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                            ),
                            onTap: !loading
                                ? () async {
                                    var images = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SelectImage(
                                                  selectOnlyOneImage: false,
                                                )));
                                    if (images != null && images.length> 0) {
                                      setState(() {
                                        nowSelectedImages.addAll(images);
                                      });
                                    }
                                  }
                                : null,
                          ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textEditingController,
                      readOnly: loading ? true : false,
                      textAlign: TextAlign.justify,
                      cursorColor: Colors.red,
                      onChanged: (value) {
                        text.value = value;
                      },
                      decoration: InputDecoration(
                          hintText: "Write here", border: InputBorder.none),
                      maxLines: null,
                    ),
                  )),
                ],
              ),
            ),
            loading ? Center(child: CircularProgressIndicator()) : Offstage()
          ],
        )),
        bottomNavigationBar: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[400]))),
            child: ValueListenableBuilder(
                valueListenable: text,
                builder: (context, textfiled, child) {
                  return RaisedButton(
                      color: utils.uploadButtonColor,
                      child: Text(widget.update ? "Update" : "Upload",
                          style: TextStyle(
                              color: utils.uploadButtonTextColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.0,
                              fontSize: 20)),
                      onPressed: !loading && widget.update ||
                              (textfiled != null && textfiled.trim() != "")
                          ? () async {
                              setState(() {
                                loading = true;
                              });
                              if (widget.update) {
                                await updateDayBook(
                                    context,
                                    user,
                                    widget.id,
                                    _textEditingController.text,
                                    dateTime.value,
                                    widget.selectedTags,
                                    widget.selctedimages,
                                    nowSelectedImages,
                                    loading);
                              } else {
                                await uploadDayBook(
                                    nowSelectedImages,
                                    context,
                                    user,
                                    widget.selectedTags,
                                    dateTime.value,
                                    _textEditingController.text,
                                    loading);
                              }
                            }
                          : null);
                })));
  }

  showselectedImages() {
    return ListView.builder(
      shrinkWrap: true,
      reverse: false,
      scrollDirection: Axis.horizontal,
      itemCount:
          (widget.selctedimages != null ? widget.selctedimages.length : 0) +
              nowSelectedImages.length +
              1,
      itemBuilder: (context, index) {
        Map<String, String> netwotkimage;
        if (widget.update &&
            widget.selctedimages != null &&
            widget.selctedimages.length > index) {
          netwotkimage = Map.from(widget.selctedimages[index]);
        }

        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: index ==
                    ((widget.selctedimages != null
                            ? widget.selctedimages.length
                            : 0) +
                        nowSelectedImages.length)
                ? InkWell(
                    child: Container(
                      height: 70,
                      width: 75,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Icon(Icons.add, color: Colors.black),
                    ),
                    onTap: !loading
                        ? () async {
                            var images = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectImage(
                                          selectOnlyOneImage: false,
                                        )));
                            setState(() {
                              nowSelectedImages.addAll(images);
                            });
                          }
                        : null,
                  )
                : Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        child: widget.update &&
                                widget.selctedimages != null &&
                                widget.selctedimages.length > index
                            ? Image.network(
                                netwotkimage['url'],
                                fit: BoxFit.cover,
                              )
                            : nowSelectedImages != null &&
                                    nowSelectedImages.length > 0
                                ? Image.file(
                                    File(widget.update
                                        ? nowSelectedImages[index -
                                            (widget.selctedimages != null
                                                ? widget.selctedimages.length
                                                : 0)]
                                        : nowSelectedImages[index]),
                                    fit: BoxFit.cover,
                                  )
                                : Offstage(),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            child: Container(
                              height: 15,
                              width: 15,
                              color: Colors.black.withOpacity(0.6),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.close,
                                      size: 15, color: Colors.red)),
                            ),
                            onTap: !loading
                                ? () {
                                    if (widget.update &&
                                        widget.selctedimages.length > index) {
                                      setState(() {
                                        widget.selctedimages.remove(
                                            widget.selctedimages[index]);
                                      });
                                    } else if (widget.update) {
                                      setState(() {
                                        nowSelectedImages.remove(
                                            nowSelectedImages[index -
                                                widget.selctedimages.length]);
                                      });
                                    } else {
                                      setState(() {
                                        nowSelectedImages
                                            .remove(nowSelectedImages[index]);
                                      });
                                    }
                                  }
                                : null,
                          ))
                    ],
                  ));
      },
    );
  }
}
