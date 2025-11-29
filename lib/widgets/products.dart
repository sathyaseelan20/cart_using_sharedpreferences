import 'package:flutter/material.dart';
import 'package:shopping_cart/models/product_model.dart';

Widget productCard(Product p, VoidCallback onAdd) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Color.fromARGB(255, 33, 243, 205),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(2, 2)
        )
      ],
                  
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Image.asset(p.image, height: 150),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      p.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text("₹ ${p.price}"),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 10),

        ElevatedButton(
          onPressed: onAdd,
          child: Text("Add to Cart",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 87, 71),
              ),
        ),)
      ],
    ),
  );
}
