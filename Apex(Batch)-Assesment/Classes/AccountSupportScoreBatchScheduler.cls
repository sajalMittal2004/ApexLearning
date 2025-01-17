public without sharing class AccountSupportScoreBatchScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        AccountSupportScoreBatch assb = new AccountSupportScoreBatch();
        Database.executeBatch(assb);

        // I will be Scheduling in Anonymous window using the following cron exp.
        // String exp = '0 0 0 * * ? *';
        // AccountSupportScoreBatchScheduler schedulerRef = new AccountSupportScoreBatchScheduler();
        // System.schedule('My Scheduled job', exp, schedulerRef);
    }
}