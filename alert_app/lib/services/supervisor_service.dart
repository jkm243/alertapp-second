class SupervisorService {
  // Mocked alerts list
  static final List<AlertItem> _alerts = [
    AlertItem(id: '1', title: 'Alerte 1', description: 'Événement suspect', location: 'Kinshasa', isPublished: false),
    AlertItem(id: '2', title: 'Alerte 2', description: 'Inondation', location: 'Gombe', isPublished: true),
  ];

  static Future<List<AlertItem>> getPendingAlerts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts.where((a) => !a.isPublished).toList();
  }

  static Future<bool> approveAlert(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _alerts[idx] = _alerts[idx].copyWith(isPublished: true);
      return true;
    }
    return false;
  }

  static Future<bool> refuseAlert(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _alerts[idx] = _alerts[idx].copyWith(isPublished: false);
      return true;
    }
    return false;
  }

  static Future<bool> sendDroneMission(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock: always succeed
    return true;
  }

  static Future<bool> attachVideo(String id, String videoPath) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _alerts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _alerts[idx] = _alerts[idx].copyWith(videoPath: videoPath);
      return true;
    }
    return false;
  }

  // Create a new alert (used by users to submit an alert)
  static Future<bool> createAlert({
    required String title,
    required String description,
    required String location,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _alerts.add(AlertItem(id: id, title: title, description: description, location: location, isPublished: false));
    return true;
  }
}

class AlertItem {
  final String id;
  final String title;
  final String description;
  final String location;
  final bool isPublished;
  final String? videoPath;

  AlertItem({required this.id, required this.title, required this.description, required this.location, required this.isPublished, this.videoPath});

  AlertItem copyWith({String? id, String? title, String? description, String? location, bool? isPublished, String? videoPath}) {
    return AlertItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isPublished: isPublished ?? this.isPublished,
      videoPath: videoPath ?? this.videoPath,
    );
  }
}
