// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend/screen/home/home_screen.dart';
import 'history/history_screen.dart'; // Ganti dengan path file Anda
import 'profile/profile_screen.dart'; // Ganti dengan path file Anda

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk menyimpan indeks tab yang sedang aktif
  int _selectedIndex = 0;

  // Daftar semua halaman/widget yang akan ditampilkan sesuai tab
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // Indeks 0
    HistoryScreen(), // Indeks 1
    ProfileScreen(), // Indeks 2
  ];

  // Fungsi yang akan dipanggil saat salah satu tab di-tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update state untuk mengubah halaman
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman sesuai dengan _selectedIndex
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Di sinilah kita mendefinisikan BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Memberi tahu tab mana yang sedang aktif
        selectedItemColor: Colors.blue, // Warna tab yang aktif
        onTap: _onItemTapped, // Menghubungkan aksi tap dengan fungsi kita
      ),
    );
  }
}
