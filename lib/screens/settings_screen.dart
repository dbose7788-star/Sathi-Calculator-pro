import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07131D),
        elevation: 0,
        title: const Text('SETTINGS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            'Calculator',
            [
              _item(
                Icons.calculate_outlined,
                'Calculator preferences',
                'Standard calculator options',
              ),
              _item(
                Icons.science_outlined,
                'Scientific mode preferences',
                'Scientific calculator options',
              ),
            ],
          ),
          const SizedBox(height: 18),
          _section(
            'Interface',
            [
              _item(
                Icons.palette_outlined,
                'Theme / interface',
                'Sathi visual preferences',
              ),
            ],
          ),
          const SizedBox(height: 18),
          _section(
            'About',
            [
              _item(
                Icons.info_outline,
                'App information',
                'Sathi Calculator',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      color: const Color(0xFF0B1822),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF00E5FF),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
