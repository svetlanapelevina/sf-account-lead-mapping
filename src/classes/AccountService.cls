public inherited sharing class AccountService {

    private static AccountService self;

    public static AccountService getInstance() {
        if (self == null) {
            self = new AccountService();
        }

        return self;
    }

    public Map<String, Account> getAccountsByWebsiteDomain(Set<String> domains) {
        List<Account> accounts = AccountQuery.findByWebsiteDomain(domains);

        Map<String, Account> accountsByWebsiteDomain = new Map<String, Account>();
        for (Account account : accounts) {
            accountsByWebsiteDomain.put(account.WebsiteDomain__c, account);
        }

        return accountsByWebsiteDomain;
    }
}