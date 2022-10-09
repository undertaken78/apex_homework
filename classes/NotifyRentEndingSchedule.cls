public class NotifyRentEndingSchedule implements Schedulable{

    public static String JOB_NAME = 'NotifyClientRentEnd';

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new NotifyRentEndingBatch(), 20);
        String cron = '0 0 6 ' + Date.today() + ' * *';
        System.schedule(JOB_NAME + Date.today(), cron, new NotifyRentEndingSchedule());
    }
}
