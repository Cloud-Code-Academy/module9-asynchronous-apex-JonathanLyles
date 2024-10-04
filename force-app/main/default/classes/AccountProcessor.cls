public with sharing class AccountProcessor {
 
    @future
    public static void countContacts(List<Id> accountIds){
        List<Account> accountsToUpdateList = new List<Account>();
        for(Account acc : [SELECT Id, Number_Of_Contacts__c, (SELECT Id,LastName FROM Contacts) FROM Account WHERE Id in :accountIds]){
            List<Contact> contacts = acc.Contacts;
            if(contacts != null && !contacts.isEmpty()){
                acc.Number_Of_Contacts__c = contacts.size();
                System.debug(contacts);
            }
            accountsToUpdateList.add(acc);
            
        }
        update accountsToUpdateList;
    }
}


