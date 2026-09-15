import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../models/third_party.dart';
import '../../providers/dolibarr_provider.dart';

class ThirdPartiesScreen extends StatefulWidget {
  const ThirdPartiesScreen({super.key});

  @override
  State<ThirdPartiesScreen> createState() => _ThirdPartiesScreenState();
}

class _ThirdPartiesScreenState extends State<ThirdPartiesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    context.read<DolibarrProvider>().fetchThirdParties(search: _searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DolibarrProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiers (Clients & Fournisseurs)'),
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
                      hintText: 'Rechercher un tiers...',
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
            child: provider.isThirdPartiesLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.thirdPartiesError != null
                    ? _buildErrorView(provider.thirdPartiesError!)
                    : provider.thirdParties.isEmpty
                        ? _buildEmptyView()
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchThirdParties(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.thirdParties.length,
                              itemBuilder: (context, index) {
                                final item = provider.thirdParties[index];
                                return _buildThirdPartyCard(context, item);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPartyCard(BuildContext context, ThirdParty party) {
    final statusMeta = Formatters.getStatusMeta('thirdparty', party.clientStatus);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
          child: Text(
            party.name.isNotEmpty ? party.name[0].toUpperCase() : 'T',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
              fontSize: 18,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                party.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusMeta['bg'],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusMeta['label'],
                style: TextStyle(
                  color: statusMeta['color'],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            if (party.codeClient != null && party.codeClient!.isNotEmpty)
              Text('Code: ${party.codeClient}', style: const TextStyle(fontSize: 12)),
            if (party.email != null && party.email!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      party.email!,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (party.phone != null && party.phone!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    party.phone!,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
          ],
        ),
        onTap: () => _showDetailSheet(context, party),
      ),
    );
  }

  void _showDetailSheet(BuildContext context, ThirdParty party) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                party.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _detailRow('Code Client', party.codeClient ?? '-'),
              _detailRow('Email', party.email ?? '-'),
              _detailRow('Téléphone', party.phone ?? '-'),
              _detailRow('Adresse', party.fullAddress),
              _detailRow('N° TVA', party.vatNumber ?? '-'),
              const SizedBox(height: 24),
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

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.business_center_outlined, size: 64, color: AppTheme.textMuted),
          SizedBox(height: 12),
          Text(
            'Aucun tiers trouvé',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppTheme.statusError),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
