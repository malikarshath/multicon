@isTest
private class EmployeeBrowserForm_Test {
    @isTest
    static void EmployeeBrowserForm_Test() {
        Account acct = new Account(Name='Test Account',organization_Email__c='test@gmail.com');
        insert acct;

        Opportunity oppo = new Opportunity(AccountId=acct.Id,StageName='Proposal/Price Quote',Required_Skills__c='Java;Mongo DB;Selenium',RecordTypeId='0120w000000EpZIAA0',CloseDate=date.valueOf('2022-08-31'),Amount=3000000.00,Duration__c=120,Name='Test oppo');
        insert oppo;
        Project__c testProject = new Project__c (Project_Name__c = 'TestProject',Stage__c = 'Draft',Account__c=acct.Id,Opportunity__c=oppo.Id);
        insert testProject;

        String proId = testProject.Id;

        Skill__c skill = new Skill__c(Name='unit Testing');
        insert skill;

        Project_Skill__c proSkill = new Project_Skill__c (Name='Test SKill',Required_Skill__c=skill.Id, Project_Id__c=testProject.Id);
        insert proSkill;

        Test.startTest();
        List<Project__c> projects = EmployeeBrowserForm.getProjects();
        List<Project_Skill__c> emp = EmployeeBrowserForm.getProjectSkills('');
        List<Project_Skill__c> emp1 = EmployeeBrowserForm.getProjectSkills(proId);
        Test.stopTest();


        System.assertEquals(1, projects.size(),'ERROR: Expected only 1 records');
        System.assertEquals(0, emp.size(),'ERROR: Expected null records');
        System.assertEquals(1, emp1.size(),'ERROR: Expected only 1 records');

    }
}
