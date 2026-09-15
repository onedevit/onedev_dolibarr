import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/invoice.dart';
import '../../providers/dolibarr_provider.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    context.read<DolibarrProvider>().fetchInvoices(search: _searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DolibarrProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures Clients'),
      ),
      body: Column(
        children: [
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
                      hintText: 'Rechercher une facture...',
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
          Expanded(
            child: provider.isInvoicesLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.invoicesError != null
                    ? Center(child: Text(provider.invoicesError!))
                    : provider.invoices.isEmpty
                        ? const Center(child: Text('Aucune facture trouvée'))
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchInvoices(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.invoices.length,
                              itemBuilder: (context, index) {
                                final invoice = provider.invoices[index];
                                return _buildInvoiceCard(context, invoice);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice) {
    final statusMeta = Formatters.getStatusMeta('invoice', invoice.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusMeta['bg'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.receipt_long_rounded, color: statusMeta['color']),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                invoice.ref,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Text(
              Formatters.formatCurrency(invoice.totalTtc),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryBlue),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Client: ${invoice.thirdPartyName}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: ${Formatters.formatDate(invoice.dateInvoice ?? invoice.dateCreation)}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusMeta['bg'],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusMeta['label'],
                    style: TextStyle(color: statusMeta['color'], fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showDetailSheet(context, invoice),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, Invoice invoice) {
    final statusMeta = Formatters.getStatusMeta('invoice', invoice.status);

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
                'Facture ${invoice.ref}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _detailRow('Client', invoice.thirdPartyName ?? '-'),
              _detailRow('Statut', statusMeta['label']),
              _detailRow('Total HT', Formatters.formatCurrency(invoice.totalHt)),
              _detailRow('Total TTC', Formatters.formatCurrency(invoice.totalTtc)),
              _detailRow('Date Facture', Formatters.formatDate(invoice.dateInvoice ?? invoice.dateCreation)),
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
