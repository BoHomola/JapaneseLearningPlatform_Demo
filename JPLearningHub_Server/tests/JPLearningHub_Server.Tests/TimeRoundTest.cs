using JPLearningHub_Server.Entities;
namespace JPLearningHub_Server.Tests
{
    public class TimeRoundTest
    {
        [Theory]
        [InlineData(0, 0, 0, 0, 0, 0)]    // Exactly on the hour
        [InlineData(0, 30, 0, 0, 0, 30)]  // Exactly on the half hour
        [InlineData(0, 14, 59, 999, 0, 0)]  // Just before quarter past
        [InlineData(0, 15, 0, 0, 0, 0)]   // Exactly quarter past
        [InlineData(0, 29, 59, 999, 0, 0)]  // Just before half past
        [InlineData(0, 30, 0, 1, 0, 30)]  // Just after half past
        [InlineData(0, 44, 59, 999, 0, 30)]  // Just before quarter to
        [InlineData(0, 45, 0, 0, 0, 30)]  // Exactly quarter to
        [InlineData(0, 59, 59, 999, 0, 30)]  // Just before next hour
        public void RoundDownShouldRoundCorrectly(int hour, int minute, int second, int millisecond, int expectedHour, int expectedMinute)
        {
            DateTime date = new(2023, 1, 1, hour, minute, second, millisecond);
            DateTime rounded = date.RoundDown();
            Assert.Equal(new DateTime(2023, 1, 1, expectedHour, expectedMinute, 0), rounded);
        }

        [Theory]
        [InlineData(0, 0, 0, 0, 0, 0)]    // Exactly on the hour
        [InlineData(0, 0, 0, 1, 0, 30)]    // Exactly on the hour
        [InlineData(0, 30, 0, 0, 0, 30)]  // Exactly on the half hour
        [InlineData(0, 14, 59, 999, 0, 30)]  // Just before quarter past
        [InlineData(0, 15, 0, 0, 0, 30)]  // Exactly quarter past
        [InlineData(0, 29, 59, 999, 0, 30)]  // Just before half past
        [InlineData(0, 30, 0, 1, 1, 0)]   // Just after half past
        [InlineData(0, 44, 59, 999, 1, 0)]  // Just before quarter to
        [InlineData(0, 45, 0, 0, 1, 0)]   // Exactly quarter to
        [InlineData(0, 59, 59, 999, 1, 0)]  // Just before next hour
        [InlineData(23, 59, 59, 999, 0, 0)]  // Just before midnight
        public void RoundUpShouldRoundCorrectly(int hour, int minute, int second, int millisecond, int expectedHour, int expectedMinute)
        {
            DateTime date = new(2023, 1, 1, hour, minute, second, millisecond);
            DateTime rounded = date.RoundUp();
            DateTime nextDayRound = new(2023, 1, 1, 23, 30, 0, 0, 0);
            if (date > nextDayRound)
            {
                Assert.Equal(new DateTime(2023, 1, 2, expectedHour, expectedMinute, 0, 0, 0, 0), rounded);
                return;
            }
            Assert.Equal(new DateTime(2023, 1, 1, expectedHour, expectedMinute, 0, 0, 0, 0), rounded);
        }

        [Fact]
        public void RoundDownShouldPreserveDateKind()
        {
            DateTime utcDate = new(2023, 1, 1, 12, 15, 30, DateTimeKind.Utc);
            DateTime roundedUtc = utcDate.RoundDown();
            Assert.Equal(DateTimeKind.Utc, roundedUtc.Kind);

            DateTime localDate = new(2023, 1, 1, 12, 15, 30, DateTimeKind.Local);
            DateTime roundedLocal = localDate.RoundDown();
            Assert.Equal(DateTimeKind.Local, roundedLocal.Kind);
        }

        [Fact]
        public void RoundUpShouldPreserveDateKind()
        {
            DateTime utcDate = new(2023, 1, 1, 12, 15, 30, DateTimeKind.Utc);
            DateTime roundedUtc = utcDate.RoundUp();
            Assert.Equal(DateTimeKind.Utc, roundedUtc.Kind);

            DateTime localDate = new(2023, 1, 1, 12, 15, 30, DateTimeKind.Local);
            DateTime roundedLocal = localDate.RoundUp();
            Assert.Equal(DateTimeKind.Local, roundedLocal.Kind);
        }

        [Fact]
        public void RoundUpShouldHandleDayChange()
        {
            DateTime date = new(2023, 1, 1, 23, 45, 0);
            DateTime rounded = date.RoundUp();
            Assert.Equal(new DateTime(2023, 1, 2, 0, 0, 0), rounded);
        }

        [Fact]
        public void RoundDownShouldHandleDayChange()
        {
            DateTime date = new(2023, 1, 2, 0, 14, 59);
            DateTime rounded = date.RoundDown();
            Assert.Equal(new DateTime(2023, 1, 2, 0, 0, 0), rounded);
        }
    }
}
