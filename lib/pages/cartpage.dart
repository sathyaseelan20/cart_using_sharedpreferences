import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/models/cart_model.dart';
import 'package:shopping_cart/models/product_model.dart';

class CartPage extends StatefulWidget {
  final Map<int, CartItem> cart;
  final Function(Product, int) onQuantityChanged;

  const CartPage({
    super.key,
    required this.cart,
    required this.onQuantityChanged,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const String cartKey = "cart_data";

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List cartList = widget.cart.values.map((c) => c.toMap()).toList();
    prefs.setString(cartKey, jsonEncode(cartList));
  }

  int get totalPrice => widget.cart.values.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));

  int get totalItems =>
      widget.cart.values.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),

      body: items.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                CartItem item = items[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    children: [
          
                      Image.asset(item.product.image,
                          height: 70, width: 70, fit: BoxFit.cover),

                      SizedBox(width: 10),

                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 5),
                            Text("₹ ${item.product.price}",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              widget.onQuantityChanged(item.product, -1);
                              saveCart();
                              setState(() {});
                            },
                          ),

                          Text(
                            "${item.quantity}",
                            style: TextStyle(fontSize: 16),
                          ),

                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              widget.onQuantityChanged(item.product, 1);
                              saveCart();
                              setState(() {});
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Items: $totalItems"),
                Text(
                  "Total: ₹ $totalPrice",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                widget.cart.clear();
                saveCart();
                Navigator.pop(context);
              },
              child: Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
