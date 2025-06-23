/**
 * Shekhar Vinayak
 * @date 17/06/2025
 * @description Efficient CSV processing for Account, Case, and Firm_Activity__c creation.
 */


public with sharing class Email_Service_impl implements IEmailService {

    public void proccessAttachment(Blob csvBlob) {
        List<String> csvLines = csvBlob.toString().split('\n');
          // Parse header to get column indexes
        List<String> headers = csvLines[0].replace('\r','').split(',');
        Map<String, Integer> colIdx = new Map<String, Integer>();
        for (Integer i = 0; i < headers.size(); i++) {
            colIdx.put(headers[i].trim(), i);
        }

        // Group by Account unique key (e.g., SourceSystemFirmID)
        Map<String, Account> accMap = new Map<String, Account>();
        Map<String, Case> caseMap = new Map<String, Case>();
        Map<String, List<String>> activitiesByFirm = new Map<String, List<String>>();
        Set<String> allActivityCodes = new Set<String>();
        Map<SObjectType, List<SObject>> recordsByType = new Map<SObjectType, List<SObject>>();
        recordsByType.put(Account.SObjectType, new List<SObject>());
        recordsByType.put(Case.SObjectType, new List<SObject>());
        recordsByType.put(Firm_Activity__c.SObjectType, new List<SObject>());

        for (Integer i = 1; i < csvLines.size(); i++) {
            String line = csvLines[i].replace('\r','').trim();
            List<String> row = line.split(',');

            String firmId = row[colIdx.get('SourceSystemFirmID')].trim();
            String accKey = firmId;

            // Create Account if not already
            if (!accMap.containsKey(accKey)) {
                Account acc = new Account(
                    AccountNumber       = firmId,
                    Name                = row[colIdx.get('SourceSystemFirmName')],
                    ShippingStreet      = row[colIdx.get('FirmStreet')],
                    ShippingCity        = row[colIdx.get('FirmCity')],
                    ShippingState       = row[colIdx.get('FirmState')],
                    ShippingPostalCode  = row[colIdx.get('FirmPostalCode')],
                    ShippingCountry     = row[colIdx.get('FirmCountry')]
                );
                accMap.put(accKey, acc);
                recordsByType.get(Account.SObjectType).add(acc);
            }

            // Create Case if not already
            String caseKey = row[colIdx.get('SourceSystemCaseID')].trim();
            if (!caseMap.containsKey(caseKey)) {
                Case cs = new Case( EngineeringReqNumber__c = row[colIdx.get('SourceSystemCaseID')]);
                caseMap.put(caseKey, cs);
                recordsByType.get(Case.SObjectType).add(cs);
            }

            // Collect activities
            String activityCode = row[colIdx.get('ActivityCode')].trim();
            allActivityCodes.add(activityCode);
            if (!activitiesByFirm.containsKey(accKey)) {
                activitiesByFirm.put(accKey, new List<String>());
            }
            activitiesByFirm.get(accKey).add(activityCode);
        }

        // Lookup Activity__c
        Map<String, Id> activityIdByCode = Activity_Selector.getActivityIdByName(allActivityCodes);

        // Create Firm_Activity__c and collect in recordsByType
        for (String accKey : activitiesByFirm.keySet()) {
            Account acc = accMap.get(accKey);
            for (String code : activitiesByFirm.get(accKey)) {
                Id actId = activityIdByCode.get(code);
                if (actId == null) {
                    System.debug('Activity not found for code: ' + code);
                    // TODO: Error handling
                }
                Firm_Activity__c fa = new Firm_Activity__c(Parent_Activity__c = actId);
                recordsByType.get(Firm_Activity__c.SObjectType).add(fa);
                // We'll link Account via registerRelationship below
            }
        }

        // === Domain Logic & UOW ===
        fflib_ISObjectUnitOfWork uow = EmailServiceAppFactory.UOWFACTORY.newInstance();

        for (SObjectType objType : recordsByType.keySet()) {
            List<SObject> records = recordsByType.get(objType);
            System.debug('SObject Type##' + objType);
            System.debug('records in SObject Type##' + records);

            if (!records.isEmpty()) {
                fflib_SObjectDomain domain = (fflib_SObjectDomain)
                EmailServiceAppFactory.DOMAINFACTORY.newInstance(records, objType);
                domain.onApplyDefaults();
                domain.onValidate();

                for (SObject rec : records) {
                    System.debug('records in SObject Type inside loop##' + rec);
                    uow.registerNew(rec);

                    // Relationship registration
                    if (rec instanceof Case && !accMap.isEmpty()) {
                        uow.registerRelationship(rec, Case.AccountId, accMap.values()[0]);
                    } else if (rec instanceof Firm_Activity__c && !accMap.isEmpty()) {
                        uow.registerRelationship(rec, Firm_Activity__c.Account__c, accMap.values()[0]);
                    }
                }
            }
        }

        uow.commitWork();
        System.debug(' UOW committed successfully');
    }
}
