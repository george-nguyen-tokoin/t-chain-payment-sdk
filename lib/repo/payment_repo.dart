import 'package:flutter/material.dart';
import 'package:t_chain_payment_sdk/config/config.dart';
import 'package:t_chain_payment_sdk/data/merchant_transaction.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/create_transaction_body.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/gen_qr_code_body.dart';
import 'package:t_chain_payment_sdk/data/request_body.dart/merchant_info_body.dart';
import 'package:t_chain_payment_sdk/data/response/data_response.dart';
import 'package:t_chain_payment_sdk/data/t_chain_payment_action.dart';
import 'package:t_chain_payment_sdk/services/t_chain_api.dart';
import 'package:t_chain_payment_sdk/t_chain_payment_sdk.dart';

class PaymentRepository {
  final TChainAPI api;

  PaymentRepository({
    required this.api,
  });

  // use bundleID to callback after having transaction result
  // in case generating QR code, let the bundleID be empty
  Future<Uri?> generateDeeplink({
    required TChainPaymentAction action,
    required String notes,
    required double amount,
    required Currency currency,
    required String chainId,
    String? bundleID,
  }) async {
    final body = GenQrCodeBody(
      notes: notes,
      amount: amount,
      currency: currency,
      chainId: chainId,
    );
    try {
      final response = await api.generateQrCode(
        apiKey: TChainPaymentSDK.instance.apiKey,
        body: body,
      );

      final qrCode = response.result?.qrCode;
      if (qrCode == null) return null;

      final Map<String, dynamic> params = {
        'qr_code': qrCode,
      };

      if (bundleID != null) {
        params['bundle_id'] = bundleID;
      }

      final Uri uri = Uri(
        scheme: TChainPaymentSDK.instance.env.scheme,
        host: 'app',
        path: action.path,
        queryParameters: params,
      );

      return uri;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<DataResponse<MerchantInfo>?> getMerchantInfo({
    required String qrCode,
  }) async {
    final body = MerchantInfoBody(qrCode: qrCode);
    try {
      final response = await api.getMerchantInfo(
        apiKey: TChainPaymentSDK.instance.apiKey,
        body: body,
      );

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<DataResponse<Map<String, dynamic>>?> getExchangeRate() async {
    try {
      final response = await api.getExchangeRate(
        apiKey: TChainPaymentSDK.instance.apiKey,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  Future<MerchantTransaction?> createMerchantTransaction(
    String address,
    double amount,
    Currency currency,
    String notes,
    String tokenName,
    String merchantId,
    String chainId,
  ) async {
    try {
      final body = CreateTransactionBody(
        walletAddress: address,
        merchantId: merchantId,
        amount: amount,
        currency: currency.shortName,
        tokenName: tokenName,
        chainId: chainId,
        notes: notes,
      );
      final response = await api.createMerchantTransaction(
        apiKey: TChainPaymentSDK.instance.apiKey,
        body: body,
      );

      return response.result;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
