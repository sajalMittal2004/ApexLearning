/** 
 * 
 * Purpose          :   Queueable Apex class to insert the same Contact for each Account in a specific state.
 * 
 * Created by       :   Sajal Mittal
 * 
 * Created Date     :   19-12-2024
 * 
 * Rivision Logs    :   V_1.0 - Created
 * 
**/
global without sharing class AddPrimaryContact implements Queueable{
    private Contact con;
    private String state;
    public AddPrimaryContact(Contact con, String state) {
        this.con = con;
        this.state = state;
    }

    global void execute(QueueableContext qc) {
        List<Account> accList = [SELECT Id, Name, BillingState FROM Account WHERE BillingState =: state LIMIT 200];
        List<Contact> conList = new List<Contact>();

        for(Account acc: acclist) {
            Contact cont = con.clone(false, false, false, false);
            cont.AccountId = acc.Id;    
            conList.add(cont);
        }
		System.debug(conList);
        if(!conList.isEmpty()) {
            insert conList;
        }
    }
}