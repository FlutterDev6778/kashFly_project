import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:keicy_dropdown_form_field/keicy_dropdown_form_field.dart';
import 'package:keicy_utils/date_time_convert.dart';
import 'package:keicy_utils/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:money_transfer_app/Pages/App/index.dart';
import 'package:money_transfer_app/Pages/PersonalDetailPage/index.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

class PersonalDetails extends StatelessWidget {
  final PersonalDetailPageStyles personalDetailPageStyles;
  final TextEditingController firstNameController;
  final FocusNode firstNameFocusNode;
  final TextEditingController middleNameController;
  final FocusNode middleNameFocusNode;
  final TextEditingController lastNameController;
  final FocusNode lastNameFocusNode;
  final TextEditingController birthDayController;
  final FocusNode birthDayFocusNode;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController phoneController;
  final FocusNode phoneFocusNode;
  final Function onGenderChanged;
  final int gender;

  PersonalDetails({
    @required this.personalDetailPageStyles,
    @required this.firstNameController,
    @required this.firstNameFocusNode,
    @required this.middleNameController,
    @required this.middleNameFocusNode,
    @required this.lastNameController,
    @required this.lastNameFocusNode,
    @required this.birthDayController,
    @required this.birthDayFocusNode,
    @required this.emailController,
    @required this.emailFocusNode,
    @required this.phoneController,
    @required this.phoneFocusNode,
    @required this.onGenderChanged,
    @required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// divider
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider(height: 1, thickness: 1, color: Colors.grey)),
            SizedBox(width: personalDetailPageStyles.widthDp * 20),
            Text(PersonalDetailPageString.personalDescLabel, style: personalDetailPageStyles.descriptionlabelTextStyle),
            SizedBox(width: personalDetailPageStyles.widthDp * 20),
            Expanded(child: Divider(height: 1, thickness: 1, color: Colors.grey)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 20),

        /// first name
        Row(
          children: [
            Text(PersonalDetailPageString.fistNameLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: firstNameController,
          focusNode: firstNameFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.fistNameHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) =>
              (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "First Name") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(middleNameFocusNode);
          },
        ),

        /// middle name
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.middleNameLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: middleNameController,
          focusNode: middleNameFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.middleNameHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) =>
              (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Middle Name") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(lastNameFocusNode);
          },
        ),

        /// last name
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.lastNameLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: lastNameController,
          focusNode: lastNameFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.lastNameHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) =>
              (input.isEmpty) ? ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Last Name") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(birthDayFocusNode);
          },
        ),

        /// birthday
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.birthDayLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: birthDayController,
          focusNode: birthDayFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          readOnly: true,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.date_range,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: AppColors.blackColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.birthDayHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) {
            if (input.isEmpty) return ValidateErrorString.textEmptyErrorText.replaceAll("{}", "Birth Day");

            DateTime dateTime = KeicyDateTime.convertDateStringToDateTime(dateString: input);

            if (DateTime.now().year - dateTime.year < 18) return ValidateErrorString.birthDayErrorText;

            return null;
          },
          onFieldSubmitted: (input) {},
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker(
                  CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime:
                        KeicyDateTime.convertDateStringToDateTime(dateString: birthDayController.text.trim()),
                    minimumYear: 1950,
                    maximumYear: DateTime.now().year,
                    onDateTimeChanged: (DateTime newDateTime) {
                      birthDayController.text = KeicyDateTime.convertDateTimeToDateString(dateTime: newDateTime);
                    },
                  ),
                );
              },
            );
          },
        ),

        /// Gender
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.genderLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        KeicyDropDownFormField(
          width: null,
          height: personalDetailPageStyles.widthDp * 55,
          menuItems: AppConstants.genderList,
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: personalDetailPageStyles.widthDp * 10,
          selectedItemStyle: personalDetailPageStyles.textFormFieldTextStyle,
          hintText: PersonalDetailPageString.genderHintHint,
          hintStyle: personalDetailPageStyles.hintTextStyle,
          fixedHeightState: false,
          value: gender,
          prefixIcons: [
            Icon(
              Icons.people,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            )
          ],
          contentHorizontalPadding: personalDetailPageStyles.widthDp * 15,
          onChangeHandler: onGenderChanged,
        ),

        /// email
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.emailLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          controller: emailController,
          focusNode: emailFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.email,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.emailHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) =>
              (!KeicyValidators.isValidEmail(input.trim())) ? ValidateErrorString.emailErrorText : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(phoneFocusNode);
          },
        ),

        /// phone number
        SizedBox(height: personalDetailPageStyles.widthDp * 20),
        Row(
          children: [
            Text(PersonalDetailPageString.phoneLabel, style: personalDetailPageStyles.labelTextStyle),
            Text("   *", style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: personalDetailPageStyles.widthDp * 5),
        TextFormField(
          readOnly: true,
          controller: phoneController,
          focusNode: phoneFocusNode,
          style: personalDetailPageStyles.textFormFieldTextStyle,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            MaskTextInputFormatter(mask: AppConstants.maskString, filter: {'0': RegExp(r'[0-9]')}),
          ],
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(personalDetailPageStyles.textFieldBorderRadius),
            ),
            prefixIcon: Icon(
              Icons.phone,
              color: AppColors.primaryColor,
              size: personalDetailPageStyles.iconSize,
            ),
            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            hintText: PersonalDetailPageString.phoneHint,
            hintStyle: personalDetailPageStyles.hintTextStyle,
          ),
          validator: (input) =>
              (input.length < 9) ? ValidateErrorString.textlengthErrorText.replaceAll("{length}", "9") : null,
          onFieldSubmitted: (input) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ],
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: personalDetailPageStyles.widthDp * 216,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
