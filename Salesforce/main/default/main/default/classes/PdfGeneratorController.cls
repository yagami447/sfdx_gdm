Global with sharing class PdfGeneratorController {
 
    public ID parentId {get;set;}
    public String pdfName {get;set;}
    public String marca {get;set;}
    public String safra {get;set;}
    public String nombre {get;set;}
    public String cnpj {get;set;}
    public String estCom {get;set;}
    public String fechaCierre {get;set;}
    public String anioCierre {get;set;}
    public Boolean contrato_clonado {get;set;}
    public Boolean lic = false;
    public Boolean aI = false;
    public List<Signatario_do_Contrato__c> firmantes {get;set;}
    
    public String nroContrato {get;set;}  
    public String inscEst {get;set;}
    public String dirUnidade {get;set;}
    public String dirCorrespondencia {get;set;}
    public String cidadeUF {get;set;}
    public String email {get;set;}
    
    public List<Item_del_Contrato__c> itemsVolumen {get;set;}
    public List<Item_del_Contrato__c> itemsPalestras {get;set;}
    public List<Item_del_Contrato__c> itemsLxL {get;set;}
    public List<Item_del_Contrato__c> itemsIdentif {get;set;}
    public List<Item_del_Contrato__c> itemsAreaEnsaios {get;set;}
    public List<Item_del_Contrato__c> itemsDiasCampo {get;set;}
    public List<metasContrato> itemsMetas {get;set;}
    public Boolean TA_hayCoop {get;set;}
    public Boolean TA_haySyM {get;set;}
    public Boolean TA_hayDolar {get;set;}
    public String ref_Coop {get;set;}
    public String ref_SyM {get;set;}
    public String ref_Dolar {get;set;}
    
    public Map<String, String> totalesAnexos {get;set;}
    
    public class metasContrato{
        public String nombre{get;set;}	 	
        public String tipo{get;set;}
        public String cantidad{get;set;}
    }
    
    WebService static void impresionContratoGuardaChuva(String idContrato){
        
        Contract c = [Select Id, ContractNumber, Account.Name, Sociedad__c From Contract Where id = : idContrato];
        
        PageReference pdf = Page.pdfContratoGuardaChuva;
        if (c.Sociedad__c == 'DSEM')
            pdf = Page.pdfContratoGuardaChuvaDSEM;
          pdf.getParameters().put('id', idContrato);
          pdf.getParameters().put('nroCont', c.ContractNumber);
                  
          Attachment attach = new Attachment();
          
          Blob body;
   
        try {
              body = pdf.getContent();          
        }catch (VisualforceException e){
            body = Blob.valueOf('Some Text');
        }  	  
   
        attach.Body = body;
        attach.Name = c.Sociedad__c + '_' + c.Account.Name + '.pdf';
        attach.IsPrivate = false;
        attach.ParentId = idContrato;
        insert attach;
                               
        List<ProcessInstance> proceso = New List<ProcessInstance>();
        proceso = [Select Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) From ProcessInstance Where TargetObjectId = :c.Id And Status = 'Pending'];
        if (proceso.size() > 0){   	      	  
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            //req.setComments('Approving request.');
            req.setAction('Approve'); //This is the action that is approve in your case, you can set it to Reject also
            req.setWorkitemId(proceso[0].WorkItems[0].Id);  
            
            //Puede q el paso de aprobacion tenga 2 aprobadores posibles, en ese caso hay q setear el q corresponde al usuario si no da error.
            Integer i = 0;
            for(ProcessInstanceWorkItem  w : proceso[0].WorkItems){
                if (w.ActorId == UserInfo.getUserId())
                    req.setWorkitemId(proceso[0].WorkItems[i].Id);
                i++;	
            }       
            Approval.ProcessResult result =  Approval.process(req);
        } 
        
    }
    
    WebService static void impresionContratoTA(String idContrato){
        
        Contrato__c c = [Select Id, Multiplicador__r.Name,RecordType.DeveloperName, Sociedad__c, Safra__c, Region_Comercial__c, Contrato_ant__c, Contrato_ant__r.Name From Contrato__c Where id = : idContrato];
  
        PageReference pdf;
        
        if (c.RecordType.DeveloperName != 'Termo_Aditivo_Lan_amentos') {
            if (c.Sociedad__c == 'BRMX' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
                pdf = Page.pdfContratoTA_BRMX_Sul;      
            if (c.Sociedad__c == 'BRMX' && c.Region_Comercial__c == 'CERRADO')
                pdf = Page.pdfContratoTA_BRMX_Cerrado;
            if (c.Sociedad__c == 'DSEM' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
                pdf = Page.pdfContratoTA_DSEM_Sul;      
            if (c.Sociedad__c == 'DSEM' && c.Region_Comercial__c == 'CERRADO')
                pdf = Page.pdfContratoTA_DSEM_Cerrado;
            if (c.Sociedad__c == 'NEOG' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
                pdf = Page.pdfContratoTA_NEOG_Sul;	 
            if (c.Sociedad__c == 'NEOG' && c.Region_Comercial__c == 'CERRADO')
                  pdf = Page.pdfContratoTA_NEOG_Cerrado;	
        } else {
            if (c.Sociedad__c == 'BRMX' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
                pdf = Page.pdfContratoTAL_BRMX_Sul_Biotec;      
            if (c.Sociedad__c == 'BRMX' && c.Region_Comercial__c == 'CERRADO')
                pdf = Page.pdfContratoTAL_BRMX_Cerrado_Biotec; 
            if (c.Sociedad__c == 'DSEM')
                pdf = Page.pdfContratoTAL_DM_Cerrado_Biotec;      
            if (c.Sociedad__c == 'NEOG')
                pdf = Page.pdfContratoTAL_NEOG_Biotec;	 
        }
              
        
          pdf.getParameters().put('id', idContrato);
                  
          Attachment attach = new Attachment();
          
          Blob body;
   
        try {
              body = pdf.getContent();          
        }catch (VisualforceException e){
            body = Blob.valueOf('Some Text');
        }  	  
   
        attach.Body = body;
        attach.Name = c.Sociedad__c + '_' + c.Safra__c + ' ' + c.Multiplicador__r.Name + '.pdf';
        attach.IsPrivate = false;
        attach.ParentId = idContrato;
        insert attach;
                               
        List<ProcessInstance> proceso = New List<ProcessInstance>();
        proceso = [Select Id, (SELECT Id, ActorId, ProcessInstanceId FROM Workitems) From ProcessInstance Where TargetObjectId = :idContrato And Status = 'Pending'];
        if (proceso.size() > 0){   	      	        	
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            //req.setComments('Approving request.');
            req.setAction('Approve'); //This is the action that is approve in your case, you can set it to Reject also
            req.setWorkitemId(proceso[0].WorkItems[0].Id);         
            Approval.ProcessResult result =  Approval.process(req);                   
        } 
        
    }
    
    public void initImpresionContratoGuardaChuva(){
        
        String idContrato = apexpages.currentpage().getparameters().get('id');
        
        Contract c = [Select Id,Account.Email__c, ContractNumber, Account.Name, Account.Nome_fantasia__c, Account.CNPJ_CPF__c, Account.IE__c, Account.ShippingStreet, Account.Shippingcity, Account.ShippingPostalCode, Account.ShippingState, Account.ShippingCountry, Account.BillingCity, Account.BillingStreet, Account.BillingPostalCode, Account.BillingState, Account.BillingCountry From Contract Where id = : idContrato];      
        nroContrato = c.ContractNumber;
        nombre = c.Account.Name;      
        email = c.Account.Email__c;
        cnpj = c.Account.CNPJ_CPF__c;
        inscEst = c.Account.IE__c;
        if (c.Account.ShippingStreet == null)
              c.Account.ShippingStreet = '';
        if (c.Account.ShippingPostalCode == null)
              c.Account.ShippingPostalCode = ''; 	  
        if (c.Account.ShippingCity == null)
              c.Account.ShippingCity = '';	  
        if (c.Account.ShippingState == null)
              c.Account.ShippingState = '';	  
        if (c.Account.BillingStreet == null)
              c.Account.BillingStreet = '';	  
        if (c.Account.BillingPostalCode == null)
              c.Account.BillingPostalCode = '';	  
        if (c.Account.BillingCity == null)
              c.Account.BillingCity = '';	  
        if (c.Account.BillingState == null)
              c.Account.BillingState = '';	  
        dirUnidade = c.Account.ShippingStreet + ' ' + c.Account.ShippingPostalCode + ' ' +  c.Account.ShippingCity + ' ' +  c.Account.ShippingState;      
        dirCorrespondencia = c.Account.BillingStreet + ' ' + c.Account.BillingPostalCode + ' ' +  c.Account.BillingCity + ' ' +  c.Account.BillingState;
        
        firmantes = new List<Signatario_do_Contrato__c>();
        for(Signatario_do_Contrato__c record: [SELECT Contacto__r.Name, Contacto__r.Title, Contacto__r.CNPJ_CPF_c__c FROM Signatario_do_Contrato__c WHERE Contrato__c =: idContrato AND contrato__r.Tipo_de_Assinatura__c= 'Eletronica']){
              firmantes.add(record);
        }
    }
    
    public void initImpresionContratoTA(){
         
          String idContrato = apexpages.currentpage().getparameters().get('id');
          
          itemsVolumen = New List<Item_del_Contrato__c>();
          itemsPalestras = New List<Item_del_Contrato__c>();
          itemsLxL = New List<Item_del_Contrato__c>();
          itemsIdentif = New List<Item_del_Contrato__c>();
          itemsMetas = New List<metasContrato>();
          
          String qry = '';
          List<Item_del_Contrato__c> itemsCont = New List<Item_del_Contrato__c>(); 
                  
          Contrato__c cont = [Select Id, Sociedad__c, Volume_Total_Autorizado__c, Meta_Qde_Treinamentos__c, Meta_Qde_Dias_de_Campo__c, Meta_Qde_comodato_de_area__c, Multiplicador__r.Name, Multiplicador__r.Nome_fantasia__c, Multiplicador__r.CNPJ_CPF__c, Multiplicador__r.IE__c, Multiplicador__r.ShippingStreet, Multiplicador__r.Shippingcity, Multiplicador__r.ShippingPostalCode, Multiplicador__r.ShippingState, Multiplicador__r.ShippingCountry, Multiplicador__r.BillingCity, Multiplicador__r.BillingStreet, Multiplicador__r.BillingPostalCode, Multiplicador__r.BillingState, Multiplicador__r.BillingCountry, Contrato_ant__c, Contrato_ant__r.Name From Contrato__c Where Id = : idContrato];
          nombre = cont.Multiplicador__r.Name;      
        cnpj = cont.Multiplicador__r.CNPJ_CPF__c;
        inscEst = cont.Multiplicador__r.IE__c;
        marca = cont.Sociedad__c;
        contrato_clonado = cont.Contrato_ant__c != null;
        
        if (cont.Multiplicador__r.ShippingStreet == null)
              cont.Multiplicador__r.ShippingStreet = '';
        if (cont.Multiplicador__r.ShippingPostalCode == null)
              cont.Multiplicador__r.ShippingPostalCode = '';	  
        if (cont.Multiplicador__r.ShippingCity == null)
              cont.Multiplicador__r.ShippingCity = '';	  
        if (cont.Multiplicador__r.ShippingState == null)
              cont.Multiplicador__r.ShippingState = '';	  
        if (cont.Multiplicador__r.ShippingCountry == null)
              cont.Multiplicador__r.ShippingCountry = '';	  
        dirUnidade = cont.Multiplicador__r.ShippingStreet + ' ' + cont.Multiplicador__r.ShippingPostalCode;
        cidadeUF = cont.Multiplicador__r.ShippingCity + ' ' + cont.Multiplicador__r.ShippingState;              	  
          
          metasContrato m = New metasContrato();
          m.nombre = 'Volume Total Autorizado para Comercialização';
          m.tipo = 'Comercialização';  	  
          m.cantidad = String.valueOf(cont.Volume_Total_Autorizado__c.format()) + ',00';  	    	     
          itemsMetas.add(m);
          
          if (cont.Sociedad__c == 'BRMX'){
              metasContrato m2 = New metasContrato();
              m2.nombre = 'Treinamentos';
              m2.tipo = 'Geração de demanda';
              if (cont.Meta_Qde_Treinamentos__c != null)m2.cantidad = String.valueOf(cont.Meta_Qde_Treinamentos__c.format());  	      
                itemsMetas.add(m2);
          }
          
          if (cont.Sociedad__c == 'DSEM'){
              metasContrato m8 = New metasContrato();
              m8.nombre = 'Comodato de Área e Ensaios de Manejo';
              m8.tipo = 'Ações Eletivas';
              if (cont.Meta_Qde_comodato_de_area__c != null) m8.cantidad = String.valueOf(cont.Meta_Qde_comodato_de_area__c.format());  	      
                itemsMetas.add(m8);
          }
          
          if (cont.Sociedad__c == 'DSEM'){
              metasContrato m9 = New metasContrato();
              m9.nombre = 'Dia de Campo Sem Custo';
              m9.tipo = 'Ações Eletivas';
              if (cont.Meta_Qde_Dias_de_Campo__c != null)m9.cantidad = String.valueOf(cont.Meta_Qde_Dias_de_Campo__c.format());  	      
                itemsMetas.add(m9);
          }
          
          metasContrato m3 = New metasContrato();
          m3.nombre = 'Palestras';
          m3.tipo = 'Geração de demanda';
          if (cont.Sociedad__c == 'DSEM')
              m3.tipo = 'Ações Eletivas';
          m3.cantidad = null;  	      
          itemsMetas.add(m3);
          
          metasContrato m4 = New metasContrato();
          m4.nombre = 'Lado a Lado (LxL)';
          m4.tipo = 'Geração de demanda';
          if (cont.Sociedad__c == 'DSEM')
              m4.tipo = 'Ações Eletivas';	
          m4.cantidad = null;  	      
          itemsMetas.add(m4);
          
          metasContrato m5 = New metasContrato();
          m5.nombre = 'Identificação das Cultivares Brasmax nas Rodovias';
          m5.tipo = 'Geração de demanda';
          if (cont.Sociedad__c == 'DSEM'){
              m5.nombre = 'Identificação das Cultivares DonMario nas Rodovias';
              m5.tipo = 'Ações Eletivas';  	      
          }
          m5.cantidad = null;  	      
          itemsMetas.add(m5);
          
          if (cont.Sociedad__c == 'BRMX'){
              metasContrato m6 = New metasContrato();
              m6.nombre = 'Controle de Estoque';
              m6.tipo = 'Relacionamento';
              m6.cantidad = null;  	      
              itemsMetas.add(m6);
          
              metasContrato m7 = New metasContrato();
              m7.nombre = 'CRM';
              m7.tipo = 'Relacionamento';
              m7.cantidad = null;  	      
              itemsMetas.add(m7);
          }  	  
          
          for (Item_del_Contrato__c i : [Select Id, RecordType.Name, Variedad__r.Name, Variedad__r.Classes_de_Bonificacao__c, Volumen_Aut_Comercializacion__c, Variedad__r.Certificado_de_Protecao__c, Variedad__r.Unidade_Preco__c, Variedad__r.Numero_de_registro__c, Variedad__r.Nombre_de_registro__c, Estado__c, Quantidade__c, Publico_Minimo__c, Tipo_de_Evento__c, Contrato_de_Multiplicacion__r.Estados_Comercializacao__c, Cotacao_de_soja__c, Praca__c, Tipo_de_Referencia__c, Precio__c From Item_del_Contrato__c Where Contrato_de_Multiplicacion__r.Id = : idContrato]){
              if (i.Tipo_de_Evento__c == 'Palestra')
                  itemsPalestras.add(i);	
              if (i.Tipo_de_Evento__c == 'Lado a Lado')
                  itemsLxL.add(i);    
              if (i.Tipo_de_Evento__c == 'Emplacamento')
                  itemsIdentif.add(i);    
              if (i.RecordType.Name == 'Volumen')
                    itemsVolumen.add(i);
          }
          
          Item_del_Contrato__c itmVacio = New Item_del_Contrato__c();  	  
          itmVacio.Estado__c = ' ';
          if (itemsPalestras.size() == 0)
              itemsPalestras.add(itmVacio);    	      		
        if (itemsLxL.size() == 0)
              itemsLxL.add(itmVacio); 	  
        if (itemsIdentif.size() == 0)
              itemsIdentif.add(itmVacio); 	  
          
          TA_hayCoop = false;
          TA_haySyM = false;
          TA_hayDolar = false;
                  
          Integer sym = 1;
          Integer coop = 2;
          Integer dolar = 3;
          
          for (Item_del_Contrato__c i : itemsVolumen){
              if (i.Cotacao_de_soja__c == 'COOPERATIVA')
                  TA_hayCoop = true;	  	    	  
              if (i.Cotacao_de_soja__c == 'SAFRAS & MERCADO')
                  TA_haySyM = true; 
              if (i.Cotacao_de_soja__c == 'DOLAR')
                  TA_hayDolar = true;    
          }
          
          if (!TA_hayCoop)
              dolar --;
          
          if (!TA_haySyM){
                dolar --;
                coop --;	
          }    	
          
          ref_Coop = '1.1.' + String.valueOf(coop); 
          ref_SyM = '1.1.' + String.valueOf(sym);
          ref_Dolar = '1.1.' + String.valueOf(dolar);
          
    }
    
     
    WebService static void savePdfAnexoI(Id opId, String nombreOp, Boolean licencias) {
       PageReference pdf;
      if(licencias){pdf = Page.pdfTemplateAnexoILicencias;}
      else{pdf = Page.PdfGeneratorTemplateAnexoI;}
      
      
      // add parent id to the parameters for standardcontroller
      pdf.getParameters().put('id',opId);
              
      // create the new attachment
      Attachment attach = new Attachment();
   
      // the contents of the attachment from the pdf
      Blob body;
   
      try {
   
          // returns the output of the page as a PDF
          body = pdf.getContent();
   
      // need to pass unit test -- current bug    
      } catch (VisualforceException e) {
          body = Blob.valueOf('Some Text');
      }
      
       Opportunity op = [Select Id, Marca__c, Account.Nome_fantasia__c	From Opportunity Where id = : opId];
   
      attach.Body = body;
      // add the user entered name
      //attach.Name = nombreOp + ' ' + Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day() + '.pdf';
      attach.Name = op.Account.Nome_fantasia__c + '_' + nombreOp + '_' + op.Marca__c + '.pdf';
      attach.IsPrivate = false;
      // attach the pdf to the opportunity
      attach.ParentId = opId;
      insert attach;
   
      // send the user to the account to view results
      //return new PageReference('/'+opId);
      // Envío de mail al contacto del Portal
     //if(!licencias) sendEmailAnexo(opId, attach);
    }
    
      WebService static void savePdfReclamo(Id caseId, String nombreCase) {
       
          PageReference pdf = Page.PdfGeneratorReclamo;
          // add parent id to the parameters for standardcontroller
          pdf.getParameters().put('id',caseId);
                  
          // create the new attachment
          Attachment attach = new Attachment();
       
          // the contents of the attachment from the pdf
          Blob body;
       
          try {
       
              // returns the output of the page as a PDF
              body = pdf.getContent();
       
          // need to pass unit test -- current bug    
          } catch (VisualforceException e) {
              body = Blob.valueOf('Some Text');
          }
       
          attach.Body = body;
          // add the user entered name
          attach.Name = nombreCase + ' ' + Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day() + '.pdf';
          attach.IsPrivate = false;
          // attach the pdf to the opportunity
          attach.ParentId = caseId;
          insert attach;
       
          // send the user to the account to view results
          //return new PageReference('/'+opId);
       
    }
    
        @future(callout=true)
      public static void generateOpportunityDocusignPDFFuture(Id opId, String rtName, Boolean licencias) {
          generateOpportunityDocusignPDF(opId, rtName, licencias);
      }
          
      public static void generateOpportunityDocusignPDF(Id opId, String rtName, Boolean licencias) {
          PageReference pdf;
          if(rtName == 'Anexo II Rebaixamento Sacas') {
              pdf = Page.PdfGeneratorTemplateRebajaSacas;
          } 
          else if(rtName == 'Reembalaje') {
              pdf = Page.pdfTemplateReembalaje;
          } else if(rtName == 'Anexo I') {
              pdf = licencias ? Page.pdfTemplateAnexoILicencias : Page.PdfGeneratorTemplateAnexoI;
          }
          if(pdf != null) {
              pdf.getParameters().put('id', opId);    
              if(!Test.isRunningTest()) {
                  Blob pdfContent = pdf.getContentAsPDF();
                  try {
                      HttpResponse response = Webservice_Docusign.sendContractEnvelope(opId, pdfContent, rtName, 'PDF', null);  
                  } catch(Exception e) {
                      ExceptionManager.saveException(e, 'PdfGeneratorController', 'generateOpportunityDocusignPDF', opId);
                  }
              }
          }  
      }
          
      @future(callout=true)
      public static void generateContratoMultiplicacaoDocusignPDF(Id contratoMultiplicacaoId, String rtName) {
          System.debug('debug 1');
          if(contratoMultiplicacaoId != null) {
              System.debug('debug 2');
              PageReference pdf;
              if(rtName == 'Termo Aditivo' || rtName== 'Termo Aditivo Biotec') {
                  System.debug('debug 3');
                  Contrato__c contratoMultiplicacaoObject;
                  try {
                      System.debug('debug 4');
                      contratoMultiplicacaoObject = [SELECT Id, Sociedad__c, Region_Comercial__c, RecordType.DeveloperName FROM Contrato__c WHERE Id = :contratoMultiplicacaoId];
                  } catch(Exception e) {
                      System.debug('debug 4 bis');
                      contratoMultiplicacaoObject = null;
                      System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Cant SOQL with Id = '+contratoMultiplicacaoId);
                  }
                  if(contratoMultiplicacaoObject != null) {
                      System.debug('debug 5');
                      if (contratoMultiplicacaoObject.RecordType.DeveloperName != 'Termo_Aditivo_Lan_amentos') {
                          if(contratoMultiplicacaoObject.Sociedad__c == 'BRMX') {
                              if(contratoMultiplicacaoObject.Region_Comercial__c == 'CERRADO') {
                                  pdf = Page.pdfContratoTA_BRMX_Cerrado;
                              } else if(contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 1' || contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 2') {
                                  pdf = Page.pdfContratoTA_BRMX_Sul;  
                              }
                          } else if(contratoMultiplicacaoObject.Sociedad__c == 'DSEM') {
                              if(contratoMultiplicacaoObject.Region_Comercial__c == 'CERRADO') {
                                  pdf = Page.pdfContratoTA_DSEM_Cerrado;
                              } else if(contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 1' || contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 2') {
                                  pdf = Page.pdfContratoTA_DSEM_Sul; 
                              }
                          } else if(contratoMultiplicacaoObject.Sociedad__c == 'NEOG') {
                              if(contratoMultiplicacaoObject.Region_Comercial__c == 'CERRADO') {
                                  pdf = Page.pdfContratoTA_NEOG_Cerrado;
                                  //pdf = Page.pdfContratoTAL_DM_CERRADO_Biotec;
                              } else if(contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 1' || contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 2') {
                                  pdf = Page.pdfContratoTA_NEOG_Sul; 
                              }
                          }    
                      } else {
                          System.debug('debug 6');
                          if(contratoMultiplicacaoObject.Sociedad__c == 'BRMX') {
                              if(contratoMultiplicacaoObject.Region_Comercial__c == 'CERRADO') {
                                  pdf = Page.pdfContratoTAL_BRMX_Cerrado_Biotec;
                                  System.debug('debug 7.1');
                              } else if(contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 1' || contratoMultiplicacaoObject.Region_Comercial__c == 'REGION 2') {
                                  System.debug('debug 7');
                                  pdf = Page.pdfContratoTAL_BRMX_Sul_Biotec;  
                                  
                              }
                          } else if(contratoMultiplicacaoObject.Sociedad__c == 'DSEM') {
                              pdf = Page.pdfContratoTAL_DM_Cerrado_Biotec; 
                              System.debug('debug 7.2');
                          } else if(contratoMultiplicacaoObject.Sociedad__c == 'NEOG') {
                              pdf = Page.pdfContratoTAL_NEOG_Biotec; 
                          }
                      } 
                  }
              }
              if(pdf != null) {
                  System.debug(contratoMultiplicacaoId);
                  pdf.getParameters().put('id', contratoMultiplicacaoId);    
                  System.debug(pdf);
                  System.debug('debug 8');
                  if(!Test.isRunningTest()) {
                      System.debug('debug 9');
                      Blob pdfContent;
                      try{
                          pdfContent = pdf.getContentAsPDF();
                      } catch(Exception e) {	
                          System.debug(e + ': ' + e.getMessage());
                      }
                      System.debug('pdfblob ' + pdfContent);
                      HttpResponse response = Webservice_Docusign.sendContractEnvelope(contratoMultiplicacaoId, pdfContent, rtName, 'PDF', null);
                      System.debug('response ' + response);  
                  }
              } else {
                  System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Cant define PDF Contract');
              }
          } else {
              System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Contrato__c is null');
          }
      }
  
      @future(callout=true)
      public static void generateContratoTermoJuridicoDocusignPDF(Id contratoTermoJuridicoId, String rtName) {
          PageReference pdf;
          Contract contratoTermoJuridico;
          System.debug(contratoTermoJuridicoId);
          if(rtName == 'Termo Juridico') {
              contratoTermoJuridico = [
                  SELECT Id, Sociedad__c, Account.Region_Comercial__c, 
                  RecordType.Name 
                  FROM Contract 
                  WHERE Id =:contratoTermoJuridicoId];
              System.debug(contratoTermoJuridico);
              if(contratoTermoJuridico != null) {
                  if(contratoTermoJuridico.Sociedad__c == 'BRMX') {
                      if(contratoTermoJuridico.Account.Region_Comercial__c == 'CERRADO') {
                          pdf = Page.pdfContratoTA_BRMX_Cerrado;
                      } else if(contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 1' || contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 2') {
                          pdf = Page.pdfContratoTA_BRMX_Sul;  
                      }
                  } else if(contratoTermoJuridico.Sociedad__c == 'DSEM') {
                      if(contratoTermoJuridico.Account.Region_Comercial__c == 'CERRADO') {
                          pdf = Page.pdfContratoTA_DSEM_Cerrado;
                      } else if(contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 1' || contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 2') {
                          pdf = Page.pdfContratoTA_DSEM_Sul; 
                      }
                  } else if(contratoTermoJuridico.Sociedad__c == 'NEOG') {
                      if(contratoTermoJuridico.Account.Region_Comercial__c == 'CERRADO') {
                          pdf = Page.pdfContratoTA_NEOG_Cerrado;
                      } else if(contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 1' || contratoTermoJuridico.Account.Region_Comercial__c == 'REGION 2') {
                          pdf = Page.pdfContratoTA_NEOG_Sul; 
                      }
                  }
              }
          }
          if(pdf != null) {
              pdf.getParameters().put('id', contratoTermoJuridicoId);    
              if(!Test.isRunningTest()) {
                  Blob pdfContent = pdf.getContentAsPDF();
                  System.debug('pdfblob ' + pdfContent);
                  HttpResponse response = Webservice_Docusign.sendContractEnvelope(contratoTermoJuridicoId, pdfContent, rtName, 'PDF', null);
                  System.debug('response ' + response);  
              }
          } else {
              System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Cant define PDF Contract');
          }
      }
      
      @future(callout=true)
      public static void generateContratoMacroDocusignPDF(String contractId) {
          System.debug('on PdfGeneratorController.generateContratoMacroDocusignPDF() method. contractId: ' + contractId);
          PageReference pdf;
          String rtName = 'Macro Milho';
          pdf = Page.pdfContratoGuardaChuvaMilho; 
          if(pdf != null) {
              System.debug(contractId);
              pdf.getParameters().put('id', contractId); 
  
              if(!Test.isRunningTest()) {
                  Blob pdfContent;
                  try{
                      pdfContent = pdf.getContentAsPDF();
                  } catch(Exception e) {	
                      System.debug(e + ': ' + e.getMessage());
                  }
                  HttpResponse response = Webservice_Docusign.sendContractEnvelope(contractId, pdfContent, rtName, 'PDF', null);
                  System.debug('response ' + response);  
              }
          } else {
              System.debug('Error in PdfGeneratorController.generateContratoMacroDocusignPDF: Cant define PDF Contract');
          } 
      }
    
    WebService static void ImpresionOpp(Id opId, String nombreOp, String rtName, String marcaOpp, Boolean licencias){
        PageReference pdf=null;
        
        pdf = Page.pdfImpresionOpp;
        
        if(rtName == 'Anexo III')
            pdf = Page.pdfImpresionAnexoIII;  	
        if(rtName == 'Exportacion')
            pdf = Page.pdfTemplate_Exportacion;
        if(rtName == 'Reembalaje')
            pdf = Page.pdfTemplateReembalaje;		
        if(rtName == 'Anexo II Rebaixamento Sacas')
            pdf = Page.PdfGeneratorTemplateRebajaSacas;	
        if(rtName == 'Anexo I Rebaixamento Ha')
            pdf = Page.PdfGeneratorTemplateRebajaHas;	
        if(rtName == 'Anexo II')
            pdf = Page.pdfImpresionOppA2;	
        if(rtName == 'Aquisição Sementes Terceiros')
            pdf = Page.pdfTemplate_Sem_Terceiros;	  	  	
  
      // add parent id to the parameters for standardcontroller
      pdf.getParameters().put('id',opId);
      //pdf.getParameters().put('marcaOpp',marcaOpp);        
      // create the new attachment
      Attachment attach = new Attachment();
   
      // the contents of the attachment from the pdf
      Blob body;
   
      try {
   
          // returns the output of the page as a PDF
          body = pdf.getContent();
   
      // need to pass unit test -- current bug    
      } catch (VisualforceException e) {
          body = Blob.valueOf('Some Text');
      }
      
      Opportunity op = [Select Id, Marca__c, Account.Nome_fantasia__c	From Opportunity Where id = : opId];
   
      attach.Body = body;
      // add the user entered name
      //attach.Name = nombreOp + ' ' + Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day() + '.pdf';
      attach.Name = op.Account.Nome_fantasia__c + '_' + nombreOp + '_' + op.Marca__c + '.pdf';
      attach.IsPrivate = false;
      // attach the pdf to the opportunity
      attach.ParentId = opId;
      attach.Description = rtName;
      insert attach;
   
      // send the user to the account to view results
      //return new PageReference('/'+opId);
      //if(rtName == 'Anexo III' && !licencias) sendEmailAnexo(opId, attach);
    }
    
    public PdfGeneratorController(ApexPages.StandardController controller){
        marca = 'BRMX'; estCom = ''; lic = false; aI = false;
        try{
            Opportunity o = [Select Name, Marca__c, Safra__c, CreatedDate, CNPJ_CPF_Anexo__c, Account.CNPJ_CPF__c, Account.Estado_Comercializacion__c, Owner.Profile.Name, Estados_Comercializacion__c, RecordType.Name, CloseDate, Epoca_de_Plantio__c, Account.Name, Importador__r.Name, Importador__r.BillingCity, Importador__r.BillingState, Importador__r.BillingCountry, Despachante_Aduanero__r.Name, Despachante_Aduanero__r.Representante__c, Cooperante__r.CNPJ_CPF__c From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
          
          marca = o.Marca__c;
            safra = '20'+String.ValueOf(o.Safra__c).left(3)+'20'+String.ValueOf(o.Safra__c).right(2);
            if(o.Epoca_de_Plantio__c == 'Inverno') safra = '20'+String.ValueOf(o.Safra__c).right(2)+'/20'+String.ValueOf(o.Safra__c).right(2);
            nombre = o.Name.left(o.Name.length() - 5);
            fechaCierre = fecha_larga(o.CloseDate);
            anioCierre = anio(o.CreatedDate);
          if(o.Account.CNPJ_CPF__c != null && o.Account.CNPJ_CPF__c != '') cnpj = o.Account.CNPJ_CPF__c;
            if(o.Cooperante__r.CNPJ_CPF__c != null && o.Cooperante__r.CNPJ_CPF__c != '') cnpj = o.Cooperante__r.CNPJ_CPF__c;
            if(o.CNPJ_CPF_Anexo__c != null && o.CNPJ_CPF_Anexo__c != '') cnpj = o.CNPJ_CPF_Anexo__c;
            if(o.Owner.Profile.Name == 'Administrativo_licencias') lic = true;
            if(o.Estados_Comercializacion__c != null) {estCom = o.Estados_Comercializacion__c;}
            else{if(o.Account.Estado_Comercializacion__c != null) estCom = o.Account.Estado_Comercializacion__c; }
            if(o.RecordType.Name == 'Anexo I') aI = true;
            estCom = estCom.deleteWhitespace();
            if(estCom.countMatches(';') > 4){estCom = estCom.left(estCom.IndexOf(';', 12) + 1) + '\r\n' + estCom.right(estCom.length() - estCom.IndexOf(';', 12)-1);}
            
            totalesAnexos = New Map<String, String>();  
            
          
            
        }catch(exception e){}
    }
    
    public String getFecha(){
       return fecha_larga(null);
    }
    public String getAnio(){
         return anio(null);
    }
    
    public String getVariedadesAnexoI(){
       return variedadesAnexoI();
    }
    public String getRutaLogo(){
        String ruta = '';
        
        if(marca == 'DSEM'){
            ruta = 'https://na27.salesforce.com/resource/1380120282000/LogoImpDSEM';	   //Productivo
            //ruta = 'https://cs16.salesforce.com/resource/1379941620000/LogoImpresionDSEM'; //Sandbox
            if(aI) ruta = 'https://na27.salesforce.com/resource/1386010085000/LogoEnBlanco'; //Productivo
            //if(aI) ruta = 'https://cs16.salesforce.com/resource/1386009212000/LogoEnBlanco'; //Sandbox
            
        }else{
            if(lic){
                ruta = 'https://na27.salesforce.com/resource/1386422647000/LogoGDMSeeds'; 	//Productivo
                //ruta = 'https://cs16.salesforce.com/resource/1384787835000/LogoGDMSeeds'; 	//Sandbox
            }else{
                ruta = 'https://na27.salesforce.com/resource/1380120147000/LogoImpBRMX'; 	//Productivo
                //ruta = 'https://cs16.salesforce.com/resource/1379937799000/LogoImpresion'; //Sandbox
            }
        }
        return ruta;
    }
    public String getMarcaImp(){
        String ruta = ''; String retorno = '';
        if(marca == 'DSEM'){
            ruta = 'DONMARIO Sementes'; retorno = 'DONMARIO SEMENTES';
        }
        if(marca == 'BRMX'){
            ruta = 'BRASMAX'; retorno = 'BRASMAX GENÉTICA';
        }
        if(marca == 'NEOG'){
            ruta = 'NEOGEN'; retorno = 'NEOGEN';
        }	
        
        return retorno;
    }
    public static String variedadesAnexoI(){
    
       String opId = ApexPages.currentPage().getParameters().get('id');  
       String variedades = '';
    
       for (OpportunityLineItem i : [Select Id, Variedade_Prod__c, PriceBookEntry.Product2.Variedade__r.Name From OpportunityLineItem Where OpportunityId = : opId])    
         variedades += i.Variedade_Prod__c + ', '; 
         
       if (variedades.length() > 2)
          variedades = variedades.substring(0, variedades.length() - 2);  
         
       return variedades;       
     
    }
    
    public static String fecha_larga(Date fech){
        Date d = null;
         if(fech == null){ d = Date.today();}
         else{d = fech;}
         
      
         Datetime dia_semana = DateTime.newInstance(d, Time.newInstance(0, 0, 0, 0));
         String dia_semana_aux = dia_semana.format('EEEE');
         Integer mes = d.month();
         String mes_aux;
         String fecha;
         
         /*if (dia_semana_aux == 'Monday') dia_semana_aux = 'Segunda';
         if (dia_semana_aux == 'Tuesday') dia_semana_aux = 'Terça';   
         if (dia_semana_aux == 'Wednesday') dia_semana_aux = 'Quarta';
         if (dia_semana_aux == 'Thursday') dia_semana_aux = 'Quinta';
         if (dia_semana_aux == 'Friday') dia_semana_aux = 'Sexta';
         if (dia_semana_aux == 'Saturday') dia_semana_aux = 'Sabado';
         if (dia_semana_aux == 'Sunday') dia_semana_aux = 'Domingo';*/
            
         if (mes == 1) mes_aux = 'Janeiro';
         if (mes == 2) mes_aux = 'Fevereiro';
         if (mes == 3) mes_aux = 'Março';
         if (mes == 4) mes_aux = 'Abril';
         if (mes == 5) mes_aux = 'Maio';
         if (mes == 6) mes_aux = 'Junho';
         if (mes == 7) mes_aux = 'Julho';
         if (mes == 8) mes_aux = 'Agosto';
         if (mes == 9) mes_aux = 'Setembro';
         if (mes == 10) mes_aux = 'Outubro';
         if (mes == 11) mes_aux = 'Novembro';
         if (mes == 12) mes_aux = 'Dezembro';                                 
                    
         //fecha = dia_semana_aux + ' ' + String.valueOf(d.day()) + ' de ' + mes_aux + ' de ' + String.valueOf(d.year());
         fecha = String.valueOf(d.day()) + ' de ' + mes_aux + ' de ' + String.valueOf(d.year());
         return fecha;          
      
      }
      public static String anio(Datetime fech){
          Datetime d = null;
          if(fech == null){ d = Date.today();} else{d = fech;}
          return String.valueOf(d.year());
      }
      public String getTipoReg(){
          Opportunity o = [Select RecordType.Name From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
          return o.RecordType.Name;
      }
       public Case getReclamo(){
             Case reclamoPdf = new Case();
  
           String caseId = ApexPages.currentPage().getParameters().get('id');  
           
             reclamoPdf = [SELECT Id, Microregion_de_Ventas__r.Name, Contact.Name, Contact.Estado__r.Name, Contact.Email, Contact.Phone, Macroregion_de_Ventas__r.Name,
              Ciudad_del_Agricultor__c, Fecha_de_Contacto__c, Fecha_Visita_Campo__c, Irrigacion__c, Tipo_De_Suelo__c, Temperatura__c, Lluvias__c,
              Altitud_Campo__c, Asistencia_Tecnica__r.Name, Assistente_Tecnico__c, Asistencia_Tecnica__r.Phone, Asistencia_Tecnica__r.Email, Cultivar__r.Name,
              Cultivar__r.Categ__r.Name, Lote__c, Sintomas__c, area_problema__c, area_Total__c, Area_Total_de_Soja__c, Data_do_problema__c, Data_de_plantio__c, Dosis_Producto_Tratamiento__c,
              Estagio_de_desenvolvimento__c, Poblacion_de_plantas__c, Producto_Tratamiento__c, Tratamiento_de_Semillas__c, Recomendacion__c, Regi_o_da_planta__c, Manejo_del_cultivo__c,
              Account.Name, Contacto_Canal_Ventas__r.Name, Diagnostico__c, Responsavel__c, CaseNumber FROM Case WHERE Id = :caseId limit 1];
          
             
           return reclamoPdf;       
         
        }
       //public Opportunity getOpp(){
           
       //}
       
     public List<OpportunityLineItem> getItems() {
         String query = 'SELECT ';
         String queryTotal = 'SELECT ';
         Boolean hayNumero = false;
         List<String> restoCampos = New List<String>();
         for(Schema.FieldSetMember f : this.getFields()) {
             query += f.getFieldPath() + ', ';
             if (String.valueOf(f.getType()) == 'Integer' || String.valueOf(f.getType()) == 'Double'){
                 queryTotal += 'Sum(' + f.getFieldPath() + ') ' + f.getFieldPath() + ', ';
                 totalesAnexos.put(f.getFieldPath(), '');
                 hayNumero = true;	
             }else{
                 restoCampos.add(f.getFieldPath());	
             }
         }
         query += 'Id FROM OpportunityLineItem Where OpportunityId = \'' + apexpages.currentpage().getparameters().get('id') + '\' Order by Variedade_Prod__c';              
         queryTotal += 'OpportunityId FROM OpportunityLineItem Where OpportunityId = \'' + apexpages.currentpage().getparameters().get('id') + '\' Group by OpportunityId';
         if (hayNumero){
                AggregateResult ar = Database.query(queryTotal);
                for (String s : totalesAnexos.keySet()){
                           String num = String.valueOf(Double.valueOf(ar.get(s)).format());
                           if (!num.contains(','))
                               num = num + ',00';
                           totalesAnexos.put(s, num);
                }	
         }
         for (String s : restoCampos)
             totalesAnexos.put(s, '');
         
         return Database.query(query);
     }
     public List<OpportunityLineItem> getItemAnexo(){
             List<OpportunityLineItem> retorno = New List<OpportunityLineItem>();
             
             Double sumArea = 0; Double sumTon = 0; Double sumExp = 0; Double sumReb = 0;
             for(OpportunityLineItem oli: [SELECT PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Area__c, Estado_de_Produccion__r.Name, Categoria__r.Name, Volume__c, Expec_Prod_Bruta__c, Opportunity.Estados_Comercializacion__c, Categoria_a_Rebaixar__r.Name, Sem_Rebajada__c, Lote_Rebajado__c FROM OpportunityLineItem WHERE OpportunityId =:apexpages.currentpage().getparameters().get('id') And Item_Rebajado__c = false]){
                 oli.Observaciones_Tasas__c = estCom; //Reutilizo este campo para mostrar los estados de comercializacion en la pagina
                 retorno.add(oli); if(oli.Area__c != null) sumArea = sumArea + oli.Area__c; if(oli.Volume__c != null) sumTon = sumTon + oli.Volume__c; if(oli.Expec_Prod_Bruta__c != null) sumExp = sumExp + oli.Expec_Prod_Bruta__c; if(oli.Sem_Rebajada__c != null) sumReb = sumReb + oli.Sem_Rebajada__c;
             }
             OpportunityLineItem tmp = New OpportunityLineItem(Volume__c = sumTon, Area__c = sumArea, Expec_Prod_Bruta__c = sumExp, Sem_Rebajada__c = sumReb);
          retorno.add(tmp); 
          return retorno;
     }
     public List<OpportunityLineItem> getItemExportacion(){
             List<OpportunityLineItem> retorno = New List<OpportunityLineItem>();
             
             Double sumSacas = 0;
             for(OpportunityLineItem oli: [SELECT TMP_Observaciones__c, PriceBookEntry.Product2.Especie__c, PriceBookEntry.Product2.Description, PriceBookEntry.Product2.Categ__r.Name, Volume__c, Opportunity.Estados_Comercializacion__c FROM OpportunityLineItem WHERE OpportunityId =:apexpages.currentpage().getparameters().get('id')]){
                 oli.TMP_Observaciones__c = oli.PriceBookEntry.Product2.Categ__r.Name;retorno.add(oli); if(oli.Volume__c != null) sumSacas = sumSacas + oli.Volume__c;
             }
             OpportunityLineItem tmp = New OpportunityLineItem(TMP_Observaciones__c = 'Total',Volume__c = sumSacas);
          retorno.add(tmp); 
          return retorno;
     }   
     public List<Schema.FieldSetMember> getFields() {
          Opportunity o = [Select RecordType.Name From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
          if (o.RecordType.Name == 'Anexo I') return SObjectType.OpportunityLineItem.FieldSets.AnexoI.getFields();
          if (o.RecordType.Name == 'Anexo II') return SObjectType.OpportunityLineItem.FieldSets.AnexoII.getFields();
          if (o.RecordType.Name == 'Anexo III') return SObjectType.OpportunityLineItem.FieldSets.Anexo_III.getFields();  
          if (o.RecordType.Name == 'Anexo IV') return SObjectType.OpportunityLineItem.FieldSets.Anexo_IV.getFields();
          if (o.RecordType.Name == 'Anexo V') return SObjectType.OpportunityLineItem.FieldSets.Anexo_V.getFields();        
          if (o.RecordType.Name == 'Anexo I Rebaixamento Ha') return SObjectType.OpportunityLineItem.FieldSets.AnexoI_Rebaixamento.getFields();    
          if (o.RecordType.Name == 'Anexo II Rebaixamento Sacas') return SObjectType.OpportunityLineItem.FieldSets.Anexo_Rebajamiento_Bolsas.getFields();
          if (o.RecordType.Name == 'VB - Pasada SAP' || o.RecordType.Name == 'VB - Pendiente' || o.RecordType.Name == 'VB - Autorizada' || o.RecordType.Name == 'VB - Rechazada') return SObjectType.OpportunityLineItem.FieldSets.VB_General.getFields();
          if (o.RecordType.Name == 'Exportacion') return SObjectType.OpportunityLineItem.FieldSets.Exportacion.getFields();        	
          if (o.RecordType.Name == 'Aquisição Sementes Terceiros') return SObjectType.OpportunityLineItem.FieldSets.Aquisicion_Sementes_Terceiros.getFields();
              
          return null;                      
     }
     
     /*public static void sendEmailAnexo(Id opId, Attachment attach){
      /////////Acá comienza el código para el envío de mail adjuntando el PDF
      
          
          String[] retorno = New String[2];
          //User u = [SELECT Id, Username, Name, Profile.Name, Email, IsActive, UserRoleId, ProfileId FROM User WHERE Id = :userId];
  
          try{
              Opportunity op = [SELECT Id, Name, RecordType.Name, OwnerId,  Owner.Name, AccountId, Account.Name, Notificado__c FROM Opportunity WHERE Id = :opId];
              if(op.Notificado__c == false){
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  List<Messaging.Emailfileattachment> attachs = New List<Messaging.Emailfileattachment>();
                  Messaging.Emailfileattachment att = New Messaging.Emailfileattachment();
                  att.setFileName(attach.Name);
                  att.setBody(attach.Body);
                  att.setContentType(attach.ContentType); 
                  attachs.add(att);
                  //Macrorregi_o_de_Vendas__c region = [SELECT id, Name FROM Macrorregi_o_de_Vendas__c WHERE Id =: regionId LIMIT 1];
                  List<Contact> conts = [SELECT Id, MasterRecordId, AccountId, Account.Name, LastName, FirstName, Name, email FROM Contact WHERE AccountId = :op.AccountId AND RecordType.Name = 'Geral' AND (Title LIKE '%PORTAL%' OR Name LIKE '%PORTAL%') AND email != null];
                  
                  String Body1 = 'O ' + op.RecordType.Name+ ' ' + op.Name + ' do Multiplicadpor ' + op.Account.Name + ' está disponível para a impressão.\r\n'; 
                  
                  Body1 += 'Clique no link abaixo para acesso ao salesforce: \r\n';
                  Body1 += 'https://na2.salesforce.com/' + op.Id;
                      
                  //EmailTemplate et = [SELECT id FROM EmailTemplate WHERE Name = 'Notificación Producción Básica'];
                  
                  //mail.setTargetObjectId('00540000001RDF0'); // PRODUCTIVO  Specify who the email should be sent to.
                  mail.setTargetObjectId(op.OwnerId); // SANDBOX  Specify who the email should be sent to.
                   
                  mail.setSenderDisplayName('Impressão de Oportunidade.');
                  //String[] toAddresses = new String[] {'enanni@donmario.com'}; //, 'sromero@donmario.com'}; //, 'admvendas@gdmseeds.com'}; /////SANDBOX///////
                  String[] toAddresses = new String[] {'admvendas@gdmseeds.com'}; /////PRODUCTIVO///////
                  
                  for(Contact c: conts) toAddresses.add(c.email);
                  
                  //mail.setTemplateId(et.id);
                  mail.setCcAddresses(toAddresses);
                  mail.setSaveAsActivity(false);
                  mail.setPlainTextBody(Body1);
                  mail.setSubject('Impressão de Oportunidade.');
                  //mail.setWhatId(oppId);
                  mail.setFileAttachments(attachs);
                  
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                  
                  op.Notificado__c = true;
                  update op;
                  retorno[0] = 'Envio OK';
                  retorno[1] = 'OK';
              }
           } catch(exception e){
              retorno[0] = 'Erro no Envio. Enviar manualmente.';
              retorno[1] = '';
          }
  
     }*/
     
      @isTest(SeeAllData=true)
      static void test1(){
          
          //PdfGeneratorController pdf = New PdfGeneratorController(New ApexPages.StandardController());
          //String a = pdf.getFecha();
          //a = pdf.getvariedadesAnexoI();
          Opportunity o = New Opportunity();
          o.Name = 'pru';
          o.StageName = 'PE - Pendiente';
          o.CloseDate = system.today();
          insert o; 
          PdfGeneratorController.savePdfAnexoI(o.Id,'aa', false);
          
          ApexPages.StandardController sc = new ApexPages.standardController(o);
          PdfGeneratorController myPage = new PdfGeneratorController(sc);
          PageReference pageRef = Page.PdfGeneratorTemplateAnexoI;
          pageRef.getParameters().put('id', String.valueOf(o.Id));
          Test.setCurrentPage(pageRef);
          String a = myPage.getFecha();
          a = myPage.getvariedadesAnexoI();
                  
      }
       @isTest(SeeAllData=true)
      static void test2(){
      
            Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
            RecordType rt_prev = [Select Id From RecordType Where Name = 'VB - Autorizada' And SObjectType = 'Opportunity' limit 1];
            Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
            Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
          Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
          insert prevision;
          PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];
  
          OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
          insert oi2;
          
          PdfGeneratorController.ImpresionOpp(prevision.Id, 'aa', 'VB - Autorizada', prevision.Marca__c, false);
          
          ApexPages.StandardController sc = new ApexPages.standardController(prevision);
          PdfGeneratorController myPage = new PdfGeneratorController(sc);
          
          PageReference pageRef = Page.pdfImpresionOpp;
          pageRef.getParameters().put('id', String.valueOf(prevision.Id));
          Test.setCurrentPage(pageRef);
          
          //myPage.getItems();
          myPage.getTipoReg();
          myPage.getRutaLogo();
          myPage.getMarcaImp();
          myPage.getvariedadesAnexoI();
          
      }
       @isTest(SeeAllData=true)
      static void test3(){
      
            Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
            RecordType rt_prev = [Select Id From RecordType Where Name = 'Anexo I' And SObjectType = 'Opportunity' limit 1];
            Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
            Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
          Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='DSEM',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
          insert prevision;
          PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];
  
          OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
          insert oi2;
          
          PdfGeneratorController.ImpresionOpp(prevision.Id, 'aa', 'Anexo I', prevision.Marca__c, false);
          
          ApexPages.StandardController sc = new ApexPages.standardController(prevision);
          PdfGeneratorController myPage = new PdfGeneratorController(sc);
          
          PageReference pageRef = Page.pdfImpresionOpp;
          pageRef.getParameters().put('id', String.valueOf(prevision.Id));
          Test.setCurrentPage(pageRef);
          
          //myPage.getItems();
          myPage.getTipoReg();
          myPage.getRutaLogo();
          myPage.getMarcaImp();
          myPage.getvariedadesAnexoI();
          
      }
       @isTest(SeeAllData=true)
      static void test4(){
      
            Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
            RecordType rt_prev = [Select Id From RecordType Where Name = 'Anexo II' And SObjectType = 'Opportunity' limit 1];
            Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
            Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
          Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
          insert prevision;
          PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];
  
          OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
          insert oi2;
          
          PdfGeneratorController.ImpresionOpp(prevision.Id, 'aa', 'Anexo II', prevision.Marca__c, false);
          
          ApexPages.StandardController sc = new ApexPages.standardController(prevision);
          PdfGeneratorController myPage = new PdfGeneratorController(sc);
          
          PageReference pageRef = Page.pdfImpresionOpp;
          pageRef.getParameters().put('id', String.valueOf(prevision.Id));
          Test.setCurrentPage(pageRef);
          
          //myPage.getItems();
          myPage.getTipoReg();
          myPage.getRutaLogo();
          myPage.getMarcaImp();
          myPage.getvariedadesAnexoI();
          
      }
       @isTest(SeeAllData=true)
      static void test5(){
      
            Categoria__c cat = [SELECT Id, Name FROM Categoria__c WHERE Name = 'BASICA' limit 1];
            RecordType rt_prev = [Select Id From RecordType Where Name = 'Anexo III' And SObjectType = 'Opportunity' limit 1];
            Account cuenta = [Select Id From Account Where Name = 'ACME' limit 1];
            Pricebook2 pb = [Select Id, Name From Pricebook2 where Name = 'Lista de Básica BMX SUL' and isActive = true limit 1];
          Opportunity prevision = New Opportunity(RecordTypeId=rt_prev.Id, Name='Previsao', AccountId = cuenta.Id,Pricebook2Id=pb.Id, CloseDate=System.today(), Marca__c='BRMX',StageName='Aberta', Safra__c='14/15', Mes__c = 'Março');
          insert prevision;
          PricebookEntry pbe = [Select Id, Product2Id From PricebookEntry where Pricebook2Id = :pb.Id and isActive = true and Product2.Categ__c = :cat.Id limit 1];
  
          OpportunityLineItem oi2 = new OpportunityLineItem(OpportunityId=prevision.Id,Quantity=20,TotalPrice=10,PricebookEntryId=pbe.Id, Semente_aprovada__c=50,Semente_comercializada__c=50);
          insert oi2;
          
          PdfGeneratorController.ImpresionOpp(prevision.Id, 'aa', 'Anexo III', prevision.Marca__c, false);
          
          ApexPages.StandardController sc = new ApexPages.standardController(prevision);
          PdfGeneratorController myPage = new PdfGeneratorController(sc);
          
          PageReference pageRef = Page.pdfImpresionOpp;
          pageRef.getParameters().put('id', String.valueOf(prevision.Id));
          Test.setCurrentPage(pageRef);
          
          //myPage.getItems();
          myPage.getTipoReg();
          myPage.getRutaLogo();
          myPage.getMarcaImp();
          myPage.getvariedadesAnexoI();
          
      }
  }