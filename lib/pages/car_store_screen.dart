import 'package:flutter/material.dart';
import 'dart:async'; // Импорт для работы с таймерами
import '../models/car.dart';
import '../service/api_service.dart';
import 'add_car_screen.dart';
import '../components/car_card.dart';
import 'car_detail_screen.dart';

class CarStoreScreen extends StatefulWidget {
  final List<Car> cars;
  final Function addCar;
  final Function toggleFavorite;
  final Function addToCart;

  CarStoreScreen({
    required this.cars,
    required this.addCar,
    required this.toggleFavorite,
    required this.addToCart,
  });

  @override
  _CarStoreScreenState createState() => _CarStoreScreenState();
}

class _CarStoreScreenState extends State<CarStoreScreen> {
  List<Car> _products = [];
  bool _isLoading = true;
  Timer? _timer; // Добавляем таймер

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    // Настройка таймера для обновления данных каждые 10 секунд
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      _fetchProducts();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Отмените таймер при уничтожении виджета
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true; // Установите флаг загрузки при каждом запросе
    });
    try {
      final products = await ApiService().getCars();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить продукты: $e')),
      );
    }
  }

  void _deleteCar(Car car) {
    setState(() {
      _products.remove(car);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин автомобилей'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(child: Text('Нет автомобилей в магазине'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final car = _products[index];
          return CarCard(
            car: car,
            onDeleteCar: () => _deleteCar(car),
            onToggleFavorite: () => widget.toggleFavorite(car),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    car: car,
                    onDeleteCar: () => _deleteCar(car),
                    addToCart: (car) {
                      widget.addToCart(car);
                      _showSnackBar('${car.name} добавлен в корзину');
                    },
                  ),
                ),
              );
            },
            onAddToCart: () {
              widget.addToCart(car);
              _showSnackBar('${car.name} добавлен в корзину');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCarScreen(onAddCar: widget.addCar),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
