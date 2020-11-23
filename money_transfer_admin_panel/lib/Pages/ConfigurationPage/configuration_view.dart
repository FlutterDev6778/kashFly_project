import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_form_field/date_form_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
import 'package:status_alert/status_alert.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:provider/provider.dart';

import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_text_form_field/keicy_text_form_field.dart';
import 'package:keicy_cookie_provider/keicy_cookie_provider.dart';
import 'package:keicy_utils/validators.dart';
import 'package:keicy_navigator/keicy_navigator.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import '../App/index.dart';
import '../SideBarPanel/index.dart';
import '../../Providers/index.dart';
import 'index.dart';

class ConfigurationView extends StatefulWidget {
  final ConfigurationPageStyles configurationPageStyles;

  const ConfigurationView({
    this.configurationPageStyles,
  });

  @override
  _ConfigurationViewState createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  SettingsDataProvider _settingsDataProvider;
  KeicyProgressDialog _keicyProgressDialog;

  Map<String, dynamic> newCashLimits;
  List<dynamic> newRates;
  List<dynamic> newPromoCodes;
  String newSupportText;
  String newAboutText;

  @override
  void initState() {
    super.initState();

    _settingsDataProvider = SettingsDataProvider.of(context);

    _keicyProgressDialog = KeicyProgressDialog.of(
      context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      layout: Layout.Column,
      padding: EdgeInsets.zero,
      width: widget.configurationPageStyles.widthDp * 120,
      height: widget.configurationPageStyles.widthDp * 120,
      progressWidget: Container(
        width: widget.configurationPageStyles.widthDp * 120,
        height: widget.configurationPageStyles.widthDp * 120,
        padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.configurationPageStyles.widthDp * 10),
        ),
        child: SpinKitFadingCircle(
          color: AppColors.primaryColor,
          size: widget.configurationPageStyles.widthDp * 80,
        ),
      ),
      message: "",
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _settingsDataProvider.addListener(_settingsDataProviderListener);
      _settingsDataProvider.getSettingsData();
    });
  }

  @override
  void dispose() {
    _settingsDataProvider.removeListener(_settingsDataProviderListener);

    super.dispose();
  }

  void _settingsDataProviderListener() async {
    if (_settingsDataProvider.settingsDataState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_settingsDataProvider.settingsDataState.progressState) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case -1:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: widget.configurationPageStyles.deviceWidth,
        height: widget.configurationPageStyles.mainHeight,
        child: Row(
          children: [
            SideBarPanel(index: 1),
            Expanded(
              child: Container(
                height: widget.configurationPageStyles.mainHeight,
                child: SingleChildScrollView(
                  child: _containerMain(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerMain(BuildContext context) {
    return Consumer<SettingsDataProvider>(builder: (context, settingsDataProvider, _) {
      if (settingsDataProvider.settingsDataState.progressState == 0 || settingsDataProvider.settingsDataState.progressState == 1) {
        return Container(
          height: widget.configurationPageStyles.mainHeight,
          child: Center(child: KeicyCupertinoIndicator()),
        );
      }

      if (settingsDataProvider.settingsDataState.progressState == -1) {
        return Container(
          height: widget.configurationPageStyles.mainHeight,
          child: Center(child: Text("Getting Configuration Data Error")),
        );
      }

      if (newCashLimits == null) {
        newCashLimits = json.decode(json.encode(_settingsDataProvider.settingsDataState.cashLimits));
      }

      if (newRates == null) {
        newRates = json.decode(json.encode(_settingsDataProvider.settingsDataState.ratesInfo));
      }

      if (newPromoCodes == null) {
        newPromoCodes = json.decode(json.encode(_settingsDataProvider.settingsDataState.promoCodes));
        newPromoCodes.add(Map<String, dynamic>());
      }

      if (newSupportText == null) {
        newSupportText = _settingsDataProvider.settingsDataState.supportText;
      }

      if (newAboutText == null) {
        newAboutText = _settingsDataProvider.settingsDataState.aboutText;
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.configurationPageStyles.primaryHorizontalPadding,
          vertical: widget.configurationPageStyles.primaryVerticalPadding,
        ),
        child: Column(
          children: [
            (widget.configurationPageStyles.runtimeType == ConfigurationPageMobileStyles)
                ? Column(
                    children: [
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                          vertical: widget.configurationPageStyles.cardVerticalMargin,
                        ),
                        child: _containerCashLimit(context, settingsDataProvider),
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                          vertical: widget.configurationPageStyles.cardVerticalMargin,
                        ),
                        child: _containerRates(context, settingsDataProvider),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                            vertical: widget.configurationPageStyles.cardVerticalMargin,
                          ),
                          child: _containerCashLimit(context, settingsDataProvider),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                            vertical: widget.configurationPageStyles.cardVerticalMargin,
                          ),
                          child: _containerRates(context, settingsDataProvider),
                        ),
                      )
                    ],
                  ),
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                vertical: widget.configurationPageStyles.cardVerticalMargin,
              ),
              child: _containerDiscount(context, settingsDataProvider),
            ),
            (widget.configurationPageStyles.runtimeType == ConfigurationPageMobileStyles)
                ? Column(
                    children: [
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                          vertical: widget.configurationPageStyles.cardVerticalMargin,
                        ),
                        child: _containerHelpAndSupport(context, settingsDataProvider),
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                          vertical: widget.configurationPageStyles.cardVerticalMargin,
                        ),
                        child: _containerAbout(context, settingsDataProvider),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                            vertical: widget.configurationPageStyles.cardVerticalMargin,
                          ),
                          child: _containerHelpAndSupport(context, settingsDataProvider),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            horizontal: widget.configurationPageStyles.cardHorizontalMargin,
                            vertical: widget.configurationPageStyles.cardVerticalMargin,
                          ),
                          child: _containerAbout(context, settingsDataProvider),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      );
    });
  }

  Widget _containerCashLimit(BuildContext context, SettingsDataProvider settingsDataProvider) {
    List<Map<String, dynamic>> cashData = [];
    settingsDataProvider.settingsDataState.cashLimits.forEach((key, value) {
      cashData.add({
        "type": key,
        "value": value,
      });
    });

    cashData.sort((a, b) {
      return a["type"].compareTo(b["type"]);
    });

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.configurationPageStyles.cardHorizontalPadding,
        vertical: widget.configurationPageStyles.cardVerticalPadding,
      ),
      child: ResponsiveDatatable(
        title: Text(
          ConfigurationPageString.tableLabelForCashLimit,
          style: widget.configurationPageStyles.tableLabelStyle,
        ),
        headers: [
          DatatableHeader(
            text: ConfigurationPageString.typHeaderForCashLimit,
            value: "type",
            textAlign: TextAlign.left,
            headerBuilder: (value) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                  ),
                ),
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Text(ConfigurationPageString.typHeaderForCashLimit, style: widget.configurationPageStyles.tableHeaderStyle),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.valueHeaderForCashLimit,
            value: "value",
            textAlign: TextAlign.left,
            editable: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.valueHeaderForCashLimit, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
          ),
        ],
        source: cashData,
        hideUnderline: true,
        showSelect: false,
        cellBorder: Border.all(color: AppColors.primaryColor, width: 1),
        tableBorder: Border.all(color: AppColors.primaryColor, width: 1),
        headerPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        cellPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        headerStyle: widget.configurationPageStyles.tableHeaderStyle,
        cellStyle: widget.configurationPageStyles.tableCellStyle,
        changeHandler: (int index, Map<String, dynamic> newRowData) {
          settingsDataProvider.settingsDataState.cashLimits.forEach((key, value) {
            if (newRowData["type"] == key) {
              newCashLimits[key] = newRowData["value"];
            }
          });
        },
        footers: [
          Column(
            children: [
              SizedBox(height: widget.configurationPageStyles.widthDp * 20),
              KeicyRaisedButton(
                width: widget.configurationPageStyles.buttonWidth,
                height: widget.configurationPageStyles.buttonHeiht,
                color: AppColors.primaryColor,
                borderRadius: widget.configurationPageStyles.widthDp * 4,
                child: Text(
                  ConfigurationPageString.saveButtonText,
                  style: widget.configurationPageStyles.buttonTextStyle,
                ),
                onPressed: () async {
                  print(newCashLimits);
                  await _keicyProgressDialog.show();
                  settingsDataProvider.saveCashLimit(newCashLimits);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _containerRates(BuildContext context, SettingsDataProvider settingsDataProvider) {
    List<Map<String, dynamic>> ratesData = [];

    for (var i = 0; i < settingsDataProvider.settingsDataState.ratesInfo.length; i++) {
      ratesData.add(settingsDataProvider.settingsDataState.ratesInfo[i]);
    }

    ratesData.sort((a, b) {
      return a["min"] > b["min"] ? 1 : -1;
    });

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.configurationPageStyles.cardHorizontalPadding,
        vertical: widget.configurationPageStyles.cardVerticalPadding,
      ),
      child: ResponsiveDatatable(
        title: Text(
          ConfigurationPageString.tableLabelForRates,
          style: widget.configurationPageStyles.tableLabelStyle,
        ),
        headers: [
          DatatableHeader(
            text: ConfigurationPageString.mintHeaderForRates,
            value: "min",
            textAlign: TextAlign.left,
            headerBuilder: (value) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                    left: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Text(ConfigurationPageString.mintHeaderForRates, style: widget.configurationPageStyles.tableHeaderStyle),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.maxHeaderForRates,
            value: "max",
            textAlign: TextAlign.left,
            editable: true,
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Text(ConfigurationPageString.maxHeaderForRates, style: widget.configurationPageStyles.tableHeaderStyle),
              );
            },
            sourceBuilder: (value, row) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Text(value != -1 ? value.toString() : "Unlimited", style: widget.configurationPageStyles.tableCellStyle),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.feeHeaderForRates,
            value: "fee",
            textAlign: TextAlign.left,
            editable: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.primaryColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.feeHeaderForRates, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
          ),
        ],
        source: ratesData,
        hideUnderline: true,
        showSelect: false,
        cellBorder: Border.all(color: AppColors.primaryColor, width: 1),
        tableBorder: Border.all(color: AppColors.primaryColor, width: 1),
        headerPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        cellPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        headerStyle: widget.configurationPageStyles.tableHeaderStyle,
        cellStyle: widget.configurationPageStyles.tableCellStyle,
        changeHandler: (int index, Map<String, dynamic> newRowData) {
          newRates[index] = newRowData;
        },
        footers: [
          Column(
            children: [
              SizedBox(height: widget.configurationPageStyles.widthDp * 20),
              KeicyRaisedButton(
                width: widget.configurationPageStyles.buttonWidth,
                height: widget.configurationPageStyles.buttonHeiht,
                color: AppColors.primaryColor,
                borderRadius: widget.configurationPageStyles.widthDp * 4,
                child: Text(
                  ConfigurationPageString.saveButtonText,
                  style: widget.configurationPageStyles.buttonTextStyle,
                ),
                onPressed: () async {
                  print(newRates);
                  await _keicyProgressDialog.show();
                  settingsDataProvider.saveRates(newRates);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _containerDiscount(BuildContext context, SettingsDataProvider settingsDataProvider) {
    List<Map<String, dynamic>> promoCodes = [];

    for (var i = 0; i < settingsDataProvider.settingsDataState.promoCodes.length; i++) {
      promoCodes.add(settingsDataProvider.settingsDataState.promoCodes[i]);
    }
    promoCodes.add(Map<String, dynamic>());

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.configurationPageStyles.cardHorizontalPadding,
        vertical: widget.configurationPageStyles.cardVerticalPadding,
      ),
      child: ResponsiveDatatable(
        title: Text(
          ConfigurationPageString.tableLabelForDiscounts,
          style: widget.configurationPageStyles.tableLabelStyle,
        ),
        headers: [
          DatatableHeader(
            text: ConfigurationPageString.reasonHeaderForDiscounts,
            value: "reason",
            textAlign: TextAlign.left,
            editable: true,
            headerBuilder: (value) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                    left: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.reasonHeaderForDiscounts, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.promoCodeHeaderForDiscounts,
            value: "code",
            textAlign: TextAlign.left,
            editable: true,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.promoCodeHeaderForDiscounts, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.startDateHeaderForDiscounts,
            value: "startDate",
            textAlign: TextAlign.left,
            editable: true,
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.startDateHeaderForDiscounts, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
            sourceBuilder: (value, row) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Container(
                  height: widget.configurationPageStyles.tableCellStyle.fontSize + 2,
                  child: DateFormField(
                    initialDate: value != null ? DateTime.fromMillisecondsSinceEpoch(value) : null,
                    initialValue: value != null ? KeicyDateTime.convertMillisecondsToDateString(ms: value) : "",
                    style: widget.configurationPageStyles.tableCellStyle,
                    format: 'yyyy-MM-d',
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                    ),
                    onDateChanged: (dateTime) {
                      if (dateTime == null) return;
                      print(newPromoCodes);
                      int index = promoCodes.indexOf(row);
                      row["startDate"] = dateTime.millisecondsSinceEpoch;
                      newPromoCodes[index] = row;

                      print(newPromoCodes);
                    },
                    showPicker: () {
                      return showDatePicker(
                        context: context,
                        initialDate: (value == null) ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(value),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 3650)),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.endDateHeaderForDiscounts,
            value: "endDate",
            textAlign: TextAlign.left,
            editable: true,
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.whiteColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.endDateHeaderForDiscounts, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
            sourceBuilder: (value, row) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Container(
                  height: widget.configurationPageStyles.tableCellStyle.fontSize + 2,
                  child: DateFormField(
                    initialDate: value != null ? DateTime.fromMillisecondsSinceEpoch(value) : null,
                    initialValue: value != null ? KeicyDateTime.convertMillisecondsToDateString(ms: value) : "",
                    style: widget.configurationPageStyles.tableCellStyle,
                    format: 'yyyy-MM-d',
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      filled: true,
                    ),
                    onDateChanged: (dateTime) {
                      if (dateTime == null) return;
                      print(newPromoCodes);
                      int index = promoCodes.indexOf(row);
                      row["endDate"] = dateTime.millisecondsSinceEpoch;
                      newPromoCodes[index] = row;

                      print(newPromoCodes);
                    },
                    showPicker: () {
                      return showDatePicker(
                        context: context,
                        initialDate: (value == null) ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(value),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 3650)),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          DatatableHeader(
            text: ConfigurationPageString.descriptionHeaderForDiscounts,
            value: "description",
            textAlign: TextAlign.left,
            editable: true,
            headerBuilder: (value) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  border: Border(
                    left: BorderSide(color: AppColors.whiteColor, width: 1),
                    right: BorderSide(color: AppColors.primaryColor, width: 1),
                    bottom: BorderSide(color: AppColors.primaryColor, width: 1),
                    top: BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ConfigurationPageString.descriptionHeaderForDiscounts, style: widget.configurationPageStyles.tableHeaderStyle),
                    Icon(Icons.edit, color: AppColors.whiteColor, size: widget.configurationPageStyles.editIconSize),
                  ],
                ),
              );
            },
          ),
        ],
        source: promoCodes,
        hideUnderline: true,
        showSelect: false,
        cellBorder: Border.all(color: AppColors.primaryColor, width: 1),
        tableBorder: Border.all(color: AppColors.primaryColor, width: 1),
        headerPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        cellPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        headerStyle: widget.configurationPageStyles.tableHeaderStyle,
        cellStyle: widget.configurationPageStyles.tableCellStyle,
        changeHandler: (int index, Map<String, dynamic> newRowData) {
          print("9999999999");
          print(newPromoCodes);
          newPromoCodes[index] = newRowData;
          print(newPromoCodes);
        },
        footers: [
          Column(
            children: [
              SizedBox(height: widget.configurationPageStyles.widthDp * 20),
              KeicyRaisedButton(
                width: widget.configurationPageStyles.buttonWidth,
                height: widget.configurationPageStyles.buttonHeiht,
                color: AppColors.primaryColor,
                borderRadius: widget.configurationPageStyles.widthDp * 4,
                child: Text(
                  ConfigurationPageString.saveButtonText,
                  style: widget.configurationPageStyles.buttonTextStyle,
                ),
                onPressed: () async {
                  if (newPromoCodes.last["reason"] == null &&
                      newPromoCodes.last["code"] == null &&
                      newPromoCodes.last["startDate"] == null &&
                      newPromoCodes.last["endDate"] == null &&
                      newPromoCodes.last["description"] == null) {
                    newPromoCodes.removeLast();
                  }
                  await _keicyProgressDialog.show();
                  settingsDataProvider.savePromoCodes(newPromoCodes);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _containerHelpAndSupport(BuildContext context, SettingsDataProvider settingsDataProvider) {
    List<Map<String, dynamic>> supportData = [];
    supportData.add({"text": settingsDataProvider.settingsDataState.supportText});

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.configurationPageStyles.cardHorizontalPadding,
        vertical: widget.configurationPageStyles.cardVerticalPadding,
      ),
      child: ResponsiveDatatable(
        title: Text(
          ConfigurationPageString.tableLabelForSupport,
          style: widget.configurationPageStyles.tableLabelStyle,
        ),
        headers: [
          DatatableHeader(
            text: ConfigurationPageString.typHeaderForCashLimit,
            value: "text",
            textAlign: TextAlign.left,
            headerBuilder: (value) {
              return Container(
                decoration: BoxDecoration(color: AppColors.primaryColor),
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Text("Text", style: widget.configurationPageStyles.tableHeaderStyle),
              );
            },
            sourceBuilder: (value, row) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: TextField(
                  // initialValue: value,
                  style: widget.configurationPageStyles.tableCellStyle,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(text: "$value"),
                  ),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (input) {
                    newSupportText = input;
                  },
                ),
              );
            },
          ),
        ],
        source: supportData,
        hideUnderline: true,
        showSelect: false,
        cellBorder: Border.all(color: AppColors.primaryColor, width: 1),
        tableBorder: Border.all(color: AppColors.primaryColor, width: 1),
        headerPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        cellPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        headerStyle: widget.configurationPageStyles.tableHeaderStyle,
        cellStyle: widget.configurationPageStyles.tableCellStyle,
        changeHandler: (int index, Map<String, dynamic> newRowData) {
          newSupportText = newRowData["text"];
        },
        footers: [
          Column(
            children: [
              SizedBox(height: widget.configurationPageStyles.widthDp * 20),
              KeicyRaisedButton(
                width: widget.configurationPageStyles.buttonWidth,
                height: widget.configurationPageStyles.buttonHeiht,
                color: AppColors.primaryColor,
                borderRadius: widget.configurationPageStyles.widthDp * 4,
                child: Text(
                  ConfigurationPageString.saveButtonText,
                  style: widget.configurationPageStyles.buttonTextStyle,
                ),
                onPressed: () async {
                  print(newSupportText);
                  await _keicyProgressDialog.show();
                  settingsDataProvider.saveSupportText(newSupportText);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _containerAbout(BuildContext context, SettingsDataProvider settingsDataProvider) {
    List<Map<String, dynamic>> aboutData = [];
    aboutData.add({"text": settingsDataProvider.settingsDataState.aboutText});

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.configurationPageStyles.cardHorizontalPadding,
        vertical: widget.configurationPageStyles.cardVerticalPadding,
      ),
      child: ResponsiveDatatable(
        title: Text(
          ConfigurationPageString.tableLabelForAbout,
          style: widget.configurationPageStyles.tableLabelStyle,
        ),
        headers: [
          DatatableHeader(
            text: ConfigurationPageString.typHeaderForCashLimit,
            value: "text",
            textAlign: TextAlign.left,
            headerBuilder: (value) {
              return Container(
                decoration: BoxDecoration(color: AppColors.primaryColor),
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: Text("Text", style: widget.configurationPageStyles.tableHeaderStyle),
              );
            },
            sourceBuilder: (value, row) {
              return Container(
                padding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
                child: TextField(
                  // initialValue: value,
                  style: widget.configurationPageStyles.tableCellStyle,
                  controller: TextEditingController.fromValue(
                    TextEditingValue(text: "$value"),
                  ),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    isCollapsed: true,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (input) {
                    newAboutText = input;
                  },
                ),
              );
            },
          ),
        ],
        source: aboutData,
        hideUnderline: true,
        showSelect: false,
        cellBorder: Border.all(color: AppColors.primaryColor, width: 1),
        tableBorder: Border.all(color: AppColors.primaryColor, width: 1),
        headerPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        cellPadding: EdgeInsets.all(widget.configurationPageStyles.widthDp * 10),
        headerStyle: widget.configurationPageStyles.tableHeaderStyle,
        cellStyle: widget.configurationPageStyles.tableCellStyle,
        changeHandler: (int index, Map<String, dynamic> newRowData) {
          newAboutText = newRowData["text"];
        },
        footers: [
          Column(
            children: [
              SizedBox(height: widget.configurationPageStyles.widthDp * 20),
              KeicyRaisedButton(
                width: widget.configurationPageStyles.buttonWidth,
                height: widget.configurationPageStyles.buttonHeiht,
                color: AppColors.primaryColor,
                borderRadius: widget.configurationPageStyles.widthDp * 4,
                child: Text(
                  ConfigurationPageString.saveButtonText,
                  style: widget.configurationPageStyles.buttonTextStyle,
                ),
                onPressed: () async {
                  print(newAboutText);
                  await _keicyProgressDialog.show();
                  settingsDataProvider.saveAboutText(newAboutText);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
