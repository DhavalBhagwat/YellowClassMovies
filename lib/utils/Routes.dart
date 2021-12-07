import 'package:get/get.dart';
import 'package:app/ui/lib.dart';

class Routes {

  static final routes = [
    GetPage(name: '/loginActivity', page: () => LoginActivity()),
    GetPage(name: '/dashboardActivity', page: () => DashboardActivity()),
    GetPage(name: '/moviesFormActivity', page: () => MoviesFormActivity()),
  ];

}
