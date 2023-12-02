class ModelDemande {
  String id;
  bool valide;
  String idDemande;
  String codeAgent;
  String codeZone;
  String typeImage;
  Coordonnes coordonnes;
  String statut;
  String file;
  String province;
  String country;
  String sector;
  String cell;
  String reference;
  String sat;
  String lot;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<Reponse> reponse;

  ModelDemande({
    required this.id,
    required this.valide,
    required this.idDemande,
    required this.codeAgent,
    required this.codeZone,
    required this.typeImage,
    required this.coordonnes,
    required this.statut,
    required this.file,
    required this.province,
    required this.country,
    required this.sector,
    required this.cell,
    required this.reference,
    required this.sat,
    required this.lot,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reponse,
  });

  factory ModelDemande.fromJson(Map<String, dynamic> json) => ModelDemande(
        id: json["_id"],
        valide: json["valide"],
        idDemande: json["idDemande"],
        codeAgent: json["codeAgent"],
        codeZone: json["codeZone"],
        typeImage: json["typeImage"],
        coordonnes: Coordonnes.fromJson(json["coordonnes"]),
        statut: json["statut"],
        file: json["file"],
        province: json["province"],
        country: json["country"],
        sector: json["sector"],
        cell: json["cell"],
        reference: json["reference"],
        sat: json["sat"],
        lot: json["lot"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reponse:
            List<Reponse>.from(json["reponse"].map((x) => Reponse.fromJson(x))),
      );
}

class Coordonnes {
  final String latitude;
  final String longitude;
  final dynamic altitude;
  final String id;

  Coordonnes({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.id,
  });

  factory Coordonnes.fromJson(Map<String, dynamic> json) => Coordonnes(
        latitude: json["latitude"],
        longitude: json["longitude"],
        altitude: json["altitude"],
        id: json["_id"],
      );
}

class Reponse {
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

    Reponse({
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

    factory Reponse.fromJson(Map<String, dynamic> json) => Reponse(
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

class Periode {
  String id;
  int demande;
  int reponse;

  Periode({
    required this.id,
    required this.demande,
    required this.reponse,
  });

  factory Periode.fromJson(Map<String, dynamic> json) => Periode(
        id: json["_id"],
        demande: json["demande"],
        reponse: json["reponse"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "demande": demande,
        "reponse": reponse,
      };
}
