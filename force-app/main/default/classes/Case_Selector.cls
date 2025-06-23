/*
 * @Shekhar Vinayak
 * @date 12/06/2025
 * @description This class is used to select data from the case object. It's the only place that case object queries
 * should be made
 */ 

//We extend the fflib_SObjectSelector class to gain access to its many useful prebuilt methods
//We extend the Task_Selector_Interface to force it to implement a particular set of methods to help with abstraction
//in the Task_Service_Impl class
public inherited sharing class Case_Selector extends fflib_SObjectSelector 
{
	//This sets the base fields that you will ALWAYS have in your queries when calling this selector class
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
			Case.Id,
			Case.Subject,
			Case.Status,
			Case.ContactId
		};
	}

	//This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Case.SObjectType;
	}

	//This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
	//of cases from the caseIds you sent in with the default fields declared in the getSObjectFieldList method above
	public List<Case> selectById(Set<Id> caseIds){
		return (List<Case>) selectSObjectsById(caseIds);
	}
}