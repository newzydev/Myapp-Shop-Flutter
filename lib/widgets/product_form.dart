import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

Future updateProduct(BuildContext context, Product product) async {
  var dio = Dio();
  var id = product.id;
  var productJSON = jsonEncode(product.toJson());
  var response = await dio.put(
    'https://66801bbc56c2c76b495b2f6e.mockapi.io/online_store/products/$id',
    data: productJSON,
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_api_token',
      },
    ),
  );

  if (response.statusCode == 200) {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

Future createProduct(BuildContext context, Product product) async {
  var dio = Dio();
  var productJSON = jsonEncode(product.toJson());
  var response = await dio.post(
    'https://66801bbc56c2c76b495b2f6e.mockapi.io/online_store/products',
    data: productJSON,
    options: Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_api_token',
      },
    ),
  );

  if (response.statusCode == 201) {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class ProductForm extends StatefulWidget {
  final Product? product;

  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: widget.product?.name);
    final TextEditingController priceController =
        TextEditingController(text: widget.product?.price);
    final TextEditingController detailController =
        TextEditingController(text: widget.product?.detail);
    final TextEditingController imageUrlController =
        TextEditingController(text: widget.product?.imageUrl);

    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text(widget.product?.name ?? 'เพิ่มสินค้า'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาระบุชื่อสินค้า';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'ราคา',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number, // Number input for price
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาราคา';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: detailController,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Multiline input for description
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาระบุรายละเอียด';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL รูปสินค้า',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาระบุ URL รูปสินค้า';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton.icon(
                  label: const Text('บันทึก'),
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Product newProduct = Product.empty();
                      newProduct.name = nameController.text;
                      newProduct.detail = detailController.text;
                      newProduct.price = priceController.text;
                      newProduct.imageUrl = imageUrlController.text;

                      var productId = widget.product?.id;

                      if (productId?.isNotEmpty ?? false) {
                        //ระบุ id ที่ต้องการอัพเดท
                        newProduct.id = productId;
                        updateProduct(context, newProduct);
                      } else {
                        createProduct(context, newProduct);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
