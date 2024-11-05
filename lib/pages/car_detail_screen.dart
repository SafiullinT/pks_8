import 'package:flutter/material.dart';
import '../models/car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;
  final VoidCallback onDeleteCar;
  final Function(Car) addToCart;

  CarDetailScreen({
    required this.car,
    required this.onDeleteCar,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Удалить автомобиль?'),
                    content: Text('Вы уверены, что хотите удалить ${car.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDeleteCar();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Удалить'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              addToCart(car);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${car.name} добавлен в корзину')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(car.imageUrl, width: 300, height: 200),
            SizedBox(height: 20),
            Text(
              car.description,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Цена: ${car.price} \$',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Характеристики:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Мощность: ${car.horsepower} л.с', style: TextStyle(fontSize: 16)),
            Text('Разгон до 100 км/ч: ${car.acceleration} с', style: TextStyle(fontSize: 16)),
            Text('Тип двигателя: ${car.engineType}', style: TextStyle(fontSize: 16)),
            Text('Максимальная скорость: ${car.maxSpeed} км/ч', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
