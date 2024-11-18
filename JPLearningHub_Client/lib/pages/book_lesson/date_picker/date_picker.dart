import 'package:flutter/material.dart';
import 'package:jplearninghub/pages/book_lesson/provider/lesson_booking_provider.dart';
import 'package:provider/provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonBookingProvider>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            _buildMonthNavigator(context),
            const SizedBox(height: 30),
            _buildWeekdayHeader(),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16),
              itemCount: 42, // 6 weeks * 7 days
              itemBuilder: (context, index) {
                if (index < provider.startingWeekday() - 1 ||
                    index >=
                        provider.daysInMonth() +
                            provider.startingWeekday() -
                            1) {
                  return Container();
                }
                final day = index - provider.startingWeekday() + 2;
                bool isDayActive = false;
                Color dayColor = Colors.grey[200]!;
                if (provider.getDayType(day) == DayType.today) {
                  dayColor = Colors.blue[100]!;
                  isDayActive = true;
                }
                if (provider.getDayType(day) == DayType.available) {
                  dayColor = Colors.green[100]!;
                  isDayActive = true;
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: dayColor.withOpacity(0.5),
                  onTap: isDayActive
                      ? () {
                          provider.selectDay(day);
                        }
                      : null,
                  child: Ink(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: dayColor),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$day',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays
            .map((day) => Text(day,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
            .toList(),
      ),
    );
  }

  Widget _buildMonthNavigator(BuildContext context) {
    final provider = Provider.of<LessonBookingProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: provider.canGoPreviousMonth()
              ? () {
                  provider.previousMonth();
                }
              : null,
        ),
        Text(provider.getDatePretty(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: provider.canGoNextMonth()
              ? () {
                  provider.nextMonth();
                }
              : null,
        ),
      ],
    );
  }
}
