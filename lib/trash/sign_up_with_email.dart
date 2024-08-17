import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWithEmailDart extends StatefulWidget {
  const SignUpWithEmailDart({Key? key}) : super(key: key);

  @override
  _SignUpWithEmailDartState createState() => _SignUpWithEmailDartState();
}

class _SignUpWithEmailDartState extends State<SignUpWithEmailDart> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
    TextEditingController();
    bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

      }
    } catch (error) {
      print('Error signing up: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign up with Email'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert an email address.';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$').hasMatch(value)) {
                      return 'Please insert a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password.';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUpWithEmailAndPassword,
                      child: Text('Create an account'),
                    ),
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
