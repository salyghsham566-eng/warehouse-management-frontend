import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/Core/config/app_environment.dart';
import 'package:project_2/Core/network/dio_client.dart';
import 'package:project_2/Features/auth/bloc/2pharmacy_search_bloc.dart';
import 'package:project_2/Features/auth/bloc/active_offer_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/change_password_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payment_form_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_payments_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/collection_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/companies_bloc.dart';
import 'package:project_2/Features/auth/bloc/create_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_archive_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_coverage_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_one_time_pharmacies_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_repeated_pharmacies_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_target_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/evaluation_work_plans_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_dashboard_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_indicator_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/financial_pharmacy_details_bloc.dart' show FinancialPharmacyDetailsBloc;
import 'package:project_2/Features/auth/bloc/login_bloc.dart';
import 'package:project_2/Features/auth/bloc/offers_bloc.dart';
import 'package:project_2/Features/auth/bloc/order_bloc.dart';
import 'package:project_2/Features/auth/bloc/order_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/orders_archive_bloc.dart';
import 'package:project_2/Features/auth/bloc/orders_tracking_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacy_account_statement_bloc.dart';
import 'package:project_2/Features/auth/bloc/profile_bloc.dart';
import 'package:project_2/Features/auth/bloc/promotional_basket_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/region_account_statement_bloc.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacies_bloc.dart';
import 'package:project_2/Features/auth/bloc/representative_pharmacy_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/submit_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/update_work_plan_bloc.dart';
import 'package:project_2/Features/auth/bloc/used_offers_history_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_inventory_file_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_goal_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_official_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plan_personal_note_bloc.dart';
import 'package:project_2/Features/auth/bloc/work_plans_bloc.dart';
import 'package:project_2/Features/auth/bloc/warehouse_bloc.dart';
import 'package:project_2/Features/auth/data/datasources/collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/companies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/evaluation_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_dashboard_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_dashboard_mock_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_dashboard_remote_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/financial_pharmacy_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/login_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_companies_repository.dart';
import 'package:project_2/Features/auth/data/datasources/mock_evaluation_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_financial_pharmacy_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_login_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_offers_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_orders_tracking_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_profile_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/mock_work_plans_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/offers_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/orders_tracking_datasource.dart' show OrdersTrackingDataSource;
import 'package:project_2/Features/auth/data/datasources/pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/profile_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_collection_payment_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_collection_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_companies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_evaluation_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_financial_indicator_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_financial_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_financial_pharmacy_details_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_login_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_offers_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_orders_tracking_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_pharmacy_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_profile_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_region_account_statement_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/remote_work_plans_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/representative_pharmacies_data_source.dart';
import 'package:project_2/Features/auth/data/datasources/work_plans_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/warehouse_data_source.dart';
import 'package:project_2/Features/auth/data/models/2pharmacy_model.dart';
import 'package:project_2/Features/auth/data/repositories/collection_payment_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/collection_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/companies_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/evaluation_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/financial_dashboard_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/financial_indicator_details_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/financial_pharmacies_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/financial_pharmacy_details_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/login_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/offers_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/order_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/orders_tracking_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/pharmacies_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/pharmacy_account_statement_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/profile_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/region_account_statement_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/representative_pharmacies_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/work_plans_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/warehouse_repository_impl.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_payment_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/collection_phermacy_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/companies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/evaluation_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_dashboard_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_indicator_details_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacies_repository.dart' show FinancialPharmaciesRepository;
import 'package:project_2/Features/auth/domain/repositories/financial_pharmacy_details_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/login_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/offers_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/order_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/orders_tracking_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacy_account_statement_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/profile_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/region_account_statement_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/representative_pharmacies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/work_plans_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/warehouse_repository.dart';
import 'package:project_2/Features/auth/services/pharmacy_statement_pdf_service.dart';
import 'package:project_2/Features/auth/services/region_statement_pdf_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio

  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      createDioClient,
    );
  }
    // =========================================================
  // Login
  // =========================================================

  // Login DataSource
  if (!sl.isRegistered<LoginDataSource>()) {
    sl.registerLazySingleton<LoginDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteLoginDataSource(
              dio: sl<Dio>(),
            )
          : MockLoginDataSource(),
    );
  }

  // Login Repository
  if (!sl.isRegistered<LoginRepository>()) {
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        dataSource: sl<LoginDataSource>(),
        dio: sl<Dio>(),
      ),
    );
  }

  // Login Bloc
  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory<LoginBloc>(
      () => LoginBloc(
        repository: sl<LoginRepository>(),
      ),
    );
  }

  // Companies
  if (!sl.isRegistered<CompaniesDataSource>()) {
    sl.registerLazySingleton<CompaniesDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteCompaniesDataSource(
              dio: sl<Dio>(),
            )
          : MockCompaniesDataSource(),
    );
  }

  if (!sl.isRegistered<CompaniesRepository>()) {
    sl.registerLazySingleton<CompaniesRepository>(
      () => CompaniesRepositoryImpl(
        dataSource: sl<CompaniesDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<CompaniesBloc>()) {
    sl.registerFactory<CompaniesBloc>(
      () => CompaniesBloc(
        repository: sl<CompaniesRepository>(),
      ),
    );
  }

  // Pharmacies
  if (!sl.isRegistered<PharmaciesDataSource>()) {
    sl.registerLazySingleton<PharmaciesDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemotePharmaciesDataSource(
              dio: sl<Dio>(),
            )
          : MockPharmaciesDataSource(),
    );
  }

  if (!sl.isRegistered<PharmaciesRepository>()) {
    sl.registerLazySingleton<PharmaciesRepository>(
      () => PharmaciesRepositoryImpl(
        dataSource: sl<PharmaciesDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<PharmaciesBloc>()) {
    sl.registerFactory<PharmaciesBloc>(
      () => PharmaciesBloc(
        repository: sl<PharmaciesRepository>(),
      ),
    );
  }
  // Order Datasource
if (!sl.isRegistered<OrderDataSource>()) {
  sl.registerLazySingleton<OrderDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteOrderDataSource(
            dio: sl<Dio>(),
          )
        : MockOrderDataSource(),
  );
}

// Order Repository
if (!sl.isRegistered<OrderRepository>()) {
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      dataSource: sl<OrderDataSource>(),
    ),
  );
}

