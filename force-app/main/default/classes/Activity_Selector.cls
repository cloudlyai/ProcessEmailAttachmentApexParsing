/*
Created by Shekhar Vinayak 
@date 21/06/2025
@description This is the selector class for the Activity__c object  
*/


public with sharing class Activity_Selector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
			Activity__c.Id,
			Activity__c.Name,
			Activity__c.Detail__c
			
		};
	}

    
    //This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Activity__c.SObjectType;
    }


    public static Map<String, Id> getActivityIdByName(Set<String> activityNames) {
        Map<String, Id> result = new Map<String, Id>();
        for (Activity__c act : [
            SELECT Id, Name FROM Activity__c
            WHERE Name IN :activityNames
        ]) {
            result.put(act.Name, act.Id);
        }
        return result;
    }
}
