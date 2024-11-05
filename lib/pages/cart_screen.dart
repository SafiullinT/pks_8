import 'package:flutter/material.dart';
import '../models/car.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends StatefulWidget {
  final List<Car> cart;
  final Function(Car) removeFromCart;

  CartScreen({required this.cart, required this.removeFromCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
      ),
      body: widget.cart.isEmpty
          ? Center(
        child: Text(
          'В корзине отсутствуют товары',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final car = widget.cart[index];
                return Slidable(
                  key: ValueKey(car),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => widget.removeFromCart(car),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Удалить',
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.network(car.imageUrl, width: 50, height: 50),
                    title: Text(car.name),
                    subtitle: Text('\$${(car.price * car.quantity).toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (car.quantity > 1) {
                                car.quantity--;
                              } else {
                                widget.removeFromCart(car);
                              }
                            });
                          },
                        ),
                        Text('${car.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              car.quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Общая сумма: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
