import 'package:flutter/material.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/Components/index.dart';
import 'package:money_transfer_app/Pages/SSNPage/ssn_page.dart';
import 'package:money_transfer_app/Pages/UploadDocumentPage/index.dart';
import 'index.dart';

class DocumentCategoryView extends StatefulWidget {
  final DocumentCategoryPageStyles documentCategoryPageStyles;

  const DocumentCategoryView({
    Key key,
    this.documentCategoryPageStyles,
  }) : super(key: key);

  @override
  _TransferViewState createState() => _TransferViewState();
}

class _TransferViewState extends State<DocumentCategoryView> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(
            title: DocumentCategoryPageString.title,
            widthDp: widget.documentCategoryPageStyles.widthDp,
            fontSp: widget.documentCategoryPageStyles.fontSp,
            haveBackIcon: true,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.documentCategoryPageStyles.primaryHorizontalPadding,
                vertical: widget.documentCategoryPageStyles.primaryVerticalPadding,
              ),
              child: _containerItems(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _containerItems(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SSNPage(documentType: DocumentCategoryPageString.itemList[index]),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UploadDocumentPage(documentType: DocumentCategoryPageString.itemList[index]),
                ),
              );
            }
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: widget.documentCategoryPageStyles.widthDp * 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DocumentCategoryPageString.itemList[index]["title"], style: widget.documentCategoryPageStyles.labelStyle),
                        (DocumentCategoryPageString.itemList[index]["description"] == "")
                            ? SizedBox()
                            : SizedBox(height: widget.documentCategoryPageStyles.widthDp * 5),
                        (DocumentCategoryPageString.itemList[index]["description"] == "")
                            ? SizedBox()
                            : Text(DocumentCategoryPageString.itemList[index]["description"],
                                style: widget.documentCategoryPageStyles.descriptionStyle),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: widget.documentCategoryPageStyles.iconSize, color: AppColors.blackColor),
                  ],
                ),
                SizedBox(height: widget.documentCategoryPageStyles.widthDp * 20),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1, thickness: 1, color: Colors.grey.withAlpha(100));
      },
      itemCount: DocumentCategoryPageString.itemList.length,
    );
  }
}
