import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/enums/signing_status.dart';
import 'package:mobileapp/events/signing/signing_request.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/screens/v1/views/signing_list_controller.dart';
import 'package:mobileapp/services/currency_config.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/signing_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class SigningListScreen extends StatefulWidget {
  const SigningListScreen({Key? key}) : super(key: key);

  @override
  _SigningListScreenState createState() => _SigningListScreenState();
}

class _SigningListScreenState extends State<SigningListScreen> {
  late ThemeData theme;
  late SigningListController controller;

  _SigningListScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = SigningListController();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SigningListController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.goToJoinSigning(),
              elevation: 2,
              child: const Icon(AppIcons.add),
            ),
            appBar: AppBar(
              title: FxText.titleLarge("Transactions"),
              centerTitle: true,
              elevation: 0,
              actions: const [],
            ),
            body: RefreshIndicator(
              onRefresh: () => controller.refreshList(),
              child: BlocSelector<AppGlobalBloc, AppGlobalState, SigningState>(
                selector: (state) => state.signingState,
                builder: (context, state) =>
                    list2(state.signingSessions ?? List.empty()),
              ),
            ),
          );
        });
  }

  Widget list2(List<SigningRequest> sessions) {
    return ListView(
      padding: FxSpacing.horizontal(
        24,
      ),
      children: [
        FxTextField(
          onChanged: (value) => setState(() => controller.searchChanged(value)),
          textFieldStyle: FxTextFieldStyle.outlined,
          labelText: 'Search transactions',
          focusedBorderColor: theme.primaryColor,
          cursorColor: theme.focusColor,
          labelStyle: FxTextStyle.bodySmall(
              color: theme.colorScheme.onBackground, xMuted: true),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: theme.focusColor.withAlpha(40),
          suffixIcon: Icon(
            AppIcons.search,
            color: theme.primaryColor,
            size: 20,
          ),
        ),
        FxSpacing.height(20),
        Column(
          children: _buildList(sessions),
        ),
      ],
    );
  }

  _buildList(List<SigningRequest> sessions) {
    List<Widget> list = [];

    list.add(FxSpacing.width(16));

    for (SigningRequest session in controller.searchSession(sessions)) {
      list.add(_buildSingle(session));
    }
    return list;
  }

  Widget _buildSingle(SigningRequest session) {
    return FxContainer(
      onTap: () => controller.signingSelected(session),
      margin: FxSpacing.bottom(16),
      paddingAll: 16,
      borderRadiusAll: 16,
      child: Row(
        children: [
          Stack(
            children: [
              FxContainer.rounded(
                paddingAll: 0,
                child: SvgPicture.asset(
                  "assets/coins/${session.coin.name.toLowerCase()}.svg",
                  height: 54,
                  width: 54,
                ),
              ),
              (getIt<CurrencyConfig>()
                              .findCoinConfig(session.blockchain, session.coin)
                              ?.isNative ??
                          false) ==
                      false
                  ? Positioned(
                      right: 4,
                      bottom: 2,
                      child: FxContainer.rounded(
                        paddingAll: 0,
                        child: SvgPicture.asset(
                          "assets/blockchains/${session.blockchain.name.toLowerCase()}.svg",
                          height: 20,
                          width: 20,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          FxSpacing.width(16),
          session.sendRequest != null
              ? sendRequestListItem(session)
              : const SizedBox.shrink(),
          session.sendTokenRequest != null
              ? sendTokenRequestListItem(session)
              : const SizedBox.shrink(),
          session.ethSmartContractRequest != null
              ? smartContractListItem(session)
              : const SizedBox.shrink(),
          FxSpacing.width(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FxText.bodySmall(
                dateFormat(DateTime.parse(session.createdAt)),
                fontSize: 10,
                color: theme.colorScheme.onBackground,
                xMuted: true,
              ),
              FxSpacing.height(16)
            ],
          ),
        ],
      ),
    );
  }

  Expanded smartContractListItem(SigningRequest session) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              getStatusIcon(session),
              FxSpacing.width(4),
              FxText.bodyMedium(
                "Call ${session.ethSmartContractRequest!.amount} ${session.coin.name}",
                fontWeight: 600,
              ),
            ],
          ),
          FxSpacing.height(4),
          Row(children: [
            FxText.bodySmall(
              shortAddress(session.fromAddress),
            ),
            const Icon(AppIcons.goTo),
            FxText.bodySmall(
              shortAddress(session.ethSmartContractRequest!.toAddress),
            ),
          ]),
        ],
      ),
    );
  }

  Expanded sendRequestListItem(SigningRequest session) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              getStatusIcon(session),
              FxSpacing.width(4),
              FxText.bodyMedium(
                "Send ${session.sendRequest!.amount} ${session.coin.name}",
                fontWeight: 600,
              ),
            ],
          ),
          FxSpacing.height(4),
          Row(children: [
            FxText.bodySmall(
              shortAddress(session.fromAddress),
            ),
            const Icon(AppIcons.goTo),
            FxText.bodySmall(
              shortAddress(session.sendRequest!.toAddress),
            ),
          ]),
        ],
      ),
    );
  }

  Widget getStatusIcon(SigningRequest session) {
    return ConditionalSwitch.single<String>(
      context: context,
      valueBuilder: (BuildContext context) => session.status.name,
      caseBuilders: {
        SigningStatus.SIGNING_SESSION_CREATED.name: (BuildContext context) =>
            Icon(AppIcons.signingStatusCreated,
                size: 16, color: theme.colorScheme.primary),
        SigningStatus.SIGNING_IN_PROGRESS.name: (BuildContext context) => Icon(
            AppIcons.signingStatusSigning,
            size: 16,
            color: theme.colorScheme.primary),
        SigningStatus.SIGNING_COMPLETED.name: (BuildContext context) => Icon(
            AppIcons.signingStatusCompleted,
            size: 16,
            color: theme.colorScheme.primary),
        SigningStatus.SIGNING_BROADCASTED.name: (BuildContext context) => Icon(
            AppIcons.signingStatusCompleted,
            size: 16,
            color: theme.colorScheme.primary),
        SigningStatus.SIGNING_FAILED.name: (BuildContext context) => Icon(
            AppIcons.signingStatusCompleted,
            size: 16,
            color: theme.colorScheme.error),
      },
      fallbackBuilder: (BuildContext context) => Icon(
          AppIcons.signingStatusCreated,
          size: 16,
          color: theme.colorScheme.primary),
    );
  }

  Expanded sendTokenRequestListItem(SigningRequest session) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              getStatusIcon(session),
              FxSpacing.width(4),
              FxText.bodyMedium(
                "Send ${session.sendTokenRequest!.amount} ${session.coin.name}",
                fontWeight: 600,
              ),
            ],
          ),
          FxSpacing.height(4),
          Row(children: [
            FxText.bodySmall(
              shortAddress(session.fromAddress),
            ),
            const Icon(AppIcons.goTo),
            FxText.bodySmall(
              shortAddress(session.sendTokenRequest!.toAddress),
            ),
          ]),
        ],
      ),
    );
  }
}
