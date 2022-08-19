@isTest
private class projectSkillHelper_Test {

    @isTest
    static void projectSkillHelper_Test() {
        List<Project_Skill__c> projectSkillLi = new List<Project_Skill__c>();
        List<Skill__c> skillLi = new List<Skill__c>();
        List<Employee_Skill__c> empSkillLi = new List<Employee_Skill__c>();


        Account acct = new Account(Name='Test Account',organization_Email__c='test@gmail.com');
        insert acct;

        Opportunity oppo = new Opportunity(AccountId=acct.Id,StageName='Proposal/Price Quote',Required_Skills__c='Java;Mongo DB;Selenium',RecordTypeId='0120w000000EpZIAA0',CloseDate=date.valueOf('2022-08-31'),Amount=3000000.00,Duration__c=120,Name='Test oppo');
        insert oppo;

        Project__c testProject = new Project__c (Project_Name__c = 'TestProject',Stage__c = 'Draft',Account__c=acct.Id,Opportunity__c=oppo.Id);
        insert testProject;

        String proId = testProject.Id;

        Skill__c skill = new Skill__c(Name='unit Testing');
        insert skill;
        skillLi.add(skill);

        Project_Skill__c proSkill = new Project_Skill__c (Name='Test SKill',Required_Skill__c=skill.Id, Project_Id__c=testProject.Id);
        insert proSkill;
        projectSkillLi.add(proSkill);

        Employee__c emp = new Employee__c(Name='Erik Marsh',Email__c='emarsh@multicon.com',Proof_ID_Type__c='Aadhar Number',Employee_ID__c=53006,ID_Number__c='123412341234',Contact_Number__c='6326330181',Availability__c=True);
        insert emp;

        Employee_Skill__c empSkill = new Employee_Skill__c(Employee_Name__c=emp.Id,Skill_of_Employee__c=skill.Id);
        insert empSkill;
        empSkillLi.add(empSkill);

        Test.startTest();
        projectSkillHelper.projectSkillHelper(projectSkillLi);
        List<Project_Assignment__c> projectAssignments = [SELECT Id,Employee_Name__c,Skill__c,Project_Id__c FROM Project_Assignment__c WHERE Project_Id__c = :testProject.Id];
        Test.stopTest();

        

        System.assertEquals(1, projectAssignments.size(),'ERROR: Expected only 1 records');
        

    }
}
