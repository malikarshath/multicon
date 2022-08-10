public with sharing class EmployeeBrowser {

    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(string projectId,string projectSkillId) {
		system.debug('------------------' +projectId+'--------------'+ projectSkillId);
		String query = '';
		Map<String,String> empWithSkill = new Map<String,String>();
		Map<String,String> projectWithSkill = new Map<String,String>();

		query += 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true';
		//List<Employee__c> employeesLi = [SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c,(SELECT Skill_of_Employee__c FROM Employee_Skills__r)  FROM Employee__c where Availability__c= true];
		// for(Employee__c emp : employeesLi){
		// 	for(Employee_Skills__c empSkill : emp.Employee_Skills__r){
		// 		empWithSkill.put(emp.Name,empSkill.Skill_of_Employee__c);
		// 	}
		// }

		if(String.isNotEmpty(projectSkillId)){
			List<Project_Skill__c> projectSkillLi = [SELECT Id,Required_Skill__c FROM Project_Skill__c];
			for(Project_Skill__c proSkill : projectSkillLi){
		 		projectWithSkill.put(proSkill.Id,proSkill.Required_Skill__c);
		 	}

		 	query = 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c, PhotoUrl__c ,(SELECT Skill_of_Employee__c FROM Employee_Skills__r WHERE Skill_of_Employee__c = \''+ projectWithSkill.get(projectSkillId)+'\' ) FROM Employee__c WHERE Availability__c= true AND id IN (SELECT Employee_Name__c FROM Employee_Skill__c WHERE Skill_of_Employee__c = \'' + projectWithSkill.get(projectSkillId)+'\')';
		}else if(String.isNotEmpty(projectId)){
			query += '';
		}
		query += ' WITH SECURITY_ENFORCED ';
		query += 'ORDER BY Name';
		system.debug(query);
		return Database.query(query);
    }
}
