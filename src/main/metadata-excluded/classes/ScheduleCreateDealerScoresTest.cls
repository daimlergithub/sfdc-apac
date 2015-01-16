@isTest
private class ScheduleCreateDealerScoresTest {
    public static testMethod void testCreateSchdule() {
        Test.startTest();
        ScheduleCreateDealerScores schClass = new ScheduleCreateDealerScores();
        String cron = '0 0 0 1 12 ? 2020';
        String jobName = 'ScheduleCreateDealerScoresTest';
        System.schedule(jobName, cron, schClass);
        Test.stopTest();
    }
}