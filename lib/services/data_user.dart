import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CrudUser {
  static Future<void> addDataToCustomDevicePathUser(
      Map<String, dynamic> user) async {
    // Récupérer les données actuelles du fichier

    user['id'] = await nextId();
    List<Map<String, dynamic>> currentData =
        await getItemsFromCrudUserFileUser();

    // Ajouter les nouvelles données à la liste actuelle
    currentData.add(user);

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(currentData);
  }

  static Future<void> writeFilesToCustomDevicePath(
      List<Map<String, dynamic>> data) async {
    Directory directory = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();

    String filePath = "${directory.path}/crudUser.json";

    String fileContent = json.encode(data);

    File file = File(filePath);
    await file.writeAsString(fileContent);
    if (kDebugMode) {
      print(
          "Les données ont été écrites avec succès dans le fichier existant : $filePath");
    }
  }

  static Future<int> nextId() async {
    try {
      // Récupérer la liste des utilisateurs à partir du fichier JSON
      List<Map<String, dynamic>> usersList =
          await getItemsFromCrudUserFileUser();

      // Trouver le prochain ID en analysant les IDs existants
      int maxId =
          usersList.fold(0, (max, user) => user['id'] > max ? user['id'] : max);
      return maxId + 1;
    } catch (error) {
      throw Exception('Erreur lors de la récupération du prochain ID : $error');
    }
  }

  static Future<List<Map<String, dynamic>>>
      getItemsFromCrudUserFileUser() async {
    try {
      Directory directory = Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getApplicationSupportDirectory();

      String filePath = "${directory.path}/crudUser.json";

      File file = File(filePath);
      String fileContent = await file.readAsString();

      // Convertir le contenu du fichier JSON en une liste de Map
      List<dynamic> jsonData = json.decode(fileContent);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(jsonData);

      return items;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Erreur lors de la lecture du fichier crudUser.json getItemsFromCrudUserFileUser(): $e');
      }
      return [];
    }
  }

  static Future<Map<String, dynamic>> getItemByMdpLogin(
      String login, String mdp) async {
    List<Map<String, dynamic>> users = await getItemsFromCrudUserFileUser();
    Map<String, dynamic> user = {};

    for (Map<String, dynamic> item in users) {
      if (item['mdp'] == mdp && item['login'] == login) {
        user = item;
        break;
      }
    }

    // Utilisation de kDebugMode pour imprimer uniquement en mode debug
    if (kDebugMode) {
      print(
          "User trouvé pour le login '$login' et le mot de passe '$mdp': $user");
    }

    return user;
  }

  static Future<void> update(
      int id, String? login, String? mdp, String? nom, String? prenom) async {
    List<Map<String, dynamic>> items = await getItemsFromCrudUserFileUser();

    // Rechercher l'élément à mettre à jour par son ID
    int indexToUpdate = items.indexWhere((item) => item['id'] == id);

    // Mettre à jour l'élément avec le nouveau texte
    items[indexToUpdate]['login'] = login;
    items[indexToUpdate]['mdp'] = mdp;
    items[indexToUpdate]['nom'] = nom;
    items[indexToUpdate]['prenom'] = prenom;

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(items);

    if (kDebugMode) {
      print("L'élément avec l'ID '$id' a été mis à jour avec succès.");
    }
  }

  static Future<void> delete(int id) async {
    List<Map<String, dynamic>> items = await getItemsFromCrudUserFileUser();

    // Supprimer l'élément de la liste
    items.removeWhere((item) => item['id'] == id);

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(items);

    if (kDebugMode) {
      print("L'élément avec l'ID '$id' a été supprimé avec succès.");
    }
  }

  static Future<List<Map<String, dynamic>>>
      getItemsFromCrudUserFileUserToRemove() async {
    try {
      Directory directory = Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getApplicationSupportDirectory();

      String filePath = "${directory.path}/crudUser.json";

      File file = File(filePath);
      String fileContent = await file.readAsString();

      // Convertir le contenu du fichier JSON en une liste de Map
      List<dynamic> jsonData = json.decode(fileContent);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(jsonData);

      return items;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la lecture du fichier crudUser.json : $e');
      }
      return [];
    }
  }
}
