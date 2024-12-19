@isTest
private class LeadProcessorTest {

    @TestSetup
    static void makeData(){
        List<Lead> leads = new List<Lead>();
        for(Integer i = 1; i <= 200; i++) {
            leads.add(new Lead(LastName = 'Test Lead 1', 
                                Company = 'Test Company', 
                                LeadSource = 'Web'));
        }
        insert leads; 
    }
    @isTest
    static void myUnitTest() {
        List<lead> leadList = [SELECT Id, Name, LeadSource FROM Lead WHERE Name Like 'Test Lead%' LIMIT 200];

        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Database.executeBatch(lp);
        Test.stopTest();

        List<lead> UpdatedLeads = [SELECT Id, Name, LeadSource FROM Lead WHERE Name Like 'Test Lead%' LIMIT 200];
        
        for(Integer i = 0; i < 200; i++) {
            Assert.areEqual('Dreamforce', UpdatedLeads[i].LeadSource);
        }
    }
}