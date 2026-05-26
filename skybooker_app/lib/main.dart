import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 🎯 API Ayarları ve Global Hafıza
const String apiPort = '5005'; 
const String apiBaseUrl = 'http://10.0.2.2:$apiPort/api';

// 👑 SÜPER ADMİN E-POSTASI
const String superAdminEmail = 'eren@test.com'; 

String? authToken; 
int? loggedInUserId;
String? loggedInFirstName;
String? loggedInLastName;
String? loggedInEmail;
String? loggedInPassword;
bool isAdmin = false; 

// 🎨 PREMIUM RENK PALETİ
const Color primaryDark = Color(0xFF0F2027);
const Color primaryBlue = Color(0xFF203A43);
const Color primaryLight = Color(0xFF2C5364);
const Color accentGold = Color(0xFFF9A826);
const Color bgColor = Color(0xFFF4F7F6);

void main() {
  runApp(const SkyBookerApp());
}

class SkyBookerApp extends StatelessWidget {
  const SkyBookerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyBooker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------------------------------------------------
// GİRİŞ YAP (LOGIN) EKRANI (MODERNİZE EDİLDİ)
// ---------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('$apiBaseUrl/Users/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim()
        }),
      );

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData is Map) {
            authToken = responseData['token'] ?? responseData['tokenString'] ?? responseData['tokenText'];
          } else { authToken = response.body; }
        } catch (e) { authToken = response.body; }

        try {
          final usersRes = await http.get(Uri.parse('$apiBaseUrl/Users'), headers: {"Authorization": "Bearer $authToken"});
          if (usersRes.statusCode == 200) {
            List users = jsonDecode(usersRes.body);
            final me = users.firstWhere((u) => u['email'] == _emailController.text.trim(), orElse: () => null);
            if (me != null) {
              loggedInUserId = me['id']; loggedInFirstName = me['firstName'];
              loggedInLastName = me['lastName']; loggedInEmail = me['email'];
              loggedInPassword = me['passwordHash']; isAdmin = (loggedInEmail == superAdminEmail);
            }
          }
        } catch (e) {}

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isAdmin ? 'Süper Admin Girişi Başarılı!' : 'Hoş Geldiniz, $loggedInFirstName!'), backgroundColor: Colors.green));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hatalı e-posta veya şifre!'), backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bağlantı Hatası: $e'), backgroundColor: Colors.redAccent));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryDark, primaryLight], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.airlines, size: 90, color: accentGold),
                  const SizedBox(height: 10),
                  const Text('SKYBOOKER', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const Text('Dünyayı Keşfetmeye Hazır Mısın?', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))]),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'E-posta', prefixIcon: const Icon(Icons.email_outlined, color: primaryBlue), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Şifre', prefixIcon: const Icon(Icons.lock_outline, color: primaryBlue), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity, height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 5),
                            onPressed: _isLoading ? null : _loginUser,
                            child: _isLoading ? const CircularProgressIndicator(color: accentGold) : const Text('GİRİŞ YAP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                          child: const Text('Hesabın yok mu? Hemen Kayıt Ol', style: TextStyle(color: primaryLight, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// KAYIT OL (REGISTER) EKRANI (MODERNİZE EDİLDİ)
// ---------------------------------------------------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _registerUser() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/Users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": 0, "firstName": _firstNameController.text.trim(), "lastName": _lastNameController.text.trim(),
          "email": _emailController.text.trim(), "passwordHash": _passwordController.text.trim()
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aramıza Hoş Geldin! Lütfen giriş yap.'), backgroundColor: Colors.green));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
    } catch (e) { } finally { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryDark, primaryLight], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Icon(Icons.person_add_alt_1, size: 70, color: accentGold),
                  const SizedBox(height: 10),
                  const Text('YENİ YOLCU', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))]),
                    child: Column(
                      children: [
                        _buildStyledTextField(_firstNameController, 'Ad', Icons.person_outline),
                        const SizedBox(height: 12),
                        _buildStyledTextField(_lastNameController, 'Soyad', Icons.badge_outlined),
                        const SizedBox(height: 12),
                        _buildStyledTextField(_emailController, 'E-posta', Icons.email_outlined),
                        const SizedBox(height: 12),
                        _buildStyledTextField(_passwordController, 'Şifre', Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity, height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 5),
                            onPressed: _isLoading ? null : _registerUser,
                            child: _isLoading ? const CircularProgressIndicator(color: accentGold) : const Text('KAYIT OL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                          child: const Text('Zaten biletin var mı? Giriş Yap', style: TextStyle(color: primaryLight, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller, obscureText: isPassword,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: primaryBlue), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }
}

// ---------------------------------------------------------
// ANA SAYFA (DİNAMİK BOTTOM NAVIGATION BAR)
// ---------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens {
    if (isAdmin) return [const SearchFlightTab(), const MyReservationsTab(), const AdminPanelTab(), const ProfileTab()];
    return [const SearchFlightTab(), const MyReservationsTab(), const ProfileTab()];
  }

  List<BottomNavigationBarItem> get _navItems {
    if (isAdmin) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Keşfet'),
        BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: 'Biletlerim'),
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Yönetim'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: 'Keşfet'),
      BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket), label: 'Biletlerim'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: accentGold,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: _navItems,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 1. UÇUŞ ARA VE FİLTRELEME SEKMESİ (MODERNİZE EDİLDİ)
