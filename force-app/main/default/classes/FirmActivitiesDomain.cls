/*
 * Created by Shekhar Vinayak 
 * @date 17/06/2025
 * @description This is the domain class for the Firm_Activity__c object
*/

public with sharing class FirmActivitiesDomain extends fflib_SObjectDomain {

    public FirmActivitiesDomain(List<SObject> records) {
        super(records);
    }

     public FirmActivitiesDomain(List<SObject> records, SObjectType sObjectType) {
        super(records, sObjectType);
    }

    // Only one Constructor class implementing both IConstructable and IConstructable2
    public class Constructor implements fflib_SObjectDomain.IConstructable2 {

        // Required by IConstructable
        public fflib_SObjectDomain construct(List<SObject> records) {
            return new FirmActivitiesDomain(records);
        }

        // Required by IConstructable2
        public fflib_SObjectDomain construct(List<SObject> records, SObjectType sObjectType) {
            return new FirmActivitiesDomain(records, sObjectType);
        }
    }

    
    public override void onValidate() {
        // Add any validation rules here if needed
    }

    public override void onApplyDefaults() {
        // Set any default values before DML
    }
}
