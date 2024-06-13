import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CrudDescription {
  static Future<void> addDataToCustomDevicePathDescription(
      Map<String, dynamic> description) async {
    // Récupérer les données actuelles du fichier
    List<Map<String, dynamic>> currentData =
        await getItemsFromCrudDescriptionFileDescription();

    // Ajouter les nouvelles données à la liste actuelle
    currentData.add(description);

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(currentData);
  }

  static Future<void> writeFilesToCustomDevicePath(
      List<Map<String, dynamic>> data) async {
    Directory directory = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();

    String filePath = "${directory.path}/crudDescription.json";

    String fileContent = json.encode(data);

    File file = File(filePath);
    await file.writeAsString(fileContent);
    if (kDebugMode) {
      print(
          "Les données ont été écrites avec succès dans le fichier existant : $filePath");
    }
  }

  static Future<List<Map<String, dynamic>>>
      getItemsFromCrudDescriptionFileDescription() async {
    try {
      Directory directory = Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getApplicationSupportDirectory();

      String filePath = "${directory.path}/crudDescription.json";

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
            'Erreur lors de la lecture du fichier crudDescription.json getItemsFromCrudDescriptionFileDescription(): $e');
      }
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDescriptionsByUserId(
      int userId) async {
    List<Map<String, dynamic>> descriptions =
        await getItemsFromCrudDescriptionFileDescription();
    List<Map<String, dynamic>> userDescriptions = [];

    for (Map<String, dynamic> item in descriptions) {
      if (item['idUser'] == userId) {
        userDescriptions.add(item);
      }
    }

    return userDescriptions;
  }

  static Future<Map<String, dynamic>> getItemId(int id) async {
    List<Map<String, dynamic>> descriptions =
        await getItemsFromCrudDescriptionFileDescription();
    Map<String, dynamic> description = {};
    for (Map<String, dynamic> item in descriptions) {
      if (item['idUser'] == id) {
        description = item;
        break;
      }
    }

    return description;
  }

  static Future<List<Map<String, dynamic>>> getItem() async {
    List<Map<String, dynamic>> descriptions =
        await getItemsFromCrudDescriptionFileDescription();

    return descriptions;
  }

  static Future<void> update(int id, String? titre, String? text) async {
    List<Map<String, dynamic>> items =
        await getItemsFromCrudDescriptionFileDescription();

    // Rechercher l'élément à mettre à jour par son ID
    int indexToUpdate = items.indexWhere((item) => item['id'] == id);

    // Mettre à jour l'élément avec le nouveau texte
    items[indexToUpdate]['titre'] = titre ?? items[indexToUpdate]['titre'];
    items[indexToUpdate]['text'] = text ?? items[indexToUpdate]['text'];

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(items);

    if (kDebugMode) {
      print("L'élément avec l'ID '$id' a été mis à jour avec succès.");
    }
  }

  static Future<void> delete(int id) async {
    List<Map<String, dynamic>> items =
        await getItemsFromCrudDescriptionFileDescription();

    // Supprimer l'élément de la liste
    items.removeWhere((item) => item['id'] == id);

    // Écrire les données mises à jour dans le fichier
    await writeFilesToCustomDevicePath(items);

    if (kDebugMode) {
      print("L'élément avec l'ID '$id' a été supprimé avec succès.");
    }
  }

  static Future<List<Map<String, dynamic>>>
      getItemsFromCrudDescriptionFileDescriptionToRemove() async {
    try {
      Directory directory = Platform.isAndroid
          ? await getApplicationDocumentsDirectory()
          : await getApplicationSupportDirectory();

      String filePath = "${directory.path}/crudDescription.json";

      File file = File(filePath);
      String fileContent = await file.readAsString();

      // Convertir le contenu du fichier JSON en une liste de Map
      List<dynamic> jsonData = json.decode(fileContent);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(jsonData);

      return items;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la lecture du fichier crudDescription.json : $e');
      }
      return [];
    }
  }
}
