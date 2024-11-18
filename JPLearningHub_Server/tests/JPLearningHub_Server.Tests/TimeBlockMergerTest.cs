using JPLearningHub_Server.Entities;
using JPLearningHub_Server.Helpers;

namespace JPLearningHub_Server.Tests
{
    public class TimeBlockMergerTest
    {
        [Fact]
        public void MergeTimeBlocks_EmptyList_ReturnsEmptyList()
        {
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks([]);
            Assert.Empty(result);
        }

        [Fact]
        public void MergeTimeBlocks_SingleBlock_ReturnsSingleBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(blocks[0].StartDate, result[0].StartDate);
            Assert.Equal(blocks[0].EndDate, result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_NonOverlappingBlocks_ReturnsUnchangedList()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 3), EndDate = new DateTime(2023, 1, 4) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Equal(2, result.Count);
            Assert.Equal(blocks[0].StartDate, result[0].StartDate);
            Assert.Equal(blocks[0].EndDate, result[0].EndDate);
            Assert.Equal(blocks[1].StartDate, result[1].StartDate);
            Assert.Equal(blocks[1].EndDate, result[1].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_OverlappingBlocks_ReturnsMergedBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 3) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2), EndDate = new DateTime(2023, 1, 4) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 4), result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_AdjacentBlocks_ReturnsMergedBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2), EndDate = new DateTime(2023, 1, 3) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 3), result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_ComplexOverlappingBlocks_ReturnsMergedBlocks()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 3) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2), EndDate = new DateTime(2023, 1, 4) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 5), EndDate = new DateTime(2023, 1, 7) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 6), EndDate = new DateTime(2023, 1, 8) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 10), EndDate = new DateTime(2023, 1, 11) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Equal(3, result.Count);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 4), result[0].EndDate);
            Assert.Equal(new DateTime(2023, 1, 5), result[1].StartDate);
            Assert.Equal(new DateTime(2023, 1, 8), result[1].EndDate);
            Assert.Equal(new DateTime(2023, 1, 10), result[2].StartDate);
            Assert.Equal(new DateTime(2023, 1, 11), result[2].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_UnsortedInput_ReturnsSortedMergedBlocks()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 5), EndDate = new DateTime(2023, 1, 7) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 3) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2), EndDate = new DateTime(2023, 1, 4) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Equal(2, result.Count);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 4), result[0].EndDate);
            Assert.Equal(new DateTime(2023, 1, 5), result[1].StartDate);
            Assert.Equal(new DateTime(2023, 1, 7), result[1].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_FullyContainedBlock_ReturnsSingleMergedBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 10) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 3), EndDate = new DateTime(2023, 1, 5) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 10), result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_IdenticalBlocks_ReturnsSingleBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 2), result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_OverlapByMicrosecond_ReturnsSingleBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2,15,15,15,999) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2,15,15,15,998), EndDate = new DateTime(2023, 1, 3) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Single(result);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 3), result[0].EndDate);
        }

        [Fact]
        public void MergeTimeBlocks_MissedByMicrosecond_ReturnsSingleBlock()
        {
            List<ITimeBlock> blocks =
        [
            new TimeBlock { StartDate = new DateTime(2023, 1, 1), EndDate = new DateTime(2023, 1, 2,15,15,15,998) },
            new TimeBlock { StartDate = new DateTime(2023, 1, 2,15,15,15,999), EndDate = new DateTime(2023, 1, 3) }
        ];
            List<ITimeBlock> result = TimeBlockMerger.MergeTimeBlocks(blocks);
            Assert.Equal(2, result.Count);
            Assert.Equal(new DateTime(2023, 1, 1), result[0].StartDate);
            Assert.Equal(new DateTime(2023, 1, 2,15,15,15,998), result[0].EndDate);
            Assert.Equal(new DateTime(2023, 1, 2,15,15,15,999), result[1].StartDate);
            Assert.Equal(new DateTime(2023, 1, 3), result[1].EndDate);
        }
    }
}
