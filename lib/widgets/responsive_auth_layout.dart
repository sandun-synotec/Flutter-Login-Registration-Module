import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/breakpoints.dart';

class ResponsiveAuthLayout extends StatelessWidget {
  final Widget child;
  final String heroTitle;
  final String heroSubtitle;

  const ResponsiveAuthLayout({
    super.key,
    required this.child,
    this.heroTitle = AppStrings.appName,
    this.heroSubtitle = AppStrings.appTagline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;

            if (maxWidth >= Breakpoints.desktopMinWidth) {
              return _buildDesktopSplitLayout(context);
            } else if (maxWidth >= Breakpoints.largeScreenMinWidth) {
              return _buildTabletCenteredLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  /// Compact layout for mobile phones (< 600px).
  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: child,
      ),
    );
  }

  /// Centered card layout for tablets / medium windows (600px - 899px).
  Widget _buildTabletCenteredLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxFormCardWidth,
          ),
          child: Card(
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Split-screen layout for desktop & wide windows (>= 900px).
  Widget _buildDesktopSplitLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxSplitLayoutWidth,
          ),
          child: Card(
            elevation: 4,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Branded Hero Panel
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(44),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            heroTitle,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            heroSubtitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 36),
                          _buildFeatureBullet(
                            Icons.shield_outlined,
                            'Enterprise Security',
                            'Password hashing, token-based sessions & input sanitization.',
                          ),
                          const SizedBox(height: 18),
                          _buildFeatureBullet(
                            Icons.devices_rounded,
                            'Fully Adaptive UI',
                            'Consistent experience on mobile, tablet, and desktop.',
                          ),
                          const SizedBox(height: 18),
                          _buildFeatureBullet(
                            Icons.flash_on_rounded,
                            'State Management with Provider',
                            'Clean separation of business logic and UI layer.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right Form Panel
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: AppColors.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: Breakpoints.maxFormCardWidth,
                          ),
                          child: child,
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
    );
  }

  Widget _buildFeatureBullet(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
