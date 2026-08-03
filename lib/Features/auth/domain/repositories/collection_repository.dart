import 'package:project_2/Features/auth/data/models/Collection_modle.dart';

abstract interface class CollectionRepository {
  Future<CollectionDashboardModel> getDashboard();
}
