import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'package:money_transfer_framework/Models/index.dart';

class UserRepository {
  static String _collectionName = "/Users";

  static Future<Map<String, dynamic>> addUser(UserModel userModel) async {
    Map<String, dynamic> result =
        await KeicyFireStoreDataProvider.instance.addDocument(path: _collectionName, data: userModel.toJson());
    return result;
  }

  static Future<Map<String, dynamic>> updateUser(userID, Map<String, dynamic> data) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.updateDocument(
      path: _collectionName,
      id: userID,
      data: data,
    );
    return result;
  }

  static Future<Map<String, dynamic>> deleteUser(userID) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.deleteDocument(
      path: _collectionName,
      id: userID,
    );
    return result;
  }

  static Future<Map<String, dynamic>> getUserByUID(String uid) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.getDocumentData(
      path: _collectionName,
      wheres: [
        {"key": "uid", "val": uid}
      ],
    );
    return result;
  }

  static Future<Map<String, dynamic>> getUserByID(String id) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.getDocumentData(
      path: _collectionName,
      wheres: [
        {"key": "id", "val": id}
      ],
    );
    return result;
  }

  static Stream<List<UserModel>> getUserModelListStreamByID(String id) {
    return KeicyFireStoreDataProvider.instance.getDocumentsStream(
      path: _collectionName,
      wheres: [
        {"key": "id", "val": id}
      ],
    ).map(
      (dataList) => dataList.map((data) => UserModel.fromJson(data)).toList(),
    );
  }

  static Future<Map<String, dynamic>> getUserByWheres(List<Map<String, dynamic>> wheres) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.getDocumentData(
      path: _collectionName,
      wheres: wheres,
    );
    return result;
  }
}
