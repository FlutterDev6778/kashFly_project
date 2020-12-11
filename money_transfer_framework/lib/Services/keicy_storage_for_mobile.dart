library keicy_storage_for_mobile_4_0;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keicy_utils/validators.dart';

class KeicyStorageForMobile {
  static KeicyStorageForMobile _instance = KeicyStorageForMobile();
  static KeicyStorageForMobile get instance => _instance;

  Future<String> uploadFileObject({@required String path, @required String fileName, @required File file}) async {
    try {
      fileName = _getValidatedFileName(fileName);
      Reference storageReference = FirebaseStorage.instance.ref().child("$path$fileName");
      UploadTask uploadTask = storageReference.putFile(file);
      final StreamSubscription<TaskSnapshot> streamSubscription = uploadTask.snapshotEvents.listen((event) {});
      await uploadTask;
      streamSubscription.cancel();
      return await storageReference.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  UploadTask uploadFileObjectWithTask({@required String path, @required String fileName, @required File file}) {
    try {
      fileName = _getValidatedFileName(fileName);
      Reference storageReference = FirebaseStorage.instance.ref().child("$path$fileName");
      UploadTask uploadTask = storageReference.putFile(file);
      return uploadTask;
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadByteData(
      {@required String path, @required String fileName, @required Uint8List byteData}) async {
    try {
      fileName = _getValidatedFileName(fileName);
      Reference storageReference = FirebaseStorage.instance.ref().child("$path$fileName");
      UploadTask uploadTask = storageReference.putData(byteData);
      final StreamSubscription<TaskSnapshot> streamSubscription = uploadTask.snapshotEvents.listen((event) {});
      await uploadTask;
      streamSubscription.cancel();
      uploadTask.cancel();
      return await storageReference.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  String _getValidatedFileName(String fileName) {
    if (fileName == null || fileName == "") return "${Random().nextInt(10000000).toString()}";
    var listFileName = fileName.split('.');
    if (listFileName.length == 1) return "${fileName}_${Random().nextInt(10000000).toString()}";
    String extention = listFileName[listFileName.length - 1];
    String fName = fileName.substring(0, fileName.length - extention.length - 1);
    return "${fName}_${Random().nextInt(10000000).toString()}.$extention";
  }

  Future<bool> deleteFile({@required String path}) async {
    try {
      String storageUrl = Uri.decodeFull(path.split(KeicyValidators.firebaseStorageFileRegExp)[1]);
      await FirebaseStorage.instance.ref().child(storageUrl).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
