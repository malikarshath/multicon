@isTest
public with sharing class EmployeeBrowser_Test {
    @isTest
    static void EmployeeBrowser_Test() {

        List<Project_Skill__c> proSkillLi = new List<Project_Skill__c>();
        List<Employee_Skill__c> empSkillLi = new List<Employee_Skill__c>();
        List<Project_Assignment__c> proAssignLi = new List<Project_Assignment__c>();
        List<Employee__c> empLi = new List<Employee__c>();
       
   

        Account acct = new Account(Name='Test Account',organization_Email__c='test@gmail.com');
        insert acct;

        Opportunity oppo = new Opportunity(AccountId=acct.Id,StageName='Proposal/Price Quote',Required_Skills__c='Java;Mongo DB;Selenium',RecordTypeId='0120w000000EpZIAA0',CloseDate=date.valueOf('2022-08-31'),Amount=3000000.00,Duration__c=120,Name='Test oppo');
        insert oppo;

        Project__c testProject = new Project__c (Project_Name__c = 'TestProject',Stage__c = 'Draft',Account__c=acct.Id,Opportunity__c=oppo.Id);
        insert testProject;
        
        Skill__c skill = new Skill__c(Name='unit Testing');
        insert skill;

        Project_Skill__c proSkill = new Project_Skill__c (Name='Test SKill',Required_Skill__c=skill.Id, Project_Id__c=testProject.Id);
        insert proSkill;
        proSkillLi.add(proSkill);

        Employee__c emp = new Employee__c(Name='Milan',Email__c='milan21@gmail.com',Proof_ID_Type__c='Aadhar Number',Employee_ID__c= 53045,
        ID_Number__c='123412341234',Contact_Number__c='6326330181',Availability__c=True);
        insert emp;
        empLi.add(emp);
        Employee__c emp1 = new Employee__c(Name='test',Email__c='test@gmail.com',Proof_ID_Type__c='Aadhar Number',Employee_ID__c= 53046,
        ID_Number__c='123412341234',Contact_Number__c='6326330181',Availability__c=True);
        insert emp1;
        empLi.add(emp1);


        Employee_Skill__c empSkill = new Employee_Skill__c(Employee_Name__c=emp.id,Skill_of_Employee__c=skill.id);
        insert empSkill;
        empSkillLi.add(empSkill);
        Employee_Skill__c empSkill1 = new Employee_Skill__c(Employee_Name__c=emp1.id,Skill_of_Employee__c=skill.id);
        insert empSkill1;
        empSkillLi.add(empSkill1);
        


        Project_Assignment__c projectassign = new Project_Assignment__c(Project_Id__c = testProject.id,Employee_Name__c =emp.id,Status__c ='Draft');
        insert projectassign;
        proAssignLi.add(projectassign);

        String proid = testProject.Id;
        String proskillid = proSkill.Id; 
        String emplid = emp1.Id;
        


        Test.startTest();

        List<Employee__c> empResult = EmployeeBrowser.getEmployees(proid,proskillid);
        List<Employee__c> empResult1 = EmployeeBrowser.getEmployees(proid,'');
        List<Employee__c> empResult2 = EmployeeBrowser.getEmployees('','');
        EmployeeBrowser.createProjectAssignment(proid,proskillid,emplid);
        List<Project_Assignment__c> proAssignRe = [SELECT Id, Name FROM Project_Assignment__c];
       
   
        Test.stopTest();


        System.assertEquals(1, empResult.size(),'ERROR: Expected only 1 records');
        System.assertEquals(1, empResult1.size(),'ERROR: Expected only 1 records');
        System.assertEquals(2, empResult2.size(),'ERROR: Expected only 1 records');
        System.assertEquals(2, proAssignRe.size(),'ERROR: Expected only 1 records');
        
        

    }
}