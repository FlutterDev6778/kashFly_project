import 'package:flutter/material.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class AboutView extends StatefulWidget {
  final AboutPageStyles aboutPageStyles;

  const AboutView({
    Key key,
    this.aboutPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<AboutView> {
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
      backgroundColor: AppColors.scaffoldBackColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: AboutPageString.title,
              widthDp: widget.aboutPageStyles.widthDp,
              fontSp: widget.aboutPageStyles.fontSp,
              haveBackIcon: true,
            ),
            SizedBox(height: widget.aboutPageStyles.widthDp * 10),
            Expanded(child: _containerText(context)),
            SizedBox(height: widget.aboutPageStyles.widthDp * 10),
          ],
        ),
      ),
    );
  }

  Widget _containerHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.aboutPageStyles.primaryHorizontalPadding,
        vertical: widget.aboutPageStyles.primaryVerticalPadding,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.all(widget.aboutPageStyles.widthDp * 8),
              child: Icon(Icons.arrow_back_ios, size: widget.aboutPageStyles.widthDp * 20, color: AppColors.blackColor),
            ),
          ),
          SizedBox(width: widget.aboutPageStyles.widthDp * 20),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: AboutPageString.title.substring(0, 1), style: widget.aboutPageStyles.title1Style),
                TextSpan(text: AboutPageString.title.substring(1), style: widget.aboutPageStyles.title2Style),
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
          horizontal: widget.aboutPageStyles.primaryHorizontalPadding,
        ),
        child: Text(
          SettingsDataProvider.of(context).settingsDataState.aboutText,
          style: widget.aboutPageStyles.labelStyle,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
