import 'package:get/get.dart';

class NavigationService {

  static NavigationService? _instance;
  NavigationService._();
  factory NavigationService() => getInstance;

  static NavigationService get getInstance {
    if (_instance == null) {
      _instance = new NavigationService._();
    }
    return _instance!;
  }

  dashboardActivity() => Get.offNamed('/dashboardActivity');

  moviesFormActivity({bool? isEdit = false, int? id = -1}) => Get.offNamed('/moviesFormActivity', arguments: {'isEdit': isEdit, 'id': id});

}