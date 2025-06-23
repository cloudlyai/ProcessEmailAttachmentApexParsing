 /**
 * Created by Shekhar Vinayak 
 * @date 17/06/2025
 * @description This is the domain class for the Account object
 */
public inherited sharing class AccountsDomain extends fflib_SObjectDomain {

    public AccountsDomain(List<SObject> records, SObjectType sObjectType) {
        super(records, sObjectType);
    }

    public AccountsDomain(List<Account> accountRecords){
        super(accountRecords);
    }

    // Only one Constructor class implementing both IConstructable and IConstructable2
    public class Constructor implements fflib_SObjectDomain.IConstructable2 {

        // Required by IConstructable
        public fflib_SObjectDomain construct(List<SObject> records) {
            return new AccountsDomain(records);
        }

        // Required by IConstructable2
        public fflib_SObjectDomain construct(List<SObject> records, SObjectType sObjectType) {
            return new AccountsDomain(records, sObjectType);
        }
    }

    public override void onApplyDefaults() {
        for (Account acc : (List<Account>) Records) {
            if (acc.Type == null) {
                acc.Type = 'Prospect';
            }
        }
    }

    public override void onValidate() {
        System.debug('inside validate method');
    }
}
