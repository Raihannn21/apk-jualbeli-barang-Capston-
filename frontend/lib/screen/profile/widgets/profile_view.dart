import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/screen/address/address_screen.dart';
import 'package:frontend/screen/history/history_screen.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../providers/theme_provider.dart';

class ProfileView extends StatelessWidget {
  final User user;
  final bool isLoggingOut;
  final VoidCallback onLogout;

  const ProfileView({
    super.key,
    required this.user,
    required this.isLoggingOut,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Kumpulan widget menu kita, untuk dianimasikan
    final List<Widget> menuItems = [
      // KARTU STREAK
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.local_fire_department_rounded,
                  color: Colors.orange.shade700, size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.loginStreak} Hari',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900)),
                  const Text('Login Streak Anda!',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),

      // JUDUL SECTION AKUN SAYA
      const Text("Akun Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 8),
      _buildProfileMenuItem(context,
          icon: Icons.receipt_long_outlined,
          title: 'Riwayat Pesanan',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()))),
      _buildProfileMenuItem(context,
          icon: Icons.location_on_outlined,
          title: 'Daftar Alamat',
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddressScreen()))),

      const SizedBox(height: 24),
      const Text("Pengaturan Aplikasi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 8),

      // TOMBOL SWITCH TEMA
      Card(
        child: SwitchListTile(
          title: const Text('Mode Vibrant/Gelap'),
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme(value);
          },
          secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Theme.of(context).primaryColor),
        ),
      ),
      const Divider(indent: 16, endIndent: 16, height: 32),

      // TOMBOL LOGOUT
      _buildProfileMenuItem(context,
          icon: Icons.logout,
          title: 'Logout',
          textColor: Theme.of(context).colorScheme.error,
          onTap: isLoggingOut ? null : onLogout),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // BAGIAN HEADER PROFIL
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Text(user.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
        ),

        // BAGIAN MENU DENGAN ANIMASI
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: menuItems,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget untuk membuat setiap baris menu
  Widget _buildProfileMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      VoidCallback? onTap,
      Color? textColor}) {
    final color = textColor ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 16)),
        trailing: textColor == null
            ? Icon(Icons.chevron_right,
                size: 20, color: Theme.of(context).hintColor)
            : null,
        onTap: onTap,
      ),
    );
  }
}
