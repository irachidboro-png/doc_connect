# Doc Connect — Application Mobile de Consultation Médicale

![Flutter](https://img.shields.io/badge/Flutter-3.44.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.12.2-blue)
![FHIR](https://img.shields.io/badge/FHIR-R4-green)
![Tests](https://img.shields.io/badge/Tests-14%20passed-brightgreen)

## Présentation

**Doc Connect** est une application mobile de consultation médicale connectée,
développée avec Flutter dans le cadre du Master e-Santé & Télémédecine (UVBF 2026).
Elle permet la gestion numérique des consultations médicales avec un système
de contrôle d'accès différencié entre médecins et patients.

---

## Membres du groupe

| Nom | Prénom |
|-----|--------|
| BORO | Ismaël Rachid |
| KONATE | Daniel Beltschatsar |
| VALEA | Kouka Arnaud |
| YAMEOGO | Noaga Raymond |

---

## Fonctionnalités implémentées

### 7 fonctionnalités obligatoires
1. ✅ **Authentification** — Login par identifiant/mot de passe + biométrie (local_auth)
2. ✅ **Navigation** — 3 onglets avec NavigationBar (Patients/Dossier, Rendez-vous, Profil)
3. ✅ **Formulaire validé** — Prise de rendez-vous avec motif, date future et heure obligatoires
4. ✅ **Liste en Cards** — Patients avec codes couleur, initiales et chevron
5. ✅ **Stockage local chiffré** — Hive + AES-256, clé dans le Keystore Android (flutter_secure_storage)
6. ✅ **Appel API REST FHIR** — GET et mapping vers ressource Patient FHIR R4 (HAPI FHIR public)
7. ✅ **Consentement RGPD** — Dialog obligatoire au premier lancement, mémorisé dans le stockage sécurisé

### Fonctionnalités bonus
- 🔐 **RBAC Médecin/Patient** — Accès différencié sur toute l'interface
- 📋 **Dossier patient complet** — Historique consultations, prescriptions, RDV à venir
- 👤 **Profil détaillé** — Informations professionnelles (médecin) et personnelles (patient)
- 📡 **Mode hors ligne** — Fallback automatique sur données locales si réseau absent

---