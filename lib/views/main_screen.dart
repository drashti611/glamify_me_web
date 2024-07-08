// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:glamify_me_web/views/screens/side_bar_screen/buyers_screen.dart';
import 'package:glamify_me_web/views/screens/side_bar_screen/categories_screen.dart';
import 'package:glamify_me_web/views/screens/side_bar_screen/dashborard.dart';
import 'package:glamify_me_web/views/screens/side_bar_screen/products_screen.dart';
import 'package:glamify_me_web/views/screens/side_bar_screen/upload_banner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case BuyersScreen.routeName:
        setState(() {
          _selectedItem = BuyersScreen();
        });
        break;
      case CategoriesScreen.routeName:
        setState(() {
          _selectedItem = CategoriesScreen();
        });
        break;
      case ProductsScreen.routeName:
        setState(() {
          _selectedItem = ProductsScreen();
        });
        break;
      case UploadBannerScreen.routeName:
        setState(() {
          _selectedItem = UploadBannerScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 49, 49),
        title: Text(
          'Glamify Me Admin Panel',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      sideBar: SideBar(
        backgroundColor: Color.fromARGB(255, 241, 238, 238),
        iconColor: Color.fromARGB(255, 77, 49, 49),
        width: 200,
        textStyle: TextStyle(
            color: Color.fromARGB(255, 77, 49, 49),
            fontWeight: FontWeight.w500),
        // activeIconColor: Color.fromARGB(255, 19, 3, 3),
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard_rounded,
            route: DashboardScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Buyers',
            icon: CupertinoIcons.person_3,
            route: BuyersScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Categories',
            icon: Icons.category_rounded,
            route: CategoriesScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Products',
            icon: Icons.shop_rounded,
            route: ProductsScreen.routeName,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            icon: CupertinoIcons.add,
            route: UploadBannerScreen.routeName,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        // header: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: Color.fromARGB(255, 77, 49, 49),
        //   child: Center(
        //     child: Text(
        //       'Glamify Me',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: Color.fromARGB(255, 77, 49, 49),
          child: Center(
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
