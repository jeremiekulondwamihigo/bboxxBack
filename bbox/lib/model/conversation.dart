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
  final String statut;
  final String file;
  final String province;
  final String country;
  final String sector;
  final String cell;

  DemandeId({
    required this.id,
    required this.valide,
    required this.idDemande,
    required this.codeAgent,
    required this.lot,
    required this.createdAt,
    required this.statut,
    required this.file,
    required this.province,
    required this.country,
    required this.sector,
    required this.cell,
  });

  factory DemandeId.fromJson(Map<String, dynamic> json) => DemandeId(
        id: json["_id"],
        valide: json["valide"],
        idDemande: json["idDemande"],
        codeAgent: json["codeAgent"],
        lot: json["lot"],
        statut: json["statut"],
        file: json["file"],
        province: json["province"],
        country: json["country"],
        sector: json["sector"],
        cell: json["cell"],
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
  String id;
  String codeClient;
  String codeCu;
  String clientStatut;
  String payementStatut;
  int consExpDays;
  String idDemande;
  DateTime dateSave;
  String codeAgent;
  String nomClient;
  String region;
  String shop;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ReponseId({
    required this.id,
    required this.codeClient,
    required this.codeCu,
    required this.clientStatut,
    required this.payementStatut,
    required this.consExpDays,
    required this.idDemande,
    required this.dateSave,
    required this.codeAgent,
    required this.nomClient,
    required this.region,
    required this.shop,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ReponseId.fromJson(Map<String, dynamic> json) => ReponseId(
        id: json["_id"],
        codeClient: json["codeClient"],
        codeCu: json["codeCu"],
        clientStatut: json["clientStatut"],
        payementStatut: json["PayementStatut"],
        consExpDays: json["consExpDays"],
        idDemande: json["idDemande"],
        dateSave: DateTime.parse(json["dateSave"]),
        codeAgent: json["codeAgent"],
        nomClient: json["nomClient"],
        region: json["region"],
        shop: json["shop"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "codeClient": codeClient,
        "codeCu": codeCu,
        "clientStatut": clientStatut,
        "PayementStatut": payementStatut,
        "consExpDays": consExpDays,
        "idDemande": idDemande,
        "dateSave": dateSave.toIso8601String(),
        "codeAgent": codeAgent,
        "nomClient": nomClient,
        "region": region,
        "shop": shop,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
