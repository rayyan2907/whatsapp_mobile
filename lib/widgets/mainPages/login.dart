import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_mobile/color.dart';
import 'package:whatsapp_mobile/screens/mobile_screen_layout.dart';
import 'package:whatsapp_mobile/services/RegAndLogin/login.dart';
import 'signUp.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // WhatsApp Logo
                        const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Color(0xFF25D366),
                          size: 70,
                        ),

                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          'WhatsApp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to continue messaging',
                          style: TextStyle(
                            color: Color(0xFF8696A0),
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8696A0),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1F2C34),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8696A0),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1F2C34),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0xFF8696A0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isEmpty || password.isEmpty) {
                                showToast(
                                  "All fields are required",
                                  duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                                  position: ToastPosition.top,
                                  backgroundColor: Colors.red,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  radius: 8.0, // optional, for rounded edges
                                );
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                              }
                              final login = LoginService();
                              final msg = await login.login(email, password);
                              setState(() {
                                _isLoading = false;
                              });

                              if (msg == 'Login Successful') {
                                showToast(
                                  msg,
                                  duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                                  position: ToastPosition.top,
                                  backgroundColor: Colors.red,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  radius: 8.0, // optional, for rounded edges
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MobileScreenLayout(),
                                  ),
                                );
                              } else {
                                showToast(
                                  msg,
                                  duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                                  position: ToastPosition.top,
                                  backgroundColor: Colors.red,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                  radius: 8.0, // optional, for rounded edges
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            showToast(
                              "Password screen is under developement",
                              duration: Duration(seconds: 2), // Equivalent to LENGTH_SHORT
                              position: ToastPosition.top,
                              backgroundColor: Colors.red,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              radius: 8.0, // optional, for rounded edges
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Color(0xFF25D366),
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF2A3942),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Color(0xFF8696A0),
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: const Duration(milliseconds: 100),
                                    ),
                                        (route) => false,
                                  );

                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Color(0xFF25D366),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const SizedBox(height: 8),

                        const Text(
                          '© 2025 WhatsApp - Clone',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
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
