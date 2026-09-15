import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class Formatters {
  // Formater les devises
  static String formatCurrency(dynamic amount, {String symbol = '€'}) {
    if (amount == null) return '0.00 $symbol';
    final double value = (amount is num)
        ? amount.toDouble()
        : (double.tryParse(amount.toString()) ?? 0.0);
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      customPattern: '#,##0.00 \u00A4',
    );
    return formatter.format(value);
  }

  // Formater les dates
  static String formatDate(dynamic rawDate) {
    if (rawDate == null || rawDate.toString().isEmpty) return '-';
    try {
      DateTime dt;
      if (rawDate is int) {
        dt = DateTime.fromMillisecondsSinceEpoch(rawDate * 1000);
      } else {
        dt = DateTime.tryParse(rawDate.toString()) ?? DateTime.now();
      }
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      return rawDate.toString();
    }
  }

  // Obtenir la couleur et le libellé de statut pour Dolibarr
  static Map<String, dynamic> getStatusMeta(String entityType, String? status) {
    final code = status ?? '0';

    switch (entityType.toLowerCase()) {
      case 'proposal': // Proposals (Devis)
        switch (code) {
          case '0':
            return {'label': 'Brouillon (Draft)', 'color': AppTheme.statusWarning, 'bg': const Color(0xFFFEF3C7)};
          case '1':
            return {'label': 'Ouvert (Open)', 'color': AppTheme.statusInfo, 'bg': const Color(0xFFDBEAFE)};
          case '2':
            return {'label': 'Signé (Signed)', 'color': AppTheme.statusSuccess, 'bg': const Color(0xFFD1FAE5)};
          case '3':
            return {'label': 'Non signé (Refused)', 'color': AppTheme.statusError, 'bg': const Color(0xFFFEE2E2)};
          case '4':
            return {'label': 'Classé (Billed)', 'color': AppTheme.primaryBlue, 'bg': const Color(0xFFE0E7FF)};
          default:
            return {'label': 'Inconnu ($code)', 'color': AppTheme.textSecondary, 'bg': const Color(0xFFF1F5F9)};
        }

      case 'order': // Customer Orders (Commandes)
        switch (code) {
          case '0':
            return {'label': 'Brouillon (Draft)', 'color': AppTheme.statusWarning, 'bg': const Color(0xFFFEF3C7)};
          case '1':
            return {'label': 'Validé (Validated)', 'color': AppTheme.statusInfo, 'bg': const Color(0xFFDBEAFE)};
          case '2':
            return {'label': 'En cours (Processing)', 'color': AppTheme.accentCyan, 'bg': const Color(0xFFE0F2FE)};
          case '3':
            return {'label': 'Livré (Delivered)', 'color': AppTheme.statusSuccess, 'bg': const Color(0xFFD1FAE5)};
          case '-1':
            return {'label': 'Annulé (Canceled)', 'color': AppTheme.statusError, 'bg': const Color(0xFFFEE2E2)};
          default:
            return {'label': 'Statut $code', 'color': AppTheme.textSecondary, 'bg': const Color(0xFFF1F5F9)};
        }

      case 'invoice': // Invoices (Factures)
        switch (code) {
          case '0':
            return {'label': 'Brouillon (Draft)', 'color': AppTheme.statusWarning, 'bg': const Color(0xFFFEF3C7)};
          case '1':
            return {'label': 'Impayé (Unpaid)', 'color': AppTheme.statusError, 'bg': const Color(0xFFFEE2E2)};
          case '2':
            return {'label': 'Payé (Paid)', 'color': AppTheme.statusSuccess, 'bg': const Color(0xFFD1FAE5)};
          case '3':
            return {'label': 'Abandonné (Canceled)', 'color': AppTheme.textSecondary, 'bg': const Color(0xFFF1F5F9)};
          default:
            return {'label': 'Statut $code', 'color': AppTheme.textSecondary, 'bg': const Color(0xFFF1F5F9)};
        }

      case 'thirdparty': // Sociétés
        switch (code) {
          case '1':
            return {'label': 'Client', 'color': AppTheme.statusSuccess, 'bg': const Color(0xFFD1FAE5)};
          case '2':
            return {'label': 'Prospect', 'color': AppTheme.statusInfo, 'bg': const Color(0xFFDBEAFE)};
          case '3':
            return {'label': 'Client/Prospect', 'color': AppTheme.accentCyan, 'bg': const Color(0xFFE0F2FE)};
          default:
            return {'label': 'Tiers', 'color': AppTheme.textSecondary, 'bg': const Color(0xFFF1F5F9)};
        }

      default:
        return {'label': status ?? 'Actif', 'color': AppTheme.primaryBlue, 'bg': const Color(0xFFE0E7FF)};
    }
  }
}
