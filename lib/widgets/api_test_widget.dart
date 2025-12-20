import 'package:flutter/material.dart';
import '../services/api_test.dart';

class ApiTestWidget extends StatelessWidget {
  const ApiTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tests API',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFfa3333),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Testez la connexion à l\'API et les endpoints d\'authentification.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => ApiTestService.testLogin(),
                  icon: const Icon(Icons.wifi, size: 18),
                  label: const Text('Test Connexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFfa3333),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => ApiTestService.runAllTests(),
                  icon: const Icon(Icons.bug_report, size: 18),
                  label: const Text('Test Complet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFfa3333),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
