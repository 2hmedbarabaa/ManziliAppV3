import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/auth_controller.dart';
import 'package:manziliapp/controller/category_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/middleware/auth_middelware.dart';
import 'package:manziliapp/model/order.dart';
import 'package:manziliapp/providers/category_providers.dart';
import 'package:manziliapp/view/home_store_view.dart';
import 'package:manziliapp/view/home_view.dart';
import 'package:manziliapp/view/login_view.dart';
import 'package:manziliapp/view/product_srore_dashbord_view.dart';
import 'package:manziliapp/view/profile.dart';
import 'package:manziliapp/view/profile_store.dart';
import 'package:manziliapp/view/register_view.dart';
import 'package:manziliapp/view/splash_view.dart';
import 'package:manziliapp/view/store_dashboard.dart';
import 'package:manziliapp/view/store_order_details_view.dart';
import 'package:manziliapp/view/store_orders_view.dart';
import 'package:manziliapp/widget/home/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

SharedPreferences? sharedPreferences;
//SharedPreferences? prefs2;
//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sharedPreferences
  sharedPreferences = await SharedPreferences.getInstance();

  // Register controllers
  Get.put(UserController());
  await Get.find<UserController>().loadUserData();

  Get.put(AuthController());
  Get.put(CategoryController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

//Future<void> _initLocalNotifications() async {
//  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//  const initSettings = InitializationSettings(android: androidSettings);
//  await flutterLocalNotificationsPlugin.initialize(initSettings);
//}

// Future<void> showLocalNotification(String title, String body) async {
//   const androidDetails = AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const platformDetails = NotificationDetails(android: androidDetails);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     platformDetails,
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/sp',
      getPages: [
        GetPage(
          name: '/sp',
          page: () => const SplashsView(),
        middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),
        GetPage(
          name: '/homestore',
          page: () => const HomeStoreView(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
        ),
        GetPage(
          name: '/sov',
          page: () {
            // Provide a dummy Order object for navigation testing
            // Replace this with your actual order fetching logic
            final dummyOrder = Order(
              id: '1',
              customerName: 'عميل تجريبي',
              customerAvatar: '',
              customerPhone: '777777777',
              customerEmail: 'dummy@email.com',
              customerAddress: 'عنوان تجريبي',
              items: [
                OrderItem(name: 'منتج 1', price: 10.0, quantity: 2, id: '1'),
                OrderItem(name: 'منتج 2', price: 5.0, quantity: 1, id: '2'),
              ],
              status: OrderStatus.new_order,
              date: DateTime.now(),
              notes: 'ملاحظة تجريبية',
            );
            return StoreOrderDetailsView(order: dummyOrder);
          },
        ),
      ],
    );
  }
}

class CartController extends GetxController {
  var isInCart = true.obs;
  var isLoading = false.obs;

  void toggleCartState() {
    isInCart.value = !isInCart.value;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void removeFromCart() {
    isInCart.value = true;
  }
}
