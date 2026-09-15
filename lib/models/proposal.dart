class Proposal {
  final String id;
  final String ref;
  final String? socid;
  final String? thirdPartyName;
  final String? totalHt;
  final String? totalTtc;
  final String? status;
  final dynamic dateCreation;
  final dynamic dateValidation;
  final String? notePublic;

  Proposal({
    required this.id,
    required this.ref,
    this.socid,
    this.thirdPartyName,
    this.totalHt,
    this.totalTtc,
    this.status,
    this.dateCreation,
    this.dateValidation,
    this.notePublic,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id']?.toString() ?? '',
      ref: json['ref']?.toString() ?? 'DEVIS-REF',
      socid: json['socid']?.toString(),
      thirdPartyName: json['thirdparty_name'] ?? json['socname'] ?? 'Tiers non spécifié',
      totalHt: json['total_ht']?.toString(),
      totalTtc: json['total_ttc']?.toString(),
      status: json['statut']?.toString() ?? json['status']?.toString(),
      dateCreation: json['date_creation'] ?? json['datec'],
      dateValidation: json['date_validation'] ?? json['datev'],
      notePublic: json['note_public']?.toString(),
    );
  }
}
