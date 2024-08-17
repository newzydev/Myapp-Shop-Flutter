import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cartList.dart';
import '../models/product.dart';
import 'card_product.dart';

Future<List<Product>> fetchProducts(BuildContext context) async {
  return context.watch<CartList>().products;
}

class ShopingCart extends StatelessWidget {
  const ShopingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Center(child: Text('ตะกร้าสินค้า'))),
        body: Center(
          child: FutureBuilder(
            future: fetchProducts(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: (snapshot.data ?? [])
                      .map<CardProduct>((p) => CardProduct(
                            product: p,
                            enableAddToCart: false,
                            enableDelete: true,
                          ))
                      .toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
