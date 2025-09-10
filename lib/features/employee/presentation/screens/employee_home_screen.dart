import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة الموظف"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 👤 بيانات سريعة عن الموظف
              const CircleAvatar(
                radius: 40,
                backgroundImage:
                    AssetImage("assets/images/avatar_placeholder.png"),
              ),
              const SizedBox(height: 12),
              const Text(
                "أهلاً، محمد أحمد",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "الوقت الآن: ${now.hour}:${now.minute.toString().padLeft(2, "0")}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // 🔘 زرار دائري لتسجيل الحضور/الانصراف
              GestureDetector(
                onTap: () {
                  // هنا هتربط Cubit أو UseCase يحفظ Attendance في Supabase
                  context.push("/employee/attendance");
                },
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "تسجيل حضور",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 📊 روابط سريعة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _quickAction(Icons.assignment, "تقاريري"),
                  _quickAction(Icons.person, "البروفايل"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String title) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
