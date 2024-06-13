import 'package:flutter/foundation.dart';
import 'package:share_life_mobile_json/services/data_user.dart';

class SessionManager extends ChangeNotifier {
  Map<String, dynamic>? _currentUser;
  // Getter pour récupérer l'utilisateur actuellement connecté
  Map<String, dynamic> get currentUser => _currentUser!;

  // Méthode pour vérifier si un utilisateur est connecté
  bool get isLoggedIn => _currentUser != null;

  //methode pour connecter l'utilisateur cree dans le peripherique executant l'application
  Future<void> loginUserPeripherique(String login, String password) async {
    final Map<String, dynamic> foundUser =
        await CrudUser.getItemByMdpLogin(password, login);

    // Vérifier si l'utilisateur est trouvé et non nul
    if (foundUser.isNotEmpty) {
      // Utilisation de kDebugMode pour imprimer uniquement en mode debug
      if (kDebugMode) {
        print("User: ${foundUser["nom"]}");
      }
      _currentUser = foundUser;

      notifyListeners();
    } else {
      // Gérer le cas où l'utilisateur n'est pas trouvé
      // Vous pouvez lancer une exception, afficher un message d'erreur, etc.
      if (kDebugMode) {
        print(
            "Aucun utilisateur trouvé pour le login '$login' et le mot de passe '$password'");
      }
    }
  }

  void refresh() {
    // Mettez ici le code pour rafraîchir les données de la session
    notifyListeners(); // Notifie les écouteurs de changements
  }

  // Méthode pour déconnecter l'utilisateur actuel
  void logoutUser() {
    _currentUser = null;
    if (kDebugMode) {
      print("User info updated: $_currentUser");
    }
  }

  // Méthode pour mettre à jour les informations de l'utilisateur dans la session
  void updateUserInfo(Map<String, dynamic>? updatedUser) {
    _currentUser = updatedUser;

    // Utilisation de kDebugMode pour imprimer uniquement en mode debug
    if (kDebugMode) {
      print("User info updated: $_currentUser");
    }

    notifyListeners(); // Notifier les auditeurs de changement de session
  }
}
