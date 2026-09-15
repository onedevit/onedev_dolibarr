class DolibarrConfig {
  final String baseUrl;
  final String apiKey;
  final String? entity;

  DolibarrConfig({
    required this.baseUrl,
    required this.apiKey,
    this.entity = '1',
  });

  String get cleanBaseUrl {
    var url = baseUrl.trim();
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (!url.endsWith('/api/index.php')) {
      if (url.contains('/api/index.php')) {
        // Leave as is
      } else if (url.endsWith('/api')) {
        url = '$url/index.php';
      } else {
        url = '$url/api/index.php';
      }
    }
    return url;
  }

  bool get isValid => baseUrl.isNotEmpty && apiKey.isNotEmpty;

  Map<String, String> get headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'DOLAPIKEY': apiKey.trim(),
      };

  Map<String, dynamic> toJson() => {
        'baseUrl': baseUrl,
        'apiKey': apiKey,
        'entity': entity,
      };

  factory DolibarrConfig.fromJson(Map<String, dynamic> json) {
    return DolibarrConfig(
      baseUrl: json['baseUrl'] ?? '',
      apiKey: json['apiKey'] ?? '',
      entity: json['entity'] ?? '1',
    );
  }
}
