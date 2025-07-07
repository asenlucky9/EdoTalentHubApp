import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../config/app_config.dart';
import '../../../../shared/services/firebase_user_service.dart';
import 'role_selection_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    
    try {
      if (_isSignUp) {
        // Sign up
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        // Create user profile in Firestore
        await FirebaseUserService.createUserProfile(
          userId: credential.user!.uid,
          email: credential.user!.email!,
          role: 'customer',
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          location: _locationController.text.trim(),
          city: _cityController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoleSelectionScreen(user: credential.user)),
          );
        }
      } else {
        // Sign in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoleSelectionScreen(user: FirebaseAuth.instance.currentUser)),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() { 
        _isLoading = false; 
        if (e.code == 'email-already-in-use') {
          _error = 'This email is already registered. Please sign in or use a different email.';
        } else {
          _error = e.message ?? 'Authentication failed';
        }
      });
    } catch (e) {
      setState(() { 
        _isLoading = false; 
        _error = 'An unexpected error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/edo_bronze.png',
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Text(_isSignUp ? 'Sign Up' : 'Sign In',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConfig.primaryColor)),
                      const SizedBox(height: 24),
                      if (_isSignUp) ...[
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(labelText: 'Full Name'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter your full name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone Number'),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter your phone number' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(labelText: 'Location'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter your location' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Enter your city' : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null,
                      ),
                      const SizedBox(height: 24),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(_error!, style: const TextStyle(color: Colors.red)),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _isLoading ? null : () {
                          setState(() { _isSignUp = !_isSignUp; _error = null; });
                        },
                        child: Text(_isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    super.dispose();
  }
} 