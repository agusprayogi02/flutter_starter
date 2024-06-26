import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common/constants.dart';
import '../../theme/theme.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.title,
    required this.formControlName,
    required this.hint,
    this.isRequiredText = false,
    this.prefix,
    this.validationMessages = const {},
  });

  final String title;
  final String formControlName;
  final String hint;
  final bool isRequiredText;
  final Widget? prefix;
  final Map<String, String Function(Object)> validationMessages;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool showPassword = false;

  final Map<String, String Function(Object)> messages = Constants.messageErrors;

  @override
  void initState() {
    super.initState();
    messages.addAll({
      ValidationMessage.required: (_) => 'inputan ini tidak boleh kosong',
      ValidationMessage.minLength: (_) => 'inputan password kurang dari 8 karakter',
      ValidationMessage.mustMatch: (_) => 'inputan password tidak sama',
      'validation_error': (e) => (e as String),
    });
    messages.addAll(widget.validationMessages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: widget.title,
              ),
              if (widget.isRequiredText)
                TextSpan(
                  text: "*",
                  style: CustomTextTheme.caption.copyWith(color: ColorTheme.statusRed),
                ),
            ],
          ),
          style: CustomTextTheme.paragraph1.copyWith(fontWeight: FontWeight.w700),
        ),
        8.verticalSpace,
        ReactiveTextField(
          formControlName: widget.formControlName,
          obscureText: !showPassword,
          style: CustomTextTheme.paragraph2.copyWith(color: ColorTheme.neutral[800]),
          keyboardType: TextInputType.visiblePassword,
          validationMessages: messages,
          decoration: GenerateTheme.inputDecoration(widget.hint).copyWith(
            prefixIcon: widget.prefix,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: showPassword
                  ? Icon(
                      Icons.visibility_off,
                      color: ColorTheme.neutral[600],
                    )
                  : Icon(
                      Icons.visibility,
                      color: ColorTheme.neutral[600],
                    ),
            ),
          ),
        )
      ],
    );
  }
}
