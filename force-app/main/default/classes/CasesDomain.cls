 /**
 * Created by Shekhar Vinayak 
 * @date 17/06/2025
 * @description This is the domain class for the Case object
 */
public inherited sharing class CasesDomain extends fflib_SObjectDomain {

    public CasesDomain(List<SObject> records, SObjectType sObjectType) {
        super(records, sObjectType);
    }

    public CasesDomain(List<Case> caseRecords) {
        super(caseRecords);
    }

    // ✅ Corrected: Only one Constructor class that implements both interfaces
    public class Constructor implements fflib_SObjectDomain.IConstructable2 {

        // Required for IConstructable
        public fflib_SObjectDomain construct(List<SObject> records) {
            return new CasesDomain(records);
        }

        // Required for IConstructable2
        public fflib_SObjectDomain construct(List<SObject> records, SObjectType sObjectType) {
            return new CasesDomain(records, sObjectType);
        }
    }

    public override void onApplyDefaults() {
        for (Case newCase : (List<Case>) Records) {
            if (newCase.Status == 'New') {
                newCase.Status = 'Working';
            }
            newCase.Origin = 'Email';
        }
    }

    public override void onValidate() {
        for (Case newCase : (List<Case>) Records) {
            if (newCase.ContactId == null) {
               // newCase.ContactId.addError('Contact must be provided for new cases.');
            }
        }
    }
}
