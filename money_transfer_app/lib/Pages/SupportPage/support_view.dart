import 'package:flutter/material.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class SupportView extends StatefulWidget {
  final SupportPageStyles supportPageStyles;

  const SupportView({
    Key key,
    this.supportPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<SupportView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: SupportPageString.title,
              widthDp: widget.supportPageStyles.widthDp,
              fontSp: widget.supportPageStyles.fontSp,
              haveBackIcon: true,
            ),
            SizedBox(height: widget.supportPageStyles.widthDp * 10),
            Expanded(child: _containerText(context)),
            SizedBox(height: widget.supportPageStyles.widthDp * 10),
          ],
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.supportPageStyles.primaryHorizontalPadding,
        vertical: widget.supportPageStyles.primaryVerticalPadding,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.all(widget.supportPageStyles.widthDp * 8),
              child: Icon(Icons.arrow_back_ios, size: widget.supportPageStyles.widthDp * 20, color: AppColors.blackColor),
            ),
          ),
          SizedBox(width: widget.supportPageStyles.widthDp * 20),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: SupportPageString.title.substring(0, 1), style: widget.supportPageStyles.title1Style),
                TextSpan(text: SupportPageString.title.substring(1), style: widget.supportPageStyles.title2Style),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerText(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.supportPageStyles.primaryHorizontalPadding,
        ),
        child: Text(
          SettingsDataProvider.of(context).settingsDataState.supportText,
          style: widget.supportPageStyles.labelStyle,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
