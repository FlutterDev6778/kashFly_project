import 'package:flutter/material.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';

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
      if (recipientModel.id == "")
        result = await RecipientRepository.addRecipient(recipientModel);
      else
        result = await RecipientRepository.updateRecipient(recipientModel.id, recipientModel.toJson());

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