// Order Bloc
if (!sl.isRegistered<OrderBloc>()) {
  sl.registerFactory<OrderBloc>(
    () => OrderBloc(
      repository: sl<OrderRepository>(),
    ),
  );
}
// Orders Tracking Datasource
if (!sl.isRegistered<OrdersTrackingDataSource>()) {
  sl.registerLazySingleton<OrdersTrackingDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteOrdersTrackingDataSource(
            dio: sl<Dio>(),
          )
        : MockOrdersTrackingDataSource(),
  );
}

// Orders Tracking Repository
if (!sl.isRegistered<OrdersTrackingRepository>()) {
  sl.registerLazySingleton<OrdersTrackingRepository>(
    () => OrdersTrackingRepositoryImpl(
      dataSource: sl<OrdersTrackingDataSource>(),
    ),
  );
}

// Orders Tracking Bloc
if (!sl.isRegistered<OrdersTrackingBloc>()) {
  sl.registerFactory<OrdersTrackingBloc>(
    () => OrdersTrackingBloc(
      repository: sl<OrdersTrackingRepository>(),
    ),
  );
}
if (!sl.isRegistered<OrderDetailsBloc>()) {
  sl.registerFactory<OrderDetailsBloc>(
    () => OrderDetailsBloc(
      repository: sl<OrdersTrackingRepository>(),
    ),
  );
}
if (!sl.isRegistered<OrdersArchiveBloc>()) {
  sl.registerFactory<OrdersArchiveBloc>(
    () => OrdersArchiveBloc(
      repository: sl<OrdersTrackingRepository>(),
    ),
  );
}
 // Collection Pharmacies DataSource
  if (!sl.isRegistered<CollectionPharmaciesDataSource>()) {
    sl.registerLazySingleton<CollectionPharmaciesDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteCollectionPharmaciesDataSource(
              dio: sl<Dio>(),
            )
          : MockCollectionPharmaciesDataSource(),
    );
  }

  // Collection Pharmacies Repository
  if (!sl.isRegistered<CollectionRepository>()) {
    sl.registerLazySingleton<CollectionRepository>(
      () => CollectionRepositoryImpl(
        dataSource: sl<CollectionPharmaciesDataSource>(),
      ),
    );
  }

  // Collection Pharmacies Bloc
  if (!sl.isRegistered<CollectionPharmaciesBloc>()) {
    sl.registerFactory<CollectionPharmaciesBloc>(
      () => CollectionPharmaciesBloc(
        repository: sl<CollectionRepository>(),
      ),
    );
  }
  if (!sl.isRegistered<
    CollectionPharmacyDetailsBloc>()) {
  sl.registerFactory<
      CollectionPharmacyDetailsBloc>(
    () => CollectionPharmacyDetailsBloc(
      repository: sl<CollectionRepository>(),
    ),
  );
}
// Collection Payment DataSource
if (!sl.isRegistered<CollectionPaymentDataSource>()) {
  sl.registerLazySingleton<
      CollectionPaymentDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteCollectionPaymentDataSource(
            dio: sl<Dio>(),
          )
        : MockCollectionPaymentDataSource(),
  );
}

