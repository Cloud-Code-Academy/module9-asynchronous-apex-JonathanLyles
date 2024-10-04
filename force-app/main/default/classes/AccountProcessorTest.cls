/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountProcessorTest {

    @isTest
    static void countContactsTest() {
        // TO DO: implement unit test
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++){
            Account acc = new Account(Name = 'Test Account ' + i);
            accounts.add(acc);
        }
        insert accounts;
        
        //Query account and verify default contact has been created and Number_Of_Contacts__c equals 1
        List<Id> accountsIds = new List<Id>();
        for(Account acc : accounts){
            accountsIds.add(acc.Id);
        }


        List<Account> accountCheck1 = [SELECT Id, (SELECT LastName FROM Contacts) FROM Account WHERE Id IN :accountsIds];

        for(Account acc : accountCheck1){
            System.assertEquals(1, acc.Contacts.size(), 'Wrong number of default contacts');
            for(Contact con : acc.Contacts){
                System.assertEquals('DefaultContact', con.LastName, 'Not the expected name for Default Contact');
            }
        }


        List<Contact> contacts = new List<Contact>();
        List<Id> accIds = new List<Id>();

        for(Account acc : accounts){
            accIds.add(acc.Id);
            for(Integer i = 0; i < 2; i++){
                Contact con = new Contact(LastName = 'Test Contact' + i, AccountId = acc.Id);
                contacts.add(con);
            }
        }
        insert contacts;

        Test.startTest();
        AccountProcessor.countContacts(accIds);
        Test.stopTest();

        //Query the updated accounts and contacts
        List<Account> updatedAccounts = [SELECT Id, Number_Of_Contacts__c, (SELECT Id, LastName FROM Contacts) FROM Account WHERE Id IN :accIds];

        System.assertEquals(200, updatedAccounts.size(), 'Wrong number of accounts created');

        for(Account acc : updatedAccounts){
           System.assertEquals(3, acc.Number_Of_Contacts__c, 'Wrong number of contacts');
        }
    }
}