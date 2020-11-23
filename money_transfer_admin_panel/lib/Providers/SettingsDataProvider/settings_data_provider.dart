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
        _settingsDataState = _settingsDataState.update(
          progressState: 2,
          aboutText: result["data"][0]["aboutText"],
          cashLimits: result["data"][1]["cashLimits"],
          promoCodes: result["data"][2]["promoCodes"],
          ratesInfo: result["data"][3]["ratesInfo"],
          supportText: result["data"][4]["supportText"],
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

  Future<void> saveCashLimit(Map<String, dynamic> data) async {
    var result = await SettingsRepository.updateSettingData("cashLimits", {"cashLimits": data});
    if (result["success"]) {
      _settingsDataState = _settingsDataState.update(cashLimits: data, progressState: 2);
      notifyListeners();
    } else {
      _settingsDataState = _settingsDataState.update(progressState: 2);
      notifyListeners();
    }
  }

  Future<void> saveRates(List<dynamic> data) async {
    var result = await SettingsRepository.updateSettingData("ratesInfo", {"ratesInfo": data});
    if (result["success"]) {
      _settingsDataState = _settingsDataState.update(ratesInfo: data, progressState: 2);
      notifyListeners();
    } else {
      _settingsDataState = _settingsDataState.update(progressState: 2);
      notifyListeners();
    }
  }

  Future<void> savePromoCodes(List<dynamic> data) async {
    var result = await SettingsRepository.updateSettingData("promoCodes", {"promoCodes": data});
    if (result["success"]) {
      _settingsDataState = _settingsDataState.update(promoCodes: data, progressState: 2);
      notifyListeners();
    } else {
      _settingsDataState = _settingsDataState.update(progressState: 2);
      notifyListeners();
    }
  }

  Future<void> saveSupportText(String data) async {
    var result = await SettingsRepository.updateSettingData("supportText", {"supportText": data});
    if (result["success"]) {
      _settingsDataState = _settingsDataState.update(supportText: data, progressState: 2);
      notifyListeners();
    } else {
      _settingsDataState = _settingsDataState.update(progressState: 2);
      notifyListeners();
    }
  }

  Future<void> saveAboutText(String data) async {
    var result = await SettingsRepository.updateSettingData("aboutText", {"aboutText": data});
    if (result["success"]) {
      _settingsDataState = _settingsDataState.update(aboutText: data, progressState: 2);
      notifyListeners();
    } else {
      _settingsDataState = _settingsDataState.update(progressState: 2);
      notifyListeners();
    }
  }
}
