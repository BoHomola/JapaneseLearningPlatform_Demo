import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jplearninghub/models/lesson_model.dart';
import 'package:shimmer/shimmer.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.timeUntilLesson,
    required this.formattedDate,
    required this.formattedTime,
  });

  final LessonModel lesson;
  final Duration timeUntilLesson;
  final String formattedDate;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      cacheKey: lesson.teacher.avatarKey,
                      imageUrl: lesson.teacher.avatarUrl,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${lesson.teacher.firstName} ${lesson.teacher.lastName}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Lesson in ${timeUntilLesson.inHours} hours ${timeUntilLesson.inMinutes.remainder(60)} minutes',
                        style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '$formattedDate at $formattedTime',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Message: ${lesson.lessonMessage}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Text(
                'Students: ${lesson.students.map((s) => '${s.firstName} ${s.lastName}').join(', ')}',
                style: TextStyle(color: Colors.grey[800], fontSize: 14),
              ),
              const SizedBox(width: 5),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    cacheKey: lesson.students.first.avatarKey,
                    imageUrl: lesson.students.first.avatarUrl,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
