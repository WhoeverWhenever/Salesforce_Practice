public with sharing class CloseOldPositionsScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
        CloseOldPositionsBatchable closeOldPositionBatch = new CloseOldPositionsBatchable();
        Database.executeBatch(closeOldPositionBatch, 2000);
    }
}
