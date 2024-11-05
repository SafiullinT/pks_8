import 'package:dio/dio.dart';
import '../models/car.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://10.0.2.2:8080'),
  );

  Future<List<Car>> getCars() async {
    try {
      final response = await _dio.get('/products');
      final data = response.data as List;
      return data.map((json) => Car.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Car> createCar(Car car) async {
    try {
      final response = await _dio.post('/products', data: car.toJson());
      return Car.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCar(Car car) async {
    try {
      await _dio.put('/products/${car.id}', data: car.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCar(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }
}
