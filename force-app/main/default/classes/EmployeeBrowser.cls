public with sharing class EmployeeBrowser {
    
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(string projectId,string projectSkillId) {
        String query = '';
        Map<String,String> projectWithSkill = new Map<String,String>();
        Map<String,String> projectSkillWithProject = new Map<String,String>();
        
        query += 'SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true';
        
        if(String.isNotEmpty(projectSkillId)){
            

            List<Project_Skill__c> projectSkillLi = [SELECT Id,Required_Skill__c,Project_Id__c FROM Project_Skill__c];
            for(Project_Skill__c proSkill : projectSkillLi){
                projectWithSkill.put(proSkill.Id,proSkill.Required_Skill__c);
                projectSkillWithProject.put(proSkill.Id,proSkill.Project_Id__c);
            }
            List<Employee_Skill__c> empWithSkill = [SELECT Employee_Name__c FROM Employee_Skill__c WHERE Skill_of_Employee__c = :projectWithSkill.get(projectSkillId)];
            Map<String,String> empWithSkillMap = new Map<String,String>();
            for(Employee_Skill__c empsk: empWithSkill){
                empWithSkillMap.put(empsk.Employee_Name__c,empsk.Id);
            }
            
            List<Project_Assignment__c> assignedProjectSkill = [SELECT Employee_Name__c FROM Project_Assignment__c WHERE Status__c = 'Draft' AND Project_Id__c = :projectSkillWithProject.get(projectSkillId)];
            Map<String,String> assignmentSkillMap = new Map<String,String>();
            for(Project_Assignment__c assignedSkill : assignedProjectSkill){
                assignmentSkillMap.put(assignedSkill.Employee_Name__c,assignedSkill.Id);
            }
            List<String> availableEmployeesSkill = new List<String>();
            for(String checkAvailability : empWithSkillMap.keySet()){
                if(!assignmentSkillMap.keySet().contains(checkAvailability)){
                    availableEmployeesSkill.add(checkAvailability);
                }
            }
            List<Employee__c> empQuery =  [SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c, PhotoUrl__c FROM Employee__c WHERE Availability__c= true AND id IN :availableEmployeesSkill ORDER BY Name] ;

            return empQuery;
        }else if(String.isNotEmpty(projectId)){
            List<Employee_Skill__c> empSKill = [SELECT Id,Employee_Name__c FROM Employee_Skill__c WHERE Skill_of_Employee__c IN (SELECT Required_Skill__c FROM Project_Skill__c WHERE Project_Id__c = :projectId)];
			
            Map<String,Id> empSkillMap = new Map<String,Id>();
            for(Employee_Skill__c emp:empSKill){
                empSkillMap.put(emp.Employee_Name__c,emp.Id);
            }
            List<Project_Assignment__c> assignedProject = [SELECT Employee_Name__c FROM Project_Assignment__c WHERE Status__c = 'Draft' AND Project_Id__c = :projectId];
            Map<String,String> assignmentMap = new Map<String,String>();
            for(Project_Assignment__c assigned : assignedProject){
                assignmentMap.put(assigned.Employee_Name__c,assigned.Id);
            }
            List<String> availableEmployees = new List<String>();
            for(String checkAvailability : empSkillMap.keySet()){
                if(!assignmentMap.keySet().contains(checkAvailability)){
                    availableEmployees.add(checkAvailability);
                }
            }
			List<Employee__c> empQuery = [SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true AND Id IN :availableEmployees ORDER BY Name];
			
			return empQuery;
        }
        List<Employee__c> empQuery = [SELECT Id, Name, Email__c, Contact_Number__c, Availability__c,Employee_ID__c,PhotoUrl__c  FROM Employee__c where Availability__c= true ORDER BY Name];
        return empQuery;
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