// Collection Payment Repository
if (!sl.isRegistered<
    CollectionPaymentRepository>()) {
  sl.registerLazySingleton<
      CollectionPaymentRepository>(
    () => CollectionPaymentRepositoryImpl(
      dataSource:
          sl<CollectionPaymentDataSource>(),
    ),
  );
}

// Collection Payment Form Bloc
if (!sl.isRegistered<
    CollectionPaymentFormBloc>()) {
  sl.registerFactoryParam<
      CollectionPaymentFormBloc,
      CollectionPharmacyModel,
      void>(
    (pharmacy, _) =>
        CollectionPaymentFormBloc(
      repository:
          sl<CollectionPaymentRepository>(),
      pharmacy: pharmacy,
    ),
  );
}
if (!sl.isRegistered<CollectionPaymentDataSource>()) {
  sl.registerLazySingleton<
      CollectionPaymentDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteCollectionPaymentDataSource(
            dio: sl<Dio>(),
          )
        : MockCollectionPaymentDataSource(),
  );
}

if (!sl.isRegistered<
    CollectionPaymentRepository>()) {
  sl.registerLazySingleton<
      CollectionPaymentRepository>(
    () => CollectionPaymentRepositoryImpl(
      dataSource:
          sl<CollectionPaymentDataSource>(),
    ),
  );
}

