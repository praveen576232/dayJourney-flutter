import 'dart:io';
import 'package:daybook/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectImage extends StatefulWidget {
  MethodChannel _methodChannel;
  SelectImage(this._methodChannel);

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  List<String> selectedImages = [];

  Future<List<String>> getAllImages() async {
    var images = await widget._methodChannel.invokeMethod("images");

    List<String> data = images.cast<String>();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          title: Text(selectedImages?.length.toString() + " Image Selected",
              style: TextStyle(color: Colors.black)),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, selectedImages);
                },
                child: Text("select", style: TextStyle(color: Colors.black)))
          ],
        ),
        body: FutureBuilder(
            future: getAllImages(),
            builder: (context, snapshot) {
              // if (snapshot.hasError) {
              //   return Container(child: Text("error"));
              // }
              return snapshot.hasData
                  ? GridView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            child: Container(
                                height: 100,
                                width: 100,
                                child: Image.file(
                                  File(snapshot.data[index]),
                                  fit: BoxFit.cover,
                                  color: selectedImages
                                          .contains(snapshot.data[index])
                                      ? Colors.black.withOpacity(0.5)
                                      : Colors.transparent,
                                  colorBlendMode: BlendMode.darken,
                                )),
                            onTap: () {
                              setState(() {
                                if (selectedImages
                                    .contains(snapshot.data[index])) {
                                  selectedImages.remove(snapshot.data[index]);
                                } else {
                                  selectedImages.add(snapshot.data[index]);
                                }
                              });
                            });
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 3 : 5),
                    )
                  : Container(
                      child: Center(child: CircularProgressIndicator()));
            }));
  }
}
