public with sharing class EmployeeBrowser {
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(string project,string projectSkill) {
		String query = '';
		query += 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true';
		query += 'WITH SECURITY_ENFORCED ';
		query += 'ORDER BY Name';

		return Database.query(query);
    }
}
