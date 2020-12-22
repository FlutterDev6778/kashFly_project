import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/MyBankPage/my_bank_page.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class CreditCardView extends StatefulWidget {
  final CreditCardPageStyles creditCardPageStyles;
  final bool isSelectable;

  const CreditCardView({
    Key key,
    this.creditCardPageStyles,
    this.isSelectable,
  }) : super(key: key);

  @override
  _CreditCardViewState createState() => _CreditCardViewState();
}

class _CreditCardViewState extends State<CreditCardView> with TickerProviderStateMixin {
  PaymentMethodProvider _paymentMethodProvider;
  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;
  String _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _paymentMethodProvider = PaymentMethodProvider.of(context);
    _userProvider = UserProvider.of(context);

    _selectedPaymentMethod = _userProvider.userState.userModel.seledtedPaymentMethod;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_paymentMethodProvider.paymentMethodState.paymentMethodListStream == null) {
        _paymentMethodProvider.getPaymentMethodDataStream(UserProvider.of(context).userState.userModel.id);
      }

      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        width: widget.creditCardPageStyles.widthDp * 120,
        padding: EdgeInsets.zero,
        height: widget.creditCardPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.creditCardPageStyles.widthDp * 120,
          height: widget.creditCardPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.creditCardPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.creditCardPageStyles.widthDp * 80,
          ),
        ),
        message: "",
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
      body: Column(
        children: [
          HeaderWidget(
            title: CreditCardPageString.title,
            widthDp: widget.creditCardPageStyles.widthDp,
            fontSp: widget.creditCardPageStyles.fontSp,
            haveBackIcon: true,
            onPressHandler: () async {
              if (_selectedPaymentMethod != _userProvider.userState.userModel.seledtedPaymentMethod) {
                await _keicyProgressDialog.show();

                UserModel _userModel = UserModel.fromJson(_userProvider.userState.userModel.toJson());
                _userModel.seledtedPaymentMethod = _selectedPaymentMethod;

                await _userProvider.saveUserData(
                  userID: _userProvider.userState.userModel.id,
                  userModel: _userModel,
                );

                _keicyProgressDialog.hide();
              }
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: widget.creditCardPageStyles.widthDp * 20),
          _containerAddNewCard(context),
          SizedBox(height: widget.creditCardPageStyles.widthDp * 30),
          // _containerActions(context),
          SizedBox(height: widget.creditCardPageStyles.widthDp * 10),
          Expanded(child: _containerPaymentMethodList(context)),
        ],
      ),
    );
  }

  Widget _containerAddNewCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.creditCardPageStyles.primaryHorizontalPadding,
      ),
      child: GestureDetector(
        onTap: () async {
          // enterCardDetails();
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => MyBankPage(isNewInfo: false)),
          );
          setState(() {
            _selectedPaymentMethod = _userProvider.userState.userModel.seledtedPaymentMethod;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.creditCardPageStyles.cardHorizontalPadding,
            vertical: widget.creditCardPageStyles.cardVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(widget.creditCardPageStyles.cardBorderRadius)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(150),
                offset: Offset(0, 3),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: widget.creditCardPageStyles.cardHeight,
                height: widget.creditCardPageStyles.cardHeight,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(widget.creditCardPageStyles.cardHeight / 2)),
                ),
                child: Icon(FontAwesomeIcons.wallet, color: AppColors.blackColor),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(CreditCardPageString.addCardLabel, style: widget.creditCardPageStyles.textStyle),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void enterCardDetails({bool isAddCard = true, int index = -1, CreditCard creditCard}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: ViewCard(
            creditCardPageStyles: widget.creditCardPageStyles,
            isAddCard: isAddCard,
            index: index,
            creditCard: creditCard != null ? creditCard : CreditCard(),
          ),
        );
      },
    );
  }

  Widget _containerPaymentMethodList(BuildContext context) {
    return Consumer<PaymentMethodProvider>(
      builder: (context, paymentMethodProvider, _) {
        return StreamBuilder<List<dynamic>>(
          stream: paymentMethodProvider.paymentMethodState.paymentMethodListStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: KeicyCupertinoIndicator());
            if (snapshot.data.length == 0) return SizedBox();

            return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                PaymentMethod _paymentMethod = PaymentMethod.fromJson(snapshot.data[index]);

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.creditCardPageStyles.primaryHorizontalPadding,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedPaymentMethod != _paymentMethod.id) {
                        setState(() {
                          _selectedPaymentMethod = _paymentMethod.id;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.creditCardPageStyles.cardHorizontalPadding,
                        vertical: widget.creditCardPageStyles.cardVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: (_selectedPaymentMethod == _paymentMethod.id) ? Color(0xFFAADAFF) : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(widget.creditCardPageStyles.cardBorderRadius)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(150),
                            offset: Offset(0, 3),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: widget.creditCardPageStyles.cardHeight,
                            height: widget.creditCardPageStyles.cardHeight,
                            decoration: BoxDecoration(
                              // color: Colors.grey.withAlpha(150),
                              borderRadius: BorderRadius.all(Radius.circular(widget.creditCardPageStyles.cardHeight / 2)),
                            ),
                            child: Image.asset(
                              "lib/Assets/Images/Cards/${_paymentMethod.card.brand}.png",
                              width: widget.creditCardPageStyles.cardHeight,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text("xxxx-xxxx-xxxx-" + _paymentMethod.card.last4, style: widget.creditCardPageStyles.textStyle),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (widget.isSelectable) {
                                enterCardDetails(
                                  isAddCard: false,
                                  index: index,
                                  creditCard: _paymentMethod.card,
                                );
                              } else {
                                await _paymentMethodProvider.deleteCreditCard(
                                  UserProvider.of(context),
                                  _paymentMethod.card.toJson(),
                                  index,
                                );

                                showDeleteSuccessDialog();

                                setState(() {
                                  _selectedPaymentMethod = _userProvider.userState.userModel.seledtedPaymentMethod;
                                });
                              }
                            },
                            child: (widget.isSelectable)
                                ? Text("View", style: widget.creditCardPageStyles.linkStyle)
                                : Icon(
                                    Icons.delete,
                                    color: AppColors.blackColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, indes) {
                return SizedBox(height: widget.creditCardPageStyles.widthDp * 10);
              },
              itemCount: snapshot.data.length,
            );
          },
        );
      },
    );
  }

  void showDeleteSuccessDialog() {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Successfully deleted',
      titleOptions: StatusAlertTextConfiguration(
        style: TextStyle(fontSize: widget.creditCardPageStyles.fontSp * 16, color: AppColors.blackColor),
      ),
      margin: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 60),
      padding: EdgeInsets.all(widget.creditCardPageStyles.widthDp * 20),
      configuration: IconConfiguration(
        icon: Icons.check_circle_outline,
        color: AppColors.primaryColor,
        size: widget.creditCardPageStyles.widthDp * 80,
      ),
      blurPower: 3,
      backgroundColor: Colors.white,
    );
  }
}
