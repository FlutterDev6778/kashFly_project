import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:money_transfer_app/Pages/Components/header_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';

import 'package:keicy_raised_button/keicy_raised_button.dart';
import 'package:keicy_inkwell/keicy_inkwell.dart';
import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
import 'package:keicy_utils/date_time_convert.dart';
import 'package:keicy_utils/validators.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class NotificationView extends StatefulWidget {
  final NotificationPageStyles notificationPageStyles;

  const NotificationView({
    Key key,
    this.notificationPageStyles,
  }) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> with TickerProviderStateMixin {
  UserProvider _userProvider;
  KeicyProgressDialog _keicyProgressDialog;

  bool _notificaitonPermission;
  bool _emailPermission;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider.of(context);

    _userProvider.setUserState(
      _userProvider.userState.update(
        progressState: 0,
        errorString: "",
      ),
      isNotifiable: false,
    );

    _notificaitonPermission = _userProvider.userState.userModel.notificaitonPermission;
    _emailPermission = _userProvider.userState.userModel.emailPermission;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _keicyProgressDialog = KeicyProgressDialog.of(
        context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        layout: Layout.Column,
        padding: EdgeInsets.zero,
        width: widget.notificationPageStyles.widthDp * 120,
        height: widget.notificationPageStyles.widthDp * 120,
        progressWidget: Container(
          width: widget.notificationPageStyles.widthDp * 120,
          height: widget.notificationPageStyles.widthDp * 120,
          padding: EdgeInsets.all(widget.notificationPageStyles.widthDp * 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.notificationPageStyles.widthDp * 10),
          ),
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: widget.notificationPageStyles.widthDp * 80,
          ),
        ),
        message: "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeicyInkWell(
        child: Column(
          children: [
            HeaderWidget(
              title: NotificationPageString.title,
              widthDp: widget.notificationPageStyles.widthDp,
              fontSp: widget.notificationPageStyles.fontSp,
              haveBackIcon: true,
            ),
            Expanded(
              child: Column(
                children: [
                  _conainerNotification(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conainerNotification(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.notificationPageStyles.primaryHorizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widget.notificationPageStyles.widthDp * 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(NotificationPageString.pushNotificationLabel, style: widget.notificationPageStyles.labelTextStyle),
              Switch(
                value: _notificaitonPermission,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    _notificaitonPermission = value;
                  });
                  StatusAlert.show(
                    context,
                    duration: Duration(seconds: 2),
                    blurPower: 3,
                    backgroundColor: Colors.white,
                    title: 'Successfully saved',
                    titleOptions: StatusAlertTextConfiguration(
                      style: TextStyle(fontSize: widget.notificationPageStyles.fontSp * 16, color: AppColors.blackColor),
                    ),
                    margin: EdgeInsets.all(widget.notificationPageStyles.widthDp * 80),
                    padding: EdgeInsets.all(widget.notificationPageStyles.widthDp * 20),
                    configuration: IconConfiguration(
                      icon: Icons.check_circle_outline,
                      color: AppColors.primaryColor,
                      size: widget.notificationPageStyles.widthDp * 80,
                    ),
                  );
                  _userProvider.saveUserData(
                    userID: _userProvider.userState.userModel.id,
                    data: {
                      "permissions": {
                        "notificaitonPermission": _notificaitonPermission,
                        "emailPermission": _emailPermission,
                      },
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: widget.notificationPageStyles.widthDp * 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(NotificationPageString.emailNotificationLabel, style: widget.notificationPageStyles.labelTextStyle),
              Switch(
                value: _emailPermission,
                activeColor: AppColors.primaryColor,
                onChanged: (value) async {
                  setState(() {
                    _emailPermission = value;
                  });
                  StatusAlert.show(
                    context,
                    duration: Duration(seconds: 2),
                    blurPower: 3,
                    backgroundColor: Colors.white,
                    title: 'Successfully saved',
                    titleOptions: StatusAlertTextConfiguration(
                      style: TextStyle(fontSize: widget.notificationPageStyles.fontSp * 16, color: AppColors.blackColor),
                    ),
                    margin: EdgeInsets.all(widget.notificationPageStyles.widthDp * 80),
                    padding: EdgeInsets.all(widget.notificationPageStyles.widthDp * 20),
                    configuration: IconConfiguration(
                      icon: Icons.check_circle_outline,
                      color: AppColors.primaryColor,
                      size: widget.notificationPageStyles.widthDp * 80,
                    ),
                  );
                  _userProvider.saveUserData(
                    userID: _userProvider.userState.userModel.id,
                    data: {
                      "permissions": {
                        "notificaitonPermission": _notificaitonPermission,
                        "emailPermission": _emailPermission,
                      },
                    },
                  );
                },
              ),
            ],
          ),

          /// button
          // SizedBox(height: widget.notificationPageStyles.widthDp * 60),
          // KeicyRaisedButton(
          //   height: widget.notificationPageStyles.widthDp * 50,
          //   color: AppColors.primaryColor,
          //   borderRadius: widget.notificationPageStyles.textFieldBorderRadius,
          //   child: Text(
          //     NotificationPageString.saveButton,
          //     style: widget.notificationPageStyles.buttonTextStyle,
          //   ),
          //   onPressed: () {
          //     _saveHandler(context);
          //   },
          // ),
        ],
      ),
    );
  }

  void _saveHandler(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.of(context).pop();
  }
}
