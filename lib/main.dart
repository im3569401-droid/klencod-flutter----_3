import 'package:flutter/material.dart';

void main() {
  runApp(const QuranCenterApp());
}

class QuranCenterApp extends StatelessWidget {
  const QuranCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مركز بيت المقدس لتحفيظ القرآن',
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF1B6B50),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B6B50),
          primary: const Color(0xFF1B6B50),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const ProfessionalLoginScreen(),
    );
  }
}

// ==========================================
// 1. شاشة تسجيل الدخول الاحترافية
// ==========================================
class ProfessionalLoginScreen extends StatefulWidget {
  const ProfessionalLoginScreen({super.key});

  @override
  State<ProfessionalLoginScreen> createState() =>
      _ProfessionalLoginScreenState();
}

class _ProfessionalLoginScreenState extends State<ProfessionalLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  int _selectedRole = 0; // 0: معلم / مشرف، 1: ولي أمر

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => HomeScreen(
          userRole: _selectedRole == 0 ? 'معلم / مشرف' : 'ولي أمر',
          username: _userController.text.trim(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.auto_stories_rounded,
                            size: 44,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'مركز بيت المقدس',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'منظومة متابعة الحفظ والحضور الذكية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6F8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _buildRoleTab('معلم / مشرف', Icons.school_rounded,
                                0, primaryColor),
                            _buildRoleTab('ولي أمر',
                                Icons.family_restroom_rounded, 1, primaryColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      _buildInputField(
                        controller: _userController,
                        label: _selectedRole == 0
                            ? 'اسم المستخدم'
                            : 'رقم جوال ولي الأمر',
                        hint: _selectedRole == 0 ? 'أدخل الاسم' : '05XXXXXXXX',
                        icon: Icons.person_outline_rounded,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'يرجى تعبئة هذا الحقل'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: _passController,
                        label: 'كلمة المرور',
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? 'يرجى إدخال كلمة المرور'
                            : null,
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'دخول إلى النظام',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(
      String title, IconData icon, int index, Color primaryColor) {
    final isSelected = _selectedRole == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected ? primaryColor : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 21),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFAFAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

// ==========================================
// 2. شاشة إدارة الحسابات (المعلمين والطلاب)
// ==========================================
class HomeScreen extends StatefulWidget {
  final String userRole;
  final String username;

  const HomeScreen({super.key, required this.userRole, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List> _users = [
    {'name': 'أحمد محمد', 'type': 'معلم', 'phone': '0599112233'},
    {'name': 'يوسف إبراهيم', 'type': 'طالب', 'phone': '0598445566'},
    {'name': 'عمر عبد الله', 'type': 'طالب', 'phone': '0597778899'},
  ];

  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedType = 'طالب';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('إضافة حساب جديد',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'رقم الجوال (للتواصل / واتساب)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: InputDecoration(
                        labelText: 'نوع الحساب',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'طالب', child: Text('طالب')),
                        DropdownMenuItem(value: 'معلم', child: Text('معلم')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedType = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6B50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isNotEmpty) {
                      setState(() {
                        _users.add({
                          'name': nameController.text.trim(),
                          'type': selectedType,
                          'phone': phoneController.text.trim().isEmpty
                              ? 'غير مسجل'
                              : phoneController.text.trim(),
                        });
                      });
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('حفظ الحساب'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteUser(int index) {
    setState(() {
      _users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('إدارة حسابات المركز',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'تسجيل الخروج',
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfessionalLoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة ترحيبية بالمستخدم الحالي
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أهلاً بك، ${widget.username}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'الصلاحية الحالية: ${widget.userRole}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // زر إضافة حساب جديد
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _showAddUserDialog,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text(
                  'إنشاء حساب طالب أو معلم جديد',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الحسابات المسجلة في النظام:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'العدد: ${_users.length}',
                  style: TextStyle(
                      fontSize: 13,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // قائمة الحسابات
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  final isTeacher = user['type'] == 'معلم';

                  return Card(
                    elevation: 0,
                    color: const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isTeacher
                            ? Colors.amber.shade100
                            : primaryColor.withValues(alpha: 0.12),
                        child: Icon(
                          isTeacher ? Icons.school_rounded : Icons.person,
                          color: isTeacher ? Colors.amber.shade800 : primaryColor,
                        ),
                      ),
                      title: Text(
                        user['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${user['type']} • الجوال: ${user['phone']}',
                        style: TextStyle(
                            fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent),
                        onPressed: () => _deleteUser(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}