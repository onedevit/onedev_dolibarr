import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dolibarr_config.dart';
import '../models/third_party.dart';
import '../models/product.dart';
import '../models/proposal.dart';
import '../models/order.dart';
import '../models/invoice.dart';

class DolibarrApiService {
  final DolibarrConfig config;

  DolibarrApiService(this.config);

  // Méthode utilitaire pour les requêtes GET
  Future<dynamic> _get(String path, {Map<String, String>? queryParams}) async {
    final cleanUrl = config.cleanBaseUrl;
    var uri = Uri.parse('$cleanUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    try {
      final response = await http.get(
        uri,
        headers: config.headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Clé API non valide ou accès refusé (401).');
      } else {
        final body = jsonDecode(response.body);
        final message = body['error']?['message'] ?? 'Erreur API (${response.statusCode})';
        throw Exception(message);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur de connexion au serveur: $e');
    }
  }

  // Tester la connexion
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final result = await _get('/status');
      if (result is Map<String, dynamic> && result.containsKey('success')) {
        return result;
      }
      return {'success': true, 'version': result['dolibarr_version'] ?? 'Connecté'};
    } catch (_) {
      // Tentative de récupération alternative via /thirdparties limit 1
      try {
        await _get('/thirdparties', queryParams: {'limit': '1'});
        return {'success': true, 'version': 'Connecté'};
      } catch (e) {
        rethrow;
      }
    }
  }

  // Récupérer les Tiers (Clients/Fournisseurs)
  Future<List<ThirdParty>> getThirdParties({String? search, int limit = 50}) async {
    final params = {'limit': limit.toString(), 'sortfield': 't.nom', 'sortorder': 'ASC'};
    if (search != null && search.trim().isNotEmpty) {
      params['sqlfilters'] = "(t.nom:like:'%${search.trim()}%')";
    }
    final data = await _get('/thirdparties', queryParams: params);
    if (data is List) {
      return data.map((json) => ThirdParty.fromJson(json)).toList();
    }
    return [];
  }

  // Récupérer les Produits & Services
  Future<List<Product>> getProducts({String? search, int limit = 50}) async {
    final params = {'limit': limit.toString(), 'sortfield': 't.ref', 'sortorder': 'ASC'};
    if (search != null && search.trim().isNotEmpty) {
      params['sqlfilters'] = "(t.label:like:'%${search.trim()}%') OR (t.ref:like:'%${search.trim()}%')";
    }
    final data = await _get('/products', queryParams: params);
    if (data is List) {
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  // Récupérer les Devis (Propositions commerciales)
  Future<List<Proposal>> getProposals({String? search, int limit = 50}) async {
    final params = {'limit': limit.toString(), 'sortfield': 't.rowid', 'sortorder': 'DESC'};
    if (search != null && search.trim().isNotEmpty) {
      params['sqlfilters'] = "(t.ref:like:'%${search.trim()}%')";
    }
    final data = await _get('/proposals', queryParams: params);
    if (data is List) {
      return data.map((json) => Proposal.fromJson(json)).toList();
    }
    return [];
  }

  // Récupérer les Commandes
  Future<List<CustomerOrder>> getOrders({String? search, int limit = 50}) async {
    final params = {'limit': limit.toString(), 'sortfield': 't.rowid', 'sortorder': 'DESC'};
    if (search != null && search.trim().isNotEmpty) {
      params['sqlfilters'] = "(t.ref:like:'%${search.trim()}%')";
    }
    final data = await _get('/orders', queryParams: params);
    if (data is List) {
      return data.map((json) => CustomerOrder.fromJson(json)).toList();
    }
    return [];
  }

  // Récupérer les Factures
  Future<List<Invoice>> getInvoices({String? search, int limit = 50}) async {
    final params = {'limit': limit.toString(), 'sortfield': 't.rowid', 'sortorder': 'DESC'};
    if (search != null && search.trim().isNotEmpty) {
      params['sqlfilters'] = "(t.ref:like:'%${search.trim()}%')";
    }
    final data = await _get('/invoices', queryParams: params);
    if (data is List) {
      return data.map((json) => Invoice.fromJson(json)).toList();
    }
    return [];
  }
}
