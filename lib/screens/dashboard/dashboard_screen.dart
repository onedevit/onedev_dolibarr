import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dolibarr_provider.dart';
import '../settings/settings_screen.dart';
import '../third_parties/third_parties_screen.dart';
import '../products/products_screen.dart';
import '../proposals/proposals_screen.dart';
import '../orders/orders_screen.dart';
import '../invoices/invoices_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<DolibarrProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.hub_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dolibarr Mobile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (auth.config != null)
                  Text(
                    auth.config!.baseUrl.replaceAll(RegExp(r'https?://'), ''),
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configuration',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: auth.config == null || !auth.isConnected
          ? _buildNotConnectedView(context)
          : RefreshIndicator(
              onRefresh: () => provider.fetchAllData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Read Only Notice Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.visibility_rounded, color: AppTheme.statusSuccess, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Mode Consultation Seule (Read-Only)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Stats Section
                    const Text(
                      'Vue d\'ensemble',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Volume Factures',
                            Formatters.formatCurrency(provider.totalInvoicesRevenue),
                            Icons.receipt_long_rounded,
                            AppTheme.primaryBlue,
                            const Color(0xFFEFF6FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Volume Devis',
                            Formatters.formatCurrency(provider.totalProposalsValue),
                            Icons.description_rounded,
                            AppTheme.statusInfo,
                            const Color(0xFFDBEAFE),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Active Modules Section
                    const Text(
                      'Modules Activés',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.15,
                      children: [
                        _buildModuleCard(
                          context,
                          title: 'Tiers & Clients',
                          subtitle: '${provider.thirdParties.length} Fiches',
                          icon: Icons.business_center_rounded,
                          color: const Color(0xFF003366),
                          bgColor: const Color(0xFFEFF6FF),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ThirdPartiesScreen()),
                          ),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Produits & Services',
                          subtitle: '${provider.products.length} Articles',
                          icon: Icons.inventory_2_rounded,
                          color: const Color(0xFF0284C7),
                          bgColor: const Color(0xFFE0F2FE),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProductsScreen()),
                          ),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Devis (Propositions)',
                          subtitle: '${provider.proposals.length} Documents',
                          icon: Icons.description_rounded,
                          color: const Color(0xFFD97706),
                          bgColor: const Color(0xFFFEF3C7),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProposalsScreen()),
                          ),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Commandes',
                          subtitle: '${provider.orders.length} Commandes',
                          icon: Icons.shopping_bag_rounded,
                          color: const Color(0xFF059669),
                          bgColor: const Color(0xFFD1FAE5),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const OrdersScreen()),
                          ),
                        ),
                        _buildModuleCard(
                          context,
                          title: 'Factures Clients',
                          subtitle: '${provider.invoices.length} Factures',
                          icon: Icons.receipt_long_rounded,
                          color: const Color(0xFF7C3AED),
                          bgColor: const Color(0xFFF3E8FF),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const InvoicesScreen()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotConnectedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 56, color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saisir les accès Dolibarr',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configurez l\'adresse de votre serveur Dolibarr et votre clé API pour commencer.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings_rounded),
              label: const Text('Configurer la connexion'),
            ),
          ],
        ),
      ),
    );
  }
}
