import 'package:bashkatep/core/bloc/super_admin/superAdmin_cubit.dart';
import 'package:bashkatep/core/utils/url.dart';
import 'package:bashkatep/presintation/screens/superAdmin/addClint_screen.dart';
import 'package:bashkatep/presintation/widgets/super_admin/clint_data_table.dart';
import 'package:bashkatep/presintation/widgets/super_admin/custom_card.dart';
import 'package:bashkatep/presintation/widgets/super_admin/overveiw_chart.dart';
import 'package:bashkatep/presintation/widgets/super_admin/start_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SuperAdminCubit, SuperAdminState>(
      builder: (context, state) {
        final cubit = context.read<SuperAdminCubit>();

        if (state is SuperAdminLoading || state is SuperAdminAddClientLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator())),
                Text(
                  state is SuperAdminLoading
                      ? 'Loading...'
                      : 'Adding client in progress ...',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        if (state is SuperAdminLoaded) {
          final clients = state.clients;
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      'Dashboard v0.1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  _buildDrawerItem(Icons.dashboard, 'Dashboard'),
                  _buildDrawerItem(Icons.shopping_cart, 'Product'),
                  _buildDrawerItem(Icons.people, 'Customers'),
                  _buildDrawerItem(Icons.attach_money, 'Income'),
                  _buildDrawerItem(Icons.campaign, 'Promote'),
                  _buildDrawerItem(Icons.help, 'Help'),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text('Hello Evano 👋'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color(0xffD3FFE7),
                                Color(0xffEFFFF6),
                              ],
                              icon: Image.asset(
                                AppImages.salaryIcon,
                                width: 75,
                                height: 75,
                                //  color: Color(0xff00AC4F),
                              ),
                              title: 'Earning',
                              amount: '\$198k',
                              changePercent: 37.8,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Container(
                            width: 2,
                            color: const Color(0xffF0F0F0),
                            height: 80,
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color(0xffCAF1FF),
                                Color(0xffCDF4FF),
                              ],
                              icon: Image.asset(
                                AppImages.walletIcon,
                                width: 75,
                                height: 75,
                              ),
                              title: 'Balance',
                              amount: '\$2.4k',
                              changePercent: -2,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Container(
                            width: 2,
                            color: const Color(0xffF0F0F0),
                            height: 80,
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color.fromARGB(255, 163, 171, 255),
                                Color.fromARGB(255, 212, 214, 255),
                              ],
                              icon: Image.asset(
                                AppImages.salesIcon,
                                width: 75,
                                height: 75,
                              ),
                              title: 'Total Sales',
                              amount: '\$89k',
                              changePercent: 11,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: OverviewChart(),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        flex: 1,
                        child: CustomerCard(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: ClientDataTable(
                      clients: clients,
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddClientScreen()), // التنقل إلى شاشة إضافة العميل
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        }

        if (state is SuperAdminNoClients) {
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      'Dashboard v0.1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  _buildDrawerItem(Icons.dashboard, 'Dashboard'),
                  _buildDrawerItem(Icons.shopping_cart, 'Product'),
                  _buildDrawerItem(Icons.people, 'Customers'),
                  _buildDrawerItem(Icons.attach_money, 'Income'),
                  _buildDrawerItem(Icons.campaign, 'Promote'),
                  _buildDrawerItem(Icons.help, 'Help'),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Text('Hello Evano 👋'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color(0xffD3FFE7),
                                Color(0xffEFFFF6),
                              ],
                              icon: Image.asset(
                                AppImages.salaryIcon,
                                width: 75,
                                height: 75,
                              ),
                              title: 'Earning',
                              amount: '\$198k',
                              changePercent: 37.8,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Container(
                            width: 2,
                            color: const Color(0xffF0F0F0),
                            height: 80,
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color(0xffCAF1FF),
                                Color(0xffCDF4FF),
                              ],
                              icon: Image.asset(
                                AppImages.walletIcon,
                                width: 75,
                                height: 75,
                              ),
                              title: 'Balance',
                              amount: '\$2.4k',
                              changePercent: -2,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 9.0),
                          Container(
                            width: 2,
                            color: const Color(0xffF0F0F0),
                            height: 80,
                          ),
                          const SizedBox(width: 9.0),
                          Expanded(
                            child: StatCard(
                              colors: [
                                Color.fromARGB(255, 163, 171, 255),
                                Color.fromARGB(255, 212, 214, 255),
                              ],
                              icon: Image.asset(
                                AppImages.salesIcon,
                                width: 75,
                                height: 75,
                              ),
                              title: 'Total Sales',
                              amount: '\$89k',
                              changePercent: 11,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: OverviewChart(),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        flex: 1,
                        child: CustomerCard(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: Center(
                      child: Text('No clients available.'),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddClientScreen()), // التنقل إلى شاشة إضافة العميل
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        }

        if (state is SuperAdminError) {
          return Center(child: Text('Something went wrong!'));
        }

        return Container();
      },
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Handle navigation
      },
    );
  }
}
