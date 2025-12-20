import 'package:flutter/material.dart';
import '../design_system.dart';

/// Exemple d'utilisation du design system
class UsageExample extends StatelessWidget {
  const UsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopNavigation(
        title: 'Exemple d\'Utilisation',
        actions: [
          AppIconButton(
            icon: Icons.settings,
            onPressed: () {},
            variant: AppButtonVariant.ghost,
          ),
        ],
      ),
      body: AppContainer(
        size: AppContainerSize.medium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section titre
            Text(
              'Bienvenue dans le Design System',
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Un système de design complet pour Flutter avec tous les composants nécessaires.',
              style: AppTypography.body.muted,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Section boutons
            _buildSection(
              title: 'Boutons',
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  AppButton(
                    text: 'Primary',
                    variant: AppButtonVariant.primary,
                    onPressed: () {},
                  ),
                  AppButton(
                    text: 'Secondary',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  AppButton(
                    text: 'Outline',
                    variant: AppButtonVariant.outline,
                    onPressed: () {},
                  ),
                  AppButton(
                    text: 'Ghost',
                    variant: AppButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  AppButton(
                    text: 'Destructive',
                    variant: AppButtonVariant.destructive,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Section cartes
            _buildSection(
              title: 'Cartes',
              child: AppGrid(
                children: [
                  AppCard(
                    title: 'Carte par défaut',
                    child: Text(
                      'Contenu de la carte avec du texte descriptif.',
                      style: AppTypography.body,
                    ),
                  ),
                  AppCard(
                    variant: AppCardVariant.outlined,
                    title: 'Carte avec contour',
                    child: Text(
                      'Contenu de la carte avec contour.',
                      style: AppTypography.body,
                    ),
                  ),
                  AppCard(
                    variant: AppCardVariant.elevated,
                    title: 'Carte élevée',
                    child: Text(
                      'Contenu de la carte avec élévation.',
                      style: AppTypography.body,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Section inputs
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
            
            // Section badges
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
                    icon: Icons.check,
                  ),
                  const AppBadge(
                    text: 'Avertissement',
                    variant: AppBadgeVariant.warning,
                    icon: Icons.warning,
                  ),
                  const AppBadge(
                    text: 'Erreur',
                    variant: AppBadgeVariant.destructive,
                    icon: Icons.error,
                  ),
                  const AppStatusBadge(status: AppStatus.active),
                  const AppStatusBadge(status: AppStatus.pending),
                  const AppNotificationBadge(count: 5),
                  const AppPriorityBadge(priority: AppPriority.high),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Section statistiques
            _buildSection(
              title: 'Statistiques',
              child: AppGrid(
                children: [
                  AppStatCard(
                    title: 'Utilisateurs',
                    value: '1,234',
                    subtitle: '+12% ce mois',
                    icon: Icons.people,
                    iconColor: AppColors.success,
                  ),
                  AppStatCard(
                    title: 'Ventes',
                    value: '€45,678',
                    subtitle: '+8% ce mois',
                    icon: Icons.euro,
                    iconColor: AppColors.primary,
                  ),
                  AppStatCard(
                    title: 'Commandes',
                    value: '89',
                    subtitle: '+23% ce mois',
                    icon: Icons.shopping_cart,
                    iconColor: AppColors.info,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Section alertes
            _buildSection(
              title: 'Alertes',
              child: Column(
                children: [
                  AppAlertCard(
                    title: 'Succès',
                    message: 'L\'opération s\'est déroulée avec succès.',
                    type: AppAlertType.success,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppAlertCard(
                    title: 'Avertissement',
                    message: 'Attention, cette action est irréversible.',
                    type: AppAlertType.warning,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppAlertCard(
                    title: 'Erreur',
                    message: 'Une erreur s\'est produite lors de l\'opération.',
                    type: AppAlertType.error,
                  ),
                ],
              ),
            ),
          ],
        ),
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
}



