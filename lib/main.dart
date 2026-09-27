import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ---------------- SHARED COLORS ----------------
const Color kPrimary = Color(0xFF0D9488); // teal
const Color kPrimaryDark = Color(0xFF0F766E);
const Color kPrimaryLight = Color(0xFFCCFBF1); // pale teal for badges/chips
const Color kBackground = Color(0xFFF7F7FB); // soft off-white
const Color kTextDark = Color(0xFF111827);
const Color kTextMuted = Color(0xFF6B7280);
const Color kLogoutRed = Color(0xFFDC2626);
const Color kLogoutBg = Color(0xFFFEE2E2);
const Color kError = Color(0xFFDC2626);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Sign-Up Home App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// ---------------- SHARED WIDGETS ----------------

// App logo row used at the top of every screen: swap the icon/text here
// to rebrand the whole app in one place.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [kPrimary, kPrimaryDark],
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.auto_awesome, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 8),
        const Text(
          'ALPHA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kTextDark,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

// A labeled input field with a soft shadow "card" look, validation
// error text, and an optional show/hide toggle for passwords.
class AuthField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kTextDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscure : false,
            validator: widget.validator,
            style: const TextStyle(fontSize: 14, color: kTextDark),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: kTextMuted, fontSize: 14),
              prefixIcon: Icon(widget.icon, size: 19, color: kTextMuted),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 19,
                        color: kTextMuted,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kPrimary, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kError, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kError, width: 1.6),
              ),
              errorStyle: const TextStyle(fontSize: 12, color: kError),
            ),
          ),
        ),
      ],
    );
  }
}

// Pill-shaped primary button shared by Login and Sign Up.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: kPrimary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Icon(icon, size: 17),
          ],
        ),
      ),
    );
  }
}

// ---------------- LOGIN SCREEN ----------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _submitted = false; // errors only appear after the first button tap

  void _handleLogin() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      // pushReplacementNamed: removes Login from the stack after logging in
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments:
            emailController.text.isEmpty ? 'User' : emailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const SizedBox(height: 28),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      color: kTextDark),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your credentials to access your account.',
                  style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.4),
                ),
                const SizedBox(height: 26),
                AuthField(
                  label: 'Email or Username',
                  hint: 'Enter your email or username',
                  icon: Icons.mail_outline,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email or username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthField(
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feature not implemented')),
                      );
                    },
                    child: const Text('Forgot password?',
                        style: TextStyle(color: kPrimary, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Log In',
                  icon: Icons.arrow_forward,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // pushNamed: keeps Login on the stack so we can pop back to it
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: kTextMuted, fontSize: 13),
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                                color: kPrimary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- SIGN-UP SCREEN ----------------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _submitted = false;

  final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void _handleSignUp() {
    setState(() => _submitted = true);
    if (_formKey.currentState!.validate()) {
      // pushReplacementNamed: takes the user straight to Home after signing up
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments:
            nameController.text.isEmpty ? 'New User' : nameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppLogo(),
                const SizedBox(height: 28),
                const Text(
                  'Create account',
                  style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                      color: kTextDark),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Fill in your details to get started.',
                  style: TextStyle(fontSize: 13, color: kTextMuted, height: 1.4),
                ),
                const SizedBox(height: 26),
                AuthField(
                  label: 'Full Name',
                  hint: 'Sarah Connor',
                  icon: Icons.person_outline,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthField(
                  label: 'Email Address',
                  hint: 'sarah@example.com',
                  icon: Icons.mail_outline,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!_emailPattern.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthField(
                  label: 'Password',
                  hint: 'Create password',
                  icon: Icons.lock_outline,
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthField(
                  label: 'Confirm Password',
                  hint: 'Repeat password',
                  icon: Icons.lock_outline,
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: 'Sign Up',
                  icon: Icons.check,
                  onPressed: _handleSignUp,
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // pop: goes back to the Login screen that is still on the stack
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: kTextMuted, fontSize: 13),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                                color: kPrimary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME SCREEN (PORTFOLIO STYLE) ----------------

// A small pill-shaped chip used for the Skills section.
class SkillChip extends StatelessWidget {
  final String label;
  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: kPrimaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 12.5, color: kPrimaryDark, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// A small project card used in the Projects grid.
class ProjectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ProjectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: kPrimaryLight,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: kPrimaryDark),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: kTextDark)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 11.5, color: kTextMuted, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String name =
        ModalRoute.of(context)!.settings.arguments as String? ?? 'User';
    final String initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: logo + avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: kPrimaryLight,
                    child: Text(
                      initial,
                      style: const TextStyle(
                          color: kPrimaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Welcome banner (this is where the name from Login/Sign-Up shows)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kPrimary, Color(0xFF0891B2)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $name!',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "You're logged in and everything is synced.",
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bio card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile App Developer',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextDark),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'I build clean, user-friendly mobile apps with Flutter — '
                      'this project showcases a simple login and sign-up flow.',
                      style:
                          TextStyle(fontSize: 12.5, color: kTextMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Skills section
              const Text('Skills',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SkillChip(label: 'Flutter'),
                  SkillChip(label: 'Dart'),
                  SkillChip(label: 'UI/UX Design'),
                  SkillChip(label: 'Firebase'),
                  SkillChip(label: 'Git'),
                ],
              ),
              const SizedBox(height: 22),

              // Projects section
              const Text('Projects',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 10),
              const Row(
                children: [
                  ProjectCard(
                    icon: Icons.layers_outlined,
                    title: 'Auth Flow App',
                    subtitle: 'Login, Sign-Up, and Home with named routes.',
                  ),
                  SizedBox(width: 12),
                  ProjectCard(
                    icon: Icons.widgets_outlined,
                    title: 'UI Components',
                    subtitle: 'Reusable fields, buttons, and cards.',
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Logout
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // pushReplacementNamed: clears Home from the stack when logging out
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  icon: const Icon(Icons.logout, size: 18, color: kLogoutRed),
                  label: const Text('Log Out',
                      style: TextStyle(
                          color: kLogoutRed, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: kLogoutBg,
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}