import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp3/pages/accueil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'connexion.dart';

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
        MaterialPageRoute(builder: (context) => Accueil()),
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

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      /*final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final db = FirebaseFirestore.instance;
      final user = <String, dynamic>{
        "email": userCredential.user?.email,
        "uid": userCredential.user?.uid,
      };

      await db.collection("users").doc(userCredential.user?.uid).set(user, SetOptions(merge: true));*/

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Accueil()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred during Google Sign-In. Please try again.";
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
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(labelText: "Confirm Password"),
                      obscureText: true,
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _inscription,
                      child: const Text("Sign up"),
                    ),
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      child: const Text("Sign in with Google"),
                    ),
                    ElevatedButton(
                      child: const Text("Already have an account?"),
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
