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

  MethodChannel _methodChannel = MethodChannel("daybook");


  Future<List<String>> feachImages(BuildContext context) async {
    bool result = await _methodChannel.invokeMethod('permision');
    var images;
    if (result) {
      images = await _methodChannel.invokeMethod("images");
      List<String> data = images.cast<String>();
      return data;
    } else {
    
      await showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  Text("Allow permistion to get a images from your gallary."),
              title: Text("Allow permistion"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      bool nowresult =
                          await _methodChannel.invokeMethod('permision');
                      if (nowresult) {
                     
                        images = await _methodChannel.invokeMethod("images");
                        List<String> data = images.cast<String>();
                      
                        Navigator.pop(context);
                        return data;
                      } else {
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      }
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
      return images;
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
            future: feachImages(context),
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
