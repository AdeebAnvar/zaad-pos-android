// import 'package:pos_app/data/models/customer_model.dart';
// import 'package:pos_app/data/models/orders_model.dart';
// import 'package:pos_app/data/models/product_model.dart';
// import 'package:pos_app/data/models/response_model.dart';
// import 'package:pos_app/data/network/network_service.dart';

// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();

//   // final NetworkService _networkService = NetworkService();

//   // Products
//   Future<ResponseModel> getAllProducts() async {
//     return await _networkService.get('/products');
//   }

//   Future<ResponseModel> getProductById(int id) async {
//     return await _networkService.get('/products/$id');
//   }

//   Future<ResponseModel> createProduct(ProductModel product) async {
//     return await _networkService.post('/products', product.toJson());
//   }

//   Future<ResponseModel> updateProduct(ProductModel product) async {
//     return await _networkService.put('/products/${product.id}', product.toJson());
//   }

//   Future<ResponseModel> deleteProduct(int id) async {
//     return await _networkService.delete('/products/$id');
//   }

//   // Customers
//   Future<ResponseModel> getAllCustomers() async {
//     return await _networkService.get('/customers');
//   }

//   Future<ResponseModel> getCustomerById(int id) async {
//     return await _networkService.get('/customers/$id');
//   }

//   Future<ResponseModel> createCustomer(CustomerModel customer) async {
//     return await _networkService.post('/customers', customer.toJson());
//   }

//   Future<ResponseModel> updateCustomer(CustomerModel customer) async {
//     return await _networkService.put('/customers/${customer.id}', customer.toJson());
//   }

//   Future<ResponseModel> deleteCustomer(int id) async {
//     return await _networkService.delete('/customers/$id');
//   }

//   // Orders
//   Future<ResponseModel> getAllOrders() async {
//     return await _networkService.get('/orders');
//   }

//   Future<ResponseModel> getOrderById(int id) async {
//     return await _networkService.get('/orders/$id');
//   }

//   Future<ResponseModel> createOrder(OrderModel order) async {
//     return await _networkService.post('/orders', order.toJson());
//   }

//   Future<ResponseModel> updateOrder(OrderModel order) async {
//     return await _networkService.put('/orders/${order.orderId}', order.toJson());
//   }

//   Future<ResponseModel> deleteOrder(int id) async {
//     return await _networkService.delete('/orders/$id');
//   }

//   Future<ResponseModel> getCustomerOrders(int customerId) async {
//     return await _networkService.get('/customers/$customerId/orders');
//   }
// }
