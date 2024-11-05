import 'package:flutter/material.dart';
import '../models/car.dart';


class CarCard extends StatelessWidget {
  final Car car;
  final VoidCallback onDeleteCar;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  CarCard({
    required this.car,
    required this.onDeleteCar,
    required this.onToggleFavorite,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: Image.network(
                  car.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${car.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(car.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: onToggleFavorite,
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: onAddToCart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
