class Conversation {
  final String id;
  final String sender;
  final String code;
  final String message;
  final bool valide;
  final String codeAgent;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final int v;
  List<DemandeId> demandeId;
  List<ReponseId> reponseId;

  Conversation({
    required this.id,
    required this.sender,
    required this.code,
    required this.message,
    required this.valide,
    required this.codeAgent,
    required this.createdAt,
    required this.updatedAt,
    // required this.v,
    required this.demandeId,
    required this.reponseId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["_id"],
        sender: json["sender"],
        code: json["code"],
        message: json["message"],
        valide: json["valide"],
        codeAgent: json["codeAgent"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        // v: json["__v"],
        demandeId: List<DemandeId>.from(
            json["demandeId"].map((x) => DemandeId.fromJson(x))),
        reponseId: List<ReponseId>.from(
            json["reponseId"].map((x) => ReponseId.fromJson(x))),
      );
}

class DemandeId {
  final String id;
  final bool valide;
  final String idDemande;
  final String codeAgent;
  final String lot;
  DateTime createdAt;

  DemandeId({
    required this.id,
    required this.valide,
    required this.idDemande,
    required this.codeAgent,
    required this.lot,
    required this.createdAt,
  });

  factory DemandeId.fromJson(Map<String, dynamic> json) => DemandeId(
        id: json["_id"],
        valide: json["valide"],
        idDemande: json["idDemande"],
        codeAgent: json["codeAgent"],
        lot: json["lot"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}

class Coordonnes {
  final String latitude;
  final String longitude;
  // String altitude;
  final String id;

  Coordonnes({
    required this.latitude,
    required this.longitude,
    // required this.altitude,
    required this.id,
  });

  factory Coordonnes.fromJson(Map<String, dynamic> json) => Coordonnes(
        latitude: json["latitude"],
        longitude: json["longitude"],
        // altitude: json["altitude"],
        id: json["_id"],
      );
}

class ReponseId {
  final String id;
  final String codeClient;
  final String codeCu;
  final String clientStatut;
  final String payementStatut;
  final int consExpDays;
  final String idDemande;
  final String text;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String nomClient;

  ReponseId({
    required this.id,
    required this.codeClient,
    required this.codeCu,
    required this.clientStatut,
    required this.payementStatut,
    required this.consExpDays,
    required this.idDemande,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.nomClient,
  });
  factory ReponseId.fromJson(Map<String, dynamic> json) => ReponseId(
      id: json["_id"],
      codeClient: json["codeClient"],
      codeCu: json["codeCu"],
      clientStatut: json["clientStatut"],
      payementStatut: json["PayementStatut"],
      consExpDays: json["consExpDays"],
      idDemande: json["idDemande"],
      text: json["text"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
      nomClient: json["nomClient"]);
}
