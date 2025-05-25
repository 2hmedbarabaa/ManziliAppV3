import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/core/globals/globals.dart';
import 'package:manziliapp/main.dart';

class AuthMiddleware extends GetMiddleware {
  // The priority field determines the order of middleware execution (lower values run first)
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    // Access the UserController instance
    final UserController userController = Get.find<UserController>();

    final user = sharedPreferences!.getString('userType'); 
                  

    // If userToken is empty, user is not authenticated, so redirect to login page.
    if (userController.userToken.value.isNotEmpty) {
      if (user == 'customer') {
        return const RouteSettings(name: '/home');
      } else if(user == 'producer') {
        return const RouteSettings(name: '/homestore');
      }
    }
    // Otherwise, no redirection is needed.
    return null;
  }
}
