public without sharing class EventTriggerHandler {
    public static void handleEvent(List<Event> newEvents, Map<Id, Event> oldEventMap) {
        Set<Id> accIds = new Set<Id>();
        for(Event evt: newEvents!=null? newEvents :oldEventMap.values()) {
            
            if(evt.whatId != null){
                accIds.add(evt.whatId);
            }
            if(oldEventMap != null && (oldEventMap.get(evt.Id).WhatId != evt.WhatId)) {
                accIds.add(oldEventMap.get(evt.Id).whatId);
            }
        }

        if(!accIds.isEmpty()) {
            List<Account> accList = [SELECT Id, Total_Activities__c, Total_Closed_Activities__c, Total_Open_Activities__c
                                    FROM Account
                                    WHERE Id IN: accIds];

            List<AggregateResult> totalEvents = [SELECT WhatId, COUNT(Id) totalEvents FROM Event Where WhatId IN: accIds GROUP BY WhatId];
            List<AggregateResult> totalClosedEvents = [SELECT WhatId, COUNT(Id) TotalClosedEvents FROM Event Where Status__c = 'Closed' AND WhatId IN: accIds GROUP BY WhatId];
            List<AggregateResult> totalOpenEvents = [SELECT WhatId, COUNT(Id) TotalOpenEvents FROM Event Where Status__c = 'Open' AND WhatId IN: accIds GROUP BY WhatId];

            Map<Id, Integer> mapOfAccountAndCountOfEvents = new Map<Id, Integer>();
            Map<Id, Integer> mapOfAccountAndCountOfClosedEvents = new Map<Id, Integer>();
            Map<Id, Integer> mapOfAccountAndCountOfOpenEvents = new Map<Id, Integer>();

            for(AggregateResult agr: totalEvents) {
                mapOfAccountAndCountOfEvents.put((Id)agr.get('WhatId'), (Integer)agr.get('totalEvents'));
            }
            for(AggregateResult agr: totalClosedEvents) {
                mapOfAccountAndCountOfClosedEvents.put((Id)agr.get('WhatId'), (Integer)agr.get('TotalClosedEvents'));
            }
            for(AggregateResult agr: totalOpenEvents) {
                mapOfAccountAndCountOfOpenEvents.put((Id)agr.get('WhatId'), (Integer)agr.get('TotalOpenEvents'));
            }

            for(Account acc: accList) {
                acc.Total_Activities__c = mapOfAccountAndCountOfEvents.get(acc.Id)!= null ? mapOfAccountAndCountOfEvents.get(acc.Id) : 0;
                acc.Total_Closed_Activities__c = mapOfAccountAndCountOfClosedEvents.get(acc.Id)!= null ? mapOfAccountAndCountOfClosedEvents.get(acc.Id) : 0;
                acc.Total_Open_Activities__c = mapOfAccountAndCountOfOpenEvents.get(acc.Id) != null ? mapOfAccountAndCountOfOpenEvents.get(acc.Id) : 0;
            }   

            if(!accList.isEmpty()) {
                update accList;
            }
        }
    }
}