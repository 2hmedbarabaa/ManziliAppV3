  import 'package:flutter/material.dart';
  import 'package:manziliapp/core/helper/app_colors.dart';
import 'package:manziliapp/view/home_view.dart';
  import 'package:manziliapp/view/product_srore_dashbord_view.dart';
  import 'package:manziliapp/view/profile_store.dart';
  import 'package:manziliapp/view/store_dashboard.dart';
  import 'package:manziliapp/view/store_orders_view.dart';
import 'package:manziliapp/widget/home/home_view_body.dart';
  import 'package:manziliapp/widget/home/storelistsection.dart';

  class HomeStoreViewBody extends StatefulWidget {
    const HomeStoreViewBody({super.key});

    @override
    _HomeStoreViewBodyState createState() => _HomeStoreViewBodyState();
  }

  class _HomeStoreViewBodyState extends State<HomeStoreViewBody> {
    int _currentIndex = 4;

    // List of pages to navigate.
    final List<Widget> _pages = [
      const StoreProfileScreen(),
      const StoreOrdersView(),
      const StartPage(),
      const ProductSroreDashbordView(),
      const StoreDashboard(),
      
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white, // White background
          selectedItemColor: const Color(0xFF1548C7), // Active color
          unselectedItemColor: const Color(0xFF949494), // Inactive color
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'الحساب ',
            ),
              BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'الطلبات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore), 
              label: 'استكشاف',
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'منتجاتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
          ],
        ),
      );
    }
  }
