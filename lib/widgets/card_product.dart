import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cartList.dart';
import '../models/product.dart';
import 'product_detail.dart';

class CardProduct extends StatefulWidget {
  final Product product;
  final bool enableAddToCart;
  final bool enableDelete;

  const CardProduct(
      {super.key,
      required this.product,
      required this.enableAddToCart,
      required this.enableDelete});

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(product: widget.product)))
      },
      child: Card(
        child: ListTile(
          leading: Image(image: NetworkImage(widget.product.imageUrl ?? '')),
          title: Text(widget.product.name ?? ''),
          subtitle: Text(widget.product.price ?? ''),
          trailing: TextButton(
            child: widget.enableAddToCart
                ? context.read<CartList>().products.contains(widget.product)
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.orange,
                      )
                : const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
            onPressed: () {
              if (widget.enableAddToCart &&
                  !context.read<CartList>().products.contains(widget.product)) {
                context.read<CartList>().add(widget.product);

                setState(() {});
              }
              if (widget.enableDelete) {
                context.read<CartList>().remove(widget.product);
              }
            },
          ),
        ),
      ),
    );
  }
}
