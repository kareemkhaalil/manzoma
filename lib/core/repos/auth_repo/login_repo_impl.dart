// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hudor/core/repos/auth_repo/login_repo.dart';
// import 'package:school_ai/core/params/endpoints.dart';
// import 'package:school_ai/core/utils/errrors/failure.dart';
// import 'package:school_ai/core/utils/network/api_services.dart';
// import 'package:school_ai/data/models/logged_user/logged_user.dart';
// import 'package:school_ai/data/repositories/auth_repo/login_repo.dart';

// class LoginRepoImpl extends LoginRepo {
//   final ApiServices apiServices;

//   LoginRepoImpl(this.apiServices);

//   @override
//   // LoginRepoImpl.dart

//   Future<Either<Failure, LoggedUser>> login(
//       String name, String password) async {
//     final formData = FormData.fromMap({
//       "name": name,
//       "password": password,
//     });

//     try {
//       final response = await apiServices.post(
//         Endpoints.login,
//         formData,
//         Options(
//           contentType: "multipart/form-data",
//           headers: {
//             "Content-Type": "multipart/form-data",
//           },
//         ),
//       );
//       debugPrint(
//         " implmenation = ${response.toString()}",
//       );

//       final userData = response; // Extract data field
//       final loggedUser = LoggedUser.fromResponse(userData);
//       debugPrint(
//         " Logged User impl = $loggedUser",
//       );
//       if (response['data'] == null || response['actionDone'] == false) {
//         return Left(AuthinFailure.fromResponse(response));
//       }
//       return Right(loggedUser);
//     } catch (e) {
//       debugPrint(e.toString());
//       return Left(ServerFailure.fromDioException(e as DioException));
//     }
//   }
// }
