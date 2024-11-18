using JPLearningHub_Server.Entities;

namespace JPLearningHub_Server.Helpers
{
    public static class TimeBlockMerger
    {
        public static List<ITimeBlock> MergeTimeBlocks(List<ITimeBlock> events)
        {
            if (events == null || events.Count == 0)
            {
                return [];
            }

            List<ITimeBlock> sortedEvents = [.. events.OrderBy(e => e.StartDate).Where(x => x.StartDate <= x.EndDate)];
            List<ITimeBlock> mergedBlocks = [];

            TimeBlock currentBlock = new()
            {
                StartDate = sortedEvents[0].StartDate,
                EndDate = sortedEvents[0].EndDate
            };

            for (int i = 1; i < sortedEvents.Count; i++)
            {
                ITimeBlock currentEvent = sortedEvents[i];

                if (currentEvent.StartDate <= currentBlock.EndDate)
                {
                    // Events overlap, extend the current block if necessary
                    currentBlock.EndDate = Max(currentBlock.EndDate, currentEvent.EndDate);
                }
                else
                {
                    // No overlap, add the current block to the result and start a new one
                    mergedBlocks.Add(currentBlock);
                    currentBlock = new TimeBlock
                    {
                        StartDate = currentEvent.StartDate,
                        EndDate = currentEvent.EndDate
                    };
                }
            }

            mergedBlocks.Add(currentBlock);

            return mergedBlocks;
        }

        private static DateTime Max(DateTime a, DateTime b)
        {
            return a > b ? a : b;
        }
    }
}
