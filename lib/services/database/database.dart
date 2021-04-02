import 'dart:io';
import 'package:daybook/screens/DisplayDayBook.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

updateDayBook(
    BuildContext context,
    User user,
    String id,
    String text,
    DateTime currentDateTime,
    List<String> selectedTags,
    dynamic selctedimages,
    List<String> nowSelectedImages,bool loading) async {
  DocumentReference ref = FirebaseFirestore.instance
      .collection("daybooks")
      .doc(user.email)
      .collection(user.uid)
      .doc(id);
  ref.get().then((doc) async {
    Map<String, dynamic> docdata = doc.data();

    if (docdata["dayNote"] != text) {
      ref.update({"dayNote": text});
    }
    if (DateTime.parse(docdata['dateTime'].toDate().toString())
            .compareTo(currentDateTime) !=
        0) {
      ref.update({"dateTime": currentDateTime});
    }

    if (docdata['tags'] != null && docdata['tags'].length > 0) {
      if (docdata['tags'] != selectedTags) {
        ref.update({"tags": selectedTags});
      }
    } else {
      if (selectedTags != null && selectedTags.length > 0) {
        ref.update({"tags": selectedTags});
      }
    }

    if (docdata['images'] != null && docdata['images'].length > 0) {
      for (var olddata in docdata['images']) {
        bool found = false;
        Map<String, String> olddataMap = Map.from(olddata);
        if (selctedimages != null) {
          for (var newdata in selctedimages) {
            Map<String, String> newdataMap = Map.from(newdata);
            if (olddataMap['fileName'] == newdataMap['fileName']) {
              selctedimages.remove(newdata);
              found = true;
              break;
            }
          }
        }
        if (nowSelectedImages.length > 0) {
          for (var newuplodefile in nowSelectedImages) {
            File file = File(newuplodefile);
            if (olddataMap['fileName'] == basename(file.path)) {
              nowSelectedImages.remove(newuplodefile);
              found = true;
              break;
            }
          }
        }
        if (!found) {
          await removeImage(
            user,
            olddataMap,
            ref,
          );
        }
      }
      List<Map<String, dynamic>> imageUrls = [];
      imageUrls = await uploadImages(nowSelectedImages, user);
      await ref.update({"images": FieldValue.arrayUnion(imageUrls)});
    } else {
      if (nowSelectedImages.length > 0) {
        List<Map<String, dynamic>> imageUrls = [];

        imageUrls = await uploadImages(nowSelectedImages, user);
        ref.update({"images": imageUrls});
      }
    }
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
      loading = false;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplayDayBook(
                  images: docdata['images'],
                  tags: selectedTags != null ? selectedTags : null,
                  dateTime: currentDateTime,
                  id: id,
                  text: text,
                )));
  });
}

removeImage(User user, Map<String, String> file, DocumentReference ref) async {
  await firebase_storage.FirebaseStorage.instance
      .ref()
      .child(user.uid)
      .child(file['fileName'])
      .delete()
      .whenComplete(() async {
    ref.update({
      'images': FieldValue.arrayRemove([file])
    });
  });
}

uploadDayBook(
    List<String> _images,
    BuildContext context,
    User user,
    List<String> selectedTags,
    DateTime currentDateTime,
    String text,
    bool loading) async {
  List<Map<String, dynamic>> imageUrls = [];
  if (_images.length > 0) {
    imageUrls = await uploadImages(_images, user);
  }

  await FirebaseFirestore.instance
      .collection("daybooks")
      .doc(user.email)
      .collection(user.uid)
      .add({
    'images': imageUrls,
    'tags': selectedTags,
    'dateTime': currentDateTime,
    'dayNote': text,
  });
  loading = false;
  Navigator.pop(context);
}

uploadImages(List<String> _images, User user) async {
  List<Map<String, dynamic>> imageUrls = [];
  for (var image in _images) {
    File file = File(image);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(user.uid)
        .child(basename(file.path));
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        imageUrls.add({'url': value, 'fileName': basename(file.path)});
      });
    });
  }
  return imageUrls;
}
