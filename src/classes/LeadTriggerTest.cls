@isTest
private class LeadTriggerTest {

    @testSetup
    private static void setup() {
        createAccounts();
    }

    @isTest
    static void testAccountWithDomainFound() {
        Test.startTest();
        Lead lead = TestDataFactory.lead().setEmail('test.lead@test-domain.com').create();
        Test.stopTest();

        Lead insertedLead = LeadQuery.findById(lead.Id);
        System.assertNotEquals(null, insertedLead.Account__c);
        System.assertEquals(insertedLead.EmailDomain__c, insertedLead.Account__r.WebsiteDomain__c);
    }

    @isTest
    static void testAccountWithDomainFoundBulk() {
        insert1000Accounts();

        Test.startTest();
        List<Lead> leads = insert1000Leads();
        Test.stopTest();

        Set<Id> leadsIds = new Set<Id>();
        for (Lead lead : leads) {
            leadsIds.add(lead.Id);
        }

        List<Lead> insertedLeads = LeadQuery.findById(leadsIds);

        for (Lead lead : insertedLeads) {
            System.assertNotEquals(null, lead.Account__c);
            System.assertEquals(lead.EmailDomain__c, lead.Account__r.WebsiteDomain__c);
        }
    }

    @isTest
    static void testAccountWithDomainNotFound() {
        Test.startTest();
        Lead lead = TestDataFactory.lead().setEmail('test.lead@noname.com').create();
        Test.stopTest();

        Lead insertedLead = LeadQuery.findById(lead.Id);
        System.assertEquals(null, insertedLead.Account__c);
    }

    @isTest
    static void testEmptyEmail() {
        Test.startTest();
        Lead lead = TestDataFactory.lead().setEmail(null).create();
        Test.stopTest();

        Lead insertedLead = LeadQuery.findById(lead.Id);
        System.assertEquals(null, insertedLead.Account__c);
    }

    private static void createAccounts() {
        List<Account> accounts = new List<Account>{
                TestDataFactory.account().setWebsite('https://test.com').get(),
                TestDataFactory.account().setWebsite('https://test-domain.com').get()
        };

        Database.insert(accounts);
    }

    private static void insert1000Accounts() {
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < 1000; i++) {
            accounts.add(TestDataFactory.account().setWebsite('https://test-domain' + i + '.com').get());
        }

        Database.insert(accounts);
    }

    private static List<Lead> insert1000Leads() {
        List<Lead> leads = new List<Lead>();

        for (Integer i = 0; i < 1000; i++) {
            leads.add(TestDataFactory.lead().setEmail('test.lead@test-domain' + i + '.com').get());
        }

        Database.insert(leads);

        return leads;
    }
}