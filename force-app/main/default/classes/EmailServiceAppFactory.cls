
/**
 * @author Shekhar Vinayak
 * @date  17/06/2025
 * @description Factory class to provide UnitOfWork, Domain, Selector, and Service layers using fflib
 */
public with sharing class EmailServiceAppFactory {

    public static final fflib_Application.UnitOfWorkFactory UOWFACTORY = new fflib_Application.UnitOfWorkFactory(
        new List<SObjectType> {
             Account.SObjectType,
             Case.SObjectType,
             Firm_Activity__c.SObjectType
                     
        });

    public static final fflib_Application.ServiceFactory SERVICEFACTORY = new fflib_Application.ServiceFactory(
        new Map<Type, Type> {
            IEmailService.class => Email_Service_impl.class
        });

    public static final fflib_Application.SelectorFactory SELECTORFACTORY = new fflib_Application.SelectorFactory(
        new Map<SObjectType, Type> {
             Account.SObjectType => Account_Selector.class,
             Case.SObjectType => Case_Selector.class,
             Firm_Activity__c.SObjectType => Activity_Selector.class
           
        });

    //This allows you to create a factory for instantiating domain classes. You can send it a set of record ids and
    public static final fflib_Application.DomainFactory DOMAINFACTORY =
            new fflib_Application.DomainFactory(
                SELECTORFACTORY,
                    new Map<SObjectType, Type>{
                        Account.SObjectType => AccountsDomain.Constructor.class,
                        Case.SObjectType => CasesDomain.Constructor.class,
                        Firm_Activity__c.SObjectType => FirmActivitiesDomain.Constructor.class
                    }
            );
}