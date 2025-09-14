import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manzoma/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:manzoma/features/auth/presentation/cubit/auth_state.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // بدلاً من التنقل المباشر، نروح على الداشبورد دايماً
            // والداشبورد هيتولى توجيه المستخدم للواجهة المناسبة
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          
          if (isMobile) {
            // Mobile Layout - Single Column
            return _buildMobileLayout(context);
          } else {
            // Desktop Layout - Two Columns
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Logo Section
            Image.asset(
              'assets/images/Asset 1.png',
              width: 200,
              height: 120,
            ),
            const SizedBox(height: 16),
            Text(
              'Smart Attendance & Payroll Management',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Login Form
            _buildLoginForm(context, isMobile: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
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
                        'Smart Attendance & Payroll Management',
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
                child: _buildLoginForm(context, isMobile: false),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isMobile}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: isMobile ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: isMobile ? Theme.of(context).textTheme.headlineLarge?.color : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to your account',
            style: TextStyle(
              fontSize: 16,
              color: isMobile ? Theme.of(context).textTheme.bodyMedium?.color : Colors.grey.shade200,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),

          // Email Field
          CustomInput(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter your email',
            labelColor: isMobile ? null : Colors.grey.shade200,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Password Field
          CustomInput(
            controller: _passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            labelColor: isMobile ? null : Colors.grey.shade200,
            prefixIcon: Icons.lock_outlined,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
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
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 32),

          // Login Button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Sign In',
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
            'Demo Accounts',
            style: TextStyle(
              fontSize: 14,
              color: isMobile ? Theme.of(context).textTheme.bodySmall?.color : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Demo buttons layout based on screen size
          isMobile 
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _emailController.text = 'admin@demo.com';
                        _passwordController.text = 'demo123';
                      },
                      child: const Text('Admin Demo'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _emailController.text = 'employee@demo.com';
                        _passwordController.text = 'demo123';
                      },
                      child: const Text('Employee Demo'),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _emailController.text = 'admin@demo.com';
                        _passwordController.text = 'demo123';
                      },
                      child: const Text('Admin'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _emailController.text = 'employee@demo.com';
                        _passwordController.text = 'demo123';
                      },
                      child: const Text('Employee'),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
