import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/productList.dart';
import 'card_product.dart';

Future<List<Product>> fetchSubjects(BuildContext context) async {
  List<Product> products = context.read<ProductList>().products;
  if (products.isEmpty) {
    var dio = Dio();
    var result = await dio.get(
        'https://66801bbc56c2c76b495b2f6e.mockapi.io/online_store/products');
    products = result.data.map<Product>(Product.fromJson).toList();

    if (context.mounted) {
      context.read<ProductList>().setProducts(products);
    }
  }

  return products;
}

class ProductsCatalog extends StatefulWidget {
  const ProductsCatalog({super.key});

  @override
  State<ProductsCatalog> createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsCatalog> {
  double _priceMax = 500;
  String _selectedOrder = 'asc';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('รายการสินค้า'))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("ราคา : "),
              ),
              Expanded(
                child: Slider(
                  value: _priceMax,
                  min: 1,
                  max: 500,
                  divisions: 100,
                  label: _priceMax.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _priceMax = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("จัดเรียง : "),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedOrder,
                  items: const [
                    DropdownMenuItem(
                        value: 'asc', child: Text('ราคาน้อยไปมาก')),
                    DropdownMenuItem(
                        value: 'desc', child: Text('ราคามากไปน้อย')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedOrder = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: fetchSubjects(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //สินค้าที่ไม่เกินราคาสูงสุด
                var products = (snapshot.data ?? [])
                    .where((p) => double.parse(p.price.toString()) < _priceMax)
                    .toList();

                //จัดเรียงตามราคา
                if (_selectedOrder == 'asc') {
                  products.sort((a, b) => double.parse(a.price.toString())
                      .compareTo(double.parse(b.price.toString())));
                } else {
                  products.sort((a, b) => double.parse(b.price.toString())
                      .compareTo(double.parse(a.price.toString())));
                }

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: (products)
                        .map<CardProduct>((p) => CardProduct(
                              product: p,
                              enableAddToCart: true,
                              enableDelete: false,
                            ))
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
