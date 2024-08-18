import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/productList.dart';
import 'product_form.dart';

Future<List<Product>> fetchProducts(BuildContext context) async {
  late List<Product> products;
  var dio = Dio();
  var response = await dio
      .get('https://66801bbc56c2c76b495b2f6e.mockapi.io/online_store/products');

  if (response.statusCode == 200) {
    products = response.data.map<Product>(Product.fromJson).toList();

    //เรียงจาก id มากไปน้อย
    products.sort((a, b) =>
        double.parse(b.id.toString()).compareTo(double.parse(a.id.toString())));

    if (context.mounted) {
      context.read<ProductList>().setProducts(products);
    }
  }

  return products;
}

Future deleteProduct(BuildContext context, Product product) async {
  var dio = Dio();
  var id = product.id;
  var response = await dio.delete(
      'https://66801bbc56c2c76b495b2f6e.mockapi.io/online_store/products/$id');

  if (response.statusCode == 200) {
    if (context.mounted) {
      fetchProducts(context);
    }
  }
}

class ProductsManage extends StatefulWidget {
  const ProductsManage({super.key});

  @override
  State<ProductsManage> createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('จัดการสินค้า'))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => const ProductForm()))
                            .then((value) => setState(() {}));
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("เพิ่มสินค้า")),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: fetchProducts(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var products = (snapshot.data ?? []);

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: (products)
                        .map<Card>(
                          (p) => Card(
                            child: ListTile(
                              leading:
                                  Image(image: NetworkImage(p.imageUrl ?? '')),
                              title: Text(p.name ?? ''),
                              subtitle: Text(p.price ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductForm(product: p)))
                                          .then((value) => setState(() {}));
                                    },
                                  ),
                                  TextButton(
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        deleteProduct(context, p);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
