import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keicy_raised_button/keicy_raised_button.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/LoginPage/index.dart';

import 'index.dart';

class LandingView extends StatefulWidget {
  const LandingView({
    Key key,
    this.landingPageStyles,
  }) : super(key: key);

  final LandingPageStyles landingPageStyles;

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: widget.landingPageStyles.mainHeight,
          child: Stack(
            children: [
              Container(
                child: Image.asset(
                  AppAssets.backImg,
                  width: widget.landingPageStyles.deviceWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: widget.landingPageStyles.widthDp * 300),
                  SvgPicture.asset(
                    AppAssets.bannerTextImg,
                    height: widget.landingPageStyles.widthDp * 70,
                    fit: BoxFit.fitHeight,
                    allowDrawingOutsideViewBox: true,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          AppAssets.landingBackImg,
                          fit: BoxFit.fill,
                          width: widget.landingPageStyles.deviceWidth - widget.landingPageStyles.widthDp * 20,
                          // fit: BoxFit.fitWidth,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widget.landingPageStyles.widthDp * 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KeicyRaisedButton(
                          width: widget.landingPageStyles.widthDp * 158,
                          height: widget.landingPageStyles.widthDp * 40,
                          borderRadius: widget.landingPageStyles.widthDp * 15,
                          color: AppColors.secondaryColor,
                          child: Text(
                            "Log in",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widget.landingPageStyles.widthDp * 10),
                          elevation: 0,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) => LoginPage(selectedTap: 0)),
                            );
                          },
                        ),
                        KeicyRaisedButton(
                          width: widget.landingPageStyles.widthDp * 158,
                          height: widget.landingPageStyles.widthDp * 40,
                          borderRadius: widget.landingPageStyles.widthDp * 15,
                          color: Color(0xFFF7A000),
                          child: Text(
                            "New Account",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: widget.landingPageStyles.widthDp * 10),
                          elevation: 0,
                          gradient: AppColors.mainGradient,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) => LoginPage(selectedTap: 1)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: widget.landingPageStyles.widthDp * 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
