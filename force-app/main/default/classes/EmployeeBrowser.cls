public with sharing class EmployeeBrowser {
    
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(string projectId,string projectSkillId) {
        String query = '';
        Map<String,String> empWithSkill = new Map<String,String>();
        Map<String,String> projectWithSkill = new Map<String,String>();
        
        query += 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true';
        
        if(String.isNotEmpty(projectSkillId)){
            List<Project_Skill__c> projectSkillLi = [SELECT Id,Required_Skill__c FROM Project_Skill__c];
            for(Project_Skill__c proSkill : projectSkillLi){
                projectWithSkill.put(proSkill.Id,proSkill.Required_Skill__c);
            }
            query = 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c, PhotoUrl__c ,(SELECT Skill_of_Employee__c FROM Employee_Skills__r WHERE Skill_of_Employee__c = \''+ projectWithSkill.get(projectSkillId)+'\' ) FROM Employee__c WHERE Availability__c= true AND id IN (SELECT Employee_Name__c FROM Employee_Skill__c WHERE Skill_of_Employee__c = \'' + projectWithSkill.get(projectSkillId)+'\')';
            
        }else if(String.isNotEmpty(projectId)){
            List<Employee_Skill__c> empSKill = [SELECT Id,Employee_Name__c FROM Employee_Skill__c WHERE Skill_of_Employee__c IN (SELECT Required_Skill__c FROM Project_Skill__c WHERE Project_Id__c = :projectId)];
			
            Map<String,Id> empSkillMap = new Map<String,Id>();
            for(Employee_Skill__c emp:empSKill){
                empSkillMap.put(emp.Employee_Name__c,emp.Id);
            }
			
            //query =  'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true AND Id IN :'+empSkillMap.keySet();
			List<Employee__c> empQuery = [SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true AND Id IN :empSkillMap.keySet() WITH SECURITY_ENFORCED ORDER BY Name];
			
			return empQuery;
        }
        query += ' WITH SECURITY_ENFORCED ';
        query += 'ORDER BY Name';
        return Database.query(query);
    }

    @AuraEnabled
    public static void createProjectAssignment(string projectId,string projectSkillId,string employeeId ){
    if(String.isNotEmpty(employeeId) && String.isNotEmpty(projectSkillId)){
        List<Project_Skill__c> skills = [SELECT Id,Required_Skill__r.Name FROM Project_Skill__c];
        Map<String,String> skillMap= new Map<String,String>();
        for(Project_Skill__c skill : skills){
            skillMap.put(skill.Id,skill.Required_Skill__r.Name);
        }
        
        List<Project_Assignment__c> newAssignments = new List<Project_Assignment__c>();
        newAssignments.add(new Project_Assignment__c(Employee_Name__c=employeeId,Project_Id__c=projectId,Status__c='Draft',Skill__c=skillMap.get(projectSkillId)));
        insert newAssignments;  
    }
}
}
