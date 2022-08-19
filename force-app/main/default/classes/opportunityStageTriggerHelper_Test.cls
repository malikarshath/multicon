@isTest
private class opportunityStageTriggerHelper_Test {
    @isTest
    static void opportunityStageTriggerHelper_Test() {

        List<Opportunity> opportunities = new List<Opportunity>();
        Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>();
        List<Skill__c> skillLi = new List<Skill__c>();

        Skill__c skill = new Skill__c(Name='unit Testing');
        insert skill;
        skillLi.add(skill);
        Skill__c skill1 = new Skill__c(Name='Java');
        insert skill1;
        skillLi.add(skill1);
        Skill__c skill2 = new Skill__c(Name='Mongo DB');
        insert skill2;
        skillLi.add(skill2);
        Skill__c skill3 = new Skill__c(Name='Selenium');
        insert skill3;
        skillLi.add(skill3);
        

        Account acct = new Account(Name='Test Account',organization_Email__c='test@gmail.com');
        insert acct;

        Opportunity oppo = new Opportunity(AccountId=acct.Id,StageName='Estimation',Required_Skills__c='Java;Mongo DB;Selenium',RecordTypeId='0120w000000EpZIAA0',CloseDate=date.valueOf('2022-08-31'),Amount=3000000.00,Duration__c=120,Name='Test oppo',No_of_Required_Employees__c=3);
        insert oppo;
        oldMap.put(oppo.Id,oppo);
        
        oppo.StageName='Proposal/Price Quote';
        update oppo;
        opportunities.add(oppo);




        Test.startTest();
        opportunityStageTriggerHelper.opportunityStageTriggerHelper(opportunities,oldMap);
        List<Project__c> project = [SELECT Id,Account__c,Opportunity__c,Budget__c,Project_Name__c,Stage__c,Start_Date__c,Duration_days__c FROM Project__c ];
        List<Project_Skill__c> proSkill = [SELECT Name, Project_Id__c,Required_Skill__c FROM Project_Skill__c];
        Test.stopTest();

        System.assertEquals(1, project.size(),'ERROR: Expected only 1 records');
        System.assertEquals(3, proSkill.size(),'ERROR: Expected only 3 records');
       
    }
    
     @isTest
    static void opportunityStageTriggerHelper_Test3() {

        List<Opportunity> opportunities = new List<Opportunity>();
        Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>();

        Skill__c skill = new Skill__c(Name='JavaScript');
        insert skill;

        Employee__c emp = new Employee__c(Name='Erik Marsh',Email__c='emarsh@multicon.com',Proof_ID_Type__c='Aadhar Number',Employee_ID__c=53006,ID_Number__c='123412341234',Contact_Number__c='6326330181',Availability__c=True);
        insert emp;

        Employee_Skill__c empSkill = new Employee_Skill__c(Employee_Name__c=emp.Id,Skill_of_Employee__c=skill.Id);
        insert empSkill;
        
    
        Account acct3 = new Account(Name='Test Account2',organization_Email__c='test2@gmail.com');
        insert acct3;

        Opportunity oppo3 = new Opportunity(AccountId=acct3.Id,StageName='Proposal/Price Quote',Required_Skills__c='Java;Mongo DB;Selenium',RecordTypeId='0120w000000EpZIAA0',CloseDate=date.valueOf('2022-08-31'),Amount=3000000.00,Duration__c=120,Name='Test oppo',No_of_Required_Employees__c=3);
        insert oppo3;
        

        Project__c testProject3 = new Project__c (Project_Name__c = oppo3.Name,Stage__c = 'Draft',Account__c=acct3.Id,Opportunity__c=oppo3.Id);
        insert testProject3;

        Project_Skill__c proSkill = new Project_Skill__c (Name='Test SKill2',Required_Skill__c=skill.Id, Project_Id__c=testProject3.Id);
        insert proSkill;

        Project_Assignment__c proAssi = new Project_Assignment__c(Project_Id__c=testProject3.Id,Status__c='Draft',Employee_Name__c=emp.Id,Skill__c=skill.Id);
        insert proAssi;

        oppo3.Project__c = testProject3.Id;
        oppo3.StageName='Negotiation';
        update oppo3;
        oldMap.put(oppo3.Id,oppo3);
        

        oppo3.StageName='Closed/Lost';
        update oppo3;
        opportunities.add(oppo3);


        Test.startTest();
        opportunityStageTriggerHelper.opportunityStageTriggerHelper(opportunities,oldMap);
        List<Project__c> project = [SELECT Id,Account__c,Opportunity__c,Budget__c,Project_Name__c,Stage__c,Start_Date__c,Duration_days__c FROM Project__c ];
        Test.stopTest();


        System.assertEquals(1, project.size(),'ERROR: Expected same stage');

        System.assertEquals('Cancelled', project[0].Stage__c,'ERROR: Expected same stage');
    }
    
}

