import 'package:flutter/material.dart';
import '../App/index.dart';

class HeaderWidget extends StatelessWidget {
  final double height;
  final String title;
  final Widget titleWidget;
  final double widthDp;
  final double fontSp;
  final bool haveBackIcon;
  final Widget iconWidget;
  final int iconType;
  final Function onPressHandler;

  HeaderWidget({
    this.height,
    @required this.title,
    this.titleWidget,
    @required this.widthDp,
    @required this.fontSp,
    @required this.haveBackIcon,
    this.iconWidget,
    this.iconType = 0,
    this.onPressHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? widthDp * 160,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(widthDp * 40)),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: widthDp * 58),
          (!haveBackIcon)
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    if (onPressHandler != null) {
                      onPressHandler();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: iconWidget ??
                      Container(
                        width: widthDp * 63,
                        height: widthDp * 34,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(widthDp * 10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(iconType == 1 ? Icons.close : Icons.arrow_back_ios, size: widthDp * 20, color: AppColors.blackColor),
                            SizedBox(width: widthDp * 14),
                          ],
                        ),
                      ),
                ),
          Expanded(
            child: titleWidget ??
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widthDp * 25,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: fontSp * 20, color: AppColors.whiteColor, fontFamily: "Exo-SemiBold"),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
