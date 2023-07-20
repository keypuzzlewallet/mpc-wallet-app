import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/screens/v1/views/password_request_controller.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class PasswordRequestScreen extends StatefulWidget {
  const PasswordRequestScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PasswordRequestScreenState createState() => _PasswordRequestScreenState();
}

class _PasswordRequestScreenState extends State<PasswordRequestScreen> {
  late ThemeData theme;
  late PasswordRequestController controller;

  _PasswordRequestScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = PasswordRequestController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<PasswordRequestController>(
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
                  "Enter Password",
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
                      FxContainer.transparent(
                        child: FxButton.block(
                          onPressed: () => controller.submit(),
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
