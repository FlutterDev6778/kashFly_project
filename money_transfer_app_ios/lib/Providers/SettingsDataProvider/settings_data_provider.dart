import 'package:flutter/material.dart';
import 'package:money_transfer_framework/Repositories/index.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class SettingsDataProvider extends ChangeNotifier {
  static SettingsDataProvider of(BuildContext context, {bool listen = false}) => Provider.of<SettingsDataProvider>(context, listen: listen);

  SettingsDataState _settingsDataState = SettingsDataState.init();
  SettingsDataState get settingsDataState => _settingsDataState;

  void setSettingsDataState(SettingsDataState settingsDataState, {bool isNotifiable = true}) {
    if (_settingsDataState != settingsDataState) {
      _settingsDataState = settingsDataState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getSettingsData() async {
    try {
      var result = await SettingsRepository.getSettingData();

      if (result["success"] && result["data"].length != 0) {
        List<dynamic> ratesInfo = result["data"][3]["ratesInfo"];
        ratesInfo.sort((a, b) {
          return (a["min"] > b["min"]) ? 1 : -1;
        });

        _settingsDataState = _settingsDataState.update(
          progressState: 2,
          aboutText: result["data"][0]["aboutText"],
          cashLimits: result["data"][1]["cashLimits"],
          promoCodes: result["data"][2]["promoCodes"],
          ratesInfo: result["data"][3]["ratesInfo"],
          supportText: result["data"][4]["supportText"],
          minAmount: double.parse(ratesInfo[0]["min"].toString()),
        );
      } else {
        _settingsDataState = _settingsDataState.update(
          progressState: -1,
        );
      }
    } catch (e) {
      _settingsDataState = _settingsDataState.update(
        progressState: -1,
      );
    }
    notifyListeners();
  }
}
