trigger projectSkill on Project_Skill__c (after insert) {
    projectSkillHelper.projectSkillHelper(Trigger.new);

}