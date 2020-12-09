import 'package:flutter/material.dart';

import 'package:money_transfer_app/Pages/ChangePinCodePage/change_pin_code_page.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/DocumentCategoryPage/index.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/MyInfoPage/index.dart';
import 'package:money_transfer_app/Pages/SSNPage/index.dart';
import 'package:money_transfer_app/Pages/UploadDocumentPage/index.dart';
import 'package:money_transfer_app/Providers/index.dart';

import 'index.dart';

class PersonalInfoView extends StatefulWidget {
  final PersonalInfoPageStyles personalInfoPageStyles;

  const PersonalInfoView({
    Key key,
    this.personalInfoPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<PersonalInfoView> {
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
              title: PersonalInfoPageString.title,
              widthDp: widget.personalInfoPageStyles.widthDp,
              fontSp: widget.personalInfoPageStyles.fontSp,
              haveBackIcon: true,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.personalInfoPageStyles.primaryHorizontalPadding,
                  vertical: widget.personalInfoPageStyles.primaryVerticalPadding,
                ),
                child: _containerItems(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerItems(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Function _onTapHandler;
        Widget icon = SizedBox();

        switch (index) {
          case 0:
            _onTapHandler = () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => MyInfoPage(
                    userModel: UserProvider.of(context).userState.userModel,
                    isNewInfo: false,
                    haveNavbar: true,
                  ),
                ),
              );
            };
            break;
          case 1:
            _onTapHandler = () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ChangePinCodePage()),
              );
            };
            break;
          case 2:
            _onTapHandler = () {
              if (UserProvider.of(context).userState.userModel.totalAmount >= 3000) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => SSNPage(documentType: DocumentCategoryPageString.itemList[1]),
                  ),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        UploadDocumentPage(documentType: DocumentCategoryPageString.itemList[0]),
                  ),
                );
              }
            };
            break;
          default:
        }

        return GestureDetector(
          onTap: _onTapHandler,
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: widget.personalInfoPageStyles.widthDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        icon,
                        SizedBox(width: widget.personalInfoPageStyles.widthDp * 10),
                        Text(PersonalInfoPageString.itemList[index], style: widget.personalInfoPageStyles.labelStyle),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: widget.personalInfoPageStyles.iconSize,
                        color: (PersonalInfoPageString.itemList[index] == "Sign Out")
                            ? Colors.transparent
                            : AppColors.blackColor),
                  ],
                ),
                SizedBox(height: widget.personalInfoPageStyles.widthDp * 20),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(100));
      },
      itemCount: PersonalInfoPageString.itemList.length,
    );
  }
}