// ---------------------------------------------------------
class SearchFlightTab extends StatefulWidget {
  const SearchFlightTab({super.key});
  @override
  State<SearchFlightTab> createState() => _SearchFlightTabState();
}
class _SearchFlightTabState extends State<SearchFlightTab> {
  List<dynamic> _allFlights = [];      
  List<dynamic> _filteredFlights = []; 
  bool _isLoading = false;

  final TextEditingController _departureFilterCtrl = TextEditingController();
  final TextEditingController _arrivalFilterCtrl = TextEditingController();

  @override void initState() { 
    super.initState(); 
    _fetchFlights(); 
    _departureFilterCtrl.addListener(_applyFilters);
    _arrivalFilterCtrl.addListener(_applyFilters);
  }

  @override void dispose() { _departureFilterCtrl.dispose(); _arrivalFilterCtrl.dispose(); super.dispose(); }

  Future<void> _fetchFlights() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/Flights'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200) {
        setState(() { _allFlights = jsonDecode(response.body); _applyFilters(); });
      }
    } catch (e) { } finally { setState(() => _isLoading = false); }
  }

  void _applyFilters() {
    final depText = _departureFilterCtrl.text.trim().toLowerCase();
    final arrText = _arrivalFilterCtrl.text.trim().toLowerCase();
    setState(() {
      _filteredFlights = _allFlights.where((flight) {
        return flight['departure'].toString().toLowerCase().contains(depText) && flight['arrival'].toString().toLowerCase().contains(arrText);
      }).toList();
    });
  }

  void _showBookingDialog(Map flight) {
    final TextEditingController pNameCtrl = TextEditingController(text: "$loggedInFirstName $loggedInLastName");
    final TextEditingController seatCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Uçuşu Onayla', style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(flight['departure'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Icon(Icons.flight_takeoff, color: accentGold),
                  Text(flight['arrival'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: pNameCtrl, decoration: InputDecoration(labelText: 'Yolcu Adı', prefixIcon: const Icon(Icons.person), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 12),
            TextField(controller: seatCtrl, decoration: InputDecoration(labelText: 'Koltuk No (Örn: 14A)', prefixIcon: const Icon(Icons.chair_alt), filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal', style: TextStyle(color: Colors.redAccent))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async { Navigator.pop(context); _bookFlight(flight['id'], pNameCtrl.text, seatCtrl.text); },
            child: const Text('Bileti Kes', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<void> _bookFlight(int flightId, String passengerName, String seatNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/Reservations'),
        headers: { "Content-Type": "application/json", if (authToken != null) "Authorization": "Bearer $authToken" },
        body: jsonEncode({ "id": 0, "userId": loggedInUserId ?? 0, "flightId": flightId, "passengerName": passengerName, "seatNumber": seatNumber, "reservationDate": DateTime.now().toIso8601String(), "status": "Onaylandı" }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✈️ Bilet Başarıyla Kesildi!'), backgroundColor: Colors.green));
      }
    } catch (e) { }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🎨 MODERN HEADER BÖLÜMÜ
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [primaryDark, primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Merhaba, ${loggedInFirstName ?? 'Yolcu'}!', style: const TextStyle(color: Colors.white70, fontSize: 18)),
                const SizedBox(height: 8),
                const Text('Yeni Bir Macera\nBaşlıyor.', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2)),
                const SizedBox(height: 24),
                // ARAMA KUTULARI
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _departureFilterCtrl, decoration: const InputDecoration(hintText: 'Nereden (Örn: Antalya)', icon: Icon(Icons.flight_takeoff, color: primaryBlue), border: InputBorder.none))),
                      Container(width: 1, height: 30, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 8)),
                      Expanded(child: TextField(controller: _arrivalFilterCtrl, decoration: const InputDecoration(hintText: 'Nereye (Örn: Roma)', icon: Icon(Icons.flight_land, color: accentGold), border: InputBorder.none))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // UÇUŞ LİSTESİ ALANI
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: primaryBlue)) 
              : _filteredFlights.isEmpty
                ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.search_off, size: 60, color: Colors.grey), SizedBox(height: 12), Text('Kriterlere uygun uçuş bulunamadı.', style: TextStyle(color: Colors.grey, fontSize: 16))]))
                : RefreshIndicator(
                    onRefresh: _fetchFlights,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16), 
                      itemCount: _filteredFlights.length,
                      itemBuilder: (context, index) {
                        final f = _filteredFlights[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 5))]),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(f['departure'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDark)), const Text('Kalkış', style: TextStyle(color: Colors.grey, fontSize: 12))]),
                                    const Icon(Icons.flight_takeoff, color: accentGold, size: 30),
                                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(f['arrival'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDark)), const Text('Varış', style: TextStyle(color: Colors.grey, fontSize: 12))]),
                                  ],
                                ),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Row(children: [Expanded(child: Container(height: 1, color: Colors.grey.shade300)), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)), child: Text(f['flightCode'], style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12))), Expanded(child: Container(height: 1, color: Colors.grey.shade300))])),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${f['price']} ₺', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.green)),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)), 
                                      onPressed: () => _showBookingDialog(f), 
                                      child: const Text('Bilet Al', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. REZERVASYONLARIM SEKMESİ (MODERNİZE EDİLDİ)
// ---------------------------------------------------------
class MyReservationsTab extends StatefulWidget {
  const MyReservationsTab({super.key});
  @override
  State<MyReservationsTab> createState() => _MyReservationsTabState();
}
class _MyReservationsTabState extends State<MyReservationsTab> {
  List<dynamic> _reservations = [];
  bool _isLoading = false;

  @override void initState() { super.initState(); _fetchReservations(); }

  Future<void> _fetchReservations() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/Reservations'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200) setState(() => _reservations = jsonDecode(response.body));
    } catch (e) { } finally { setState(() => _isLoading = false); }
  }

  Future<void> _cancelReservation(int reservationId) async {
    bool confirm = await showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Bileti İptal Et'), content: const Text('Emin misiniz?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Vazgeç')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('İptal Et', style: TextStyle(color: Colors.red)))])) ?? false;
    if (!confirm) return;
    try {
      final response = await http.delete(Uri.parse('$apiBaseUrl/Reservations/$reservationId'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bilet İptal Edildi!'), backgroundColor: Colors.orange));
        _fetchReservations();
      }
    } catch (e) { }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biletlerim', style: TextStyle(fontWeight: FontWeight.bold))),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryBlue)) : RefreshIndicator(
        onRefresh: _fetchReservations,
        child: ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _reservations.length,
          itemBuilder: (context, index) {
            final res = _reservations[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: const Icon(Icons.airplane_ticket, color: Colors.green, size: 30)),
                title: Text('${res['passengerName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryDark)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(children: [const Icon(Icons.chair, size: 16, color: Colors.grey), const SizedBox(width: 4), Text('Koltuk: ${res['seatNumber']}', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)), const SizedBox(width: 12), const Icon(Icons.check_circle, size: 16, color: Colors.green), const SizedBox(width: 4), Text('${res['status']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600))]),
                ),
                trailing: IconButton(icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 28), onPressed: () => _cancelReservation(res['id'])),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. YÖNETİM PANELİ (ADMİN SEKMESİ)
// ---------------------------------------------------------
class AdminPanelTab extends StatefulWidget {
  const AdminPanelTab({super.key});
  @override
  State<AdminPanelTab> createState() => _AdminPanelTabState();
}
class _AdminPanelTabState extends State<AdminPanelTab> {
  List<dynamic> _flights = [];
  bool _isLoading = false;

  @override void initState() { super.initState(); _fetchFlights(); }

  Future<void> _fetchFlights() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/Flights'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200) setState(() => _flights = jsonDecode(response.body));
    } catch (e) { } finally { setState(() => _isLoading = false); }
  }

  Future<void> _deleteFlight(int id) async {
    bool confirm = await showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Uçuşu Sil'), content: const Text('Emin misiniz?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil', style: TextStyle(color: Colors.red)))])) ?? false;
    if (!confirm) return;
    try {
      final response = await http.delete(Uri.parse('$apiBaseUrl/Flights/$id'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200 || response.statusCode == 204) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uçuş Silindi!'), backgroundColor: Colors.orange)); _fetchFlights(); }
    } catch (e) { }
  }

  void _showFlightDialog({Map? flight}) {
    final codeCtrl = TextEditingController(text: flight != null ? flight['flightCode'] : '');
    final depCtrl = TextEditingController(text: flight != null ? flight['departure'] : '');
    final arrCtrl = TextEditingController(text: flight != null ? flight['arrival'] : '');
    final priceCtrl = TextEditingController(text: flight != null ? flight['price'].toString() : '');
    final isEditing = flight != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isEditing ? 'Uçuşu Güncelle' : 'Yeni Uçuş Ekle', style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: InputDecoration(labelText: 'Kodu', filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), const SizedBox(height: 10),
              TextField(controller: depCtrl, decoration: InputDecoration(labelText: 'Kalkış', filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), const SizedBox(height: 10),
              TextField(controller: arrCtrl, decoration: InputDecoration(labelText: 'Varış', filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))), const SizedBox(height: 10),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Fiyat', filled: true, fillColor: Colors.grey.shade100, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal', style: TextStyle(color: Colors.red))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              Navigator.pop(context);
              final payload = { "id": isEditing ? flight['id'] : 0, "flightCode": codeCtrl.text.trim(), "departure": depCtrl.text.trim(), "arrival": arrCtrl.text.trim(), "price": double.tryParse(priceCtrl.text.trim()) ?? 0.0, "departureTime": isEditing ? flight['departureTime'] : DateTime.now().add(const Duration(days: 3)).toIso8601String() };
              final url = Uri.parse(isEditing ? '$apiBaseUrl/Flights/${flight['id']}' : '$apiBaseUrl/Flights');
              final req = isEditing ? http.put : http.post;
              try {
                final res = await req(url, headers: { "Content-Type": "application/json", if (authToken != null) "Authorization": "Bearer $authToken" }, body: jsonEncode(payload));
                if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Uçuş Güncellendi!' : 'Uçuş Eklendi!'), backgroundColor: Colors.green)); _fetchFlights(); }
              } catch (e) { }
            },
            child: Text(isEditing ? 'Güncelle' : 'Kaydet', style: const TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yönetim Paneli', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: primaryDark),
      floatingActionButton: FloatingActionButton.extended(backgroundColor: accentGold, onPressed: () => _showFlightDialog(), icon: const Icon(Icons.add, color: primaryDark), label: const Text('Uçuş Ekle', style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold))),
      body: _isLoading ? const Center(child: CircularProgressIndicator(color: primaryBlue)) : RefreshIndicator(
        onRefresh: _fetchFlights,
        child: ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _flights.length,
          itemBuilder: (context, index) {
            final f = _flights[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: ListTile(
                title: Text('${f['flightCode']} | ${f['departure']} ➔ ${f['arrival']}', style: const TextStyle(fontWeight: FontWeight.bold, color: primaryDark)),
                subtitle: Text('Fiyat: ${f['price']} ₺', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit_square, color: primaryBlue), onPressed: () => _showFlightDialog(flight: f)), 
                    IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => _deleteFlight(f['id'])),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. PROFİL SEKMESİ (MODERNİZE EDİLDİ)
// ---------------------------------------------------------
class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}
class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override void initState() {
    super.initState();
    _firstNameController.text = loggedInFirstName ?? ''; _lastNameController.text = loggedInLastName ?? '';
    _emailController.text = loggedInEmail ?? ''; _passwordController.text = loggedInPassword ?? '';
  }

  Future<void> _updateProfile() async {
    if (loggedInUserId == null) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.put(Uri.parse('$apiBaseUrl/Users/$loggedInUserId'), headers: { "Content-Type": "application/json", if (authToken != null) "Authorization": "Bearer $authToken" }, body: jsonEncode({ "id": loggedInUserId, "firstName": _firstNameController.text.trim(), "lastName": _lastNameController.text.trim(), "email": _emailController.text.trim(), "passwordHash": _passwordController.text.trim() }));
      if (response.statusCode == 200 || response.statusCode == 204) {
        loggedInFirstName = _firstNameController.text.trim(); loggedInLastName = _lastNameController.text.trim();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil Güncellendi!'), backgroundColor: Colors.green));
      }
    } catch (e) { } finally { setState(() => _isLoading = false); }
  }

  void _logout() {
    authToken = null; loggedInUserId = null; loggedInFirstName = null; loggedInLastName = null; loggedInEmail = null; loggedInPassword = null; isAdmin = false;
    if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Çıkış yapıldı.'), backgroundColor: Colors.blue)); Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())); }
  }

  Future<void> _deleteAccount() async {
    if (loggedInUserId == null) return;
    bool confirm = await showDialog(context: context, builder: (context) => AlertDialog(title: const Text('Hesabı Sil'), content: const Text('Emin misiniz?'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')), TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil', style: TextStyle(color: Colors.red)))])) ?? false;
    if (!confirm) return;
    try {
      final response = await http.delete(Uri.parse('$apiBaseUrl/Users/$loggedInUserId'), headers: { if (authToken != null) "Authorization": "Bearer $authToken" });
      if (response.statusCode == 200 || response.statusCode == 204) { authToken = null; loggedInUserId = null; isAdmin = false; if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())); }
    } catch (e) { }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilim', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: accentGold),
              child: const CircleAvatar(radius: 50, backgroundColor: primaryDark, child: Icon(Icons.person, size: 60, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
              child: Column(
                children: [
                  _buildStyledTextField(_firstNameController, 'Ad', Icons.person_outline), const SizedBox(height: 12),
                  _buildStyledTextField(_lastNameController, 'Soyad', Icons.badge_outlined), const SizedBox(height: 12),
                  _buildStyledTextField(_emailController, 'E-posta', Icons.email_outlined), const SizedBox(height: 12),
                  _buildStyledTextField(_passwordController, 'Şifre', Icons.lock_outline, isPassword: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: primaryBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _isLoading ? null : _updateProfile, icon: const Icon(Icons.save), label: const Text('BİLGİLERİMİ GÜNCELLE', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 55, child: OutlinedButton.icon(style: OutlinedButton.styleFrom(foregroundColor: primaryDark, side: const BorderSide(color: primaryDark, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _logout, icon: const Icon(Icons.logout), label: const Text('ÇIKIŞ YAP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)))),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, height: 50, child: TextButton.icon(style: TextButton.styleFrom(foregroundColor: Colors.redAccent), onPressed: _deleteAccount, icon: const Icon(Icons.delete_forever), label: const Text('Hesabımı Kalıcı Olarak Sil', style: TextStyle(fontWeight: FontWeight.bold))))
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller, obscureText: isPassword,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: primaryBlue), filled: true, fillColor: Colors.grey.shade50, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
    );
  }
}