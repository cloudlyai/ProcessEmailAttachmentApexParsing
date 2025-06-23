/* created by Shekhar on 17/06/2025
 * @description This is the selector class for the Account object
 */

public inherited sharing class Account_Selector extends fflib_SObjectSelector {
	//This sets the base fields that you will ALWAYS have in your queries when calling this selector class
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
			Account.Id,
			Account.Name,
			Account.Type,
			Account.Description
		};
	}

	//This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Account.SObjectType;
    }

    //This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
	//of cases from the AccountIds you sent in with the default fields declared in the getSObjectFieldList method above
	public List<Account> selectById(Set<Id> accountIds){
		return (List<Account>) selectSObjectsById(accountIds);
    }
}