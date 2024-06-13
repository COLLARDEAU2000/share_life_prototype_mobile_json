class Description {
  int id;
  int idUser;
  String titre;
  String text;

  Description(this.id, this.idUser, this.titre, this.text);
/*
  // transformer les objets
  factory Description.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? 0;
    final idUser = json['idUser'] ?? 'Nom par défaut';
    final titre = json['titre'] ?? 'Nom par défaut';
    final text = json['text'] ?? 'Nom par défaut';
    return Description(id, idUser, titre, text);
  }

  // transformer les objets user en occurence Json pour la serialisation process de sauvegarde
  Map<String, dynamic> toJson() {
    return {'id': id, 'idUser': idUser, 'titre': titre, 'texte': text};
  }
  */
}
