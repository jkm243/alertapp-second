import 'package:flutter/material.dart';
import '../../../services/supervisor_service.dart';

class AlertsReviewPage extends StatefulWidget {
  const AlertsReviewPage({super.key});

  @override
  State<AlertsReviewPage> createState() => _AlertsReviewPageState();
}

class _AlertsReviewPageState extends State<AlertsReviewPage> {
  late Future<List<AlertItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = SupervisorService.getPendingAlerts();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = SupervisorService.getPendingAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérifier les alertes'), backgroundColor: const Color(0xFFfa3333)),
      body: FutureBuilder<List<AlertItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucune alerte en attente'));
          }
          final alerts = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final a = alerts[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(a.title),
                    subtitle: Text('${a.description}\n${a.location}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'approve') {
                          final ok = await SupervisorService.approveAlert(a.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Alerte approuvée' : 'Erreur')));
                          _refresh();
                        } else if (value == 'refuse') {
                          final ok = await SupervisorService.refuseAlert(a.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Alerte refusée' : 'Erreur')));
                          _refresh();
                        } else if (value == 'drone') {
                          final ok = await SupervisorService.sendDroneMission(a.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Mission drone envoyée' : 'Échec')));
                        } else if (value == 'video') {
                          // Placeholder: In a real app you'd pick a file and upload
                          final ok = await SupervisorService.attachVideo(a.id, 'local/path/video.mp4');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Vidéo attachée' : 'Échec')));
                          _refresh();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'approve', child: Text('Approuver')),
                        const PopupMenuItem(value: 'refuse', child: Text('Refuser')),
                        const PopupMenuItem(value: 'drone', child: Text('Envoyer mission drone')),
                        const PopupMenuItem(value: 'video', child: Text('Ajouter vidéo')),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
