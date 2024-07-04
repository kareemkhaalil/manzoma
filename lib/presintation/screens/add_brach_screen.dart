import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudor/core/bloc/admin/add_branch_cubit/add_branch_cubit.dart';
import 'package:hudor/core/utils/validation/validator.dart';
import 'package:hudor/presintation/screens/admin_screen.dart';
import 'package:hudor/presintation/widgets/custom_text_field.dart';

class AddBranchScreen extends StatelessWidget {
  const AddBranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final cubit = context.read<AddBranchCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: BlocListener<AddBranchCubit, AddBranchState>(
        listener: (context, state) {
          if (state is AddBranchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AddBranchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة الفرع بنجاح')),
            );
          }
        },
        child: BlocBuilder<AddBranchCubit, AddBranchState>(
          builder: (context, state) {
            if (state is AddBranchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "إضافة فرع جديد",
                        style: TextStyle(
                          fontSize: 38,
                          color: Color(0xff3ED9A0),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: height * 0.1),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.location_city,
                        hintText: 'ادخل اسم الفرع',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: Validator().validateName,
                        controller: cubit.nameController,
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.person,
                        hintText: 'ادخل رقم هوية المدير',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: Validator().validateName,
                        controller: cubit.managerIdController,
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.qr_code,
                        hintText: 'ادخل رمز الاستجابة السريعة',
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: Validator().validateName,
                        controller: cubit.qrCodeController,
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.location_on,
                        hintText: 'ادخل خطوط العرض',
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        validator: Validator().validateLatitude,
                        controller: cubit.latitudeController,
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        width: width * 0.9,
                        height: height * 0.065,
                        prefixIcon: Icons.location_on,
                        hintText: 'ادخل خطوط الطول',
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        validator: Validator().validateLongitude,
                        controller: cubit.longitudeController,
                      ),
                      SizedBox(height: height * 0.06),
                      ElevatedButton(
                        onPressed: () async {
                          if (cubit.formKey.currentState!.validate()) {
                            final latitude =
                                double.parse(cubit.latitudeController.text);
                            final longitude =
                                double.parse(cubit.longitudeController.text);
                            cubit.setLocation(latitude, longitude);

                            await cubit.addBranch(
                              cubit.nameController.text,
                              cubit.location!,
                              cubit.managerIdController.text,
                              cubit.qrCodeController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3ED9A0),
                          fixedSize: Size(width * 0.9, height * 0.065),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "إضافة الفرع",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
