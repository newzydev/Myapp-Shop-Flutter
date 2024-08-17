import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cartList.dart';
import 'models/productList.dart';
import 'widgets/products_catalog.dart';
import 'widgets/profile.dart';
import 'widgets/shoping_cart.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductList()),
    ChangeNotifierProvider(create: (_) => CartList())
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: MaterialApp(
          home: Scaffold(
        body: TabBarView(
          children: <Widget>[
            ProductsCatalog(),
            ShopingCart(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(
                Icons.list,
                color: Colors.red,
              ),
              text: "Catalog",
            ),
            Tab(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.red,
              ),
              text: "Cart",
            ),
            Tab(
              icon: Icon(
                Icons.person,
                color: Colors.red,
              ),
              text: "Profile",
            ),
          ],
            labelColor: Colors.red,
            unselectedLabelColor: Colors.red,
            indicatorColor: Colors.red,
            indicatorWeight: 3.0,
        ),
          backgroundColor: Colors.white,
      )),
    );
  }
}
