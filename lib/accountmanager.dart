import 'dart:async';

import 'package:flutter/services.dart';

class Account {
  String name;
  String accountType;

  Account({
    required this.name,
    required this.accountType
  });
}

class AccessToken {
  String tokenType;
  String token;

  AccessToken({
    required this.tokenType,
    required this.token
  });
}

class AccountManager {
  static const MethodChannel _channel = const MethodChannel('accountManager');

  static const String _KeyAccountName = 'account_name';
  static const String _KeyAccountType = 'account_type';
  static const String _KeyAuthTokenType = 'auth_token_type';
  static const String _KeyAccessToken = 'access_token';

  static Future<bool> addAccount(Account account) async {
    return await _channel.invokeMethod('addAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    });
  }

  static Future<AccessToken?> getAccessToken(Account account,
      String authTokenType) async {
    AccessToken? accessToken;
    final res = await _channel.invokeMethod('getAccessToken', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType,
      _KeyAuthTokenType: authTokenType
    });
    if (res != null) {
      accessToken = AccessToken(
        tokenType: res[_KeyAuthTokenType],
        token: res[_KeyAccessToken],
      );
    }
    return accessToken;
  }

  static Future<List<Account>> getAccounts() async {
    List<Account> accounts = [];
    final result = await _channel.invokeMethod('getAccounts');
    for (var item in result) {
      accounts.add(
          new Account(
              name: item[_KeyAccountName],
              accountType: item[_KeyAccountType]
          )
      );
    }
    return accounts;
  }

  static Future<bool> removeAccount(Account account) async {
    return await _channel.invokeMethod('removeAccount', {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    });
  }

  static Future<bool> setAccessToken(Account account, AccessToken? token
      ) async {
    final data = {
      _KeyAccountName: account.name,
      _KeyAccountType: account.accountType
    };
    if (token != null) {
      data[_KeyAuthTokenType] = token.tokenType;
      data[_KeyAccessToken] = token.token;
    }
    return await _channel.invokeMethod('setAccessToken', data);
  }
}
