// ignore_for_file: library_private_types_in_public_api, use_super_parameters, prefer_const_constructors, unused_element, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_life_mobile_json/services/data_desciption.dart';
import 'package:share_life_mobile_json/services/data_user.dart';
import 'package:share_life_mobile_json/utils/session_management.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Map<String, dynamic>> descriptions = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    var currentUser = sessionManager.currentUser!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Accueil'),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: InkWell(
                  onTap: () {
                    // Naviguer vers la page de modification du profil
                    _showEditUserDialog(context, currentUser);
                  },
                  child: const Text('Modifier profil'),
                ),
              ),
              PopupMenuItem(
                child: InkWell(
                  onTap: () {
                    // Se déconnecter
                    _logout(context);
                  },
                  child: const Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  void _logout(BuildContext context) {
    Provider.of<SessionManager>(context, listen: false).logoutUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildBody(BuildContext context) {
    try {
      final sessionManager = Provider.of<SessionManager>(context);
      var currentUser = sessionManager.currentUser!;

      return _buildLoggedInUI(context, currentUser);
    } catch (e) {
      // Afficher un message d'erreur
      return _buildErrorUI(
          context, 'Erreur lors de la récupération des données.');
    }
  }

  Future<void> _refreshData() async {
    try {
      final newDescriptions = await CrudDescription.getDescriptionsByUserId(
          Provider.of<SessionManager>(context, listen: false)
              .currentUser['id']);
      setState(() {
        descriptions = newDescriptions;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing data: $e');
      }
      // Gérer l'erreur
    }
  }

  Widget _buildLoggedInUI(
      BuildContext context, Map<String, dynamic> currentUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.deepPurple,
          child: Text(
            currentUser['nom'][0],
            style: const TextStyle(fontSize: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${currentUser['nom']} ${currentUser['prenom']}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            _showAddDescriptionDialog(context);
          },
          child: const Text('Ajouter une description'),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            color: Colors.black38,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDescriptionList(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionList(BuildContext context) {
    return ListView.builder(
      itemCount: descriptions.length,
      itemBuilder: (context, index) {
        final description = descriptions[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(description['titre']),
            subtitle: Text(description['text']),
            trailing: PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      _showEditDescriptionDialog(context, description);
                    },
                    child: const Text('Modifier'),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      _showDeleteConfirmationDialog(context, description);
                    },
                    child: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDescriptionDialog(BuildContext context) {
    TextEditingController titreController = TextEditingController();
    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une description'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Texte'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                String titre = titreController.text;
                String text = textController.text;
                _addDescription(context, titre, text);
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _addDescription(BuildContext context, String titre, String text) async {
    try {
      final idUser = Provider.of<SessionManager>(context, listen: false)
          .currentUser!['id'];
      await CrudDescription.addDataToCustomDevicePathDescription({
        'id': DateTime.now().millisecondsSinceEpoch,
        'idUser': idUser,
        'titre': titre,
        'text': text,
      });
      await _refreshData(); // Mettre à jour les données après l'ajout
    } catch (e) {
      if (kDebugMode) {
        print('Error adding description: $e');
      }
      // Gérer l'erreur
    }
  }

  void _showEditDescriptionDialog(
      BuildContext context, Map<String, dynamic> description) {
    TextEditingController titreController =
        TextEditingController(text: description['titre']);
    TextEditingController textController =
        TextEditingController(text: description['text']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier la description'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Texte'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                String titre = titreController.text;
                String text = textController.text;
                _editDescription(context, description['id'], titre, text);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(
      BuildContext context, Map<String, dynamic> currentUser) {
    TextEditingController loginController =
        TextEditingController(text: currentUser['login']);
    TextEditingController mdpController =
        TextEditingController(text: currentUser['mdp']);
    TextEditingController nomController =
        TextEditingController(text: currentUser['nom']);
    TextEditingController prenomController =
        TextEditingController(text: currentUser['prenom']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: loginController,
                decoration: const InputDecoration(labelText: 'Login'),
              ),
              TextField(
                controller: mdpController,
                decoration: const InputDecoration(labelText: 'mot de passe '),
              ),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: 'Prenom'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                String login = loginController.text;
                String mdp = mdpController.text;
                String nom = nomController.text;
                String prenom = prenomController.text;
                _editUser(context, currentUser, login, mdp, nom, prenom);
                Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content:
              const Text('Voulez-vous vraiment supprimer cette description ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteDescription(context, description['id']);
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _editDescription(
      BuildContext context, int id, String titre, String text) async {
    try {
      await CrudDescription.update(id, titre, text);
      await _refreshData(); // Mettre à jour les données après la modification
    } catch (e) {
      if (kDebugMode) {
        print('Error editing description: $e');
      }
      // Gérer l'erreur
    }
  }

  void _editUser(BuildContext context, Map<String, dynamic> currentUser,
      String login, String mdp, String nom, String prenom) async {
    try {
      await CrudUser.update(currentUser['id'], login, mdp, nom, prenom);

      // Mettre à jour les informations de l'utilisateur dans la session
      currentUser['login'] = login;
      currentUser['mdp'] = mdp;
      currentUser['nom'] = nom;
      currentUser['prenom'] = prenom;

      // Vérifier si le widget est toujours monté avant de mettre à jour les informations de la session
      if (mounted) {
        // Mettre à jour les informations de la session
        Provider.of<SessionManager>(context, listen: false)
            .updateUserInfo(currentUser);
      }

      // Mettre à jour les données sur l'écran
      await _refreshData();
    } catch (e) {
      if (kDebugMode) {
        print('Error editing user: $e');
      }
      // Gérer l'erreur
    }
  }

  void _deleteDescription(BuildContext context, int id) async {
    try {
      await CrudDescription.delete(id);
      await _refreshData(); // Mettre à jour les données après la suppression
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting description: $e');
      }
      // Gérer l'erreur
    }
  }

  Widget _buildErrorUI(BuildContext context, String errorMessage) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Erreur'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Une erreur est survenue: $errorMessage',
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Actions à effectuer lorsqu'il y a une erreur, comme revenir à la page précédente
                Navigator.pop(context);
              },
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
