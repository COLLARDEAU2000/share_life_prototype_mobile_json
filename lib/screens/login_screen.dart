// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_life_mobile_json/utils/route.dart';
import 'package:share_life_mobile_json/utils/session_management.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Retire la flèche de retour
        title: Text('Se connecter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _login;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'login'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre login';
              }
              return null;
            },
            onSaved: (value) {
              _login = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre mot de passe';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              try {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Ajoutez ici la logique pour authentifier l'utilisateur
                  // Tentative de connexion
                  await Provider.of<SessionManager>(context, listen: false)
                      .loginUserPeripherique(_login, _password);
                }
                Navigator.pushNamed(context, '/home');
              } catch (e) {
                // En cas d'erreur, afficher un message d'erreur
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Erreur de connexion'),
                    content: const Text(
                        'Nom d\'utilisateur ou mot de passe incorrect.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Se connecter'),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () {
              // Naviguer vers l'écran de création de compte
              Navigator.pushNamed(context, Routes.createCompte);
            },
            child: Text(
              'Créer un compte',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purple,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
