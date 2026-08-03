import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/Core/config/app_environment.dart';
import 'package:project_2/Core/network/dio_client.dart';
import 'package:project_2/Features/auth/bloc/companies_bloc.dart';
import 'package:project_2/Features/auth/bloc/order_bloc.dart';
import 'package:project_2/Features/auth/bloc/order_details_bloc.dart';
import 'package:project_2/Features/auth/bloc/orders_archive_bloc.dart';
import 'package:project_2/Features/auth/bloc/orders_tracking_bloc.dart';
import 'package:project_2/Features/auth/bloc/pharmacies_bloc.dart';
import 'package:project_2/Features/auth/data/datasources/companies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_companies_repository.dart';
import 'package:project_2/Features/auth/data/datasources/mock_order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_orders_tracking_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/mock_pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/orders_tracking_datasource.dart' show OrdersTrackingDataSource;
import 'package:project_2/Features/auth/data/datasources/pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_companies_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_order_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_orders_tracking_datasource.dart';
import 'package:project_2/Features/auth/data/datasources/remote_pharmacies_datasource.dart';
import 'package:project_2/Features/auth/data/repositories/companies_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/order_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/orders_tracking_repository_impl.dart';
import 'package:project_2/Features/auth/data/repositories/pharmacies_repository_impl.dart';
import 'package:project_2/Features/auth/domain/repositories/companies_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/order_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/orders_tracking_repository.dart';
import 'package:project_2/Features/auth/domain/repositories/pharmacies_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      createDioClient,
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
}