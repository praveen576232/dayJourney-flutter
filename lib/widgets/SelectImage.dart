import 'dart:io';
import 'package:daybook/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectImage extends StatefulWidget {
  bool selectOnlyOneImage;
  SelectImage({@required this.selectOnlyOneImage});

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  List<String> selectedImages = [];
  bool permistionCheck = false;
  MethodChannel _methodChannel = MethodChannel("daybook");
  Future<List<String>> getAllImages(BuildContext context) async {
    bool permistion = await _methodChannel.invokeMethod('checkPermistion');
    print("permistion0 " + permistion.toString());
    if (permistion) {
      List<String> data = await feachImages();
      return data;
    } else {
      print("permistionnnnnm denied");
      await _methodChannel.invokeMethod('permision');
      bool permistioncheck =
          await _methodChannel.invokeMethod('checkPermistion');
      if (permistioncheck) {
        print("permistion 2 allow");
        List<String> data = await feachImages();
        return data;
      } else {
        print("permistion2 denied");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                    Text("Allow permistion to get a images from your gallary."),
                title: Text("Allow permistion"),
                actions: [
                  FlatButton(
                      onPressed: () async {
                        List<String> data = await feachImages();
                        return data;
                      },
                      child: Text("Allow")),
                  FlatButton(
                      onPressed: () {
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      },
                      child: Text("Deny")),
                ],
              );
            });
      }
    }
  }

  Future<List<String>> feachImages() async {
    var images = await _methodChannel.invokeMethod("images");
    List<String> data = images.cast<String>();
    return data;
  }

  @override
  void initState() {
    super.initState();
  }

  checkPermistion() async {
    bool permistion = await _methodChannel.invokeMethod('checkPermistion');
    setState(() {
      permistionCheck = permistion;
    });
    if (!permistionCheck) {
      await _methodChannel.invokeMethod('permision');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: utils.appbgcolor,
          title: Text(selectedImages?.length.toString() + " Image Selected",
              style: TextStyle(color: Colors.black)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            FlatButton(
                onPressed: selectedImages.length > 0
                    ? () {
                        Navigator.pop(context, selectedImages);
                      }
                    : null,
                child: Text("select",
                    style: TextStyle(
                        color: selectedImages.length > 0
                            ? Colors.black
                            : Colors.grey)))
          ],
        ),
        body: FutureBuilder(
            future: getAllImages(context),
            builder: (context, snapshot) {
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
                            onTap: !widget.selectOnlyOneImage
                                ? () {
                                    setState(() {
                                      if (selectedImages
                                          .contains(snapshot.data[index])) {
                                        selectedImages
                                            .remove(snapshot.data[index]);
                                      } else {
                                        selectedImages
                                            .add(snapshot.data[index]);
                                      }
                                    });
                                  }
                                : () {
                                    Navigator.pop(
                                        context, snapshot.data[index]);
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
