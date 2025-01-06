// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'cv/ai_description.dart';
import 'cv/cv-editor-screens.dart';
import 'cv/education_form.dart';
import 'cv/experience.dart';
import 'cv/skills.dart';
import 'firebase_options.dart';
import 'homescreen.dart';
import 'models/models.dart';

import 'services/ai_services.dart';
import 'services/auth_services.dart';
import 'services/storage.dart';
import 'widgets/section_cards.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   initServices();
   
  runApp(MyApp());
}

void initServices() {
  // Make sure the StorageService is properly instantiated
  Get.put<StorageService>(StorageService());
  Get.put<AuthService>(AuthService());
  Get.put<AIService>(AIService());
  
  // You can also use lazyPut if you prefer
  // Get.lazyPut<StorageService>(() => StorageService());
}


class MyApp extends StatelessWidget {
  final authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CV Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/register', page: () => RegisterScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/cv/editor', page: () => CVEditorScreen()),
        GetPage(name: '/cv/education', page: () => EducationForm()),
        GetPage(name: '/cv/experience', page: () => ExperienceForm()),
        GetPage(name: '/cv/skills', page: () => SkillsForm()),
        GetPage(name: '/cv/ai-description', page: () => AIDescriptionScreen()),
      ],
    );
  }
}

// splash_screen.dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = Get.find();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 2));
    final user = await _authService.getCurrentUser();
    Get.offAllNamed(user != null ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 24),
            Text(
              'CV Builder',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

