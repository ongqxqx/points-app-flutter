import 'package:flutter/material.dart';

class SignInWithEmailDart extends StatefulWidget {
  const SignInWithEmailDart({Key? key}) : super(key: key);

  @override
  _SignInWithEmailDartState createState() => _SignInWithEmailDartState();
}

class _SignInWithEmailDartState extends State<SignInWithEmailDart> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Inherit the theme from main.dart
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In with Email'),
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
                      return 'Please insert email address.';
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert password.';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // 处理忘记密码逻辑
                      },
                      child: const Text('Forget password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // 处理登录逻辑
                        }
                      },
                      child: Text('Sign In'),
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
