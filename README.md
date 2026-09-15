# Dolibarr Mobile Enterprise 📱💼

Une application mobile moderne, professionnelle et sécurisée développée avec **Flutter** (dédiée pour **Android** & **iOS**) permettant de se connecter directement à n'importe quelle instance du serveur **Dolibarr ERP/CRM** via son API REST.

L'application est conçue en mode **Consultation Seule (Read-Only)** pour permettre aux utilisateurs et décisionnaires de consulter la totalité de leurs données d'entreprise en temps réel, de manière fluide et intuitive sans risque de modification involontaire.

---

## 🚀 Fonctionnalités Principales

- 🔐 **Configuration du Serveur & Connexion Sécurisée** :
  - Saisie de l'URL du serveur Dolibarr et de la clé d'API (`DOLAPIKEY`).
  - Test de connexion instantané avec affichage de la version du serveur.
  - Sauvegarde locale sécurisée des identifiants (`SharedPreferences`).

- 📊 **Tableau de Bord Interactif (Dashboard)** :
  - Vue d'ensemble des indicateurs clés (KPI) : Volume global des factures et des devis.
  - Grille dynamique des modules activés avec compteurs d'éléments.
  - Fonctionnalité *Pull-to-Refresh* pour rafraîchir toutes les données en un glissement.

- 🏢 **Gestion des Tiers (Clients & Fournisseurs)** :
  - Liste complète des entreprises et contacts.
  - Filtre et recherche en temps réel par nom.
  - Fiche détaillée pour chaque tiers (Code client, Téléphone, Email, Adresse, N° TVA).

- 📦 **Catalogue Produits & Services** :
  - Affichage clair des articles en vente (Produits physiques et Services).
  - Détail des prix HT et TTC ainsi que le niveau de stock réel disponible.

- 📜 **Propositions Commerciales (Devis)** :
  - Liste chronologique des devis avec badges de statut colorés (*Brouillon*, *Ouvert*, *Signé*, *Classé*).
  - Modal de détails complet avec totaux financiers.

- 🛒 **Commandes Clients** :
  - Suivi des commandes clients et de leur état (*Brouillon*, *Validé*, *En cours*, *Livré*, *Annulé*).

- 🧾 **Factures Clients** :
  - Suivi de la facturation avec distinction visuelle des factures *Payées*, *Impayées* ou *En brouillon*.

---

## 🎨 Design & Ergonomie (Enterprise UI)

- **Material 3 Design** : Interface élégante adaptée aux standards des applications professionnelles de gestion.
- **Thème Dolibarr Enterprise** : Palette de couleurs bleu marine (`#003366`) et ardoise sombre (`#1E293B`).
- **Typographie Soignée** : Utilisation de la police Google Fonts **Inter** pour une lisibilité optimale des chiffres et des tableaux.
- **Badges de Statut Dynamiques** : Codage couleur intuitif pour chaque état de document (Vert = Validé/Payé, Ambre = Brouillon, Rouge = Impayé/Annulé, Bleu = En cours).

---

## 🏗️ Structure du Projet (Clean Architecture)

```text
lib/
├── main.dart                   # Point d'entrée principal de l'application
├── core/
│   ├── theme/
│   │   └── app_theme.dart      # Système de thème et couleurs Material 3
│   └── utils/
│       └── formatters.dart     # Formateurs de devises, dates et statuts
├── models/                     # Modèles de données (JSON Deserialization)
│   ├── dolibarr_config.dart
│   ├── dolibarr_module.dart
│   ├── third_party.dart
│   ├── product.dart
│   ├── proposal.dart
│   ├── order.dart
│   └── invoice.dart
├── services/                   # Couche Réseau & Stockage
│   ├── storage_service.dart    # Gestion de la persistance locale
│   └── dolibarr_api_service.dart # Client HTTP pour l'API REST Dolibarr
├── providers/                  # Gestion d'état (Provider Pattern)
│   ├── auth_provider.dart      # État de la connexion et configuration
│   └── dolibarr_provider.dart  # État des données et requêtes API
└── screens/                    # Interfaces utilisateur (UI Screens)
    ├── settings/               # Écran de configuration de l'API
    ├── dashboard/              # Tableau de bord principal
    ├── third_parties/          # Écran de gestion des Tiers
    ├── products/               # Écran du catalogue Produits
    ├── proposals/              # Écran des Devis
    ├── orders/                 # Écran des Commandes
    └── invoices/               # Écran des Factures
```

---

## ⚙️ Prérequis & Installation

### 1. Prérequis
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version >= 3.13.0)
- Dart SDK (Version >= 3.0.0)
- Android Studio ou VS Code avec l'extension Flutter installée.

### 2. Récupération des dépendances
Dans le dossier du projet, exécutez :
```bash
flutter pub get
```

### 3. Exécution de l'application
Pour lancer l'application sur un émulateur ou un appareil connecté :
```bash
flutter run
```

---

## 🗝️ Comment obtenir sa clé d'API Dolibarr (DOLAPIKEY) ?

1. Connectez-vous à votre interface web **Dolibarr ERP/CRM**.
2. Allez dans le menu **Configuration** ➡️ **Utilisateurs & Groupes**.
3. Sélectionnez votre utilisateur.
4. Dans l'onglet **Utilisateur**, recherchez le champ **Clé API (DOLAPIKEY)**.
5. Si le champ est vide, cliquez sur **Générer clé API**.
6. Copiez cette clé et saisissez-la dans l'écran de configuration de l'application mobile avec l'URL de votre serveur (ex: `https://votre-dolibarr.com`).

---

## 🧪 Tests & Analyse de Code

Pour exécuter l'analyseur de code statique :
```bash
flutter analyze
```

Pour exécuter les tests unitaires et d'interface :
```bash
flutter test
```

---

## 📄 Licence & Crédits

Projet développé pour l'écosystème Dolibarr ERP/CRM.
Tous droits réservés.
