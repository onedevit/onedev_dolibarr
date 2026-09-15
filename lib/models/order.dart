class CustomerOrder {
  final String id;
  final String ref;
  final String? socid;
  final String? thirdPartyName;
  final String? totalHt;
  final String? totalTtc;
  final String? status;
  final dynamic dateCreation;
  final dynamic dateCommande;
  final String? notePublic;

  CustomerOrder({
    required this.id,
    required this.ref,
    this.socid,
    this.thirdPartyName,
    this.totalHt,
    this.totalTtc,
    this.status,
    this.dateCreation,
    this.dateCommande,
    this.notePublic,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    return CustomerOrder(
      id: json['id']?.toString() ?? '',
      ref: json['ref']?.toString() ?? 'CMD-REF',
      socid: json['socid']?.toString(),
      thirdPartyName: json['thirdparty_name'] ?? json['socname'] ?? 'Tiers non spécifié',
      totalHt: json['total_ht']?.toString(),
      totalTtc: json['total_ttc']?.toString(),
      status: json['statut']?.toString() ?? json['status']?.toString(),
      dateCreation: json['date_creation'] ?? json['datec'],
      dateCommande: json['date_commande'] ?? json['date_order'],
      notePublic: json['note_public']?.toString(),
    );
  }
}
