Global with sharing class ControladorDescarte  {
  public ID parentId {get;set;}
  public String pdfName {get;set;}
  public String marca {get;set;}
  public String safra {get;set;}
  public String nombre {get;set;}
  public String cnpj {get;set;}
  public String estCom {get;set;}
  public String fechaCierre {get;set;}
  public String anioCierre {get;set;}
  public Boolean lic = false;
  public Boolean aI = false;
  
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
          Approval.ProcessResult result =  Approval.process(req);
      } 
      
  }
  
  WebService static void impresionContratoTA(String idContrato){
    
      Contrato__c c = [Select Id, Multiplicador__r.Name, Sociedad__c, Safra__c, Region_Comercial__c From Contrato__c Where id = : idContrato];
      
      PageReference pdf;
      if (c.Sociedad__c == 'BRMX' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
          pdf = Page.pdfContratoTA_BRMX_Sul;      
      if (c.Sociedad__c == 'BRMX' && c.Region_Comercial__c == 'CERRADO')
          pdf = Page.pdfContratoTA_BRMX_Cerrado;
      if (c.Sociedad__c == 'DSEM' && (c.Region_Comercial__c == 'REGION 1' || c.Region_Comercial__c == 'REGION 2'))
          pdf = Page.pdfContratoTA_DSEM_Sul;      
      if (c.Sociedad__c == 'DSEM' && c.Region_Comercial__c == 'CERRADO')
          pdf = Page.pdfContratoTA_DSEM_Cerrado;
          
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
      
      Contract c = [Select Id, ContractNumber, Account.Name, Account.Nome_fantasia__c, Account.CNPJ_CPF__c, Account.IE__c, Account.ShippingStreet, Account.Shippingcity, Account.ShippingPostalCode, Account.ShippingState, Account.ShippingCountry, Account.BillingCity, Account.BillingStreet, Account.BillingPostalCode, Account.BillingState, Account.BillingCountry From Contract Where id = : idContrato];      
      nroContrato = c.ContractNumber;
      nombre = c.Account.Name;      
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
              
      Contrato__c cont = [Select Id, Sociedad__c, Volume_Total_Autorizado__c, Meta_Qde_Treinamentos__c, Meta_Qde_Dias_de_Campo__c, Meta_Qde_comodato_de_area__c, Multiplicador__r.Name, Multiplicador__r.Nome_fantasia__c, Multiplicador__r.CNPJ_CPF__c, Multiplicador__r.IE__c, Multiplicador__r.ShippingStreet, Multiplicador__r.Shippingcity, Multiplicador__r.ShippingPostalCode, Multiplicador__r.ShippingState, Multiplicador__r.ShippingCountry, Multiplicador__r.BillingCity, Multiplicador__r.BillingStreet, Multiplicador__r.BillingPostalCode, Multiplicador__r.BillingState, Multiplicador__r.BillingCountry From Contrato__c Where Id = : idContrato];
      nombre = cont.Multiplicador__r.Name;      
      cnpj = cont.Multiplicador__r.CNPJ_CPF__c;
      inscEst = cont.Multiplicador__r.IE__c;
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
      m.nombre = 'Volume Total Autorizado para Comercialização (Sc/40Kg)';
      m.tipo = 'Comercialização';     
      m.cantidad = String.valueOf(cont.Volume_Total_Autorizado__c.format()) + ',00';                 
      itemsMetas.add(m);
      
      if (cont.Sociedad__c == 'BRMX'){
          metasContrato m2 = New metasContrato();
          m2.nombre = 'Treinamentos';
          m2.tipo = 'Geração de demanda';
          m2.cantidad = String.valueOf(cont.Meta_Qde_Treinamentos__c.format());           
          itemsMetas.add(m2);
      }
      
      if (cont.Sociedad__c == 'DSEM'){
          metasContrato m8 = New metasContrato();
          m8.nombre = 'Comodato de Área e Ensaios de Manejo';
          m8.tipo = 'Ações Eletivas';
          m8.cantidad = String.valueOf(cont.Meta_Qde_comodato_de_area__c.format());           
          itemsMetas.add(m8);
      }
      
      if (cont.Sociedad__c == 'DSEM'){
          metasContrato m9 = New metasContrato();
          m9.nombre = 'Dia de Campo Sem Custo';
          m9.tipo = 'Ações Eletivas';
          m9.cantidad = String.valueOf(cont.Meta_Qde_Dias_de_Campo__c.format());          
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
    
    Opportunity op = [Select Id, Marca__c, Account.Nome_fantasia__c From Opportunity Where id = : opId];
 
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
        if(contratoMultiplicacaoId != null) {
            PageReference pdf;
            if(rtName == 'Termo Aditivo') {
                Contrato__c contratoMultiplicacaoObject;
                try {
                    contratoMultiplicacaoObject = [SELECT Id, Sociedad__c, Region_Comercial__c FROM Contrato__c WHERE Id = :contratoMultiplicacaoId];
                } catch(Exception e) {
                    contratoMultiplicacaoObject = null;
                    System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Cant SOQL with Id = '+contratoMultiplicacaoId);
                }
                if(contratoMultiplicacaoObject != null) {
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
                    }    
                }                       
            }
            if(pdf != null) {
                pdf.getParameters().put('id', contratoMultiplicacaoId);    
                if(!Test.isRunningTest()) {
                    Blob pdfContent = pdf.getContentAsPDF();
                    HttpResponse response = Webservice_Docusign.sendContractEnvelope(contratoMultiplicacaoId, pdfContent, rtName, 'PDF', null);  
                }
            } else {
                System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Cant define PDF Contract');
            }
        } else {
            System.debug('Error in PdfGeneratorController.generateContratoMultiplicacaoDocusignPDF: Contrato__c is null');
        }
    }
  
  WebService static void ImpresionOpp(Id opId, String nombreOp, String rtName, String marcaOpp, Boolean licencias){
    PageReference pdf=null;
    if(rtName == 'Anexo III'){
        pdf = Page.pdfImpresionAnexoIII;
    }else{
        if(rtName == 'Exportacion'){pdf = Page.pdfTemplate_Exportacion;}
        else{if(rtName == 'Reembalaje'){pdf = Page.pdfTemplateReembalaje;}
             else{if(rtName == 'Anexo II Rebaixamento Sacas'){pdf = Page.PdfGeneratorTemplateRebajaSacas;}
                  else{if(rtName == 'Anexo I Rebaixamento Ha'){pdf = Page.PdfGeneratorTemplateRebajaHas;}
                       //else{if(rtName == 'Anexo II'){pdf = Page.pdfContratoGuardaChuva;}
                       else{if(rtName == 'Anexo II'){pdf = Page.pdfImpresionOppA2;} 
                            else{pdf = Page.pdfImpresionOpp;}
                       }
                  }
            }
        }
    }

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
    
    Opportunity op = [Select Id, Marca__c, Account.Nome_fantasia__c From Opportunity Where id = : opId];
 
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
  
  public ControladorDescarte(ApexPages.StandardController controller){
    marca = 'BRMX'; estCom = ''; lic = false; aI = false;
    try{
        Opportunity o = [Select Name, Marca__c, Safra__c, CreatedDate, CNPJ_CPF_Anexo__c, Account.CNPJ_CPF__c, Account.Estado_Comercializacion__c, Owner.Profile.Name, Estados_Comercializacion__c, RecordType.Name, CloseDate, Epoca_de_Plantio__c, Account.Name, Importador__r.Name, Importador__r.BillingCity, Importador__r.BillingState, Importador__r.BillingCountry, Despachante_Aduanero__r.Name, Despachante_Aduanero__r.Representante__c, Cooperante__r.CNPJ_CPF__c From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];
        marca = o.Marca__c;
        safra = '20'+String.ValueOf(o.Safra__c).left(3)+'20'+String.ValueOf(o.Safra__c).right(2);
        if(o.Epoca_de_Plantio__c == 'Inverno') safra = '20'+String.ValueOf(o.Safra__c).right(2)+'/20'+String.ValueOf(o.Safra__c).right(2);
        nombre = o.Name.left(o.Name.length() - 5);
        cnpj = o.Account.CNPJ_CPF__c;
        fechaCierre = fecha_larga(o.CloseDate);
        anioCierre = anio(o.CreatedDate);
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
        ruta = 'https://na27.salesforce.com/resource/1380120282000/LogoImpDSEM';       //Productivo
        //ruta = 'https://cs16.salesforce.com/resource/1379941620000/LogoImpresionDSEM'; //Sandbox
        if(aI) ruta = 'https://na27.salesforce.com/resource/1386010085000/LogoEnBlanco'; //Productivo
        //if(aI) ruta = 'https://cs16.salesforce.com/resource/1386009212000/LogoEnBlanco'; //Sandbox
        
    }else{
        if(lic){
            ruta = 'https://na27.salesforce.com/resource/1386422647000/LogoGDMSeeds';   //Productivo
            //ruta = 'https://cs16.salesforce.com/resource/1384787835000/LogoGDMSeeds';     //Sandbox
        }else{
            ruta = 'https://na27.salesforce.com/resource/1380120147000/LogoImpBRMX';    //Productivo
            //ruta = 'https://cs16.salesforce.com/resource/1379937799000/LogoImpresion'; //Sandbox
        }
    }
    return ruta;
  }
  public String getMarcaImp(){
    String ruta = ''; String retorno = '';
    if(marca == 'DSEM'){
        ruta = 'DONMARIO Sementes'; retorno = 'DONMARIO SEMENTES';
    }else{
        ruta = 'BRASMAX'; retorno = 'BRASMAX GENÉTICA';
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
        for(OpportunityLineItem oli: [SELECT PriceBookEntry.Product2.Variedade__r.Nombre_de_Registro__c, Unidade_descarte__c, Quantity, Area__c, Estado_de_Produccion__r.Name, Categoria__r.Name, Volume__c, Expec_Prod_Bruta__c, Opportunity.Estados_Comercializacion__c, Categoria_a_Rebaixar__r.Name, Sem_Rebajada__c, Lote_Rebajado__c FROM OpportunityLineItem WHERE OpportunityId =:apexpages.currentpage().getparameters().get('id') And Item_Rebajado__c = false]){
            oli.Observaciones_Tasas__c = estCom; //Reutilizo este campo para mostrar los estados de comercializacion en la pagina
            retorno.add(oli); if(oli.Area__c != null) sumArea = sumArea + oli.Area__c; if(oli.Volume__c != null) sumTon = sumTon + oli.Volume__c; if(oli.Expec_Prod_Bruta__c != null) sumExp = sumExp + oli.Expec_Prod_Bruta__c; if(oli.Sem_Rebajada__c != null) sumReb = sumReb + oli.Sem_Rebajada__c;
        }
        return retorno;
   }
   public List<Schema.FieldSetMember> getFields() {
        Opportunity o = [Select RecordType.Name From Opportunity Where Id = : apexpages.currentpage().getparameters().get('id')];         
        if (o.RecordType.Name == 'Descarte') {
            return SObjectType.OpportunityLineItem.FieldSets.Anexo_Descarte.getFields();
        }
        return null;                      
   }
   
	
}