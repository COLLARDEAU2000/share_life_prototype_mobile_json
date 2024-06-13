class User {
  // liste d'attribus
  int id;
  String login;
  String mdp;
  String nom;
  String prenom;

  // constructeur objet user
  User(this.id, this.login, this.mdp, this.nom, this.prenom);
/*
  // transformer les objets
  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final login = json['login'] ?? 'Nom par défaut';
    final mdp = json['mdp'] ?? 'Nom par défaut';
    final nom = json['nom'] ?? 'Nom par défaut';
    final prenom = json['prenom'] ?? 'Nom par défaut';
    return User(id, login, mdp, nom, prenom);
  }

  // transformer les objets user en occurence Json pour la serialisation process de sauvegarde
  Map<String, dynamic> toJson() {
    return {'id': id, 'login': login, 'mdp': mdp, 'nom': nom, "prenom": prenom};
  }
  */
}
