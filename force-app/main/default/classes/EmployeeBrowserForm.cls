public with sharing class EmployeeBrowserForm {
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjects() {
        return [SELECT Id, Name FROM Project__c WHERE Stage__c = 'Draft' ORDER BY Name];

    }
    @AuraEnabled(cacheable=true)
    public static List<Project_Skill__c> getProjectSkills(String projectId ) {
        if (String.isEmpty(projectId)) {
			return new List<Project_Skill__c>();
		} else {
			return [
				SELECT Id,Name,Required_Skill__c, Project_Id__c
				FROM Project_Skill__c
				WHERE Project_Id__r.Id = :projectId 
				ORDER BY Name ASC
			];
		}

    }
    
}
