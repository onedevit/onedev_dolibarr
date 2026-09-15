class Invoice {
  final String id;
  final String ref;
  final String? socid;
  final String? thirdPartyName;
  final String? totalHt;
  final String? totalTtc;
  final String? status; // 0=Draft, 1=Unpaid, 2=Paid, 3=Canceled
  final String? paye; // 0=Not paid, 1=Paid
  final dynamic dateCreation;
  final dynamic dateInvoice;
  final String? notePublic;

  Invoice({
    required this.id,
    required this.ref,
    this.socid,
    this.thirdPartyName,
    this.totalHt,
    this.totalTtc,
    this.status,
    this.paye,
    this.dateCreation,
    this.dateInvoice,
    this.notePublic,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id']?.toString() ?? '',
      ref: json['ref']?.toString() ?? 'FAC-REF',
      socid: json['socid']?.toString(),
      thirdPartyName: json['thirdparty_name'] ?? json['socname'] ?? 'Tiers non spécifié',
      totalHt: json['total_ht']?.toString(),
      totalTtc: json['total_ttc']?.toString(),
      status: json['statut']?.toString() ?? json['status']?.toString(),
      paye: json['paye']?.toString(),
      dateCreation: json['date_creation'] ?? json['datec'],
      dateInvoice: json['date'] ?? json['date_invoice'],
      notePublic: json['note_public']?.toString(),
    );
  }

  bool get isPaid => paye == '1' || status == '2';
}
