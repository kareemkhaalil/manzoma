import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/branch_cubit.dart';
import '../../domain/entities/branch_entity.dart';
import '../widgets/add_branch_dialog.dart';
import '../widgets/branch_card.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load branches when screen initializes
    context.read<BranchCubit>().getBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'إدارة الفروع',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.go('/branches/create'),
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'إضافة فرع جديد',
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'البحث عن فرع...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Branches List
          Expanded(
            child: BlocBuilder<BranchCubit, BranchState>(
              builder: (context, state) {
                if (state is BranchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is BranchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'حدث خطأ: ${state.message}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<BranchCubit>().getBranches();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is BranchLoaded) {
                  final filteredBranches = state.branches.where((branch) {
                    final matchesSearch = searchQuery.isEmpty ||
                        branch.name
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        (branch.address
                                ?.toLowerCase()
                                .contains(searchQuery.toLowerCase()) ??
                            false);
                    return matchesSearch;
                  }).toList();

                  if (filteredBranches.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store_outlined,
                            size: 64.w,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'لا توجد فروع',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'اضغط على + لإضافة فرع جديد',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BranchCubit>().getBranches();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: filteredBranches.length,
                      itemBuilder: (context, index) {
                        return BranchCard(
                          branch: filteredBranches[index],
                          onTap: () => _showBranchDetails(
                              context, filteredBranches[index]),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // void _showAddBranchDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => const AddBranchDialog(),
  //   );
  // }

  void _showBranchDetails(BuildContext context, BranchEntity branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(branch.displayName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('العنوان', branch.fullAddress),
            _buildDetailRow('خط العرض', branch.latitude.toStringAsFixed(6)),
            _buildDetailRow('خط الطول', branch.longitude.toStringAsFixed(6)),
            _buildDetailRow(
                'نطاق الحضور', '${branch.radiusMeters.toStringAsFixed(0)} متر'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
