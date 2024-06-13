// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_life_mobile_json/services/data_user.dart';
import 'package:share_life_mobile_json/utils/route.dart';
import 'package:share_life_mobile_json/utils/session_management.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: CreateForm(),
      ),
    );
  }
}

class CreateForm extends StatefulWidget {
  const CreateForm({Key? key});

  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  late String _login;
  late String _password;
  late String _nom;
  late String _prenom;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Login'),
            validator: (value) => _validateFormField(value, 'Login'),
            onSaved: (value) => _login = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            validator: (value) => _validateFormField(value, 'Mot de passe'),
            onSaved: (value) => _password = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (value) => _validateFormField(value, 'Nom'),
            onSaved: (value) => _nom = value!,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Prénom'),
            validator: (value) => _validateFormField(value, 'Prénom'),
            onSaved: (value) => _prenom = value!,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _createAccount,
            child: const Text('Créer un compte'),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.login),
            child: const Text(
              'Déjà un compte ? Connectez-vous',
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

  String? _validateFormField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre $fieldName';
    }
    return null;
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await CrudUser.addDataToCustomDevicePathUser({
          'id': 0,
          'login': _login,
          'mdp': _password,
          'nom': _nom,
          'prenom': _prenom,
        });

        await Provider.of<SessionManager>(context, listen: false)
            .loginUserPeripherique(_login, _password);

        Navigator.pushNamed(context, Routes.home);
      } catch (e) {
        _showErrorDialog();
        // Utilisation de kDebugMode pour afficher uniquement en mode debug
        if (kDebugMode) {
          print('Erreur lors de la création du compte : $e');
        }
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur de connexion'),
        content: const Text('Nom d\'utilisateur ou mot de passe incorrect.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
