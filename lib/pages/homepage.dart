import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/models/cart_model.dart';
import 'package:shopping_cart/models/product_model.dart';
import 'package:shopping_cart/pages/cartpage.dart';
import 'package:shopping_cart/widgets/products.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, CartItem> cart = {};
  static const String cartKey = "cart_data";

  List<Product> productList = [
    Product(id: 1, title: "Chair1", price: 1200, image: "assets/images/v1.jpg"),
    Product(id: 2, title: "Chair2", price: 900, image: "assets/images/v2.jpg"),
    Product(id: 3, title: "Chair3", price: 700, image: "assets/images/v3.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(cartKey);

    if (data != null) {
      List decoded = jsonDecode(data);
      for (var item in decoded) {
        CartItem ci = CartItem.fromMap(item);
        cart[ci.product.id] = ci;
      }
      setState(() {});
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List cartList = cart.values.map((c) => c.toMap()).toList();
    prefs.setString(cartKey, jsonEncode(cartList));
  }

  void addToCart(Product p) {
    setState(() {
      if (cart.containsKey(p.id)) {
        cart[p.id]!.quantity++;
      } else {
        cart[p.id] = CartItem(product: p, quantity: 1);
      }
    });
    saveCart();
  }

  int get totalItems => cart.values.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => cart.values.fold(
    0,
    (s, item) => s + (item.product.price * item.quantity),
  );

  void _updateQuantity(Product product, int delta) {
  setState(() {
    if (cart.containsKey(product.id)) {
      cart[product.id]!.quantity += delta;

      if (cart[product.id]!.quantity <= 0) {
        cart.remove(product.id);
      }
    }
  });

  saveCart();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartPage(
                        cart: cart,
                        onQuantityChanged: _updateQuantity,
                    ))
                  );
                },
                icon: Icon(Icons.shopping_cart, size: 28),
              ),
              if (totalItems > 0)
                Positioned(
                  right: 0,
                  top: 5,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      "$totalItems",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),

      body: ListView(
        children: productList.map((p) {
          return productCard(p, () => addToCart(p));
        }).toList(),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Text(
          "Total Price: ₹ $totalPrice",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
}
