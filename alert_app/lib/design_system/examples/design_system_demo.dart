import 'package:flutter/material.dart';
import '../design_system.dart';

/// Page de démonstration complète du design system
class DesignSystemDemo extends StatefulWidget {
  const DesignSystemDemo({super.key});

  @override
  State<DesignSystemDemo> createState() => _DesignSystemDemoState();
}

class _DesignSystemDemoState extends State<DesignSystemDemo> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design System Demo',
      theme: _isDarkMode ? AppTheme.dark : AppTheme.light,
      home: Scaffold(
        appBar: AppTopNavigation(
          title: 'Design System Demo',
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: AppBottomNavigation(
          items: const [
            AppBottomNavItem(
              icon: Icons.palette,
              label: 'Couleurs',
            ),
            AppBottomNavItem(
              icon: Icons.text_fields,
              label: 'Typographie',
            ),
            AppBottomNavItem(
              icon: Icons.widgets,
              label: 'Composants',
            ),
            AppBottomNavItem(
              icon: Icons.dashboard,
              label: 'Layout',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildColorsDemo();
      case 1:
        return _buildTypographyDemo();
      case 2:
        return _buildComponentsDemo();
      case 3:
        return _buildLayoutDemo();
      default:
        return _buildColorsDemo();
    }
  }

  Widget _buildColorsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Palette de Couleurs',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Couleurs primaires
          _buildColorSection(
            title: 'Couleurs Primaires',
            colors: [
              ('50', AppColors.primary50),
              ('100', AppColors.primary100),
              ('200', AppColors.primary200),
              ('300', AppColors.primary300),
              ('400', AppColors.primary400),
              ('500', AppColors.primary500),
              ('600', AppColors.primary600),
              ('700', AppColors.primary700),
              ('800', AppColors.primary800),
              ('900', AppColors.primary900),
              ('950', AppColors.primary950),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Couleurs d'état
          _buildColorSection(
            title: 'Couleurs d\'État',
            colors: [
              ('Success', AppColors.success),
              ('Warning', AppColors.warning),
              ('Info', AppColors.info),
              ('Destructive', AppColors.destructive),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypographyDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiérarchie Typographique',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          _buildTypographyExample('H1', AppTypography.h1),
          _buildTypographyExample('H2', AppTypography.h2),
          _buildTypographyExample('H3', AppTypography.h3),
          _buildTypographyExample('H4', AppTypography.h4),
          _buildTypographyExample('H5', AppTypography.h5),
          _buildTypographyExample('H6', AppTypography.h6),
          _buildTypographyExample('Body Large', AppTypography.bodyLarge),
          _buildTypographyExample('Body', AppTypography.body),
          _buildTypographyExample('Body Small', AppTypography.bodySmall),
          _buildTypographyExample('Caption', AppTypography.caption),
          _buildTypographyExample('Button', AppTypography.button),
        ],
      ),
    );
  }

  Widget _buildComponentsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Composants UI',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Boutons
          _buildSection(
            title: 'Boutons',
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                AppButton(
                  text: 'Primary',
                  variant: AppButtonVariant.primary,
                ),
                AppButton(
                  text: 'Secondary',
                  variant: AppButtonVariant.secondary,
                ),
                AppButton(
                  text: 'Outline',
                  variant: AppButtonVariant.outline,
                ),
                AppButton(
                  text: 'Ghost',
                  variant: AppButtonVariant.ghost,
                ),
                AppButton(
                  text: 'Destructive',
                  variant: AppButtonVariant.destructive,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Cartes
          _buildSection(
            title: 'Cartes',
            child: Row(
              children: [
                Expanded(
                  child: AppCard(
                    title: 'Carte par défaut',
                    child: Text(
                      'Contenu de la carte',
                      style: AppTypography.body,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    variant: AppCardVariant.outlined,
                    title: 'Carte avec contour',
                    child: Text(
                      'Contenu de la carte',
                      style: AppTypography.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Inputs
          _buildSection(
            title: 'Champs de Saisie',
            child: Column(
              children: [
                const AppInput(
                  label: 'Nom',
                  hint: 'Entrez votre nom',
                ),
                const SizedBox(height: AppSpacing.md),
                const AppInput(
                  label: 'Email',
                  hint: 'Entrez votre email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSpacing.md),
                const AppPasswordInput(
                  label: 'Mot de passe',
                  hint: 'Entrez votre mot de passe',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Badges
          _buildSection(
            title: 'Badges',
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                const AppBadge(
                  text: 'Par défaut',
                  variant: AppBadgeVariant.default_,
                ),
                const AppBadge(
                  text: 'Succès',
                  variant: AppBadgeVariant.success,
                ),
                const AppBadge(
                  text: 'Avertissement',
                  variant: AppBadgeVariant.warning,
                ),
                const AppBadge(
                  text: 'Erreur',
                  variant: AppBadgeVariant.destructive,
                ),
                const AppStatusBadge(status: AppStatus.active),
                const AppStatusBadge(status: AppStatus.pending),
                const AppNotificationBadge(count: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layout et Navigation',
            style: AppTypography.h4,
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Conteneurs
          _buildSection(
            title: 'Conteneurs',
            child: Column(
              children: [
                AppContainer(
                  size: AppContainerSize.small,
                  child: Text(
                    'Conteneur Petit',
                    style: AppTypography.body,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppContainer(
                  size: AppContainerSize.medium,
                  child: Text(
                    'Conteneur Moyen',
                    style: AppTypography.body,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppContainer(
                  size: AppContainerSize.large,
                  child: Text(
                    'Conteneur Grand',
                    style: AppTypography.body,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Grille
          _buildSection(
            title: 'Grille Responsive',
            child: AppGrid(
              children: List.generate(6, (index) {
                return AppCard(
                  child: Text(
                    'Élément ${index + 1}',
                    style: AppTypography.body,
                  ),
                );
              }),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Sections
          _buildSection(
            title: 'Sections',
            child: AppSection(
              title: 'Section d\'exemple',
              subtitle: 'Description de la section',
              child: Text(
                'Contenu de la section',
                style: AppTypography.body,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection({
    required String title,
    required List<(String, Color)> colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: colors.map((colorData) {
            return Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: colorData.$2,
                borderRadius: AppBorderRadius.mdRadius,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    colorData.$1,
                    style: AppTypography.caption.copyWith(
                      color: _getContrastColor(colorData.$2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '#${colorData.$2.value.toRadixString(16).substring(2).toUpperCase()}',
                    style: AppTypography.caption.copyWith(
                      color: _getContrastColor(colorData.$2),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTypographyExample(String name, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: AppTypography.caption.muted,
          ),
          Text(
            'The quick brown fox jumps over the lazy dog',
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5,
        ),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }

  Color _getContrastColor(Color color) {
    // Calcul simple pour déterminer si utiliser du blanc ou du noir
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