if (!sl.isRegistered<
    CollectionPaymentsHistoryBloc>()) {
  sl.registerFactory<
      CollectionPaymentsHistoryBloc>(
    () => CollectionPaymentsHistoryBloc(
      repository:
          sl<CollectionPaymentRepository>(),
    ),
  );
}
  // =========================================================
  // Financial Dashboard - UC-182 / UC-183
  // =========================================================

  // Financial Dashboard DataSource
  if (!sl.isRegistered<FinancialDashboardDataSource>()) {
    sl.registerLazySingleton<FinancialDashboardDataSource>(
      () => AppEnvironment.useRemoteData
          ? FinancialDashboardRemoteDataSource(
              dio: sl<Dio>(),
            )
          : FinancialDashboardMockDataSource(),
    );
  }

  // Financial Dashboard Repository
  if (!sl.isRegistered<FinancialDashboardRepository>()) {
    sl.registerLazySingleton<FinancialDashboardRepository>(
      () => FinancialDashboardRepositoryImpl(
        dataSource: sl<FinancialDashboardDataSource>(),
      ),
    );
  }

  // Financial Dashboard Bloc
  if (!sl.isRegistered<FinancialDashboardBloc>()) {
    sl.registerFactory<FinancialDashboardBloc>(
      () => FinancialDashboardBloc(
        repository: sl<FinancialDashboardRepository>(),
      ),
    );
  }
  // =========================================================
  // Financial Pharmacies - UC-185
  // =========================================================

  if (!sl.isRegistered<FinancialPharmaciesDataSource>()) {
    sl.registerLazySingleton<
        FinancialPharmaciesDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteFinancialPharmaciesDataSource(
              dio: sl<Dio>(),
            )
          : MockFinancialPharmaciesDataSource(),
    );
  }

  if (!sl.isRegistered<FinancialPharmaciesRepository>()) {
    sl.registerLazySingleton<
        FinancialPharmaciesRepository>(
      () => FinancialPharmaciesRepositoryImpl(
        dataSource:
            sl<FinancialPharmaciesDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<FinancialPharmaciesBloc>()) {
    sl.registerFactory<FinancialPharmaciesBloc>(
      () => FinancialPharmaciesBloc(
        repository:
            sl<FinancialPharmaciesRepository>(),
      ),
    );
  }
    // =========================================================
  // Financial Indicator Details - UC-186
  // =========================================================

  if (!sl.isRegistered<
      FinancialIndicatorDetailsDataSource>()) {
    sl.registerLazySingleton<
        FinancialIndicatorDetailsDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteFinancialIndicatorDetailsDataSource(
              dio: sl<Dio>(),
            )
          : MockFinancialIndicatorDetailsDataSource(),
    );
  }

  if (!sl.isRegistered<
      FinancialIndicatorDetailsRepository>()) {
    sl.registerLazySingleton<
        FinancialIndicatorDetailsRepository>(
      () => FinancialIndicatorDetailsRepositoryImpl(
        dataSource:
            sl<FinancialIndicatorDetailsDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<
      FinancialIndicatorDetailsBloc>()) {
    sl.registerFactory<
        FinancialIndicatorDetailsBloc>(
      () => FinancialIndicatorDetailsBloc(
        repository:
            sl<FinancialIndicatorDetailsRepository>(),
      ),
    );
  }
    // =========================================================
  // Financial Pharmacy Details - UC-187
  // =========================================================

  if (!sl.isRegistered<
      FinancialPharmacyDetailsDataSource>()) {
    sl.registerLazySingleton<
        FinancialPharmacyDetailsDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteFinancialPharmacyDetailsDataSource(
              dio: sl<Dio>(),
            )
          : MockFinancialPharmacyDetailsDataSource(),
    );
  }

  if (!sl.isRegistered<
      FinancialPharmacyDetailsRepository>()) {
    sl.registerLazySingleton<
        FinancialPharmacyDetailsRepository>(
      () => FinancialPharmacyDetailsRepositoryImpl(
        dataSource:
            sl<FinancialPharmacyDetailsDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<
      FinancialPharmacyDetailsBloc>()) {
    sl.registerFactory<
        FinancialPharmacyDetailsBloc>(
      () => FinancialPharmacyDetailsBloc(
        repository:
            sl<FinancialPharmacyDetailsRepository>(),
      ),
    );
  }
    // =========================================================
  // Pharmacy Account Statement - UC-188
  // =========================================================

  if (!sl.isRegistered<
      PharmacyAccountStatementDataSource>()) {
    sl.registerLazySingleton<
        PharmacyAccountStatementDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemotePharmacyAccountStatementDataSource(
              dio: sl<Dio>(),
            )
          : MockPharmacyAccountStatementDataSource(),
    );
  }

  if (!sl.isRegistered<
      PharmacyAccountStatementRepository>()) {
    sl.registerLazySingleton<
        PharmacyAccountStatementRepository>(
      () => PharmacyAccountStatementRepositoryImpl(
        dataSource:
            sl<PharmacyAccountStatementDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<
      PharmacyAccountStatementBloc>()) {
    sl.registerFactory<
        PharmacyAccountStatementBloc>(
      () => PharmacyAccountStatementBloc(
        repository:
            sl<PharmacyAccountStatementRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<
      PharmacyStatementPdfService>()) {
    sl.registerLazySingleton<
        PharmacyStatementPdfService>(
      () => PharmacyStatementPdfService(),
    );
  }
    // =========================================================
  // Region Account Statement - UC-189
  // =========================================================

  if (!sl.isRegistered<
      RegionAccountStatementDataSource>()) {
    sl.registerLazySingleton<
        RegionAccountStatementDataSource>(
      () => AppEnvironment.useRemoteData
          ? RemoteRegionAccountStatementDataSource(
              dio: sl<Dio>(),
            )
          : MockRegionAccountStatementDataSource(),
    );
  }

  if (!sl.isRegistered<
      RegionAccountStatementRepository>()) {
    sl.registerLazySingleton<
        RegionAccountStatementRepository>(
      () => RegionAccountStatementRepositoryImpl(
        dataSource:
            sl<RegionAccountStatementDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<
      RegionAccountStatementBloc>()) {
    sl.registerFactory<
        RegionAccountStatementBloc>(
      () => RegionAccountStatementBloc(
        repository:
            sl<RegionAccountStatementRepository>(),
      ),
    );
  }

  if (!sl.isRegistered<
      RegionStatementPdfService>()) {
    sl.registerLazySingleton<
        RegionStatementPdfService>(
      () => RegionStatementPdfService(),
    );
  }
  // ==========================================================
// Work Plans - UC-191
// ==========================================================

if (!sl.isRegistered<WorkPlansDataSource>()) {
  sl.registerLazySingleton<WorkPlansDataSource>(
    () {
      if (AppEnvironment.useRemoteData) {
        return RemoteWorkPlansDataSource(
          dio: sl<Dio>(),
        );
      }

      return MockWorkPlansDataSource();
    },
  );
}

if (!sl.isRegistered<WorkPlansRepository>()) {
  sl.registerLazySingleton<WorkPlansRepository>(
    () => WorkPlansRepositoryImpl(
      dataSource:
          sl<WorkPlansDataSource>(),
    ),
  );
}

if (!sl.isRegistered<WorkPlansBloc>()) {
  sl.registerFactory<WorkPlansBloc>(
    () => WorkPlansBloc(
      repository:
          sl<WorkPlansRepository>(),
    ),
  );
}
// ==========================================================
// Work Plans
// ==========================================================
if (!sl.isRegistered<WorkPlanDetailsBloc>()) {
  sl.registerFactory<WorkPlanDetailsBloc>(
    () => WorkPlanDetailsBloc(
      repository: sl<WorkPlansRepository>(),
    ),
  );
}

if (!sl.isRegistered<WorkPlanGoalDetailsBloc>()) {
  sl.registerFactory<WorkPlanGoalDetailsBloc>(
    () => WorkPlanGoalDetailsBloc(
      repository: sl<WorkPlansRepository>(),
    ),
  );
}
if (!sl.isRegistered<WorkPlanPersonalNoteBloc>()) {
  sl.registerFactory<WorkPlanPersonalNoteBloc>(
    () => WorkPlanPersonalNoteBloc(
      repository: sl<WorkPlansRepository>(),
    ),
  );
}if (!sl.isRegistered<WorkPlanOfficialNoteBloc>()) {
  sl.registerFactory<WorkPlanOfficialNoteBloc>(
    () => WorkPlanOfficialNoteBloc(
      repository: sl<WorkPlansRepository>(),
    ),
  );
}
// ==========================================================
// Create Work Plan - UC-200
// ==========================================================

if (!sl.isRegistered<CreateWorkPlanBloc>()) {
  sl.registerFactory<CreateWorkPlanBloc>(
    () => CreateWorkPlanBloc(
      repository:
          sl<WorkPlansRepository>(),
    ),
  );
}
// =========================================================
// Submit Work Plan - UC-201
// =========================================================

if (!sl.isRegistered<SubmitWorkPlanBloc>()) {
  sl.registerFactory<SubmitWorkPlanBloc>(
    () => SubmitWorkPlanBloc(
      repository:
          sl<WorkPlansRepository>(),
    ),
  );
}
// =========================================================
// Update Work Plan - UC-203
// =========================================================

if (!sl.isRegistered<UpdateWorkPlanBloc>()) {
  sl.registerFactory<UpdateWorkPlanBloc>(
    () => UpdateWorkPlanBloc(
      repository:
          sl<WorkPlansRepository>(),
    ),
  );
}
// =========================================================
// Evaluation - UC-204
// =========================================================

// DataSource
if (!sl.isRegistered<EvaluationDataSource>()) {
  sl.registerLazySingleton<
      EvaluationDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteEvaluationDataSource(
            dio: sl<Dio>(),
          )
        : MockEvaluationDataSource(),
  );
}

// Repository
if (!sl.isRegistered<
    EvaluationRepository>()) {
  sl.registerLazySingleton<
      EvaluationRepository>(
    () => EvaluationRepositoryImpl(
      dataSource:
          sl<EvaluationDataSource>(),
    ),
  );
}

// Bloc
if (!sl.isRegistered<EvaluationBloc>()) {
  sl.registerFactory<EvaluationBloc>(
    () => EvaluationBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}// =========================================================
// Evaluation Target Details - UC-206
// =========================================================

if (!sl.isRegistered<
    EvaluationTargetDetailsBloc>()) {
  sl.registerFactory<
      EvaluationTargetDetailsBloc>(
    () => EvaluationTargetDetailsBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}
// =========================================================
// Evaluation Coverage Details - UC-207
// =========================================================

if (!sl.isRegistered<
    EvaluationCoverageDetailsBloc>()) {
  sl.registerFactory<
      EvaluationCoverageDetailsBloc>(
    () =>
        EvaluationCoverageDetailsBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}
// =========================================================
// Evaluation Repeated Pharmacies - UC-208
// =========================================================

if (!sl.isRegistered<
    EvaluationRepeatedPharmaciesDetailsBloc>()) {
  sl.registerFactory<
      EvaluationRepeatedPharmaciesDetailsBloc>(
    () =>
        EvaluationRepeatedPharmaciesDetailsBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}// =========================================================
// Evaluation One Time Pharmacies - UC-209
// =========================================================

if (!sl.isRegistered<
    EvaluationOneTimePharmaciesDetailsBloc>()) {
  sl.registerFactory<
      EvaluationOneTimePharmaciesDetailsBloc>(
    () =>
        EvaluationOneTimePharmaciesDetailsBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}// =========================================================
// Evaluation Work Plans - UC-211
// =========================================================

if (!sl.isRegistered<
    EvaluationWorkPlansBloc>()) {
  sl.registerFactory<
      EvaluationWorkPlansBloc>(
    () => EvaluationWorkPlansBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}
// =========================================================
// Evaluation Archive - UC-212
// =========================================================

if (!sl.isRegistered<
    EvaluationArchiveBloc>()) {
  sl.registerFactory<
      EvaluationArchiveBloc>(
    () => EvaluationArchiveBloc(
      repository:
          sl<EvaluationRepository>(),
    ),
  );
}
// =========================================================
// Offers & Discounts - UC-213
// =========================================================

// Data Source
if (!sl.isRegistered<
    OffersDataSource>()) {
  sl.registerLazySingleton<
      OffersDataSource>(
    () =>
        AppEnvironment.useRemoteData
            ? RemoteOffersDataSource(
                dio: sl<Dio>(),
              )
            : MockOffersDataSource(),
  );
}

// Repository
if (!sl.isRegistered<
    OffersRepository>()) {
  sl.registerLazySingleton<
      OffersRepository>(
    () =>
        OffersRepositoryImpl(
      dataSource:
          sl<OffersDataSource>(),
    ),
  );
}

// Bloc
if (!sl.isRegistered<
    OffersBloc>()) {
  sl.registerFactory<
      OffersBloc>(
    () => OffersBloc(
      repository:
          sl<OffersRepository>(),
    ),
  );
}
// =========================================================
// Promotional Basket Details - UC-214 -> UC-218
// =========================================================

if (!sl.isRegistered<
    PromotionalBasketDetailsBloc>()) {
  sl.registerFactory<
      PromotionalBasketDetailsBloc>(
    () =>
        PromotionalBasketDetailsBloc(
      repository:
          sl<OffersRepository>(),
    ),
  );
}
// =========================================================
// Used Offers History - UC-220 -> UC-221
// =========================================================

if (!sl.isRegistered<
    UsedOffersHistoryBloc>()) {
  sl.registerFactory<
      UsedOffersHistoryBloc>(
    () =>
        UsedOffersHistoryBloc(
      repository:
          sl<OffersRepository>(),
    ),
  );
}
// =========================================================
// Active Offer Details
// =========================================================

if (!sl.isRegistered<
    ActiveOfferDetailsBloc>()) {
  sl.registerFactory<
      ActiveOfferDetailsBloc>(
    () => ActiveOfferDetailsBloc(
      repository:
          sl<OffersRepository>(),
    ),
  );
}
// =========================================================
// Warehouse - UC-222
// =========================================================

if (!sl.isRegistered<WarehouseDataSource>()) {
  sl.registerLazySingleton<WarehouseDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteWarehouseDataSource(
            dio: sl<Dio>(),
          )
        : MockWarehouseDataSource(),
  );
}

if (!sl.isRegistered<WarehouseRepository>()) {
  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(
      dataSource: sl<WarehouseDataSource>(),
    ),
  );
}

if (!sl.isRegistered<WarehouseBloc>()) {
  sl.registerFactory<WarehouseBloc>(
    () => WarehouseBloc(
      repository: sl<WarehouseRepository>(),
    ),
  );
}
if (!sl.isRegistered<
    WarehouseInventoryFileBloc>()) {
  sl.registerFactory<
      WarehouseInventoryFileBloc>(
    () => WarehouseInventoryFileBloc(
      repository:
          sl<WarehouseRepository>(),
    ),
  );
}// =========================================================
// Representative Pharmacies - UC-235 -> UC-241
// =========================================================

if (!sl.isRegistered<
    RepresentativePharmaciesDataSource>()) {
  sl.registerLazySingleton<
      RepresentativePharmaciesDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteRepresentativePharmaciesDataSource(
            dio: sl<Dio>(),
          )
        : MockRepresentativePharmaciesDataSource(),
  );
}

if (!sl.isRegistered<
    RepresentativePharmaciesRepository>()) {
  sl.registerLazySingleton<
      RepresentativePharmaciesRepository>(
    () =>
        RepresentativePharmaciesRepositoryImpl(
      dataSource:
          sl<RepresentativePharmaciesDataSource>(),
    ),
  );
}

if (!sl.isRegistered<
    RepresentativePharmaciesBloc>()) {
  sl.registerFactory<
      RepresentativePharmaciesBloc>(
    () => RepresentativePharmaciesBloc(
      repository:
          sl<RepresentativePharmaciesRepository>(),
    ),
  );
}if (!sl.isRegistered<
    RepresentativePharmacyDetailsBloc>()) {
  sl.registerFactory<
      RepresentativePharmacyDetailsBloc>(
    () =>
        RepresentativePharmacyDetailsBloc(
      repository:
          sl<RepresentativePharmaciesRepository>(),
    ),
  );
}// =========================================================
// Account / Profile - UC-261 -> UC-266
// =========================================================

if (!sl.isRegistered<ProfileDataSource>()) {
  sl.registerLazySingleton<ProfileDataSource>(
    () => AppEnvironment.useRemoteData
        ? RemoteProfileDataSource(
            dio: sl<Dio>(),
          )
        : MockProfileDataSource(),
  );
}

if (!sl.isRegistered<ProfileRepository>()) {
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      dataSource: sl<ProfileDataSource>(),
    ),
  );
}

if (!sl.isRegistered<ProfileBloc>()) {
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      profileRepository:
          sl<ProfileRepository>(),
    ),
  );
}if (!sl.isRegistered<
    ChangePasswordBloc>()) {
  sl.registerFactory<
      ChangePasswordBloc>(
    () => ChangePasswordBloc(
      repository:
          sl<ProfileRepository>(),
    ),
  );
}
}