import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../application/auth/auth_cubit.dart';
import '../../../../../injection.dart';
import '../../../../common/extensions/extensions.dart';
import '../../../components/components.dart';
import '../../../theme/theme.dart';
import '../auth.dart';

part 'register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const path = "/register";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<AuthCubit>(),
        ),
      ],
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = RegisterController(context);
    return ReactiveFormBuilder(
      form: () => c.formG,
      builder: (context, form, child) => BaseScaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) => c.authListener(context, state, form),
            builder: (context, state) {
              return ReactiveFormConsumer(
                builder: (context, formL, child) {
                  return PrimaryButton(
                    onTap: () => c.onSubmit(formL),
                    title: "Daftar",
                    isEnable: formL.valid && formL.control('unit_1').value != -1,
                  );
                },
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                child: BaseLogo(),
              ),
              Text(
                'Silahkan daftar akun baru',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CustomTextTheme.paragraph3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Buat akun untuk menggunakan aplikasi',
                style: AppStyles.text14Px.copyWith(
                  color: ColorTheme.neutral[600],
                ),
              ),
              28.verticalSpace,
              // const TextInput(
              //   title: "Nip",
              //   formControlName: "nip",
              //   hint: 'Masukkan NIP',
              //   prefix: Icon(Icons.numbers),
              //   textInputType: TextInputType.number,
              //   isRequiredText: true,
              // ),
              // 6.verticalSpace,
              const TextInput(
                title: "Nama",
                formControlName: "name",
                hint: 'Masukkan nama lengkap',
                prefix: Icon(Icons.person),
                isRequiredText: true,
              ),
              6.verticalSpace,
              const TextInput(
                title: "Nomor Ponsel",
                formControlName: "phone_number",
                hint: 'Masukkan nomor ponsel',
                prefix: Icon(Icons.phone),
                textInputType: TextInputType.phone,
                isRequiredText: true,
              ),
              6.verticalSpace,
              const TextInput(
                title: "Email",
                formControlName: "email",
                hint: 'Masukkan Email anda',
                prefix: Icon(Icons.email),
                textInputType: TextInputType.emailAddress,
                isRequiredText: true,
              ),
              6.verticalSpace,
              PasswordInput(
                formControlName: "password",
                title: "Password",
                hint: "Masukkan Password anda",
                isRequiredText: true,
                prefix: const Icon(Icons.key),
                validationMessages: c.passwordMessages,
              ),
              18.verticalSpace,
              Text.rich(
                TextSpan(
                  text: "Sudah memiliki akun? ",
                  style: AppStyles.text14Px.copyWith(
                    color: ColorTheme.black,
                  ),
                  children: [
                    TextSpan(
                      text: "Masuk",
                      style: AppStyles.text14PxBold.copyWith(
                        color: ColorTheme.primary,
                      ),
                      // recognizer: TapGestureRecognizer()
                      // ..onTap = () => context.route.push(OtpRoute(email: "Aaab".toString())),
                      recognizer: TapGestureRecognizer()..onTap = c.onLogin,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
