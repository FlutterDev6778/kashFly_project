import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_avatar_image/keicy_avatar_image.dart';
import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
import 'package:money_transfer_app/DataProviders/index.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/TransactionHistoryProvider/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class HomeView extends StatefulWidget {
  final HomePageStyles homePageStyles;
  final Function(int) onNavItemPressHandler;

  const HomeView({
    Key key,
    this.homePageStyles,
    this.onNavItemPressHandler,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<HomeView> {
  SettingsDataProvider _settingsDataProvider;
  int touchedIndex;

  @override
  void initState() {
    super.initState();

    _settingsDataProvider = SettingsDataProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (TransactionHistoryProvider.of(context).transactionHistoryState.totalTransactionAmountStream == null)
        TransactionHistoryProvider.of(context)
            .getTotalTransactionAmountStream(UserProvider.of(context).userState.userModel.id);
      if (TransactionHistoryProvider.of(context).transactionHistoryState.transactionListStream == null)
        TransactionHistoryProvider.of(context).getTransactioinListStream(
          UserProvider.of(context).userState.userModel.id,
          UserProvider.of(context).userState.userModel.customerReferenceNo,
          5,
        );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackColor2,
      body: KeicyInkWell(
        child: Container(
          height: widget.homePageStyles.mainHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _containerHeader(context),
              SizedBox(height: widget.homePageStyles.widthDp * 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.homePageStyles.widthDp * 20,
                        ),
                        child: _containerRatesInfo(context),
                      ),
                      SizedBox(height: widget.homePageStyles.widthDp * 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.homePageStyles.widthDp * 20,
                          // vertical: widget.homePageStyles.widthDp * 20,
                        ),
                        child: _containerLimit(context),
                      ),
                      SizedBox(height: widget.homePageStyles.widthDp * 10),
                      _containerRecentTransaction(context),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: widget.homePageStyles.widthDp * 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Consumer<TransactionHistoryProvider>(builder: (context, transactionHistoryProvider, _) {
      return StreamBuilder<double>(
          stream: transactionHistoryProvider.transactionHistoryState.totalTransactionAmountStream,
          builder: (context, snapshot) {
            double value = 0;
            if (!snapshot.hasData) {
              value = 0;
            } else {
              value = snapshot.data;
            }

            return Container(
              height: widget.homePageStyles.widthDp * 160,
              decoration: BoxDecoration(
                gradient: AppColors.mainGradient,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(widget.homePageStyles.widthDp * 40)),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.homePageStyles.widthDp * 25,
                vertical: widget.homePageStyles.widthDp * 25,
              ),
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.sort, size: widget.homePageStyles.widthDp * 30, color: AppColors.whiteColor),
                  SizedBox(height: widget.homePageStyles.widthDp * 30),
                  Text(
                    "Total Spend: \$${value.toStringAsFixed(2)}",
                    style: widget.homePageStyles.titleStyle,
                  ),
                ],
              ),
            );
          });
    });
  }

  Widget _containerRatesInfo(BuildContext context) {
    _settingsDataProvider.settingsDataState.ratesInfo.sort((a, b) {
      return (a["min"] > b["min"]) ? 1 : -1;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(HomePageString.ratesInfoLabel, style: widget.homePageStyles.labelStyle),
        SizedBox(height: widget.homePageStyles.widthDp * 5),
        Container(
          height: widget.homePageStyles.widthDp * 124,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var data = _settingsDataProvider.settingsDataState.ratesInfo[index];
              return Container(
                width: widget.homePageStyles.widthDp * 160,
                height: widget.homePageStyles.widthDp * 124,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.homePageStyles.widthDp * 20),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.homePageStyles.widthDp * 12,
                  vertical: widget.homePageStyles.widthDp * 18,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.moneyIcon,
                      width: widget.homePageStyles.widthDp * 30,
                      height: widget.homePageStyles.widthDp * 30,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "\$${data['min']}-${data['max'] == -1 ? '' : '\$'}${data['max'] == -1 ? 'Unlimited' : data['max']}",
                      style: widget.homePageStyles.labelStyle,
                    ),
                    Text("Fee: \$${data['fee']}", style: widget.homePageStyles.feeTextStyle),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: widget.homePageStyles.widthDp * 15);
            },
            itemCount: _settingsDataProvider.settingsDataState.ratesInfo.length,
          ),
        ),
      ],
    );
  }

  Widget _containerLimit(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, _) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.homePageStyles.widthDp * 20,
          // vertical: widget.homePageStyles.widthDp * 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(widget.homePageStyles.widthDp * 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: widget.homePageStyles.widthDp * 10),
            Text(HomePageString.limitLabel, style: widget.homePageStyles.labelStyle),
            SizedBox(height: widget.homePageStyles.widthDp * 13),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(widget.homePageStyles.widthDp * 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
                    borderRadius: BorderRadius.circular(widget.homePageStyles.widthDp * 10),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.dailyIcon,
                        width: widget.homePageStyles.widthDp * 18,
                        height: widget.homePageStyles.widthDp * 18,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: widget.homePageStyles.widthDp * 7),
                      Text(
                        "Daily ${_settingsDataProvider.settingsDataState.cashLimits['daily']}",
                        style: widget.homePageStyles.limitTextStyle,
                      ),
                      SizedBox(width: widget.homePageStyles.widthDp * 12),
                      SvgPicture.asset(
                        AppAssets.monthIcon,
                        width: widget.homePageStyles.widthDp * 18,
                        height: widget.homePageStyles.widthDp * 18,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: widget.homePageStyles.widthDp * 7),
                      Text(
                        "Monthly ${_settingsDataProvider.settingsDataState.cashLimits['monthly']}",
                        style: widget.homePageStyles.limitTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(150)),
            // SizedBox(height: widget.homePageStyles.widthDp * 10),
            Consumer<UserProvider>(builder: (context, userProvider, _) {
              int monthlyAvailableAmount = _settingsDataProvider.settingsDataState.cashLimits['monthly'] -
                  userProvider.userState.userModel.monthlyCount;
              int currentAmount = userProvider.userState.userModel.monthlyCount;

              return Container(
                width: double.infinity,
                height: widget.homePageStyles.widthDp * 125,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: widget.homePageStyles.widthDp * 30),
                              Icon(
                                Icons.fiber_manual_record,
                                size: widget.homePageStyles.widthDp * 10,
                                color: AppColors.secondaryColor,
                              ),
                              SizedBox(width: widget.homePageStyles.widthDp * 10),
                              Text(
                                "Currrent $currentAmount",
                                style: TextStyle(
                                  fontSize: widget.homePageStyles.fontSp * 12,
                                  color: AppColors.blackColor,
                                  fontFamily: "Exo-SemiBold",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: widget.homePageStyles.widthDp * 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: widget.homePageStyles.widthDp * 30),
                              Icon(
                                Icons.fiber_manual_record,
                                size: widget.homePageStyles.widthDp * 10,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: widget.homePageStyles.widthDp * 10),
                              Text(
                                "Available $monthlyAvailableAmount",
                                style: TextStyle(
                                  fontSize: widget.homePageStyles.fontSp * 12,
                                  color: AppColors.blackColor,
                                  fontFamily: "Exo-SemiBold",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                  pieTouchResponse.touchInput is FlPanEnd) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex = pieTouchResponse.touchedSectionIndex;
                              }
                            });
                          }),
                          startDegreeOffset: 300,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: (currentAmount == 0 ||
                                  currentAmount == _settingsDataProvider.settingsDataState.cashLimits['monthly'])
                              ? 0
                              : widget.homePageStyles.widthDp * 4,
                          centerSpaceRadius: 0,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.secondaryColor,
                              value:
                                  100 * currentAmount / _settingsDataProvider.settingsDataState.cashLimits['monthly'],
                              title: '',
                              radius: widget.homePageStyles.widthDp * 45,
                              titleStyle:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff044d7c)),
                              titlePositionPercentageOffset: 0.55,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              color: AppColors.primaryColor,
                              value: 100 *
                                  monthlyAvailableAmount /
                                  _settingsDataProvider.settingsDataState.cashLimits['monthly'],
                              title: '',
                              radius: widget.homePageStyles.widthDp * 40,
                              titleStyle:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff90672d)),
                              titlePositionPercentageOffset: 0.55,
                              showTitle: false,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            return null;
        }
      },
    );
  }

  Widget _containerRecentTransaction(BuildContext context) {
    return Container(
      child: Consumer<TransactionHistoryProvider>(builder: (context, transactionHistoryProvider, _) {
        return StreamBuilder<List<Stream<Map<String, dynamic>>>>(
            stream: transactionHistoryProvider.transactionHistoryState.transactionListStream,
            builder: (context, transactionSnapshot) {
              if (!transactionSnapshot.hasData) {
                return Center(
                  child: KeicyCupertinoIndicator(),
                );
              }

              if (transactionSnapshot.data.length == 0) {
                return SizedBox();
                return Center(
                  child: Text("No Pending Transaction", style: widget.homePageStyles.textStyle),
                );
              }
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.homePageStyles.widthDp * 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: widget.homePageStyles.widthDp * 20,
                            fontFamily: "EXo-SemiBold",
                            color: AppColors.blackColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (widget.onNavItemPressHandler != null) widget.onNavItemPressHandler(2);
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                              fontSize: widget.homePageStyles.widthDp * 14,
                              fontFamily: "EXo-SemiBold",
                              color: Color(0xFF14A1F2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: widget.homePageStyles.widthDp * 5),
                  Column(
                    children: List<int>.generate(
                            transactionSnapshot.data.length < 2 ? transactionSnapshot.data.length : 2, (index) => index)
                        .map((index) {
                      return StreamBuilder<Map<String, dynamic>>(
                          stream: transactionSnapshot.data[index],
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: widget.homePageStyles.historyCardHeight,
                                child: Center(child: KeicyCupertinoIndicator()),
                              );
                            }

                            if (snapshot.data == null) {
                              return SizedBox();
                            }

                            TransactionModel transactionModel = snapshot.data["transactionModel"];
                            RecipientModel recipientModel = snapshot.data["recipientModel"];

                            return GestureDetector(
                              onTap: () {
                                if (widget.onNavItemPressHandler != null) widget.onNavItemPressHandler(2);
                              },
                              child: Container(
                                // height: widget.homePageStyles.historyCardHeight,
                                margin: EdgeInsets.all(widget.homePageStyles.widthDp * 15),
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.homePageStyles.widthDp * 20,
                                  vertical: widget.homePageStyles.widthDp * 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(widget.homePageStyles.widthDp * 15),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        KeicyAvatarImage(
                                          url: recipientModel.avatarUrl,
                                          userName: recipientModel.firstName,
                                          width: widget.homePageStyles.widthDp * 49,
                                          height: widget.homePageStyles.widthDp * 49,
                                          borderRadius: widget.homePageStyles.widthDp * 10,
                                          backColor: AppColors.recipientColor[index % AppColors.recipientColor.length]
                                              ["backColor"],
                                          textColor: AppColors.recipientColor[index % AppColors.recipientColor.length]
                                              ["textColor"],
                                        ),
                                        SizedBox(width: widget.homePageStyles.widthDp * 15),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              recipientModel.firstName,
                                              style: widget.homePageStyles.textStyle,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: widget.homePageStyles.widthDp * 5),
                                            Text(
                                              "${KeicyDateTime.convertMillisecondsToDateString(ms: transactionModel.ts)}",
                                              style: widget.homePageStyles.birthDayStyle,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "\$${transactionModel.amount}",
                                            style: widget.homePageStyles.amountStyle,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          transactionModel.jubaReferenceNum == ""
                                              ? Text(
                                                  transactionModel.transactioinErrorString,
                                                  style: transactionModel.state == 0
                                                      ? widget.homePageStyles.pendingStyle
                                                      : widget.homePageStyles.sentStyle,
                                                  overflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.right,
                                                  maxLines: 3,
                                                )
                                              : StreamBuilder<Map<String, dynamic>>(
                                                  stream: Stream.fromFuture(
                                                    SendRemittanceStatusDataProvider.getSendRemittanceStatus(
                                                      referenceNum: transactionModel.jubaReferenceNum,
                                                    ),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return SizedBox();
                                                    }

                                                    if (snapshot.data == null) {
                                                      return SizedBox();
                                                    }

                                                    Map<String, dynamic> jubaTransactionState = snapshot.data;

                                                    return Text(
                                                      AppConstants.jubaTransactionState[jubaTransactionState["Data"][0]
                                                          ["Status"]],
                                                      style: transactionModel.state == 0
                                                          ? widget.homePageStyles.pendingStyle
                                                          : widget.homePageStyles.sentStyle,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center,
                                                    );
                                                  },
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }).toList(),
                  ),
                ],
              );
            });
      }),
    );
  }

  Widget _containerCashLimits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(HomePageString.cashLimitsLabel, style: widget.homePageStyles.labelStyle),
        SizedBox(height: widget.homePageStyles.widthDp * 10),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// hearder
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: widget.homePageStyles.widthDp * 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(150), width: 1)),
                    ),
                    child: Text(HomePageString.limitTypeLabel, style: widget.homePageStyles.textStyle),
                  ),

                  /// first row
                  SizedBox(height: widget.homePageStyles.widthDp * 20),
                  Text(
                    HomePageString.dailyLabel,
                    style: widget.homePageStyles.textStyle,
                  ),

                  /// second row
                  SizedBox(height: widget.homePageStyles.widthDp * 20),
                  Text(
                    HomePageString.monthlyLabel,
                    style: widget.homePageStyles.textStyle,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                /// hearder
                Container(
                  padding: EdgeInsets.symmetric(vertical: widget.homePageStyles.widthDp * 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.withAlpha(150), width: 1)),
                  ),
                  child: Text(HomePageString.limitNumberLabel, style: widget.homePageStyles.textStyle),
                ),

                /// first row
                SizedBox(height: widget.homePageStyles.widthDp * 20),
                Text(
                  "${_settingsDataProvider.settingsDataState.cashLimits['daily'] ?? ''}",
                  style: widget.homePageStyles.textStyle,
                ),

                /// second row
                SizedBox(height: widget.homePageStyles.widthDp * 20),
                Text(
                  "${_settingsDataProvider.settingsDataState.cashLimits['monthly'] ?? ''}",
                  style: widget.homePageStyles.textStyle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
