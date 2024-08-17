import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cartList.dart';
import '../models/product.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Center(child: Text(widget.product.name ?? ''))),
          body: Column(children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(image: NetworkImage(widget.product.imageUrl ?? '')),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.detail ?? ''),
            )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                  onPressed: () {
                    if (context
                        .read<CartList>()
                        .products
                        .contains(widget.product)) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return const AlertDialog(
                                title: Center(
                                    child: Text('สินค้าอยู่ในตะกร้าแล้ว')));
                          });
                    } else {
                      context.read<CartList>().add(widget.product);

                      //update icon
                      setState(() {});
                    }
                  },
                  icon:
                      context.read<CartList>().products.contains(widget.product)
                          ? const Icon(Icons.check)
                          : const Icon(Icons.add_shopping_cart),
                  label: const Text("เพิ่มเข้าตะกร้าสินค้า")),
            ),
          ])),
    );
  }
}
