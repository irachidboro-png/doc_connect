import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConsentementDialog {
  static const _storage = FlutterSecureStorage();
  static const _keyConsent = 'rgpd_consent';

  static Future<bool> aDejaConsenti() async {
    final value = await _storage.read(key: _keyConsent);
    return value == 'true';
  }

  static Future<void> marquerConsenti() async {
    await _storage.write(key: _keyConsent, value: 'true');
  }

  static Future<bool> afficherSiNecessaire(BuildContext context) async {
    final dejaConsenti = await aDejaConsenti();
    if (dejaConsenti) return true;

    if (!context.mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.privacy_tip, color: Color(0xFF1B2A6B)),
            SizedBox(width: 8),
            Text('Confidentialité', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Doc Connect collecte et stocke vos données médicales '
            'localement sur votre appareil, de façon chiffrée.\n\n'
            'Ces données ne sont partagées avec aucun tiers sans '
            'votre consentement explicite.\n\n'
            'Conformément au RGPD, vous pouvez demander la '
            'suppression de vos données à tout moment depuis '
            'l\'onglet Profil.\n\n'
            'En continuant, vous acceptez ces conditions.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Refuser', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2A6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Accepter'),
          ),
        ],
      ),
    );

    if (result == true) {
      await marquerConsenti();
      return true;
    }
    return false;
  }
}