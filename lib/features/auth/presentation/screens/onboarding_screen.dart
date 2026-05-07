import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../widgets/splitz_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.group_rounded,
      title: 'Create Groups',
      subtitle: 'Add your roommates, trip buddies, or anyone you split expenses with.',
      gradient: SplitzColors.splitzGradient,
    ),
    _OnboardingPage(
      icon: Icons.receipt_long_rounded,
      title: 'Track Expenses',
      subtitle: 'Log expenses on the fly. We handle the math — fair splits, every time.',
      gradient: SplitzColors.successGradient,
    ),
    _OnboardingPage(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Settle Up',
      subtitle: 'See who owes who and settle debts with minimized transactions.',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB800), Color(0xFFFF8C42)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_onboarded', true);
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? SplitzColors.darkBgGradient
              : const LinearGradient(
                  colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SplitzLogo(size: 28),
                    if (_currentPage < _pages.length - 1)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: isDark
                                ? SplitzColors.darkTextTertiary
                                : SplitzColors.lightTextTertiary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: page.gradient,
                              boxShadow: [
                                BoxShadow(
                                  color: SplitzColors.accentPrimary.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              page.icon,
                              size: 48,
                              color: Colors.white,
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                                duration: 500.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fadeIn(duration: 400.ms),
                          SplitzSpacing.vGapHuge,
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ClashDisplay',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? SplitzColors.darkText
                                  : SplitzColors.lightText,
                              letterSpacing: -0.5,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                          SplitzSpacing.vGapLg,
                          Text(
                            page.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? SplitzColors.darkTextSecondary
                                  : SplitzColors.lightTextSecondary,
                              height: 1.5,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 350.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: index == _currentPage
                                ? SplitzColors.splitzGradient
                                : null,
                            color: index == _currentPage
                                ? null
                                : (isDark
                                    ? SplitzColors.darkBorder
                                    : SplitzColors.lightBorder),
                          ),
                        ),
                      ),
                    ),
                    SplitzSpacing.vGapXxl,
                    SplitzButton(
                      label: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      isFullWidth: true,
                    ),
                    SplitzSpacing.vGapLg,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
