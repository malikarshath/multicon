trigger opportunityStage on Opportunity (after update) {
    opportunityStageTriggerHelper.opportunityStageTriggerHelper(Trigger.new,Trigger.oldMap);

}