import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:soko_flow/base/show_custom_snackbar.dart';
import 'package:soko_flow/controllers/allocations_controller.dart';
import 'package:soko_flow/controllers/customers_controller.dart';
import 'package:soko_flow/controllers/product_category_controller.dart';
import 'package:soko_flow/controllers/product_controller.dart';
import 'package:soko_flow/data/repository/customer/customer_repository.dart';
import 'package:soko_flow/data/repository/new_leads_repo.dart';
import 'package:soko_flow/data/repository/orders_count_repo.dart';
import 'package:soko_flow/data/repository/products_repo/products_repo_provider.dart';
import 'package:soko_flow/data/repository/routes_repo.dart';
import 'package:soko_flow/data/repository/sales_count.dart';
import 'package:soko_flow/data/repository/visit_count_repo.dart';
import 'package:soko_flow/models/company_outlets/company_outlets_model.dart';
import 'package:soko_flow/models/leadsModel/new_leads.dart';
import 'package:soko_flow/models/ordersCountModel/orders_count.dart';
import 'package:soko_flow/models/salesCountModel/sales_count.dart';
import 'package:soko_flow/models/visitCountModel/visit_count.dart';


final dataSyncRepositoryProvider =
Provider<DataSyncRepository>((ref) => DataSyncRepository(ref));

class DataSyncRepository extends StateNotifier {
  final Ref ref;
  DataSyncRepository(this.ref) : super(0);
  Future<bool> syncData() async{
    try{
      await Get.find<ProductCategoryController>().getProductCategories();
      await Get.find<StockHistoryController>().getLatestAllocations(true);
      await Get.find<CustomersController>().getCustomers(45, true);

      await ref.read(CustomerRepositoryProvider).getOutlets(true);
      await ref.read(CustomerRepositoryProvider).getRoutes(true);
      await ref.read(visitsCountRepositoryProvider).getVisitsCount();
      await ref.read(newLeadsRepositoryProvider).getNewLeads();
      await ref.read(ordersCountRepositoryProvider).getOrdersCount();
      await ref.read(salesCountRepositoryProvider).getSalesCount();
      await ref.read(productsRepo).getProducts(true);
      await ref.read(routesRepository).getUserRoutes(true);


      showCustomSnackBar("Successfully synced Data", isError: false);
      return true;
    }on Exception catch (exception) {
      if(exception.toString().contains("SocketException") || exception.toString().contains("TimeoutException")){
        showCustomSnackBar("Stable internet connection needed to sync");
        throw exception;
      }else{
        showCustomSnackBar(exception.toString());
        throw exception;
      }

    } catch (error) {
      showCustomSnackBar(error.toString());
      throw error;
      // executed for errors of all types other than Exception
    }
  }
}
