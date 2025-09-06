import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/core/localization/app_localizations.dart';
import 'package:manzoma/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:manzoma/features/auth/presentation/cubit/auth_state.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import 'package:flutter_localization/flutter_localization.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return const LoginView();
        },
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Side - Branding
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/patternBlue.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  opacity: const AlwaysStoppedAnimation(0.1),
                  filterQuality: FilterQuality.low,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Asset 1.png',
                          width: 300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          FlutterLocalization.instance.getString(context, 'smartAttendancePayroll'),
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Side - Login Form
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(48),
              color: Theme.of(context).primaryColorDark,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          FlutterLocalization.instance.getString(context, 'welcomeBack'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FlutterLocalization.instance.getString(context, 'signInToAccount'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade200,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),

                        // Email Field
                        CustomInput(
                          controller: _emailController,
                          label: FlutterLocalization.instance.getString(context, 'email'),
                          hintText: FlutterLocalization.instance.getString(context, 'enterEmail'),
                          labelColor: Colors.grey.shade200,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return FlutterLocalization.instance.getString(context, 'pleaseEnterEmail');
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return FlutterLocalization.instance.getString(context, 'pleaseEnterValidEmail');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Password Field
                        CustomInput(
                          controller: _passwordController,
                          label: FlutterLocalization.instance.getString(context, 'password'),
                          hintText: FlutterLocalization.instance.getString(context, 'enterPassword'),
                          labelColor: Colors.grey.shade200,
                          prefixIcon: Icons.lock_outlined,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return FlutterLocalization.instance.getString(context, 'pleaseEnterPassword');
                            }
                            if (value.length < 6) {
                              return FlutterLocalization.instance.getString(context, 'passwordMinLength');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(FlutterLocalization.instance.getString(context, 'forgotPassword')),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Login Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: FlutterLocalization.instance.getString(context, 'signIn'),
                              isLoading: state is AuthLoading,
                              backgroundColor: const Color(0xff222DFF),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signIn(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Demo Login Buttons
                        const Divider(),
                        const SizedBox(height: 16),
                        Text(
                          FlutterLocalization.instance.getString(context, 'demoAccounts'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _emailController.text = 'admin@demo.com';
                                  _passwordController.text = 'demo123';
                                },
                                child: Text(FlutterLocalization.instance.getString(context, 'admin')),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _emailController.text = 'employee@demo.com';
                                  _passwordController.text = 'demo123';
                                },
                                child: Text(FlutterLocalization.instance.getString(context, 'employee')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
