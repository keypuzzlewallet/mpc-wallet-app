import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/blockchain/estimate_fee_result.dart';
import 'package:mobileapp/events/enums/fee_level.dart';
import 'package:mobileapp/events/pricefeed/coin_price.dart';
import 'package:mobileapp/events/signing/requests/eth_contract_request.dart';
import 'package:mobileapp/models/address_list_item.dart';
import 'package:mobileapp/models/blockchain_coin_item.dart';
import 'package:mobileapp/screens/v1/views/create_new_signing_controller.dart';
import 'package:mobileapp/services/utils.dart';
import 'package:mobileapp/states/app_global_bloc.dart';
import 'package:mobileapp/states/app_global_state.dart';
import 'package:mobileapp/states/settings_state.dart';
import 'package:mobileapp/states/wallets_state.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

class CreateNewSigningScreen extends StatefulWidget {
  EthContractRequest? ethContractRequest;
  final BlockchainCoinItem blockchainCoinItem;
  final bool isOnlyWhitelisted;

  CreateNewSigningScreen(
      {Key? key,
      required this.blockchainCoinItem,
      required this.isOnlyWhitelisted,
      this.ethContractRequest})
      : super(key: key);

  @override
  _CreateNewSigningScreenState createState() => _CreateNewSigningScreenState();
}

class _CreateNewSigningScreenState extends State<CreateNewSigningScreen> {
  late ThemeData theme;
  late CreateNewSigningController controller;

