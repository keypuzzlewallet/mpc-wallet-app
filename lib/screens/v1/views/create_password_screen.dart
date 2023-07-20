import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/create_password_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late ThemeData theme;
  late CreatePasswordController controller;

  _CreatePasswordScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CreatePasswordController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CreatePasswordController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                  onTap: () => controller.goBack(),
                  child: const Icon(
                    AppIcons.back,
                    size: 20,
                  ),
                ),
                title: FxText.titleLarge(
                  "Create Password",
                ),
                actions: const <Widget>[],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: FxSpacing.fromLTRB(
                      20, FxSpacing.safeAreaTop(context), 20, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: FxTextField(
                          labelText: "Password",
                          obscureText: true,
                          enableSuggestions: false,
                          maxLines: 1,
                          autocorrect: false,
                          onChanged: (value) =>
                              controller.onEnterPassword(value),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: FxTextField(
                          labelText: "Re-enter password",
                          obscureText: true,
                          maxLines: 1,
                          enableSuggestions: false,
                          autocorrect: false,
                          onChanged: (value) =>
                              controller.onReEnterPassword(value),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: PasswordStrengthChecker(
                            strength: controller.passwordStrength),
                      ),
                      FxContainer.transparent(
                        child: FxButton.block(
                          onPressed: () => controller.submit(),
                          disabled: !controller.isPasswordGood,
                          elevation: 0,
                          child: FxText.labelLarge(
                            "Use this password",
                            fontWeight: 700,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}

class _SingleRate extends StatelessWidget {
  final String name;
  final String value;

  const _SingleRate({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: FxText.titleMedium(name, fontWeight: 600)),
          FxText.bodyLarge(value, fontWeight: 600),
        ],
      ),
    );
  }
}
