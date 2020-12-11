import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/CreditCardPage/index.dart';
import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';
import 'package:money_transfer_app/Providers/TransactionHistoryProvider/transaction_history_provider.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_avatar_image/keicy_avatar_image.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_utils/date_time_convert.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';
import 'package:money_transfer_app/DataProviders/index.dart';

import 'index.dart';

class TransactionHistoryView extends StatefulWidget {
  final TransactionHistoryPageStyles transactionHistoryPageStyles;

  const TransactionHistoryView({
    Key key,
    this.transactionHistoryPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<TransactionHistoryView> with TickerProviderStateMixin {
  TransactionHistoryProvider _transactionHistoryProvider;
  KeicyProgressDialog _keicyProgressDialog;

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _transactionHistoryProvider = TransactionHistoryProvider.of(context);

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    _transactionHistoryProvider.setTransactionHistoryState(
      _transactionHistoryProvider.transactionHistoryState.update(progressState: 0, errorString: ""),
      isNotifiable: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _transactionHistoryProvider.addListener(_transactionHistoryProviderListener);

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.transactionHistoryPageStyles.widthDp * 120,
        height: widget.transactionHistoryPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.transactionHistoryPageStyles.widthDp * 120,
          height: widget.transactionHistoryPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.transactionHistoryPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.transactionHistoryPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.transactionHistoryPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );

      if (_transactionHistoryProvider.transactionHistoryState.transactionListStream == null)
        _transactionHistoryProvider.getTransactioinListStream(
          UserProvider.of(context).userState.userModel.id,
          UserProvider.of(context).userState.userModel.customerReferenceNo,
          5,
        );
    });
  }

  @override
  void dispose() {
    _transactionHistoryProvider.removeListener(_transactionHistoryProviderListener);

    super.dispose();
  }

  void _transactionHistoryProviderListener() async {
    if (_transactionHistoryProvider.transactionHistoryState.progressState != 1 && _keicyProgressDialog.isShowing()) {
      await _keicyProgressDialog.hide();
    }

    switch (_transactionHistoryProvider.transactionHistoryState.progressState) {
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
      backgroundColor: AppColors.scaffoldBackColor2,
      body: KeicyInkWell(
        child: Container(
          height: widget.transactionHistoryPageStyles.mainHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                title: TransactionHistoryPageString.title,
                widthDp: widget.transactionHistoryPageStyles.widthDp,
                fontSp: widget.transactionHistoryPageStyles.fontSp,
                haveBackIcon: false,
              ),
              SizedBox(height: widget.transactionHistoryPageStyles.widthDp * 20),
              Expanded(
                child: _containerTransactionList(context),
              ),
              SizedBox(height: widget.transactionHistoryPageStyles.widthDp * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerTransactionList(BuildContext context) {
    return Consumer<TransactionHistoryProvider>(builder: (context, transactionHistoryProvider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<Stream<Map<String, dynamic>>>>(
                stream: transactionHistoryProvider.transactionHistoryState.transactionListStream,
                builder: (context, transactionSnapshot) {
                  if (!transactionSnapshot.hasData) {
                    return Center(
                      child: KeicyCupertinoIndicator(),
                    );
                  }

                  if (transactionSnapshot.data.length == 0) {
                    return Center(
                      child: Text("No Pending Transaction", style: widget.transactionHistoryPageStyles.textStyle),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    addRepaintBoundaries: false,
                    itemBuilder: (context, index) {
                      return StreamBuilder<Map<String, dynamic>>(
                        stream: transactionSnapshot.data[index],
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: widget.transactionHistoryPageStyles.historyCardHeight,
                              child: Center(child: KeicyCupertinoIndicator()),
                            );
                          }

                          if (snapshot.data == null) {
                            return SizedBox();
                          }

                          TransactionModel transactionModel = snapshot.data["transactionModel"];
                          RecipientModel recipientModel = snapshot.data["recipientModel"];

                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: widget.transactionHistoryPageStyles.historyCardHorizontalPadding,
                              ),
                              child: Container(
                                // height: widget.transactionHistoryPageStyles.historyCardHeight,
                                margin: EdgeInsets.all(widget.transactionHistoryPageStyles.widthDp * 5),
                                padding: EdgeInsets.symmetric(
                                  horizontal: widget.transactionHistoryPageStyles.widthDp * 20,
                                  vertical: widget.transactionHistoryPageStyles.widthDp * 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(widget.transactionHistoryPageStyles.widthDp * 15),
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
                                          width: widget.transactionHistoryPageStyles.widthDp * 49,
                                          height: widget.transactionHistoryPageStyles.widthDp * 49,
                                          borderRadius: widget.transactionHistoryPageStyles.widthDp * 10,
                                          backColor: AppColors.recipientColor[index % AppColors.recipientColor.length]
                                              ["backColor"],
                                          textColor: AppColors.recipientColor[index % AppColors.recipientColor.length]
                                              ["textColor"],
                                        ),
                                        SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 15),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              recipientModel.firstName,
                                              style: widget.transactionHistoryPageStyles.textStyle,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: widget.transactionHistoryPageStyles.widthDp * 5),
                                            Text(
                                              "${KeicyDateTime.convertMillisecondsToDateString(ms: transactionModel.ts)}",
                                              style: widget.transactionHistoryPageStyles.birthDayStyle,
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
                                            style: widget.transactionHistoryPageStyles.amountStyle,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          transactionModel.jubaReferenceNum == ""
                                              ? Text(
                                                  transactionModel.transactioinErrorString,
                                                  style: transactionModel.state == 0
                                                      ? widget.transactionHistoryPageStyles.pendingStyle
                                                      : widget.transactionHistoryPageStyles.sentStyle,
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
                                                      if (!snapshot.hasData) {
                                                        return SizedBox();
                                                      }
                                                    }

                                                    if (snapshot.data == null) {
                                                      return SizedBox();
                                                    }

                                                    Map<String, dynamic> jubaTransactionState = snapshot.data;

                                                    return Text(
                                                      AppConstants.jubaTransactionState[jubaTransactionState["Data"][0]
                                                          ["Status"]],
                                                      style: transactionModel.state == 0
                                                          ? widget.transactionHistoryPageStyles.pendingStyle
                                                          : widget.transactionHistoryPageStyles.sentStyle,
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
                            ),
                          );
                        },
                      );
                    },
                    // separatorBuilder: (context, index) {
                    //   return SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 10);
                    // },
                    itemCount: transactionSnapshot.data.length,
                  );
                }),
          ),
        ],
      );
    });
  }
}
