@isTest
public class TestAddOpportunityLineItemController {
    @istest public static void test(){
                Account acc = new Account(Name = 'Teste');
                acc.Responsavel_NEOGEN__c = '020 - Eduardo L. da Silva';
                insert acc;
                Contrato__c cont = new Contrato__c();
                cont.Multiplicador__c = acc.Id;
                cont.Safra__c = '19/20';
                cont.Sociedad__c = 'NEOG';
                insert cont;
                Product2 prod = new Product2(Name = 'Test');
                prod.IsActive = true;
                prod.Obtentor__c = 'Bayer';
                insert prod;
                Item_del_Contrato__c icon = new Item_del_Contrato__c();
                icon.Cultivar__c = prod.Id;
                icon.Contrato_de_Multiplicacion__c = cont.Id;
                insert icon;
                Opportunity opp = new Opportunity(Name = 'Test', CloseDate = System.Today(), StageName = 'Edición', AccountId = acc.Id, Marca__c = 'NEOG', Safra__c = '18/19');
                insert opp;
                AddOpportunityLineItemController.getTheOpportunity(opp.Id);
                AddOpportunityLineItemController.getNeedBasedOnOpportunity(opp.Id);
                AddOpportunityLineItemController.getOptionCategoria();
                AddOpportunityLineItemController.getStates();
                AddOpportunityLineItemController.getConfigurationBMX(opp.Id);
                AddOpportunityLineItemController.getFields(opp.Id);
                AddOpportunityLineItemController.validarOfertaSAP(opp.Id);
                AddOpportunityLineItemController.getUsers();
                List<PricebookEntry> prods = AddOpportunityLineItemController.updateAvailableList(opp.Id, '%');
                OpportunityLineItem listas = null;
                if(prods.size() > 0){
                    listas = AddOpportunityLineItemController.addToShoppingCart(opp.Id, prods.get(0),0.0);
                }
                if(listas != null)AddOpportunityLineItemController.saveShoppingCart(opp.Id, new List<OpportunityLineItem>{listas});
                AddOpportunityLineItemController.saveOpportunity(opp.Id);
                if(listas != null)AddOpportunityLineItemController.RemoveFromShoppingCart(opp.Id, new List<OpportunityLineItem>{listas});
        }
}