/**
 * @author Shekhar Vinayak
 * @date  17/06/2025
 * @description Utility class to get the service class name for the given area name
 */

public class EmailServUtility {
    public static String getServiceClassName(String areaName) {
        List<ShGl_ServLayer_ClassMapping__mdt> mappingList = [
            SELECT Area__c, Service_Class__c
            FROM ShGl_ServLayer_ClassMapping__mdt
            WHERE Area__c = :areaName
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        return (!mappingList.isEmpty() && mappingList[0].Service_Class__c != null) ? mappingList[0].Service_Class__c : null;
    }
}