public class TestDataFactory {

    public static LeadBuilder lead() {
        return new LeadBuilder();
    }

    public static AccountBuilder account() {
        return new AccountBuilder();
    }

    public class LeadBuilder {
        private Lead lead = new Lead();

        private LeadBuilder() {
            this.lead.LastName = 'Test Lead';
            this.lead.Company = 'Test Company';
        }

        public LeadBuilder setEmail(String email) {
            this.lead.Email = email;
            return this;
        }

        public Lead get() {
            return this.lead;
        }

        public Lead create() {
            Database.insert(this.lead);
            return this.lead;
        }
    }

    public class AccountBuilder {
        private Account account = new Account();

        private AccountBuilder() {
            this.account.Name = 'Test Account';
        }

        public AccountBuilder setWebsite(String website) {
            this.account.Website = website;
            return this;
        }

        public Account get() {
            return this.account;
        }

        public Account create() {
            Database.insert(this.account);
            return this.account;
        }
    }
}