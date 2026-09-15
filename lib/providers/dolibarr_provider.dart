import 'package:flutter/material.dart';
import '../models/dolibarr_config.dart';
import '../models/third_party.dart';
import '../models/product.dart';
import '../models/proposal.dart';
import '../models/order.dart';
import '../models/invoice.dart';
import '../services/dolibarr_api_service.dart';

class DolibarrProvider extends ChangeNotifier {
  DolibarrApiService? _apiService;

  // Listes des données des modules
  List<ThirdParty> _thirdParties = [];
  List<Product> _products = [];
  List<Proposal> _proposals = [];
  List<CustomerOrder> _orders = [];
  List<Invoice> _invoices = [];

  // Vérification de la disponibilité des modules
  bool _hasThirdParties = true;
  bool _hasProducts = true;
  bool _hasProposals = true;
  bool _hasOrders = true;
  bool _hasInvoices = true;

  // États de chargement
  bool _isThirdPartiesLoading = false;
  bool _isProductsLoading = false;
  bool _isProposalsLoading = false;
  bool _isOrdersLoading = false;
  bool _isInvoicesLoading = false;

  // Messages d'erreur
  String? _thirdPartiesError;
  String? _productsError;
  String? _proposalsError;
  String? _ordersError;
  String? _invoicesError;

  // Accesseurs (Getters)
  List<ThirdParty> get thirdParties => _thirdParties;
  List<Product> get products => _products;
  List<Proposal> get proposals => _proposals;
  List<CustomerOrder> get orders => _orders;
  List<Invoice> get invoices => _invoices;

  bool get hasThirdParties => _hasThirdParties;
  bool get hasProducts => _hasProducts;
  bool get hasProposals => _hasProposals;
  bool get hasOrders => _hasOrders;
  bool get hasInvoices => _hasInvoices;

  bool get isThirdPartiesLoading => _isThirdPartiesLoading;
  bool get isProductsLoading => _isProductsLoading;
  bool get isProposalsLoading => _isProposalsLoading;
  bool get isOrdersLoading => _isOrdersLoading;
  bool get isInvoicesLoading => _isInvoicesLoading;

  String? get thirdPartiesError => _thirdPartiesError;
  String? get productsError => _productsError;
  String? get proposalsError => _proposalsError;
  String? get ordersError => _ordersError;
  String? get invoicesError => _invoicesError;

  void updateConfig(DolibarrConfig? config) {
    if (config != null && config.isValid) {
      _apiService = DolibarrApiService(config);
      fetchAllData();
    }
  }

  Future<void> fetchAllData() async {
    if (_apiService == null) return;
    await Future.wait([
      fetchThirdParties(),
      fetchProducts(),
      fetchProposals(),
      fetchOrders(),
      fetchInvoices(),
    ]);
  }

  // Fetch Third Parties
  Future<void> fetchThirdParties({String? search}) async {
    if (_apiService == null) return;
    _isThirdPartiesLoading = true;
    _thirdPartiesError = null;
    notifyListeners();

    try {
      _thirdParties = await _apiService!.getThirdParties(search: search);
      _hasThirdParties = true;
    } catch (e) {
      _thirdPartiesError = e.toString().replaceAll('Exception: ', '');
      _hasThirdParties = false;
    } finally {
      _isThirdPartiesLoading = false;
      notifyListeners();
    }
  }

  // Fetch Products
  Future<void> fetchProducts({String? search}) async {
    if (_apiService == null) return;
    _isProductsLoading = true;
    _productsError = null;
    notifyListeners();

    try {
      _products = await _apiService!.getProducts(search: search);
      _hasProducts = true;
    } catch (e) {
      _productsError = e.toString().replaceAll('Exception: ', '');
      _hasProducts = false;
    } finally {
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  // Fetch Proposals
  Future<void> fetchProposals({String? search}) async {
    if (_apiService == null) return;
    _isProposalsLoading = true;
    _proposalsError = null;
    notifyListeners();

    try {
      _proposals = await _apiService!.getProposals(search: search);
      _hasProposals = true;
    } catch (e) {
      _proposalsError = e.toString().replaceAll('Exception: ', '');
      _hasProposals = false;
    } finally {
      _isProposalsLoading = false;
      notifyListeners();
    }
  }

  // Fetch Orders
  Future<void> fetchOrders({String? search}) async {
    if (_apiService == null) return;
    _isOrdersLoading = true;
    _ordersError = null;
    notifyListeners();

    try {
      _orders = await _apiService!.getOrders(search: search);
      _hasOrders = true;
    } catch (e) {
      _ordersError = e.toString().replaceAll('Exception: ', '');
      _hasOrders = false;
    } finally {
      _isOrdersLoading = false;
      notifyListeners();
    }
  }

  // Fetch Invoices
  Future<void> fetchInvoices({String? search}) async {
    if (_apiService == null) return;
    _isInvoicesLoading = true;
    _invoicesError = null;
    notifyListeners();

    try {
      _invoices = await _apiService!.getInvoices(search: search);
      _hasInvoices = true;
    } catch (e) {
      _invoicesError = e.toString().replaceAll('Exception: ', '');
      _hasInvoices = false;
    } finally {
      _isInvoicesLoading = false;
      notifyListeners();
    }
  }

  // Quick Statistics Calculations
  double get totalInvoicesRevenue {
    return _invoices.fold(0.0, (sum, item) => sum + (double.tryParse(item.totalTtc ?? '0') ?? 0.0));
  }

  double get totalProposalsValue {
    return _proposals.fold(0.0, (sum, item) => sum + (double.tryParse(item.totalTtc ?? '0') ?? 0.0));
  }
}
