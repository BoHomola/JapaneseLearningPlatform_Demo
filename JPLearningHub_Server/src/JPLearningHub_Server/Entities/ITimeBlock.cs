namespace JPLearningHub_Server.Entities
{
    public interface ITimeBlock
    {
        DateTime StartDate { get; set; }
        DateTime EndDate { get; set; }
    }

    public class TimeBlock : ITimeBlock
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

    }

    public static class ITimeBlockExtensions
    {
        public static ITimeBlock RoundToHalf(this ITimeBlock timeBlock)
        {
            return new TimeBlock
            {
                StartDate = RoundDown(timeBlock.StartDate),
                EndDate = RoundUp(timeBlock.EndDate)
            };
        }

        public static bool Overlaps(this ITimeBlock timeBlock, List<ITimeBlock> timeBlocks)
        {
            foreach (ITimeBlock block in timeBlocks)
            {
                if (block.StartDate < timeBlock.EndDate && timeBlock.StartDate < block.EndDate)
                {
                    return true;
                }
            }
            return false;
        }

        public static DateTime RoundDown(this DateTime date)
        {
            if ((date.Minute == 0 || date.Minute == 30) && date.Second == 0 && date.Millisecond == 0 && date.Nanosecond == 0)
            {
                return date;
            }

            return date.Minute < 30
                ? new DateTime(date.Year, date.Month, date.Day, date.Hour, 0, 0, 0, date.Kind)
                : new DateTime(date.Year, date.Month, date.Day, date.Hour, 30, 0, 0, date.Kind);
        }

        public static DateTime RoundUp(this DateTime date)
        {
            if ((date.Minute == 0 || date.Minute == 30) && date.Second == 0 && date.Millisecond == 0 && date.Nanosecond == 0)
            {
                return date;
            }

            return date.Minute < 30 || (date.Minute == 30 && date.Second == 0 && date.Millisecond == 0)
                ? new DateTime(date.Year, date.Month, date.Day, date.Hour, 30, 0, 0, date.Kind)
                : date.Date.AddHours(date.Hour + 1);
        }
    }
}
