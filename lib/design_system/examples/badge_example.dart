import 'package:flutter/material.dart';
import '../components/badges.dart';
import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';

/// Exemple pratique avec composant Badge complet
class BadgeExample extends StatelessWidget {
  const BadgeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemple de Badges'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badges de base
            _buildSection(
              title: 'Badges de Base',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppBadge(
                      text: 'Par défaut',
                      variant: AppBadgeVariant.default_,
                    ),
                    const AppBadge(
                      text: 'Secondaire',
                      variant: AppBadgeVariant.secondary,
                    ),
                    const AppBadge(
                      text: 'Contour',
                      variant: AppBadgeVariant.outline,
                    ),
                    const AppBadge(
                      text: 'Destructif',
                      variant: AppBadgeVariant.destructive,
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
                      text: 'Information',
                      variant: AppBadgeVariant.info,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Tailles de badges
            _buildSection(
              title: 'Tailles de Badges',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppBadge(
                      text: 'Petit',
                      variant: AppBadgeVariant.default_,
                      size: AppBadgeSize.small,
                    ),
                    const AppBadge(
                      text: 'Moyen',
                      variant: AppBadgeVariant.default_,
                      size: AppBadgeSize.medium,
                    ),
                    const AppBadge(
                      text: 'Grand',
                      variant: AppBadgeVariant.default_,
                      size: AppBadgeSize.large,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Badges avec icônes
            _buildSection(
              title: 'Badges avec Icônes',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppBadge(
                      text: 'Avec icône',
                      variant: AppBadgeVariant.default_,
                      icon: Icons.star,
                    ),
                    const AppBadge(
                      text: 'Succès',
                      variant: AppBadgeVariant.success,
                      icon: Icons.check,
                    ),
                    const AppBadge(
                      text: 'Erreur',
                      variant: AppBadgeVariant.destructive,
                      icon: Icons.error,
                    ),
                    const AppBadge(
                      text: 'Info',
                      variant: AppBadgeVariant.info,
                      icon: Icons.info,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Badges supprimables
            _buildSection(
              title: 'Badges Supprimables',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppBadge(
                      text: 'Supprimable',
                      variant: AppBadgeVariant.default_,
                      isDismissible: true,
                    ),
                    const AppBadge(
                      text: 'Avec icône',
                      variant: AppBadgeVariant.success,
                      icon: Icons.tag,
                      isDismissible: true,
                    ),
                    const AppBadge(
                      text: 'Personnalisé',
                      variant: AppBadgeVariant.warning,
                      color: Color(0xFF8B5CF6),
                      textColor: Colors.white,
                      isDismissible: true,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Badges de statut
            _buildSection(
              title: 'Badges de Statut',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppStatusBadge(status: AppStatus.active),
                    const AppStatusBadge(status: AppStatus.inactive),
                    const AppStatusBadge(status: AppStatus.pending),
                    const AppStatusBadge(status: AppStatus.error),
                    const AppStatusBadge(status: AppStatus.completed),
                    const AppStatusBadge(status: AppStatus.cancelled),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Badges de notification
            _buildSection(
              title: 'Badges de Notification',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppNotificationBadge(count: 1),
                    const AppNotificationBadge(count: 5),
                    const AppNotificationBadge(count: 12),
                    const AppNotificationBadge(count: 99),
                    const AppNotificationBadge(count: 150, maxCount: 99),
                    const AppNotificationBadge(
                      count: 1000,
                      color: AppColors.success,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Badges de priorité
            _buildSection(
              title: 'Badges de Priorité',
              children: [
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    const AppPriorityBadge(priority: AppPriority.low),
                    const AppPriorityBadge(priority: AppPriority.medium),
                    const AppPriorityBadge(priority: AppPriority.high),
                    const AppPriorityBadge(priority: AppPriority.critical),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Exemple d'utilisation dans une liste
            _buildSection(
              title: 'Utilisation dans une Liste',
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: AppBorderRadius.lgRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildListItem(
                        title: 'Tâche importante',
                        subtitle: 'Description de la tâche',
                        status: AppStatus.pending,
                        priority: AppPriority.high,
                        notifications: 3,
                      ),
                      const Divider(),
                      _buildListItem(
                        title: 'Tâche terminée',
                        subtitle: 'Description de la tâche',
                        status: AppStatus.completed,
                        priority: AppPriority.medium,
                        notifications: 0,
                      ),
                      const Divider(),
                      _buildListItem(
                        title: 'Tâche en erreur',
                        subtitle: 'Description de la tâche',
                        status: AppStatus.error,
                        priority: AppPriority.critical,
                        notifications: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Exemple d'utilisation dans des cartes
            _buildSection(
              title: 'Utilisation dans des Cartes',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        title: 'Projet Alpha',
                        description: 'Développement en cours',
                        status: AppStatus.active,
                        progress: 75,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildCard(
                        title: 'Projet Beta',
                        description: 'En attente de validation',
                        status: AppStatus.pending,
                        progress: 45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.h5.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required AppStatus status,
    required AppPriority priority,
    required int notifications,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.muted,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          if (notifications > 0)
            AppNotificationBadge(count: notifications),
          const SizedBox(width: AppSpacing.sm),
          AppStatusBadge(status: status),
          const SizedBox(width: AppSpacing.sm),
          AppPriorityBadge(priority: priority),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required AppStatus status,
    required int progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppBorderRadius.lgRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.h6,
                ),
              ),
              AppStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTypography.bodySmall.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              status == AppStatus.active ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$progress% terminé',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}

