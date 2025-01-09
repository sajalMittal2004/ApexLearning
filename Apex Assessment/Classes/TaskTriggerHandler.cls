public without sharing class TaskTriggerHandler {
    public static void handleTask(List<Task> newTasks, Map<Id, Task> oldTaskMap) {
        Set<Id> accIds = new Set<Id>();
        for(Task tsk: newTasks!=null? newTasks :oldTaskMap.values()) {
            
            if(tsk.whatId != null){
                accIds.add(tsk.whatId);
            }
            if(oldTaskMap != null && (oldTaskMap.get(tsk.Id).WhatId != tsk.WhatId)) {
                accIds.add(oldTaskMap.get(tsk.Id).whatId);
            }
        }

        if(!accIds.isEmpty()) {
            List<Account> accList = [SELECT Id, Total_Activities__c, Total_Closed_Activities__c, Total_Open_Activities__c
                                    FROM Account
                                    WHERE Id IN: accIds];

            List<AggregateResult> totalTasks = [SELECT WhatId, COUNT(Id) totalActivities FROM Task Where WhatId IN: accIds GROUP BY WhatId];
            List<AggregateResult> totalClosedtasks = [SELECT WhatId, COUNT(Id) TotalClosedActivities FROM Task Where Status__c = 'Closed' AND WhatId IN: accIds GROUP BY WhatId];
            List<AggregateResult> totalOpenTasks = [SELECT WhatId, COUNT(Id) TotalOpenActivities FROM Task Where Status__c = 'Open' AND WhatId IN: accIds GROUP BY WhatId];

            Map<Id, Integer> mapOfAccountAndCountOfActivities = new Map<Id, Integer>();
            Map<Id, Integer> mapOfAccountAndCountOfClosedActivities = new Map<Id, Integer>();
            Map<Id, Integer> mapOfAccountAndCountOfOpenActivities = new Map<Id, Integer>();

            for(AggregateResult agr: totalTasks) {
                mapOfAccountAndCountOfActivities.put((Id)agr.get('WhatId'), (Integer)agr.get('totalActivities'));
            }
            for(AggregateResult agr: totalClosedtasks) {
                mapOfAccountAndCountOfClosedActivities.put((Id)agr.get('WhatId'), (Integer)agr.get('TotalClosedActivities'));
            }
            for(AggregateResult agr: totalOpenTasks) {
                mapOfAccountAndCountOfOpenActivities.put((Id)agr.get('WhatId'), (Integer)agr.get('TotalOpenActivities'));
            }

            for(Account acc: accList) {
                acc.Total_Activities__c = mapOfAccountAndCountOfActivities.get(acc.Id)!= null ? mapOfAccountAndCountOfActivities.get(acc.Id) : 0;
                acc.Total_Closed_Activities__c = mapOfAccountAndCountOfClosedActivities.get(acc.Id)!= null ? mapOfAccountAndCountOfClosedActivities.get(acc.Id) : 0;
                acc.Total_Open_Activities__c = mapOfAccountAndCountOfOpenActivities.get(acc.Id) != null ? mapOfAccountAndCountOfOpenActivities.get(acc.Id) : 0;
            }

            if(!accList.isEmpty()) {
                update accList;
            }
        }
    }
}