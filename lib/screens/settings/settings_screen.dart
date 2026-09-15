import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urlController;
  late TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _urlController = TextEditingController(text: authProvider.config?.baseUrl ?? '');
    _apiKeyController = TextEditingController(text: authProvider.config?.apiKey ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.saveAndConnect(
      _urlController.text.trim(),
      _apiKeyController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie à Dolibarr !'),
            backgroundColor: AppTheme.statusSuccess,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Échec de la connexion'),
            backgroundColor: AppTheme.statusError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration Dolibarr'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card if Connected
            if (auth.isConnected)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppTheme.statusSuccess, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Connecté avec succès',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                            ),
                          ),
                          Text(
                            'Dolibarr Version: ${auth.versionInfo ?? "Active"}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Help Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Entrez l\'URL de votre instance Dolibarr et votre clé API (disponible dans votre profil utilisateur Dolibarr).',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.primaryBlue.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adresse URL du Serveur Dolibarr',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _urlController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      hintText: 'https://mon-dolibarr.com',
                      prefixIcon: Icon(Icons.dns_rounded, color: AppTheme.textSecondary),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir l\'adresse URL';
                      }
                      if (!value.startsWith('http://') && !value.startsWith('https://')) {
                        return 'L\'URL doit commencer par http:// ou https://';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Clé API (DOLAPIKEY)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Ex: 123456789abcdef...',
                      prefixIcon: Icon(Icons.key_rounded, color: AppTheme.textSecondary),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir la clé API';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Connect / Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _submit,
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.link_rounded),
                                SizedBox(width: 8),
                                Text('Tester & Enregistrer'),
                              ],
                            ),
                    ),
                  ),

                  if (auth.isConnected) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await auth.logout();
                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Déconnexion effectuée')),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.statusError,
                          side: const BorderSide(color: AppTheme.statusError),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.logout_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Se déconnecter'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
