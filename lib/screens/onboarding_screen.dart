import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 3;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Suivez tous vos journaux',
      'description': 'Surveillez et analysez tous vos journaux d\'application en un seul endroit avec des capacités puissantes de filtrage et de recherche.',
      'icon': Icons.analytics_outlined,
    },
    {
      'title': 'Alertes en temps réel',
      'description': 'Recevez des notifications instantanées pour les erreurs critiques et les avertissements afin de résoudre les problèmes avant qu\'ils n\'affectent vos utilisateurs.',
      'icon': Icons.notifications_active_outlined,
    },
    {
      'title': 'Analyses détaillées',
      'description': 'Plongez dans les détails des journaux avec des métadonnées complètes, des traces d\'erreur et des informations contextuelles.',
      'icon': Icons.insights_outlined,
    },
  ];

  void _nextPage() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent, 

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    'Passer',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _numPages,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _pages[index]['icon'],
                          size: 120,
                          color: Theme.of(context).colorScheme.primary,
                        )
                        .animate()
                        .scale(duration: 400.ms)
                        .fadeIn(),
                        
                        const SizedBox(height: 40),
                        
                        Text(
                          _pages[index]['title'],
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .moveY(begin: 20, end: 0, delay: 200.ms, duration: 300.ms),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          _pages[index]['description'],
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .moveY(begin: 20, end: 0, delay: 400.ms, duration: 300.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _numPages,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Next/Start button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentPage == _numPages - 1 ? 'Commencer' : 'Suivant',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
