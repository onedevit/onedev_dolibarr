import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/product.dart';
import '../../providers/dolibarr_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    context.read<DolibarrProvider>().fetchProducts(search: _searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DolibarrProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits & Services'),
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un produit/service...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _onSearch,
                  icon: const Icon(Icons.search_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: provider.isProductsLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.productsError != null
                    ? Center(child: Text(provider.productsError!))
                    : provider.products.isEmpty
                        ? const Center(child: Text('Aucun produit trouvé'))
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchProducts(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.products.length,
                              itemBuilder: (context, index) {
                                final product = provider.products[index];
                                return _buildProductCard(context, product);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: product.isService ? const Color(0xFFE0F2FE) : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            product.isService ? Icons.design_services_rounded : Icons.inventory_2_rounded,
            color: product.isService ? AppTheme.accentCyan : AppTheme.statusWarning,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                product.label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Text(
              Formatters.formatCurrency(product.priceTtc ?? product.price),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Réf: ${product.ref}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            if (product.stock != null)
              Text('Stock: ${product.stock}', style: const TextStyle(fontSize: 12, color: AppTheme.statusSuccess)),
          ],
        ),
        onTap: () => _showDetailSheet(context, product),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _detailRow('Référence', product.ref),
              _detailRow('Type', product.isService ? 'Service' : 'Produit physique'),
              _detailRow('Prix HT', Formatters.formatCurrency(product.price)),
              _detailRow('Prix TTC', Formatters.formatCurrency(product.priceTtc)),
              _detailRow('Stock réel', product.stock ?? 'N/A'),
              if (product.description != null && product.description!.isNotEmpty)
                _detailRow('Description', product.description!),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
