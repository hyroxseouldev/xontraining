import 'package:flutter/material.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

class ProgramListItem extends StatelessWidget {
  const ProgramListItem({required this.program, super.key});

  final ProgramEntity program;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(url: program.thumbnailUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if ((program.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      program.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if ((program.difficulty ?? '').isNotEmpty)
                        Chip(label: Text(program.difficulty!)),
                      if (program.daysPerWeek != null)
                        Chip(label: Text('${program.daysPerWeek}d/week')),
                      if (program.dailyWorkoutMinutes != null)
                        Chip(label: Text('${program.dailyWorkoutMinutes}min')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final value = url?.trim() ?? '';
    if (value.isEmpty) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.image_not_supported_outlined),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        value,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 64,
            height: 64,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
