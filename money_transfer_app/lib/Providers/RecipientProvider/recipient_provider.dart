import 'package:flutter/material.dart';
import 'package:money_transfer_app/DataProviders/index.dart';
import 'package:provider/provider.dart';
import 'package:date_time_format/date_time_format.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class RecipientProvider extends ChangeNotifier {
  static RecipientProvider of(BuildContext context, {bool listen = false}) => Provider.of<RecipientProvider>(context, listen: listen);

  RecipientState _recipientState = RecipientState.init();
  RecipientState get recipientState => _recipientState;

  void setRecipientState(RecipientState recipientState, {bool isNotifiable = true}) {
    if (_recipientState != recipientState) {
      _recipientState = recipientState;
      if (isNotifiable) notifyListeners();
    }
  }

  void getRecipientModelStream(String senderID) {
    _recipientState = _recipientState.update(
      recipientModelListStream: RecipientRepository.getRecipientModelListStream(senderID),
    );
    notifyListeners();
  }

  void saveRecipientData(RecipientModel recipientModel) async {
    try {
      var result;
      if (recipientModel.id == "") {
        ///
        /// juba express register
        ///
        Map<String, dynamic> _userData = recipientModel.toJson();
        // _userData["City"] = "MNS";
        _userData["City"] = "MGQ";
        _userData["State"] = "SOM";

        var jubaResult = await RegisterCustomerDataProvider.registerCustomer(customerData: _userData);

        if (jubaResult["Response"]["Code"] == "001") {
          recipientModel.customerReferenceNo = jubaResult["Data"]["CustomerReferenceNo"];
        } else {
          _recipientState = _recipientState.update(
            progressState: -1,
            errorString: jubaResult["Response"]["Message"],
          );
          notifyListeners();
          return;
        }
        //////////////////////////////////////////////////////
        result = await RecipientRepository.addRecipient(recipientModel);
      } else {
        Map<String, dynamic> _userData = recipientModel.toJson();
        // _userData["DateOfBirth"] = DateTimeFormat.format(
        //   DateTime.fromMillisecondsSinceEpoch(recipientModel.d),
        //   format: "m/d/Y",
        // );
        _userData["City"] = "MGQ";
        _userData["State"] = "SOM";

        var jubaResult = await UpdateCustomerDataProvider.updateCustomer(customerData: _userData);

        if (jubaResult["Response"]["Code"] == "001") {}
        result = await RecipientRepository.updateRecipient(recipientModel.id, recipientModel.toJson());
      }

      if (result["success"]) {
        _recipientState = _recipientState.update(
          progressState: 2,
          errorString: "",
        );
      } else {
        _recipientState = _recipientState.update(
          progressState: -1,
          errorString: "Save Recipient Data Failed",
        );
      }
    } catch (e) {
      _recipientState = _recipientState.update(
        progressState: -1,
        errorString: "Save Recipient Data Failed",
      );
    }
    notifyListeners();
  }
}
