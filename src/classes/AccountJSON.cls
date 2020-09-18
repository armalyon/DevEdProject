public class AccountJSON {
    public cls_account account;
    class cls_account {
        public String Name;
        public cls_BillingAddress BillingAddress;
        public String Phone;
        public String Type;
        public String Industry;
        public String AccountNumber;
        public String Rating;
        public String Site;
        public String Description;
    }
    class cls_BillingAddress {
        public String city;
        public String country;
        public String postalCode;
        public String state;
        public String street;
    }

    public static AccountJSON mapAccountToAccountJSON(Account acc){
        AccountJSON accountJSONobj = new AccountJSON();

        accountJSONobj.account = new cls_account();
        accountJSONobj.account.Name = acc.Name;
        accountJSONobj.account.Industry = acc.Industry;
        accountJSONobj.account.Rating = acc.Rating;
        accountJSONobj.account.Type = acc.Type;
        accountJSONobj.account.AccountNumber = acc.AccountNumber;
        accountJSONobj.account.Site = acc.Site;
        accountJSONobj.account.Phone = acc.Phone = acc.Phone;
        accountJSONobj.account.Description = acc.Description;

        accountJSONobj.account.BillingAddress = new cls_BillingAddress();
        accountJSONobj.account.BillingAddress.city = acc.BillingCity;
        accountJSONobj.account.BillingAddress.country = acc.BillingCountry;
        accountJSONobj.account.BillingAddress.postalCode = acc.BillingPostalCode;
        accountJSONobj.account.BillingAddress.state = acc.BillingState;
        accountJSONobj.account.BillingAddress.street = acc.BillingStreet;

        return accountJSONobj;
    }
}