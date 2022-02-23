@isTest
public class NotaFiscalElectronicaTriggerTest {

    @isTest
    static void aContactWithNotasFiscalesWithProductsShouldDoTheCountingCorrectly() {
        Contact c = new Contact(
        	LastName = 'test'
        );
        insert c;
        
        List<Nota_Fiscal_Eletr_nica__c> notasFiscales = new List<Nota_Fiscal_Eletr_nica__c>();
        notasFiscales.add(new Nota_Fiscal_Eletr_nica__c(
        	Vendedor__c = c.Id,
            NFe__c = '1234'
        ));
        notasFiscales.add(new Nota_Fiscal_Eletr_nica__c(
            Vendedor__c = c.Id,
            NFe__c = '1235'
        ));
        notasFiscales.add(new Nota_Fiscal_Eletr_nica__c(
            Vendedor__c = c.Id,
            NFe__c = '1236'
        ));
        insert notasFiscales;
        
        List<Produto_da_nota_fiscal__c> productos = new List<Produto_da_nota_fiscal__c>();
        productos.add(new Produto_da_nota_fiscal__c(
        	Valor_Bonificacao__c = 50,
            Quantidade_KG__c = 120,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[0].Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 20,
            Quantidade_KG__c = 80,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[0].Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 20,
            Quantidade_KG__c = 20,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[1].Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 40,
            Quantidade_KG__c = 40,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[1].Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 70,
            Quantidade_KG__c = 70,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[1].Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 100,
            Quantidade_KG__c = 300,
            Nota_Fiscal_Eletr_nica__c = notasFiscales[2].Id
        ));
        
        Test.startTest();
        insert productos;
        Test.stopTest();
        
        Map<Id, Nota_Fiscal_Eletr_nica__c> notasFiscalesMap = new Map<Id, Nota_Fiscal_Eletr_nica__c>([
            SELECT Quantidade_KG_Total_NF__c, Valor_Total_Bonificacao_NF__c
            FROM Nota_Fiscal_Eletr_nica__c
            WHERE Id IN :notasFiscales
        ]);
        
        System.assertEquals(200, notasFiscalesMap.get(notasFiscales[0].Id).Quantidade_KG_Total_NF__c);
        System.assertEquals(70, notasFiscalesMap.get(notasFiscales[0].Id).Valor_Total_Bonificacao_NF__c);
        System.assertEquals(130, notasFiscalesMap.get(notasFiscales[1].Id).Quantidade_KG_Total_NF__c);
        System.assertEquals(130, notasFiscalesMap.get(notasFiscales[1].Id).Valor_Total_Bonificacao_NF__c);
        System.assertEquals(300, notasFiscalesMap.get(notasFiscales[2].Id).Quantidade_KG_Total_NF__c);
        System.assertEquals(100, notasFiscalesMap.get(notasFiscales[2].Id).Valor_Total_Bonificacao_NF__c);
        
        c = [
            SELECT Valor_Total_Bonificacao_DMValoriza__c, Quantidade_KG_Total_DMValoriza__c,
            	Total_NFe__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        
        System.assertEquals(3, c.Total_NFe__c);
        System.assertEquals(630, c.Quantidade_KG_Total_DMValoriza__c);
        System.assertEquals(300, c.Valor_Total_Bonificacao_DMValoriza__c);
    }
    
    @isTest
    static void ifAContactHas1NotaElectronicaAndIsEliminatedTheCountersShouldUpdateTo0() {
        Contact c = new Contact(
        	LastName = 'test'
        );
        insert c;
        
        Nota_Fiscal_Eletr_nica__c notaFiscal = new Nota_Fiscal_Eletr_nica__c(
        	Vendedor__c = c.Id,
            NFe__c = '1234'
        );
        insert notaFiscal;
        
        List<Produto_da_nota_fiscal__c> productos = new List<Produto_da_nota_fiscal__c>();
        productos.add(new Produto_da_nota_fiscal__c(
        	Valor_Bonificacao__c = 50,
            Quantidade_KG__c = 50,
            Nota_Fiscal_Eletr_nica__c = notaFiscal.Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 1000,
            Quantidade_KG__c = 120,
            Nota_Fiscal_Eletr_nica__c = notaFiscal.Id
        ));
        productos.add(new Produto_da_nota_fiscal__c(
            Valor_Bonificacao__c = 330,
            Quantidade_KG__c = 200,
            Nota_Fiscal_Eletr_nica__c = notaFiscal.Id
        ));
        insert productos;
        
        c = [
            SELECT Valor_Total_Bonificacao_DMValoriza__c, Quantidade_KG_Total_DMValoriza__c,
            	Total_NFe__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        
        System.assertEquals(1, c.Total_NFe__c);
        System.assertEquals(370, c.Quantidade_KG_Total_DMValoriza__c);
        System.assertEquals(1380, c.Valor_Total_Bonificacao_DMValoriza__c);
        
        Test.startTest();
        delete notaFiscal;
        Test.stopTest();
        
        c = [
            SELECT Valor_Total_Bonificacao_DMValoriza__c, Quantidade_KG_Total_DMValoriza__c,
            	Total_NFe__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        
        System.assertEquals(0, c.Total_NFe__c);
        System.assertEquals(0, c.Quantidade_KG_Total_DMValoriza__c);
        System.assertEquals(0, c.Valor_Total_Bonificacao_DMValoriza__c);
    }
    
}