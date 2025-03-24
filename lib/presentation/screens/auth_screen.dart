import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/core/styles.dart';
import '../../providers/auth_provider.dart';
import '../widgets/styled_snackbar.dart';
import '../widgets/text_with_link.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends ConsumerState<AuthScreen> {
  bool _isSignIn = true;

  bool _obscure = true;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  static const decoration = InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey, width: 0.5)));

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authViewModel = ref.read(authViewModelProvider.notifier);

    if (_isSignIn) {
      await authViewModel.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      await authViewModel.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        username: _nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          styledSnackbar(next.error.toString(), 18),
        );
      }
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/auth_page_cover.png',
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "WELCOME, HERO!\nYOUR MISSIONS AWAIT",
                textAlign: TextAlign.start,
                style: AppTextStyle.titleText,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isSignIn)
                      TextFormField(
                        decoration: decoration.copyWith(
                          labelText: 'Hero Name',
                          labelStyle: AppTextStyle.inputLabel,
                        ),
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter hero name';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: decoration.copyWith(
                        labelText: 'Email',
                        labelStyle: AppTextStyle.inputLabel,
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: decoration.copyWith(
                        labelText: 'Password',
                        labelStyle: AppTextStyle.inputLabel,
                        suffix: GestureDetector(
                          onTap: () => setState(() {
                            _obscure = !_obscure;
                          }),
                          child: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                      obscureText: _obscure,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _submit();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTextStyle.primaryRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(_isSignIn ? 'Sign In' : 'Sign Up',
                            style: AppTextStyle.buttonText),
                      ),
                    ),
                    TextWithLink(
                      text: _isSignIn ? 'Not a hero?' : 'Already a hero?',
                      linkedText: _isSignIn ? 'Become one!' : 'Sign In',
                      onTap: () {
                        setState(() {
                          _isSignIn = !_isSignIn;
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
