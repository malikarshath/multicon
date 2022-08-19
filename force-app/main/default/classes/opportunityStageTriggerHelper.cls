public with sharing class opportunityStageTriggerHelper {

    public static void  opportunityStageTriggerHelper(List<Opportunity> opportunities, Map<Id,Opportunity> oldMap) {
        List<Project__c> projects = new List<Project__c>();
        List<Project__c> oldProjects = [SELECT Project_Name__c,Account__c,Stage__c FROM Project__c];
        List<Project_Skill__c> projectSkills = new List<Project_Skill__c>();
        Map<String,Id> skillMap = new Map<String,Id>();
        for (Skill__c skill : [SELECT Id,Name FROM Skill__c ]){
            skillMap.put(skill.Name,skill.Id);
        }

        for (Opportunity opportunity : opportunities){
            if (opportunity.StageName == 'Proposal/Price Quote' && oldMap.get(opportunity.Id).StageName != opportunity.StageName){
                Project__c project = new Project__c (Account__c=opportunity.AccountId,Opportunity__c=opportunity.Id,Budget__c=opportunity.Amount,Project_Name__c=opportunity.Name,Stage__c='Draft',Start_Date__c=opportunity.Tentative_Project_Start_Date__c,Duration_days__c=opportunity.Duration__c);
                projects.add(project);
            }
            else if (opportunity.StageName == 'Closed/Won' && oldMap.get(opportunity.Id).StageName != opportunity.StageName){
                for (Project__c oldProject : oldProjects){
                    if(oldProject.Project_Name__c==opportunity.Name && oldProject.Account__c==opportunity.AccountId ){
                        oldProject.Stage__c = 'Initiated';
                        oldProject.Start_Date__c=system.today();
                    }
                }
                
            }
            else if (opportunity.StageName == 'Closed/Lost' && oldMap.get(opportunity.Id).StageName != opportunity.StageName){
                for (Project__c oldProject : oldProjects){
                    if(oldProject.Project_Name__c==opportunity.Name && oldProject.Account__c==opportunity.AccountId ){
                        oldProject.Stage__c = 'Cancelled';
                    }
                }
                
            }
        }
        insert projects;
        Database.update(oldProjects,false) ; 

        Map<String,Id> projectSkillMap = new Map<String,Id>();
        for (Project__c projectSkill : [SELECT Id,Project_Name__c FROM Project__c ]){
            projectSkillMap.put(projectSkill.Project_Name__c,projectSkill.Id);
        }
        for (Opportunity opportunity : opportunities){
            if (opportunity.StageName == 'Proposal/Price Quote' && oldMap.get(opportunity.Id).StageName != opportunity.StageName){
                string skill = opportunity.Required_Skills__c + ';';
                
                for (String skillExtract : skill.split(';')){
                    projectSkills.add(new Project_Skill__c(Name=skillExtract+' required for '+opportunity.Name,Project_Id__c=projectSkillMap.get(opportunity.Name),Required_Skill__c=skillMap.get(skillExtract)));
                }
            }
        }

        insert projectSkills;
    }
}
