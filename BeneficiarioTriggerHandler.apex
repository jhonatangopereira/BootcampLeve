public class BeneficiarioTriggerHandler {
    public static void BeneficiarioValidateFields(Beneficiario__c benef) {
        try {
            Date birthDay = benef.Data_de_nascimento__c;
            String benefType = String.valueOf(benef.Tipo_de_Beneficiario__c);
            String CPF = String.valueOf(benef.CPF__c);
            String dueDay = String.valueOf(benef.Dia_do_vencimento__c);
            String paymentType = String.valueOf(benef.Tipo_de_pagamento__c);
            
            if (benefType.equals('Titular') || benefType.equals('Responsável Pagante')) {
                if (String.isBlank(CPF))
                	benef.CPF__c.addError('O campo CPF é obrigatório preenchimento se o Tipo de beneficário for Titular ou Responsável pagante!');
                if (benefType.equals('Responsável Pagante')) {
                    if (String.isBlank(dueDay))
                    	benef.Dia_do_vencimento__c.addError('Você precisa preencher o campo Dia de vencimento!');
                    if (String.isBlank(paymentType))
                        benef.Tipo_de_pagamento__c.addError('Você precisa preencher o campo Tipo de pagamento!');
                    if (birthDay.daysBetween(Date.today()) / 365 < 18)
                        benef.Data_de_nascimento__c.addError('Você precisa ter mais de 18 anos para ser Responsável pagante!');
                }
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    
    public static void BeneficiarioInsert(Beneficiario__c benef) {
        Pagamento__c payment = new Pagamento__c(Beneficiario__c=benef.Id);
        payment.Tipo_de_pagamento__c = benef.Tipo_de_pagamento__c;
        payment.Dia_do_vencimento__c = benef.Dia_do_vencimento__c;
       	try {
            insert payment;
        } catch (DmlException e) {
            System.debug(e);
        }
    }
    
    public static void BeneficiarioUpdate(Beneficiario__c benef) {
        Pagamento__c paymentToUpdate = [SELECT Id FROM Pagamento__c
                                        WHERE Beneficiario__c =: benef.Id LIMIT 1];
        paymentToUpdate.Dia_do_vencimento__c = benef.Dia_do_vencimento__c;
        paymentToUpdate.Tipo_de_pagamento__c = benef.Tipo_de_pagamento__c;
        try {
            update paymentToUpdate;
        } catch (DmlException e) {
            System.debug(e);
        }
    }
}
