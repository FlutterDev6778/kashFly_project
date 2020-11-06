import 'package:flutter/material.dart';
import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/Components/searchable_dropdown.dart';
import 'package:money_transfer_app/Pages/PersonalDetailPage/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

class AddressDetails extends StatelessWidget {
  final PersonalDetailPageStyles personalDetailPageStyles;
  final List<DropdownMenuItem<dynamic>> stateItemList;
  final List<DropdownMenuItem<dynamic>> cityItemList;
  final String state;
  final String city;
  final Function onstateChanged;
  final Function oncityChanged;
  final bool validateStarted;
  final TextEditingController addressController;
  final FocusNode addressFocusNode;
  final TextEditingController streetController;
  final FocusNode streetFocusNode;
  final TextEditingController aptController;
  final FocusNode aptFocusNode;
  final TextEditingController zipCodeController;
  final FocusNode zipCodeFocusNode;

  AddressDetails({
    @required this.personalDetailPageStyles,
    @required this.stateItemList,
    @required this.cityItemList,
    @required this.state,
    @required this.city,
    @required this.onstateChanged,
    @required this.oncityChanged,
    @required this.validateStarted,
    @required this.addressController,
    @required this.addressFocusNode,
    @required this.streetController,
    @required this.streetFocusNode,
    @required this.aptController,
    @required this.aptFocusNode,
    @required this.zipCodeController,
    @required this.zipCodeFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// divider
        SizedBox(height: personalDetailPageStyles.widthDp * 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider(height: 1, thickness: 1, color: Colors.grey)),
            SizedBox(width: personalDetailPageStyles.widthDp * 20),
            Text(PersonalDetailPageString.addressDescLabel, style: personalDetailPageStyles.descriptionlabelTextStyle),
            SizedBox(width: personalDetailPageStyles.widthDp * 20),
            Expanded(child: Divider(height: 1, thickness: 1, color: Colors.grey)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 20),

        /// Country
        Row(
          children: [
            Text(PersonalDetailPageString.countryLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          initialValue: AppConstants.countryList[0]['text'],
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.language,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            // hintText: PersonalDetailPageString.addressHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          // validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Address") : null,
          readOnly: true,
          onFieldSubmitted: (input) {
            // FocusScope.of(context).requestFocus(_zipCodeFocusNode);
          },
        ),

        /// state
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.stateLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        SearchChoices.single(
          items: stateItemList,
          value: state,
          hint: PersonalDetailPageString.stateHint,
          searchHint: null,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          height: personalDetailPageStyles.widthDp * 55,
          prefixIcon: Icon(
            Icons.location_city,
            color: AppColors.primaryColor,
            size: personalDetailPageStyles.iconSize,
          ),
          padding: EdgeInsets.symmetric(horizontal: personalDetailPageStyles.widthDp * 15, vertical: 0),
          borderRadius: personalDetailPageStyles.widthDp * 10,
          iconSize: personalDetailPageStyles.iconSize,
          onChanged: onstateChanged,
          dialogBox: true,
          isExpanded: true,
          validator: (value) => (validateStarted && value == null) ? ValidateErrorString.dropdownItemErrorText : null,
        ),

        /// city
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.cityHint, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        SearchChoices.single(
          items: cityItemList,
          value: city,
          hint: PersonalDetailPageString.cityHint,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          searchHint: null,
          height: personalDetailPageStyles.widthDp * 55,
          prefixIcon: Icon(
            Icons.local_hotel,
            color: AppColors.primaryColor,
            size: personalDetailPageStyles.iconSize,
          ),
          padding: EdgeInsets.symmetric(horizontal: personalDetailPageStyles.widthDp * 15, vertical: 0),
          borderRadius: personalDetailPageStyles.widthDp * 10,
          iconSize: personalDetailPageStyles.iconSize,
          onChanged: oncityChanged,
          dialogBox: true,
          isExpanded: true,
          validator: (value) => (validateStarted && value == null) ? ValidateErrorString.dropdownItemErrorText : null,
        ),

        /// address
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.addressLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: addressController,
          focusNode: addressFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.location_on,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.addressHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Address") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(aptFocusNode);
          },
        ),

        // /// street
        // SizedBox(height: personalDetailPageStyles.widthDp * 20),
        // Row(
        //   children: [
        //     Text(PersonalDetailPageString.streetLabel, style: personalDetailPageStyles.labelTextStyle),
        //     Text("   *", style: TextStyle(color: Colors.red)),
        //   ],
        // ),
        // SizedBox(height: personalDetailPageStyles.widthDp * 5),
        // TextFormField(
        //   controller: streetController,
        //   focusNode: streetFocusNode,
        //   style: personalDetailPageStyles.textFormFieldTextStyle,
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.next,
        //   decoration: InputDecoration(
        //     errorStyle: TextStyle(height: 0.5),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
        //     ),
        //     prefixIcon: Icon(
        //       Icons.location_searching,
        //       color: AppColors.primaryColor,
        //       size: personalDetailPageStyles.iconSize,
        //     ),
        //     contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
        //     hintText: PersonalDetailPageString.streetHint,
        //     hintStyle: personalDetailPageStyles.hintTextStyle,
        //   ),
        //   validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Street") : null,
        //   onFieldSubmitted: (input) {
        //     FocusScope.of(context).requestFocus(aptFocusNode);
        //   },
        // ),

        /// apt
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.aptLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: aptController,
          focusNode: aptFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.location_city,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.aptHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Apt") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(zipCodeFocusNode);
          },
        ),

        /// zip code
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.zipCodeLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: zipCodeController,
          focusNode: zipCodeFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.code,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.zipcodeHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) => (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Zip Code") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ],
    );
  }
}
