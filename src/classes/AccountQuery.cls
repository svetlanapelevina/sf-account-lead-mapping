public inherited sharing class AccountQuery {

    public static List<Account> findByWebsiteDomain(Set<String> domains) {
        return [
                SELECT Id, WebsiteDomain__c
                FROM Account
                WHERE WebsiteDomain__c IN :domains
                LIMIT 1
        ];
    }
}