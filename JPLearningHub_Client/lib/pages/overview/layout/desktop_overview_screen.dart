import 'package:flutter/material.dart';
import 'package:jplearninghub/pages/overview/lesson_card.dart';
import 'package:jplearninghub/provider/lesson_state.dart';
import 'package:jplearninghub/provider/timezone_state.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DesktopOverviewScreen extends StatelessWidget {
  const DesktopOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's lessons",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        Consumer<TimezoneState>(builder: (context, lessonState, child) {
          if (!timezoneState.isLoaded) {
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()));
          }
          return Consumer<LessonState>(builder: (context, lessonState, child) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final lesson = lessonState.lessons[index];
                  final timeUntilLesson =
                      lesson.startDate.difference(DateTime.now());

                  DateTime localStartTime =
                      timezoneState.convertUtcToLocalTime(lesson.startDate);
                  final formattedDate =
                      DateFormat('EEEE, MMMM d, y').format(localStartTime);
                  final formattedTime =
                      DateFormat('h:mm a').format(localStartTime);

                  return LessonCard(
                      lesson: lesson,
                      timeUntilLesson: timeUntilLesson,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime);
                },
                childCount: lessonState.lessons.length,
              ),
            );
          });
        }),
      ],
    );
  }
}