  _CreateNewSigningScreenState();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = CreateNewSigningController(
        isOnlyWhitelisted: widget.isOnlyWhitelisted,
        blockchainCoinItem: widget.blockchainCoinItem,
        ethContractRequestDefault: widget.ethContractRequest);
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<CreateNewSigningController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: FxText.titleLarge("Create Transaction"),
              leading: InkWell(
                  onTap: () {
                    controller.goBack();
                  },
                  child: const Icon(AppIcons.back)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context), 20, 0),
                child: SingleChildScrollView(
                  child: Container(
                    padding: FxSpacing.nTop(20),
                    child: BlocSelector<AppGlobalBloc, AppGlobalState,
                        WalletsState>(
                      selector: (state) => state.walletsState,
                      builder: (context, walletsState) {
                        return BlocSelector<AppGlobalBloc, AppGlobalState,
                            SettingsState>(
                          selector: (state) {
                            return state.settingsState;
                          },
                          builder: (context, settingsState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: controller.addressList.isNotEmpty
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(AppIcons.addressList, color: theme.iconTheme.color?.withAlpha(120),),
                                              FxSpacing.width(30),
                                              DropdownButton<AddressListItem>(
                                                value: controller
                                                    .selectedAddressListItem,
                                                dropdownColor: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                items: controller.addressList
                                                    .map((e) => DropdownMenuItem<
                                                    AddressListItem>(
                                                    value: e,
                                                    child: FxText.bodyLarge(e.name)))
                                                    .toList(),
                                                onChanged: (value) => setState(() =>
                                                    controller
                                                        .setAddressListItem(value)),
                                              )
                                            ],
                                          ),
                                        )
                                      : null,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: FxTextField(
                                    labelText: "To Address",
                                    readOnly: settingsState.whitelisted,
                                    controller: controller.toAddressController,
                                    icon: const Icon(AppIcons.toAddress),
                                    suffixIcon: settingsState.whitelisted
                                        ? IconButton(
                                            icon: const Icon(AppIcons.copy),
                                            onPressed: () =>
                                                controller.copyToAddress(),
                                          )
                                        : IconButton(
                                            icon:
                                                const Icon(AppIcons.qrScanner),
                                            onPressed: () =>
                                                controller.scanQrCode(),
                                          ),
                                  ),
                                ),
                                FxSpacing.height(20),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: FxTextField(
                                    controller: controller.amountController,
                                    labelText: "Amount",
                                    keyboardType: TextInputType.number,
                                    icon: const Icon(AppIcons.currency),
                                  ),
                                ),
                                buildFeeLevel(),
                                walletsState.defaultWallet != null &&
                                        walletsState.defaultWallet!.threshold +
                                                1 ==
                                            walletsState
                                                .defaultWallet!.noMembers
                                    ? const SizedBox.shrink()
                                    : buildSelectSigners(walletsState),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  alignment: Alignment.center,
                                  child: settingsState.whitelisted
                                      ? Row(
                                          children: [
                                            Icon(AppIcons.alert,
                                                color: theme.colorScheme.error
                                                    .withAlpha(400)),
                                            FxSpacing.width(10),
                                            Flexible(
                                                child: FxText(
                                              "Whitelisted mode is enabled. You can only send to whitelisted addresses.",
                                              softWrap: true,
                                              color: theme.colorScheme.error
                                                  .withAlpha(400),
                                            ))
                                          ],
                                        )
                                      : null,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary
                                              .withAlpha(28),
                                          blurRadius: 4,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: FxButton.medium(
                                        elevation: 0,
                                        borderRadiusAll:
                                            Constant.containerRadius.xs,
                                        onPressed: () => controller.submit(
                                            walletsState.defaultWallet!,
                                            settingsState.whitelisted),
                                        child: FxText.labelMedium(
                                            "Create Transaction",
                                            fontWeight: 600,
                                            color:
                                                theme.colorScheme.onPrimary)),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Column buildFeeLevel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxSpacing.height(20),
        BlocSelector<AppGlobalBloc, AppGlobalState, EstimateFeeResult?>(
          selector: (state) => state.signingState.estimatedFee,
          builder: (context, estimatedFee) {
            return BlocSelector<AppGlobalBloc, AppGlobalState,
                List<CoinPrice>?>(
              selector: (state) => state.walletsState.prices,
              builder: (context, prices) {
                return Container(
                  padding: FxSpacing.nLeft(10),
                  child: FxText.titleMedium(
                      "Fee Levels: ${estimatedFee != null ? "${formatNumber(controller.getFee(estimatedFee))} ${widget.blockchainCoinItem.coinConfig.coin.name} ${controller.convertToFiat(estimatedFee, prices, widget.blockchainCoinItem.coinConfig.coin)}" : ""}",
                      fontWeight: 600,
                      letterSpacing: 0.2),
                );
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: FeeLevel.LOW,
                  activeColor: theme.colorScheme.primary,
                  groupValue: controller.feeLevel,
                  onChanged: (FeeLevel? value) =>
                      setState(() => controller.setFeeLevel(value!)),
                ),
                FxText(
                  "Low",
                )
              ],
            ),
            Row(
              children: [
                Radio(
                  value: FeeLevel.MEDIUM,
                  activeColor: theme.colorScheme.primary,
                  groupValue: controller.feeLevel,
                  onChanged: (FeeLevel? value) =>
                      setState(() => controller.setFeeLevel(value!)),
                ),
                FxText(
                  "Medium",
                )
              ],
            ),
            Row(
              children: [
                Radio(
                  value: FeeLevel.HIGH,
                  activeColor: theme.colorScheme.primary,
                  groupValue: controller.feeLevel,
                  onChanged: (FeeLevel? value) =>
                      setState(() => controller.setFeeLevel(value!)),
                ),
                FxText(
                  "High",
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Column buildSelectSigners(WalletsState walletsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxSpacing.height(20),
        Container(
          padding: FxSpacing.nLeft(10),
          child: FxText.titleMedium("Select Signers",
              fontWeight: 600, letterSpacing: 0.2),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: walletsState.defaultWallet!.members
                .map((member) => ChoiceChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      selectedColor: theme.colorScheme.primary,
                      label: FxText.bodyMedium(
                        "${member.party_id}: ${member.party_name}",
                        color: controller.signers.contains(member)
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onBackground,
                      ),
                      selected: controller.signers.contains(member),
                      onSelected: (selected) =>
                          setState(() => controller.signerSelected(member)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
