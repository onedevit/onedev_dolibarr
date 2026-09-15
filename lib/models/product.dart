class Product {
  final String id;
  final String ref;
  final String label;
  final String? description;
  final String? price;
  final String? priceTtc;
  final String? type; // 0 = Product, 1 = Service
  final String? stock;
  final String? status; // 1 = In sale, 0 = Not in sale

  Product({
    required this.id,
    required this.ref,
    required this.label,
    this.description,
    this.price,
    this.priceTtc,
    this.type,
    this.stock,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      ref: json['ref']?.toString() ?? 'REF',
      label: json['label']?.toString() ?? 'Produit Sans Nom',
      description: json['description']?.toString(),
      price: json['price']?.toString(),
      priceTtc: json['price_ttc']?.toString(),
      type: json['type']?.toString(),
      stock: json['stock_real']?.toString() ?? json['stock']?.toString(),
      status: json['status']?.toString() ?? json['tosell']?.toString(),
    );
  }

  bool get isService => type == '1';
  bool get isInSale => status == '1';
}
