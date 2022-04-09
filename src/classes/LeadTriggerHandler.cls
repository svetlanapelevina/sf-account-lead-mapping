public without sharing class LeadTriggerHandler {

    private static final AccountService accountServiceInstance = AccountService.getInstance();

    public static void handleBeforeInsert(List<Lead> newLeads) {
        Map<Lead, String> emailDomainsByLead = new Map<Lead, String>();

        for (Lead lead : newLeads) {
            if (String.isBlank(lead.Email)) {
                continue;
            }

            String emailDomain = DomainUtils.getEmailDomain(lead.Email);

            emailDomainsByLead.put(lead, emailDomain);
        }

        if (emailDomainsByLead.isEmpty()) {
            return;
        }

        Set<String> leadEmailDomains = new Set<String>(emailDomainsByLead.values());

        Map<String, Account> accountsByWebsiteDomain = accountServiceInstance.getAccountsByWebsiteDomain(leadEmailDomains);

        for (Lead lead : newLeads) {
            if (String.isBlank(lead.Email)) {
                continue;
            }

            String leadDomain = emailDomainsByLead.get(lead);

            lead.Account__c = accountsByWebsiteDomain.get(leadDomain)?.Id;

            System.debug(lead.Account__c);
        }
    }
}