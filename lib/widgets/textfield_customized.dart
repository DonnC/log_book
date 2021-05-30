// entry of formbuilderfield
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:log_book/utils/index.dart';
import 'package:relative_scale/relative_scale.dart';

Widget formEntryField({
  String title,
  @required BuildContext context,
  TextEditingController controller,
  String validateError,
  String hintText: '',
  String initialText,
  bool autoFocus: false,
  int maxLines: 1,
  bool obscureText: false,
  bool isPhoneField: false,
  bool readOnly: false,
  bool unfocus: false,
  Color titleColor,
  bool enforceMaxLength: false,
  int maxLength,
  var customOnChangeCallback,

  /// determine if this is a custom phone input field or general textfield. Text by default
  String labelText: '',
  Widget suffixIcon: const SizedBox.shrink(),
  var validators,
}) {
  return RelativeBuilder(
    builder: (context, height, width, sy, sx) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: kStyle(),
            ),
            customTextField(
              context: context,
              controller: controller,
              hintText: hintText,
              maxLines: maxLines,
              autoFocus: autoFocus,
              obscureText: obscureText,
              readOnly: readOnly,
              errorString: validateError,
              labelText: labelText,
              unfocus: unfocus,
              suffixIcon: suffixIcon,
              initialText: initialText,
              customOnChangeCallback: customOnChangeCallback,
              enforceMaxLength: enforceMaxLength,
              maxLength: maxLength,
            ),
          ],
        ),
      );
    },
  );
}

Widget customTextField({
  TextEditingController controller,
  BuildContext context,
  String initialText,
  String hintText: '',
  int maxLines: 1,
  bool readOnly: false,
  bool obscureText: false,
  bool unfocus: false,
  String labelText: '',
  bool autoFocus: false,
  var customOnChangeCallback,
  bool enforceMaxLength: false,
  int maxLength,
  String errorString: 'this field is required',
  Widget suffixIcon: const SizedBox.shrink(),
}) {
  const double _radius = 5.0;

  return Padding(
    padding: EdgeInsets.all(12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialText,
        controller: controller,
        autofocus: autoFocus,
        style: kStyle(),
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: enforceMaxLength
            ? MaxLengthEnforcement.enforced
            : MaxLengthEnforcement.none,
        obscureText: obscureText,
        validator: (value) {
          if (value.isEmpty) {
            return errorString;
          }
          return null;
        },
        onEditingComplete: () => unfocus
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).nextFocus(),
        onChanged: customOnChangeCallback,
        decoration: InputDecoration(
          labelText: labelText,
          fillColor: Colors.grey,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          hintText: hintText,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 13,
            height: 3,
          ),
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: textColor,
            fontStyle: FontStyle.italic,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
      ),
    ),
  );
}
