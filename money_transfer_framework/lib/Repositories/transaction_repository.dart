import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'package:money_transfer_framework/Models/index.dart';

class TransactionRepository {
  static String _collectionName = "/TransactionHistorys";

  static Future<Map<String, dynamic>> addTransaction(TransactionModel transactionModel) async {
    Map<String, dynamic> result =
        await KeicyFireStoreDataProvider.instance.addDocument(path: _collectionName, data: transactionModel.toJson());
    return result;
  }

  static Future<Map<String, dynamic>> updateTransaction(transactionHistoryID, Map<String, dynamic> data) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.updateDocument(
      path: _collectionName,
      id: transactionHistoryID,
      data: data,
    );
    return result;
  }

  static Future<Map<String, dynamic>> deleteTransaction(transactionHistoryID) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.deleteDocument(
      path: _collectionName,
      id: transactionHistoryID,
    );
    return result;
  }

  static Future<Map<String, dynamic>> getTransactionByID(String id) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance.getDocumentData(
      path: _collectionName,
      wheres: [
        {"key": "id", "val": id}
      ],
    );
    return result;
  }

  static Stream<List<TransactionModel>> getTransactionModelListStream({
    List<Map<String, dynamic>> wheres,
    List<Map<String, dynamic>> orderby,
    int limit,
  }) {
    return KeicyFireStoreDataProvider.instance
        .getDocumentsStream(
          path: _collectionName,
          wheres: wheres,
          orderby: orderby,
          limit: limit,
        )
        .map(
          (dataList) => dataList.map((data) => TransactionModel.fromJson(data)).toList(),
        );
  }

  static Future<Map<String, dynamic>> getTransactionByWheres(
    List<Map<String, dynamic>> wheres,
    List<Map<String, dynamic>> orderby,
  ) async {
    Map<String, dynamic> result = await KeicyFireStoreDataProvider.instance
        .getDocumentData(path: _collectionName, wheres: wheres, orderby: orderby);
    return result;
  }
}
