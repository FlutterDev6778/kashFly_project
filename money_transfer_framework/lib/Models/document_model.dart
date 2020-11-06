import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  String subCategory;
  String title;
  String imagePath;
  String imagePath1;
  String documentNumber;
  int expireDateTs;

  DocumentModel({
    this.subCategory = "",
    this.title = "",
    this.imagePath = "",
    this.imagePath1 = "",
    this.documentNumber = "",
    this.expireDateTs = 0,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      map = Map<String, dynamic>();
    }
    return DocumentModel(
      subCategory: map['subCategory'] ?? "",
      title: map['title'] ?? "",
      imagePath: map['imagePath'] ?? "",
      imagePath1: map['imagePath1'] ?? "",
      documentNumber: map['documentNumber'] ?? "",
      expireDateTs: map['expireDateTs'] ?? 0,
    );
  }

  DocumentModel update(Map<String, dynamic> map) {
    return DocumentModel(
      subCategory: map['subCategory'] ?? subCategory ?? "",
      title: map['title'] ?? title ?? "",
      imagePath: map['imagePath'] ?? imagePath ?? "",
      imagePath1: map['imagePath1'] ?? imagePath1 ?? "",
      documentNumber: map['documentNumber'] ?? documentNumber ?? "",
      expireDateTs: map['expireDateTs'] ?? expireDateTs ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "subCategory": subCategory ?? "",
      "title": title ?? "",
      "imagePath": imagePath ?? "",
      "imagePath1": imagePath1 ?? "",
      "documentNumber": documentNumber ?? "",
      "expireDateTs": expireDateTs ?? 0,
    };
  }

  @override
  List<Object> get props => [
        subCategory,
        title,
        imagePath,
        imagePath1,
        documentNumber,
        expireDateTs,
      ];

  @override
  bool get stringify => true;
}
