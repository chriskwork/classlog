import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
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
            // TODO: user name from DB
            "Yohan Kim",
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
                  leading: Icon(Icons.abc),
                  title: Text(
                    "Editar Perfil",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),

                const Divider(height: 1, color: lineColor),

                // Seguridad
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.abc),
                  title: Text(
                    "Seguridad",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                )
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Log out button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: lineColor),
                  foregroundColor: textPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text("Cerrar Sesión"),
            ),
          ),
        ],
      ),
    );
  }
}
