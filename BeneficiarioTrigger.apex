trigger BeneficiarioTrigger on Beneficiario__c (before insert, before update, after insert, after update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    	BeneficiarioTriggerHandler.BeneficiarioValidateFields(Trigger.New[0]);
    else if (Trigger.isAfter) {
        if (Trigger.isInsert)
            BeneficiarioTriggerHandler.BeneficiarioInsert(Trigger.New[0]);
        else if (Trigger.isUpdate)
            BeneficiarioTriggerHandler.BeneficiarioUpdate(Trigger.New[0]);
    }
}
