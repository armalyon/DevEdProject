
public with sharing class ExternalOrgAccountManager {
    private static final String ACCOUNTS_URL = 'https://eu27.force.com/services/apexrest/accounts/';
    private static final String OAUTH_URL = 'https://eu27.force.com/services/oauth2/token';

    public static Account getExternalAccountById(ID id) {
        OauthData oauthData = getOauthData();
        if (oauthData.access_token != null) {
            Http getHttp = new Http();
            HttpRequest getRequest = new HttpRequest();
            getRequest.setEndpoint(ACCOUNTS_URL + id);
            getRequest.setHeader('Content-Type', 'application/json');
            getRequest.setHeader('Authorization', 'Bearer ' + oauthData.access_token);
            getRequest.setMethod('GET');
            HttpResponse getResponse = getHttp.send(getRequest);
            return (Account) JSON.deserialize(getResponse.getBody(), Account.class);
        } else return null;
    }

    public static void createNewExternalAccount(Account account) {
        OauthData oauthData = getOauthData();
        if (oauthData.access_token != null) {
            Http postHttp = new Http();
            HttpRequest postRequest = new HttpRequest();
            postRequest.setMethod('POST');
            postRequest.setEndpoint(ACCOUNTS_URL);
            postRequest.setHeader('Content-Type', 'application/json');
            postRequest.setHeader('Authorization', 'Bearer ' + oauthData.access_token);

            postRequest.setBody(
                    JSON.serializePretty(
                            AccountJSON.mapAccountToAccountJSON(account), true)
            );
            HttpResponse response = postHttp.send(postRequest);
            System.debug('>>>>>>>>>>>>>>>>>>>' + response.getBody());
        }
    }

    public static void deleteExternalAccountById(Id idToDelete) {
        OauthData oauthData = getOauthData();
        if (oauthData.access_token != null) {
            Http delHttp = new Http();
            HttpRequest delRequest = new HttpRequest();
            delRequest.setMethod('DELETE');
            delRequest.setEndpoint(ACCOUNTS_URL + idToDelete);
            delRequest.setHeader('Authorization', 'Bearer ' + oauthData.access_token);
            HttpResponse response = delHttp.send(delRequest);
            System.debug('>>>>>>>>>>>' + response.getBody());
        }
    }

    public static void updateAccountInfoDyId(Id id, String name, String rating, String phone, String site,
            String industry, String billingCountry, String billingState, String billingPostalCode,
            String billingCity, String billingStreet) {

        OauthData oauthData = getOauthData();
        if (oauthData.access_token != null) {
            Http putHttp = new Http();
            HttpRequest putRequest = new HttpRequest();
            putRequest.setMethod('PUT');
            putRequest.setEndpoint(ACCOUNTS_URL + id);
            putRequest.setHeader('Authorization', 'Bearer ' + oauthData.access_token);
            putRequest.setHeader('Content-Type', 'application/json');
            putRequest.setBody('{' +
                    '"name" : "' + name + '", ' +
                    '"rating" : "' + rating + '", ' +
                    '"phone" : "' + phone + '", ' +
                    '"site" : "' + site + '", ' +
                    '"industry" : "' + industry + '", ' +
                    '"billingCountry" : "' + billingCountry + '", ' +
                    '"billingState" : "' + billingState + '", ' +
                    '"billingPostalCode" : "' + billingPostalCode + '", ' +
                    '"billingCity" : "' + billingCity + '", ' +
                    '"billingStreet" : "' + billingStreet + '" ' +
                    '}');
            HttpResponse response = putHttp.send(putRequest);
            System.debug('>>>>>>>>>>>>>>>>' + response.getBody());
        }

    }


    private static OauthData getOauthData() {
        Main_Org_Credential__mdt credentials = [
                SELECT
                        Client_Id__c, Client_Secret__c, Username__c, Password__c
                FROM Main_Org_Credential__mdt
                WHERE MasterLabel = 'Support User'
        ];

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(OAUTH_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(getOauthRequestBody(credentials));
        HttpResponse response = http.send(request);

        return (OauthData) JSON.deserialize(response.getBody(), OauthData.class);
    }

    private static String getOauthRequestBody(Main_Org_Credential__mdt credentials) {
        return 'grant_type=password&' +
                'client_id=' + credentials.Client_Id__c + '&' +
                'client_secret=' + credentials.Client_Secret__c + '&' +
                'username=' + credentials.Username__c + '&' +
                'password=' + credentials.Password__c;
    }

    public class OauthData {
        public String access_token { get; set; }
        public String instance_url { get; set; }
        public String id { get; set; }
        public String token_type { get; set; }
        public String issued_at { get; set; }
        public String signature { get; set; }

    }

}