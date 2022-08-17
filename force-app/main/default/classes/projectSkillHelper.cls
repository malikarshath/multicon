public with sharing class projectSkillHelper {
    public static void  projectSkillHelper(List<Project_Skill__c> projectSkills) {

        integer i = 0;

        Map<Id,String> skillMap = new Map<Id,String>();
        for (Skill__c skill : [SELECT Id,Name FROM Skill__c ]){
            skillMap.put(skill.Id,skill.Name);
        }
    


        List<Project_Assignment__c> projectAssignments = new List<Project_Assignment__c>();
        for(Employee_Skill__c employee: [SELECT Id,Skill_of_Employee__c,Employee_Name__c From Employee_Skill__c where Employee_Name__r.Availability__c = TRUE]){
            for(Project_Skill__c projectSkill : projectSkills){
                if(employee.Skill_of_Employee__c==projectSkill.Required_Skill__c){
                    projectAssignments.add(new Project_Assignment__c(Project_Id__c=projectSkill.Project_Id__c,Status__c='Draft',Employee_Name__c=employee.Employee_Name__c,Skill__c=skillMap.get(projectSkill.Required_Skill__c)));
                    i++;
                    break;
                }
            }
            if(i >= projectSkills.size()){
                break;
            }
            
        }

        insert projectAssignments;


    }
}
