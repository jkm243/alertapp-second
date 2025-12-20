import 'package:flutter/material.dart';
import '../design_system/colors.dart' as design_colors;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Restez informé avec des alertes en temps réel',
      description:
          'Recevez des notifications instantanées sur les incidents dans votre région, vous aidant à rester en sécurité et conscient de votre environnement.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB6ufUtD9ctj7u6ERWkad8AyL-QPD_tZqRYq1aRFuYZiD3hp-51gaEriZJ9_nATgXJHrZKD9IHbvAy1Go-KJpc3qFQjKtOaCwmdyV9P2IBjQiGLO1oZwyRNNuFkvWwK_SMgWOTm4q6K1hkXi2FFtCvaIE3aM8laJDjzGSuC5_-fKfOts-c2Nyz-yU8VHl1spp4EY6kukanARTf0ZOwzbqC4H97A2WNt75aNXpMTUgDD1iq2MeGNogli_jB7yJu0hs5NopDfJsPgXZSh',
    ),
    OnboardingPage(
      title: 'Signalez les incidents facilement',
      description:
          'Contribuez à la sécurité de votre communauté en signalant les incidents en quelques clics. Partager l\'information aide tous les résidents.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB6ufUtD9ctj7u6ERWkad8AyL-QPD_tZqRYq1aRFuYZiD3hp-51gaEriZJ9_nATgXJHrZKD9IHbvAy1Go-KJpc3qFQjKtOaCwmdyV9P2IBjQiGLO1oZwyRNNuFkvWwK_SMgWOTm4q6K1hkXi2FFtCvaIE3aM8laJDjzGSuC5_-fKfOts-c2Nyz-yU8VHl1spp4EY6kukanARTf0ZOwzbqC4H97A2WNt75aNXpMTUgDD1iq2MeGNogli_jB7yJu0hs5NopDfJsPgXZSh',
    ),
    OnboardingPage(
      title: 'Protégez votre communauté',
      description:
          'Ensemble, nous créons une communauté plus sûre. Vos alertes peuvent aider à prévenir les crimes et à protéger les autres résidents.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB6ufUtD9ctj7u6ERWkad8AyL-QPD_tZqRYq1aRFuYZiD3hp-51gaEriZJ9_nATgXJHrZKD9IHbvAy1Go-KJpc3qFQjKtOaCwmdyV9P2IBjQiGLO1oZwyRNNuFkvWwK_SMgWOTm4q6K1hkXi2FFtCvaIE3aM8laJDjzGSuC5_-fKfOts-c2Nyz-yU8VHl1spp4EY6kukanARTf0ZOwzbqC4H97A2WNt75aNXpMTUgDD1iq2MeGNogli_jB7yJu0hs5NopDfJsPgXZSh',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: design_colors.AppColors.background,
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Skip Button (top right)
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _skipOnboarding(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.close,
                  color: Colors.grey[700],
                  size: 28,
                ),
              ),
            ),
          ),

          // Dots Indicator and Navigation Buttons (bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Progress dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? design_colors.AppColors.primary
                              : design_colors.AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation buttons
                  if (_currentPage < _pages.length - 1)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: design_colors.AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Suivant',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _completeOnboarding(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: design_colors.AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Commencer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  page.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Text content
          Column(
            children: [
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF230F0F),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _completeOnboarding() {
    // TODO: Save onboarding completion to shared preferences
    Navigator.of(context).pushReplacementNamed('/home');
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imageUrl;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
