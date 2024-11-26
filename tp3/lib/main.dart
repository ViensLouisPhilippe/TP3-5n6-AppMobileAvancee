import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp3/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tp3/pages/connection.dart';
import 'package:tp3/pages/reussipage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Inscription(title: 'Flutter Demo Home Page'),
    );
  }
}

class Inscription extends StatefulWidget {
  const Inscription({super.key, required this.title});
  final String title;

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  Future<void> _inscription() async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "All fields are required.";
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters long.";
      });
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final db = FirebaseFirestore.instance;
      final user = <String, dynamic>{
        "email": _emailController.text,
        "uid": userCredential.user?.uid,
      };

      await db.collection("users").doc(userCredential.user?.uid).set(user);
      print('Utilisateur inscrit avec succès ! UID: ${userCredential.user?.uid}');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Reussipage()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = "The email is already in use.";
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          _errorMessage = "The password is too weak.";
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorMessage = "The email address is not valid.";
        });
      } else {
        setState(() {
          _errorMessage = "An unexpected error occurred. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        return null;
                      },
                    ),
                    // Confirm password input
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(labelText: "Confirm Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 20),
                    // Sign up button
                    ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Processing Data...")),
                        );
                        await _inscription();
                      },
                      child: Text("Sign up"),
                    ),
                    ElevatedButton(
                      child: Text("Already have an account?"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Connexion()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
