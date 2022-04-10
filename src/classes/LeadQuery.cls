public inherited sharing class LeadQuery {

    public static Lead findById(Id leadId) {
        return (Lead) SObjectUtils.getFirstListElement(findById(new Set<Id>{leadId}));
    }

    public static List<Lead> findById(Set<Id> leadsId) {
        return [
                SELECT Id, Account__c, Account__r.Website, Account__r.WebsiteDomain__c, EmailDomain__c
                FROM Lead
                WHERE Id = :leadsId
        ];
    }
}