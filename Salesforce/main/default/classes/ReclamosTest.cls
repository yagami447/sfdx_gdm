@istest (seeAllData=true)
    private class ReclamosTest {
        static testmethod void theTest(){
            Case reclamoPrueba = New Case();
            Case pdfPrueba = New Case();
            User duenioReclamo = New User();
            Account cuenta = New Account();
            Contact contactoR = New Contact();
            Cidade__c CiudadTest = New Cidade__c();
            
            duenioReclamo = [SELECT Id FROM User WHERE isActive = true and Usuario_Reclamos__c like '%Fernando%' limit 1];
            cuenta = [SELECT Id FROM Account WHERE Name = 'ACME' limit 1];
            contactoR = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Tiago Goulart' limit 1];
            CiudadTest = [SELECT Id FROM Cidade__c WHERE Name = 'PASSO FUNDO' limit 1];
            reclamoPrueba.Responsavel__c = '061 - Fernando Frehner';
            reclamoPrueba.Responsavel_pelo_atendimento__c = duenioReclamo.Id;
            reclamoPrueba.OwnerId = duenioReclamo.Id;
            reclamoPrueba.Marca__c = 'BRASMAX';
            reclamoPrueba.ContactId = contactoR.Id;
            reclamoPrueba.AccountId = cuenta.Id;
            reclamoPrueba.Ciudad_del_Problema__c = CiudadTest.Id;
            
            insert reclamoPrueba;

            PdfGeneratorController.savePdfReclamo(reclamoPrueba.Id, 'TestPdf');
            ApexPages.StandardController sc = new ApexPages.standardController(reclamoPrueba);
            PdfGeneratorController myPage = new PdfGeneratorController(sc);            
                    
            PageReference pageRef = Page.PdfGeneratorReclamo;
            pageRef.getParameters().put('id', String.valueOf(reclamoPrueba.Id));
            Test.setCurrentPage(pageRef);
            
            myPage.getReclamo();
            
            reclamosController.Asignar(reclamoPrueba.Id, duenioReclamo.Id);
            reclamosController.reclamoAEdicion(reclamoPrueba.Id, true);
        }
            
        static testmethod void theTest1(){
            Case reclamoPrueba = New Case();
            User duenioReclamo = New User();
            Account cuenta = New Account();
            Contact contactoR = New Contact();
            RecordType rt = New RecordType();
            
            duenioReclamo = [SELECT Id FROM User WHERE Name = 'Patricia Ueno' limit 1];
            cuenta = [SELECT Id FROM Account WHERE Name = 'ACME' limit 1];
            contactoR = [SELECT Id FROM Contact WHERE Usuario_Reclamos__c = 'Tiago Goulart' limit 1];
            rt = [SELECT Id, Name FROM RecordType WHERE Name = 'Reclamo Venda Basica' limit 1];
            reclamoPrueba.OwnerId = duenioReclamo.Id;
            reclamoPrueba.Marca__c = 'BRMX';
            reclamoPrueba.ContactId = contactoR.Id;
            reclamoPrueba.AccountId = cuenta.Id;
            reclamoPrueba.Reason = 'Atraso';
            reclamoPrueba.RecordTypeId = rt.Id;
            reclamoPrueba.Status = 'Aberta';
            reclamoPrueba.Description = 'Lalalalala';
            reclamoPrueba.Data_do_problema__c = System.today();
            
            //insert reclamoPrueba;
            
            reclamoPrueba.Respuesta__c = 'dsdfskfhkshfkjshfjks';
            reclamoPrueba.Data_da_solu_o_do_caso__c = System.today();
            reclamoPrueba.Status = 'Fechada';
            
            //update reclamoPrueba;            
            
        }   
    }