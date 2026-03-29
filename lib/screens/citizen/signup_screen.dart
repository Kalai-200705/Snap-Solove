import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  void signup() {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        password.text.isEmpty ||
        confirm.text.isEmpty) {
      show("Fill all fields");
      return;
    }

    if (phone.text.length != 10) {
      show("Enter valid 10-digit phone number");
      return;
    }

    if (password.text != confirm.text) {
      show("Passwords do not match");
      return;
    }

    // UI ONLY → simulate success
    show("Account created successfully");

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget field(String label, TextEditingController c,
      {bool isPassword = false, bool isConfirm = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: c,
        obscureText: isPassword
            ? isPasswordHidden
            : isConfirm
                ? isConfirmHidden
                : false,
        keyboardType: label == "Phone Number"
            ? TextInputType.phone
            : TextInputType.text,
        inputFormatters: label == "Phone Number"
            ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]
            : [],
        decoration: InputDecoration(
          prefixIcon: Icon(
            label == "Email"
                ? Icons.email
                : label == "Phone Number"
                    ? Icons.phone
                    : label.contains("Password")
                        ? Icons.lock
                        : Icons.person,
          ),
          labelText: label,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(isPasswordHidden
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                )
              : isConfirm
                  ? IconButton(
                      icon: Icon(isConfirmHidden
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isConfirmHidden = !isConfirmHidden;
                        });
                      },
                    )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Icon(Icons.person_add, size: 90, color: Colors.white),

                const SizedBox(height: 15),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Register to continue",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 30),

                // FORM CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      field("Name", name),
                      field("Email", email),
                      field("Phone Number", phone),
                      field("Password", password, isPassword: true),
                      field("Confirm Password", confirm, isConfirm: true),

                      const SizedBox(height: 20),

                      // SIGNUP BUTTON
                      GestureDetector(
                        onTap: signup,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // LOGIN NAVIGATION
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}