import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/data/repository/customer/customer_repository.dart';
import 'package:soko_flow/data/repository/customer/user_onBoard_permisions_repo.dart';
import 'package:soko_flow/models/checkout_form_model.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/company_routes/company_routes_model.dart';

import '../../models/company_outlets/customer_groups.dart';
import '../application/customer_notifier.dart';

final selectedOutletProvider =
    StateProvider<CompanyOutletsModel?>((ref) => null);
final selectedRouteProvider =
    StateProvider<CompanyOutletsModel?>((ref) => null);
final addCustomerNotifierProvider =
    StateNotifierProvider.autoDispose<AddCustomerNotifier, AsyncValue>((ref) {
  return AddCustomerNotifier(read: ref);
});

final userOnBoardPermissionsProvider =
    FutureProvider.autoDispose<Response>((ref) async {
  final response = await ref.watch(onBoardPermissionsRepositoryProvider).getPermissions();
  return response;
});

final customerCreditStatusProvider = FutureProvider.autoDispose.family<Response, String>((ref, customerId) async {
  final response = await ref.watch(onBoardPermissionsRepositoryProvider).getCustomerCreditorStatus(customerId);
  return response;
});

final companyOutletsProvider =
    FutureProvider.autoDispose<List<CompanyOutletsModel>?>((ref) async {
  final outlets = await ref.watch(CustomerRepositoryProvider).getOutlets(false);
  return outlets;
});
final customerGroupsProvider =
    FutureProvider.autoDispose<List<CustomerGroupModel>?>((ref) async {
  final groups =
      await ref.watch(CustomerRepositoryProvider).getCustomerGroups(false);
  return groups;
});
final companyRoutesProvider =
    FutureProvider.autoDispose<List<Subregion>>((ref) async {
  try {
    final routes = await ref.watch(CustomerRepositoryProvider).getRoutes(false);
    return routes;
  } catch (e) {
    throw e;
  }
});


final customerNotifier =
StateNotifierProvider.autoDispose<CustomerNotifier, AsyncValue>((ref) {
  return CustomerNotifier(read: ref);
});

class CustomerNotifier extends StateNotifier<AsyncValue> {
  CustomerNotifier({required this.read}) : super(const AsyncValue.data(null));
  Ref read;

  Future<void> submitCheckOutForm() async {
    state = const AsyncValue.loading();

    File? image = read.read(checkoutFormDataProvider).image ?? null;
    var formData = read.read(checkoutFormDataProvider).toJson();
    try {
      final responseModel = await read
          .read(CustomerRepositoryProvider)
          .submitCheckoutForm(formData, image ?? null);
      showSnackBar(text: "Form Submitted successfully");
      state = AsyncValue.data(responseModel);
    } catch (e, s) {
      showSnackBar(text: "An error occurred", bgColor: Colors.red);
      print("error: ${s}");
      state = AsyncValue.error(e.toString(), s);
      throw e;
    }
  }



}

final checkoutFormDataProvider = StateProvider<CheckoutFormModel>((ref) =>
    CheckoutFormModel(
        interestedInNewOrder: "Yes",
        pricingAccuracy: "Yes",
        incorrectPricingProductName: "",
        progressStatus: "Good",
        newInsights: "",
        productVisible: "Yes",
        veryNextStep: "Push for order"));

