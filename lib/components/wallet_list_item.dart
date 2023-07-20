import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:mobileapp/events/enums/key_scheme.dart';
import 'package:mobileapp/events/keygenv2/encrypted_keygen_with_scheme.dart';
import 'package:mobileapp/inject.dart';
import 'package:mobileapp/models/nonce_entity.dart';
import 'package:mobileapp/models/wallet_entity.dart';
import 'package:mobileapp/services/wallet_service.dart';
import 'package:mobileapp/theme/app_theme.dart';
import 'package:mobileapp/theme/constant.dart';

Widget walletListItem(WalletEntity wallet) {
  Color iconBG = AppTheme.theme.colorScheme.primary;
  Color iconColor = AppTheme.theme.colorScheme.background;

  return FxContainer.bordered(
    paddingAll: 16,
    margin: FxSpacing.fromLTRB(24, 8, 24, 8),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    borderRadiusAll: 4,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: FxSpacing.all(6),
          decoration: BoxDecoration(color: iconBG, shape: BoxShape.circle),
          child: Icon(
            AppIcons.wallet,
            color: iconColor,
            size: 20,
          ),
        ),
        Expanded(
          child: Container(
            margin: FxSpacing.left(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FxText.bodyLarge(wallet.name,
                    color: AppTheme.theme.colorScheme.onBackground,
                    fontWeight: 600),
                Container(
                  margin: FxSpacing.top(2),
                  child: FxText.bodySmall(
                    wallet.walletId,
                    color:
                        AppTheme.theme.colorScheme.onBackground.withAlpha(160),
                    fontWeight: 600,
                  ),
                ),
                FxSpacing.height(4),
                Row(
                  children:
                      wallet.encryptedKeygenResult.encryptedKeygenWithScheme
                          .map((key) => Container(
                              margin: FxSpacing.right(4),
                              child: EnhancedFutureBuilder(
                                future: _getNonceCount(key),
                                rememberFutureResult: true,
                                whenNotDone: const SizedBox.shrink(),
                                whenDone: (text) => FxText.labelSmall(
                                  text,
                                  fontSize: 9,
                                ),
                              ),))
                          .toList(),
                )
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FxText.bodySmall(dateFormat(wallet.createdAt),
                fontSize: 12,
                letterSpacing: 0.2,
                color: AppTheme.theme.colorScheme.onBackground,
                muted: true,
                fontWeight: 600),
            Container(
              margin: FxSpacing.top(2),
              child: Row(
                children: <Widget>[
                  Icon(
                    AppIcons.members,
                    color:
                        AppTheme.theme.colorScheme.onBackground.withAlpha(200),
                    size: 20,
                  ),
                  FxSpacing.width(3),
                  FxText.bodyMedium(wallet.noMembers.toString(),
                      color: AppTheme.theme.colorScheme.onBackground
                          .withAlpha(200),
                      fontWeight: 500),
                  FxSpacing.width(7),
                  Icon(
                    AppIcons.requiredSigners,
                    color:
                        AppTheme.theme.colorScheme.onBackground.withAlpha(200),
                    size: 20,
                  ),
                  FxSpacing.width(3),
                  FxText.bodyMedium((wallet.threshold + 1).toString(),
                      color: AppTheme.theme.colorScheme.onBackground
                          .withAlpha(200),
                      fontWeight: 500),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<String> _getNonceCount(EncryptedKeygenWithScheme key) async {
  if (key.keyScheme == KeyScheme.ECDSA) {
    return "${key.keyScheme.name}: \u221E";
  } else {
    NonceEntity? nonce = await getIt<WalletService>().getNonce(key.encryptedLocalKey.pubkey, key.keyScheme);
    if (nonce == null) {
      return "${key.keyScheme.name}: 0";
    }
    int nonceCount = nonce.nonceSize - nonce.currentNonce;
    return "${key.keyScheme.name}: $nonceCount";
  }
}
