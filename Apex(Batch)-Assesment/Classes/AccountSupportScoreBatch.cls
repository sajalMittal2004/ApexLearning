public without sharing class AccountSupportScoreBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Priority, Status, AccountId, CreatedDate FROM Case WHERE Status != \'Closed\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        Map<Id, List<Case>> accountIdsAndCasesMap = new Map<Id, List<Case>>();
        if(!scope.isEmpty()) {
            for(Case cs: scope) {

                if(cs.AccountId != null) {
    
                    if(!accountIdsAndCasesMap.containsKey(cs.AccountId)) {
                        accountIdsAndCasesMap.put(cs.AccountId, new List<Case>());
                    }else {
                        accountIdsAndCasesMap.get(cs.AccountId).add(cs);
                    }
                }
            }
        }
        
        if(!accountIdsAndCasesMap.keySet().isEmpty()) {
            Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, Name, Support_Score__c
                                                             FROM Account 
                                                             WHERE Id IN: accountIdsAndCasesMap.keySet()]);

            for(Id accId: accountIdsAndCasesMap.keySet()) {
                if(accountsMap.get(accId).Support_Score__c == Null) {
                    accountsMap.get(accId).Support_Score__c = 0;
                }
            }

            for(Id accId: accountIdsAndCasesMap.keySet()) {
                Integer score = 0;
                List<Case> cases = accountIdsAndCasesMap.get(accId);
                score = calculateScore(cases);

                if(score < 0) {
                    score = 0;
                }
                
                accountsMap.get(accId).Support_Score__c += score;
                
                
            } 
            if(!accountsMap.values().isEmpty()) {
                update accountsMap.values();
            }
        }
        
    }

    public void finish(Database.BatchableContext bc) {
    }

    private Integer calculateScore(List<Case> cases) {
        Integer score = 0;

        if(!cases.isEmpty()) {
            for(Case cs: cases) {
                if(!String.isBlank(cs.Priority)) {
                    if(cs.Priority == 'High') {
                        score += 3;
                    }
                    if(cs.Priority == 'Medium') {
                        score += 2;
                    }
                    if(cs.Priority == 'Low') {
                        score += 1;
                    }
                    Integer days = (Date.valueOf(cs.CreatedDate)).daysBetween(system.today());
                    if(days < 30) {
                        score += 1;
                    }
                    if(days > 60) {
                        score -= 1;
                    }
                }
            }
        }
        

        return score;
    }
}