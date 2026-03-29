import 'package:flutter/material.dart';

class EmployeeLoginPage extends StatefulWidget {
  @override
  State<EmployeeLoginPage> createState() => _EmployeeLoginPageState();
}

class _EmployeeLoginPageState extends State<EmployeeLoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  String error = "";

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = "";
    });

    await Future.delayed(Duration(seconds: 1));

    if (emailController.text == "emp@demo.com" &&
        passwordController.text == "1234") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DummyDashboard()),
      );
    } else {
      setState(() {
        error = "Invalid email or password";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),

            Icon(Icons.engineering, size: 80, color: Colors.white),

            SizedBox(height: 10),

            Text(
              "Employee Login",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // EMAIL
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: "Employee Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter email";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        // PASSWORD
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter password";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10),

                        // FORGOT PASSWORD
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text("Forgot Password?"),
                          ),
                        ),

                        // ERROR MESSAGE
                        if (error.isNotEmpty)
                          Text(error,
                              style: TextStyle(color: Colors.red)),

                        SizedBox(height: 10),

                        // LOGIN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white)
                                : Text("Login as Employee",
                                    style: TextStyle(fontSize: 16)),
                          ),
                        ),

                        SizedBox(height: 20),

                        // SIGN UP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            TextButton(
                              onPressed: () {},
                              child: Text("Sign Up"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DUMMY DASHBOARD
class DummyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee Dashboard")),
      body: Center(child: Text("Welcome Employee")),
    );
  }
}