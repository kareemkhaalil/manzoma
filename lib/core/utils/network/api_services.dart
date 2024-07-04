// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class ApiServices {
//   final Dio _dio;
//   //final String _baseUrl = Endpoints.baseUrl;
//   ApiServices(
//     this._dio,
//   );
//   // CRUD service

// // CREATE service
//   Future<Map<String, dynamic>> post(
//       String endPoint, var data, Options options) async {
//     try {
//       final response = await _dio.post(
//         _baseUrl + endPoint,
//         data: data,
//         options: options,
//       );
//       debugPrint("api services response =  $response");
//       // Check status code
//       if (response.statusCode == 200) {
//         // Return parsed response data
//         return response.data;
//       } else {
//         // Handle error response
//         throw DioException(
//             response: response,
//             error: 'Failed to post data',
//             requestOptions: RequestOptions(path: _baseUrl + endPoint));
//       }
//     } catch (e) {
//       // Handle Dio errors
//       debugPrint("api services =  $e");
//       throw DioException(
//           requestOptions: RequestOptions(path: _baseUrl + endPoint),
//           error: e.toString());
//     }
//   }

// // READ service
//   Future<Map<String, dynamic>> get(
//       String endPoint, var data, Options options) async {
//     try {
//       final response = await _dio.get(
//         _baseUrl + endPoint,
//         data: data,
//         options: options,
//       );
//       debugPrint("api services response (get methode)=  $response");
//       // Check status code
//       if (response.statusCode == 200) {
//         // Return parsed response data
//         return response.data;
//       } else {
//         // Handle error response
//         throw DioException(
//             response: response,
//             error: 'Failed to gwt data',
//             requestOptions: RequestOptions(path: _baseUrl + endPoint));
//       }
//     } catch (e) {
//       // Handle Dio errors
//       debugPrint("api services (get methode)=  $e");
//       throw DioException(
//           requestOptions: RequestOptions(path: _baseUrl + endPoint),
//           error: e.toString());
//     }
//   }

// // UPDATE service
//   Future<Map<String, dynamic>> put(
//       String endPoint, var data, Options options) async {
//     try {
//       final response = await _dio.put(
//         _baseUrl + endPoint,
//         data: data,
//         options: options,
//       );
//       debugPrint("api services response (put methode)=  $response");
//       // Check status code
//       if (response.statusCode == 200) {
//         // Return parsed response data
//         return response.data;
//       } else {
//         // Handle error response
//         throw DioException(
//             response: response,
//             error: 'Failed to put data',
//             requestOptions: RequestOptions(path: _baseUrl + endPoint));
//       }
//     } catch (e) {
//       // Handle Dio errors
//       debugPrint("api services (put methode)=  $e");
//       throw DioException(
//           requestOptions: RequestOptions(path: _baseUrl + endPoint),
//           error: e.toString());
//     }
//   }

// // DELETE service
//   Future<Map<String, dynamic>> delete(
//       String endPoint, var data, Options options) async {
//     try {
//       final response = await _dio.delete(
//         _baseUrl + endPoint,
//         data: data,
//         options: options,
//       );
//       debugPrint("api services response (delete methode) =  $response");
//       // Check status code
//       if (response.statusCode == 200) {
//         // Return parsed response data
//         return response.data;
//       } else {
//         // Handle error response
//         throw DioException(
//             response: response,
//             error: 'Failed to delete data',
//             requestOptions: RequestOptions(path: _baseUrl + endPoint));
//       }
//     } catch (e) {
//       // Handle Dio errors
//       debugPrint("api services (delete methode)=  $e");
//       throw DioException(
//           requestOptions: RequestOptions(path: _baseUrl + endPoint),
//           error: e.toString());
//     }
//   }
// }
