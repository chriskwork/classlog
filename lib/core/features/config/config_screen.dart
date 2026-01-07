import 'package:classlog/core/features/auth/screens/login_screen.dart';
import 'package:classlog/core/features/config/config_edit_profile.dart';
import 'package:classlog/core/features/config/config_security.dart';
import 'package:classlog/core/providers/auth_provider.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Padding(
      padding: const EdgeInsets.all(Gaps.lg),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),

          // Profile image
          Center(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 56,
                    // backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
              ),

              // Edit icon
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(height: 20),
          Text(
            user?.fullName ?? 'Usuario',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          // Config options
          Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: lineColor, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            child: Column(
              children: [
                // Perfil
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.person_outline_rounded),
                  title: Text(
                    "Editar Perfil",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfigEditProfile(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, color: lineColor),

                // Seguridad
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.lock_outline_rounded),
                  title: Text(
                    "Seguridad",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfigSecurity(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Log out button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: lineColor),
                  foregroundColor: textPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: Gaps.lg),
          // Eliminate account
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FilledButton(
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Eliminar Cuenta'),
                    content: Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  final success = await ref.read(authProvider.notifier).deleteAccount();
                  if (success && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar cuenta'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                "Eliminar Cuenta",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
