import 'package:keicy_firestore_0_14_data_provider/keicy_firestore_0_14_data_provider.dart';

import 'package:money_transfer_framework/Models/index.dart';

class RecipientRepository {
  static String _collectionName = "/Recipients";

  static Future<Map<String, dynamic>> addRecipient(RecipientModel recipientModel) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.addDocument(path: _collectionName, data: recipientModel.toJson());
    return result;
  }

  static Future<Map<String, dynamic>> updateRecipient(recipientID, Map<String, dynamic> data) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.updateDocument(
      path: _collectionName,
      id: recipientID,
      data: data,
    );
    return result;
  }

  static Future<Map<String, dynamic>> deleteRecipient(recipientID) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.deleteDocument(
      path: _collectionName,
      id: recipientID,
    );
    return result;
  }

  static Stream<RecipientModel> getRecipientModelStreamByID(String id) {
    return KeicyFireStoreDataProvider.instance.getDocumentStreamByID(path: _collectionName, id: id).map(
          (data) => RecipientModel.fromJson(data),
        );
  }

  static Stream<List<RecipientModel>> getRecipientModelListStream(String senderID) {
    return KeicyFireStoreDataProvider.instance.getDocumentsStream(
      path: _collectionName,
      wheres: [
        {"key": "senderID", "val": senderID}
      ],
      orderby: [
        {"key": "createdDateTs", "desc": true}
      ],
    ).map(
      (dataList) => dataList.map((data) => RecipientModel.fromJson(data)).toList(),
    );
  }
}
