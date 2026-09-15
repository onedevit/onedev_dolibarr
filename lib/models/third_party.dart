class ThirdParty {
  final String id;
  final String name;
  final String? codeClient;
  final String? email;
  final String? phone;
  final String? address;
  final String? zip;
  final String? town;
  final String? country;
  final String? clientStatus; // 0=Neither, 1=Customer, 2=Prospect, 3=Both
  final String? supplierStatus; // 0=No, 1=Supplier
  final String? vatNumber;

  ThirdParty({
    required this.id,
    required this.name,
    this.codeClient,
    this.email,
    this.phone,
    this.address,
    this.zip,
    this.town,
    this.country,
    this.clientStatus,
    this.supplierStatus,
    this.vatNumber,
  });

  factory ThirdParty.fromJson(Map<String, dynamic> json) {
    return ThirdParty(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['nom'] ?? 'Sans Nom',
      codeClient: json['code_client']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      zip: json['zip']?.toString(),
      town: json['town']?.toString(),
      country: json['country']?.toString(),
      clientStatus: json['client']?.toString(),
      supplierStatus: json['fournisseur']?.toString(),
      vatNumber: json['tva_intra']?.toString(),
    );
  }

  String get fullAddress {
    final parts = [address, zip, town, country].where((p) => p != null && p.trim().isNotEmpty).toList();
    return parts.isEmpty ? 'Adresse non renseignée' : parts.join(', ');
  }

  bool get isCustomer => clientStatus == '1' || clientStatus == '3';
  bool get isSupplier => supplierStatus == '1';
}
