import 'package:flutter/material.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

class BlueprintSectionCard extends StatelessWidget {
  const BlueprintSectionCard({required this.section, super.key});

  final BlueprintSectionEntity section;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(section.title),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(section.content),
            ),
          ),
        ],
      ),
    );
  }
}
