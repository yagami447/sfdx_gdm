global without sharing class aSiteEventosController {
    private String token;
    public SiteUser__c logUser { get; set; }
    private SiteUserSession__c activeSession;
    private Account activeAccount;
    private String safraActual;
    private Caracteristica_de_evento__mdt eventMtd { get; set; }

    private Map<String, Id> rty;

    public String language { get; set; }
    public String titulo { get; set; }
    private Map<String, String> rTypes;

    public evento evento2 { get; set; }
    public Map<Id, CRM_Calendario_de_Eventos__c> relatedEventos { get; set; }
    public CRM_Detalle_Calendario_de_eventos__c[] relatedEventoItems { get; set; }

    public CRM_Detalle_Calendario_de_eventos__c[] tmpEventoItems { get; set; }
    public CRM_Detalle_Calendario_de_eventos__c[] tmpEventoItemsNew { get; set; }

    public item[] tmpEventoItems2 { get; set; }
    public item[] tmpEventoItemsNew2 { get; set; }
    public item[] tmpAppItemsRemove { get; set; }

    public String recId { get; set; }
    public String editId { get; set; }

    private Map<String, String> mapNombresProd;
    private Map<String, String> mapEventosTipoReg;

    public String tipoEvento { get; set; }
    public Integer principalSelected { get; set; }

    public List<SelectOption> optionsAddNuevoEvento { get; set; }
    public List<SelectOption> optionsEditEvento { get; set; }
    public List<SelectOption> optionsObtentor { get; set; }

    public Boolean verItems { get; set; }
    public Boolean verArchivos { get; set; }
    public Integer linea { get; set; }
    public String mensaje { get; set; }
    public String filtro { get; set; }
    public Boolean overLimit { get; set; }
    public String enviarAprobacion { get; set; }
    public Boolean agregarArchivos { get; set; }

    public List<adjunto> archivo { get; set; }
    public List<adjunto> archivos { get; set; }
    public String attToRemove { get; set; }

    public class evento {
        public String Id { get; set; }
        public String fase { get; set; }
        public String prazoDeLancamento { get; set; }
        public Date fecha { get; set; }
        public DateTime fechaInicio { get; set; }
        public DateTime fechaFin { get; set; }
        public String cuenta { get; set; }
        public String marca { get; set; }
        public String safra { get; set; }
        public String evaluacion { get; set; }
        public String ciudad { get; set; }
        public String ciudad_nombre { get; set; }
        public String estado { get; set; }
        public String comentarios { get; set; }
        public String costo { get; set; }
        public String direccion { get; set; }
        public String evento { get; set; }
        public Boolean finalizado { get; set; }
        public Boolean irrigado { get; set; }
        public Boolean usarCoorCiudad { get; set; }
        public String latitud { get; set; }
        public String longitud { get; set; }
        public String agricultor { get; set; }
        public String revenda { get; set; }
        public String divulgarEmNomeDe { get; set; }
        public String tipoAgricultor { get; set; }
        public String tipoRevenda { get; set; }
        public String cpf_cnpj_agricultor { get; set; }
        public String cpf_cnpj_revenda { get; set; }
        public String participantes { get; set; }
        public Boolean autorizado { get; set; }
    }

    public class item {
        public String Id { get; set; }
        public String obtentor { get; set; }
        public String id_producto { get; set; }
        public String desc_producto { get; set; }
        public Date data_colheita { get; set; }
        public Date data_plantio { get; set; }
        public String area_colhida { get; set; }
        public String area_plantada { get; set; }
        public String produtividade { get; set; }
        public String volume_doado { get; set; }
        public Boolean produto_principal { get; set; }
        public Integer indice { get; set; }
        public String populacao_de_plantas { get; set; }
        public String espacamento { get; set; }
        public String cultura_antecessora { get; set; }
    }

    public class adjunto {
        public String id { get; set; }
        public String tipo { get; set; }
        public Attachment att { get; set; }

        public adjunto(String id, String tipo, Attachment att) {
            this.id = id;
            this.tipo = tipo;
            this.att = att;
        }
    }

    global aSiteEventosController() {
        try {
            rty = Opp_Utils.cargarRecordTypesOportunidades();
            language = UserInfo.getLanguage();
            rTypes = Opp_Utils.cargarRecordTypesOppbyDevName();
            titulo = System.currentPageReference().getParameters().get('evento');
            System.debug('TITULO ' + titulo);
            evento2 = new evento();
            editId = System.currentPageReference().getParameters().get('e');
            System.debug('EDIT ID ' + editId);
            verItems = false;
            overLimit = false;

            cargarEventosTipoReg();
            cargarObtentores();
            cargarNombresProds();

            if (String.isNotEmpty(editId)) {
                evento2 = aEventosManager.getEvento(editId);
            } else {
                evento2.evento = titulo;
            }

            tipoEvento = mapEventosTipoReg.get(evento2.evento);

            String goArchivos = System.currentPageReference().getParameters().get('goArchivos');
            verArchivos = goArchivos == '1';

            List<Caracteristica_de_evento__mdt> eventsMtd = [
                SELECT Id, Permitir_creacion_de_nuevos__c
                FROM Caracteristica_de_evento__mdt
                WHERE Nombre_especifico_del_evento__c = :titulo
            ];

            if (!eventsMtd.isEmpty()) {
                eventMtd = eventsMtd[0];
            }
        } catch (Exception e) {
        }
    }

    public PageReference validate() {
        token = System.currentPageReference().getParameters().get('token');

        if (token != null) {
            logUser = aSiteAuthManager.VerifyUserSession(token);

            if (logUser != null) {
                activeSession = aSiteAuthManager.getUserSession(token);
                activeAccount = aSiteAuthManager.getActiveAccount_byUser(logUser);
                safraActual = aEventosManager.getSafraActualEventos();
                System.debug('SAFRA ACTUAL ' + safraActual);

                if (String.isEmpty(evento2.Id)) {
                    evento2.cuenta = activeAccount.Id;
                    evento2.safra = safraActual;
                    evento2.marca = activeSession.Marca__c;
                }

                return null;
            }
        }

        PageReference p = new PageReference('/apex/aSiteLogin');

        String marca = aSiteAuthManager.getMarcaBySession(token);

        if (marca != null) {
            p.getParameters().put('comp', marca);
        }
        p.setRedirect(true);
        return p;
    }

    public List<CRM_Calendario_de_Eventos__c> getEventos() {
        try {
            if (relatedEventos != null && !relatedEventos.isEmpty()) {
                return relatedEventos.values();
            }
            System.debug('SAFRA ACTUAL ' + safraActual);
            System.debug('ACTIVE SESION MARCA ' + activeSession.Marca__c);
            relatedEventos = new Map<Id, CRM_Calendario_de_Eventos__c>(
                aEventosManager.getEventos(activeAccount.Id, safraActual, activeSession.Marca__c, titulo)
            );

            if (!relatedEventos.isEmpty()) {
                recId = relatedEventos.values()[0].Id;
                setActiveEvento();
            }

            return relatedEventos.values();
        } catch (Exception e) {
            System.debug('el error en getEventos es ' + e.getMessage() + ' ' + e.getCause());
            System.debug('el error en getEventos es ' + e.getLineNumber());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            return null;
        }
    }

    /**
     * Identifica que evento está activo y consulta los items relacionados para mostrar en pantalla
     */
    public void setActiveEvento() {
        try {
            relatedEventoItems = aEventosManager.getEventosItemsByEvento(recId);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, aSiteUtils.procesarAlerta(e.getMessage())));
        }
    }

    public List<item> getEventoItems() {
        try {
            List<CRM_Detalle_Calendario_de_eventos__c> tmpItems = new List<CRM_Detalle_Calendario_de_eventos__c>();
            List<item> tmpItems2 = new List<item>();

            if (tmpEventoItems2 != null) {
                return tmpEventoItems2;
            }

            if (editId != null) {
                tmpItems = aEventosManager.getEventosItemsByEvento(editId);
            }

            Integer i = 0;

            for (CRM_Detalle_Calendario_de_eventos__c s : tmpItems) {
                item oli = new item();

                oli.Id = s.Id;
                oli.obtentor = s.Obtentor__c;
                oli.id_producto = s.Cultivar__c;
                oli.desc_producto = s.Cultivar__r.Name;
                oli.data_colheita = s.Data_de_colheita__c;
                oli.data_plantio = s.Data_de_plantio__c;
                oli.area_colhida = String.valueOf(s.Area_Colhida__c);
                oli.area_plantada = s.Area_Plantada__c != null ? String.valueOf(s.Area_Plantada__c).replace('.', ',') : null;
                oli.produtividade = s.Produtividade__c != null ? String.valueOf(s.Produtividade__c).replace('.', ',') : null;
                oli.volume_doado = s.Volume_Doado__c != null ? String.valueOf(s.Volume_Doado__c).replace('.', ',') : null;
                oli.produto_principal = s.Produto_Principal__c;
                oli.populacao_de_plantas = s.Populacao_de_plantas__c != null
                    ? String.valueOf(s.Populacao_de_plantas__c).replace('.', ',')
                    : null;
                oli.espacamento = s.Espacamento__c != null ? String.valueOf(s.Espacamento__c).replace('.', ',') : null;
                oli.cultura_antecessora = s.Cultura_antecessora__c;
                oli.indice = i;

                if (oli.produto_principal) {
                    principalSelected = i;
                }
                i++;

                tmpItems2.add(oli);
            }

            formatearDatosItems(false, tmpItems2);
            tmpEventoItems2 = tmpItems2;
            return tmpItems2;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            return tmpEventoItems2;
        }
    }

    public Boolean getCreationIsAllowed() {
        return eventMtd == null ? true : eventMtd.Permitir_creacion_de_nuevos__c;
    }

    public List<item> getEventoItemsNew() {
        List<item> tmpItems = new List<item>();

        try {
            if (tmpEventoItemsNew2 != null) {
                return tmpEventoItemsNew2;
            }

            List<Product2> prods = aEventosManager.getProductos('', tipoEvento);

            if (prods.size() == 21) {
                overLimit = true;
                prods.remove(20);
            }

            Integer j = 0;

            for (Product2 p : prods) {
                item oli = new item();
                oli.obtentor = p.Obtentor__c;
                oli.id_producto = p.Id;
                oli.desc_producto = p.Name;
                oli.indice = j;
                tmpItems.add(oli);
                j++;
            }

            tmpEventoItemsNew2 = tmpItems;
            return tmpItems;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            return tmpEventoItemsNew2;
        }
    }

    public List<adjunto> getEventoArchivos() {
        List<adjunto> tmpArchivos = new List<adjunto>();

        try {
            if (archivos != null) {
                return archivos;
            } else if (editId != null) {
                List<Attachment_Content__c> attContents = [
                    SELECT Id, Attachment_Type__c, (SELECT Id, Name, ParentId FROM Attachments)
                    FROM Attachment_Content__c
                    WHERE CRM_Calendario_de_Eventos__c = :editId
                ];

                for (Attachment_Content__c attContent : attContents) {
                    if (!attContent.Attachments.isEmpty()) {
                        tmpArchivos.add(new adjunto(attContent.Id, attContent.Attachment_Type__c, attContent.Attachments[0]));
                    }
                }

                for (Attachment att : [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :editId]) {
                    tmpArchivos.add(new adjunto(att.Id, 'Arquivos gerais', att));
                }
            }

            archivos = tmpArchivos;
            return tmpArchivos;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            return tmpArchivos;
        }
    }

    public List<adjunto> getArchivoNew() {
        List<adjunto> tmpArchivo = new List<adjunto>{ new adjunto('', '', new Attachment()) };

        try {
            if (archivo != null) {
                return archivo;
            } else {
                archivo = tmpArchivo;
                return tmpArchivo;
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            return tmpArchivo;
        }
    }

    public void updateAvailableList() {
        overLimit = false;
        tmpEventoItemsNew2.clear();
        List<Product2> prods = new List<Product2>();
        prods = aEventosManager.getProductos(filtro, tipoEvento);

        if (prods.size() == 21) {
            overLimit = true;
            prods.remove(20);
        }

        Integer j = 0;

        for (Product2 p : prods) {
            item oli = new item();
            oli.obtentor = p.Obtentor__c;
            oli.id_producto = p.Id;
            oli.desc_producto = p.Name;
            oli.indice = j;
            tmpEventoItemsNew2.add(oli);
            j++;
        }
    }

    public PageReference getVariedadesObt_Add_NewEvento() {
        List<Product2> prods = new List<Product2>();
        optionsAddNuevoEvento = new List<SelectOption>();

        if (String.isNotEmpty(tmpEventoItemsNew2[0].obtentor)) {
            prods = [SELECT Id, Name FROM Product2 WHERE Obtentor__c = :tmpEventoItemsNew2[0].obtentor];
        }

        for (Product2 p : prods) {
            optionsAddNuevoEvento.add(new SelectOption(p.Id, p.Name));
        }

        return null;
    }

    public PageReference getVariedadesObt_Edit_Evento() {
        List<Product2> prods = new List<Product2>();
        optionsEditEvento = new List<SelectOption>();

        if (String.isNotEmpty(tmpEventoItems2[linea].obtentor)) {
            prods = [SELECT Id, Name FROM Product2 WHERE Obtentor__c = :tmpEventoItems2[linea].obtentor];
        }

        for (Product2 p : prods) {
            optionsEditEvento.add(new SelectOption(p.Id, p.Name));
        }

        return null;
    }

    public PageReference setearEstadoNewEvento() {
        evento2.estado = '';

        if (evento2.ciudad != null) {
            Cidade__c ciu = [SELECT Id, Name, Estado__r.Name FROM Cidade__c WHERE Id = :evento2.ciudad];
            evento2.estado = ciu.Estado__r.Name;
            evento2.ciudad_nombre = ciu.Name;
        }

        return null;
    }

    public PageReference saveEvento() {
        mensaje = '';

        try {
            agregarArchivos = false;

            if (enviarAprobacion == '1') {
                mensaje = validarAprobacion(null);

                if (!String.isEmpty(mensaje)) {
                    return null;
                }

                if (tipoEvento == 'Test a campo') {
                    // Debe informarse si no existe un archivo de tipo Termo de autorização anexado al CRM Evento (US 11591, US 17284)
                    AggregateResult result = [
                        SELECT COUNT(Id) Total
                        FROM Attachment_Content__c
                        WHERE CRM_Calendario_de_Eventos__c = :editId AND Attachment_Type__c = 'Termo de autorização'
                    ];

                    agregarArchivos = (Integer) result.get('Total') == 0;
                } else if (tipoEvento == 'Emplacamento') {
                    AggregateResult result = [
                        SELECT COUNT(Id) Total
                        FROM Attachment_Content__c
                        WHERE CRM_Calendario_de_Eventos__c = :editId
                    ];
                    agregarArchivos = (Integer) result.get('Total') == 0;
                }

                if (!agregarArchivos) {
                    formatearDatosItems(true, tmpEventoItems2);
                    aSiteUtils.retorno ret = aEventosManager.saveEvento(
                        evento2,
                        tmpEventoItems2,
                        tmpAppItemsRemove,
                        tipoEvento,
                        logUser
                    );
                    formatearDatosItems(false, tmpEventoItems2);

                    if (ret.exito == false) {
                        mensaje = ret.mensaje;
                        return null;
                    } else if (editId == null) {
                        editId = ret.id;
                    }

                    aEventosManager.enviarEventoAprobacion(editId);
                }
            } else if (enviarAprobacion == '2') {
                formatearDatosItems(true, tmpEventoItems2);
                aSiteUtils.retorno ret = aEventosManager.saveEvento(
                    evento2,
                    tmpEventoItems2,
                    tmpAppItemsRemove,
                    tipoEvento,
                    logUser
                );
                formatearDatosItems(false, tmpEventoItems2);

                if (ret.exito == false) {
                    mensaje = ret.mensaje;
                    return null;
                } else if (editId == null) {
                    editId = ret.id;
                }

                aEventosManager.enviarEventoAprobacion(editId);
            } else {
                formatearDatosItems(true, tmpEventoItems2);
                aSiteUtils.retorno ret = aEventosManager.saveEvento(
                    evento2,
                    tmpEventoItems2,
                    tmpAppItemsRemove,
                    tipoEvento,
                    logUser
                );
                formatearDatosItems(false, tmpEventoItems2);

                if (ret.exito == false) {
                    mensaje = ret.mensaje;
                    return null;
                } else if (editId == null) {
                    editId = ret.id;
                }
            }

            enviarAprobacion = null;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, e.getLineNumber() + ' ' + e.getMessage()));
            mensaje = e.getMessage();
            return null;
        }

        aAppManager.updateSession(activeSession);

        if (agregarArchivos == false) {
            PageReference pr = new PageReference('/apex/aSiteEventoEdit');
            pr.setRedirect(true);
            pr.getParameters().put('e', editId);
            pr.getParameters().put('token', token);
            pr.getParameters().put('evento', titulo);
            pr.getParameters().put('goArchivos', '0');
            return pr;
            /*
            PageReference pr = new PageReference('/apex/aSiteEventos');
            pr.setRedirect(true);
            pr.getParameters().put('token',token);
            pr.getParameters().put('evento',titulo); 
            return pr;*/
        } else {
            return null;
        }
    }

    /**
     * Método auxiliar para formatear los campos provenientes desde front (US 11587 y US 14347).
     */
    private void formatearDatosItems(Boolean formatear, item[] tmpItems) {
        if (formatear) {
            for (item i : tmpItems) {
                i.area_colhida = String.isEmpty(i.area_colhida)
                    ? i.area_colhida
                    : i.area_colhida.replace('.', '').replace(',', '.');
                i.area_plantada = String.isEmpty(i.area_plantada)
                    ? i.area_plantada
                    : i.area_plantada.replace('.', '').replace(',', '.');
                i.produtividade = String.isEmpty(i.produtividade)
                    ? i.produtividade
                    : i.produtividade.replace('.', '').replace(',', '.');
                i.volume_doado = String.isEmpty(i.volume_doado)
                    ? i.volume_doado
                    : i.volume_doado.replace('.', '').replace(',', '.');
                i.populacao_de_plantas = String.isEmpty(i.populacao_de_plantas)
                    ? i.populacao_de_plantas
                    : i.populacao_de_plantas.replace('.', '').replace(',', '.');
                i.espacamento = String.isEmpty(i.espacamento)
                    ? i.espacamento
                    : i.espacamento.replace('.', '').replace(',', '.');
            }
        } else {
            for (item i : tmpItems) {
                i.area_colhida = String.isEmpty(i.area_colhida) ? i.area_colhida : i.area_colhida.replace('.', ',');
                i.area_plantada = String.isEmpty(i.area_plantada) ? i.area_plantada : i.area_plantada.replace('.', ',');
                i.produtividade = String.isEmpty(i.produtividade) ? i.produtividade : i.produtividade.replace('.', ',');
                i.volume_doado = String.isEmpty(i.volume_doado) ? i.volume_doado : i.volume_doado.replace('.', ',');
                i.populacao_de_plantas = String.isEmpty(i.populacao_de_plantas)
                    ? i.populacao_de_plantas
                    : i.populacao_de_plantas.replace('.', ',');
                i.espacamento = String.isEmpty(i.espacamento) ? i.espacamento : i.espacamento.replace('.', ',');
            }
        }
    }

    /**
     * Valida los campos requeridos para solicitar la aprobación de un CRM Evento de Lado a Lado o Emplacamento (US 11580 y US 11595).
     * Si no se ingresa el parámetro eventoId, se valida la información en el wrapper evento2 y los elementos en la lista tmpEventoItems2.
     * Por requerimiento del FEATURE 11614, también se valida el plazo de lanzamiento (prazo de lançamento) a partir de la ciudad del evento.
     */
    private String validarAprobacion(String eventoId) {
        String retorno = '';

        if (String.isEmpty(eventoId)) {
            if (tipoEvento == 'Test a campo' || tipoEvento == 'Emplacamento' || tipoEvento == 'Treinamento Tecnico') {
                // validaciones FEATURE 11614
                List<Prazo_de_Lancamento__c> plazos = New List<Prazo_de_Lancamento__c>();
                plazos = [
                    SELECT Id, Evento__c, Estado__c, Configuracion_de_Marca__r.Marca__c
                    FROM Prazo_de_Lancamento__c
                    WHERE Evento__c = :tipoEvento AND Estado__r.Name = :evento2.estado AND Configuracion_de_Marca__r.Marca__c = 'BRMX' limit 1
                ];
                if (plazos.size() > 0)
                    evento2.prazoDeLancamento = plazos[0].Id;
                
                
                if (String.isEmpty(evento2.prazoDeLancamento)) {
                    retorno = 'Não é permitido cadastrar eventos fora do prazo';
                } else if (validatePrazoDeLancamento(evento2.prazoDeLancamento, evento2.fase)) {
                    retorno = 'Não é permitido cadastrar eventos fora do prazo de lançamento';
                } else if ((tipoEvento == 'Emplacamento' || tipoEvento == 'Test a campo') && tmpEventoItems2.size() <= 0) {
                    retorno = 'Não é permitido enviar emplacamento sem produto';
                }
            }

            if (String.isEmpty(retorno)) {
                if (tipoEvento == 'Test a campo') {
                    // validaciones US 11580 (aSiteEventoEdit.page)
                    if (validateRequiredFields(null)) {
                        retorno = 'Você deve preencher todos os campos para solicitar aprovação';
                    } else if (String.isNotEmpty(evento2.tipoAgricultor) && String.isEmpty(evento2.cpf_cnpj_agricultor)) {
                        retorno = 'É obrigatório informa o ' + evento2.tipoAgricultor + ' do agricultor';
                    } else if (validateRequiredFieldsItems(null, true, true)) {
                        retorno = 'Você deve especificar: Área plantada, Data de plantio, Volume Doado, População de plantas, Espaçamento e Cultura antecessora para o produto principal';
                    } else if (validateRequiredFieldsItems(null, true, false)) {
                        retorno = 'Você deve especificar: Área plantada, Data de plantio, População de plantas, Espaçamento e Cultura antecessora para o produto comparado';
                    } else if (validateRequiredFieldsItems(null, false, true)) {
                        retorno = 'Você deve especificar: Área colhida, Data de colheida e Produtividade';
                    } else if (validateRequiredFieldsItems(null, false, false)) {
                        retorno = 'Você deve especificar: Área colhida, Data de colheida e Produtividade';
                    }
                } else if (tipoEvento == 'Emplacamento') {
                    // validaciones US 11595
                    if (validateRequiredFields(null)) {
                        retorno = 'Você deve preencher todos os campos para solicitar aprovação';
                    }
                }
            }
        } else {
            CRM_Calendario_de_Eventos__c evento = relatedEventos.get(eventoId);

            if (tipoEvento == 'Test a campo' || tipoEvento == 'Emplacamento' || tipoEvento == 'Treinamento Tecnico') {
                // validaciones FEATURE 11614
                if (evento.Prazo_de_Lancamento__c == null) {
                    retorno = 'Não é permitido cadastrar eventos fora do prazo';
                } else if (validatePrazoDeLancamento(evento.Prazo_de_Lancamento__c, evento.Fase__c)) {
                    retorno = 'Não é permitido cadastrar eventos fora do prazo de lançamento';
                }
            }

            if (String.isEmpty(retorno)) {
                if (tipoEvento == 'Test a campo') {
                    // validaciones US 11580 (aSiteEventos.page)
                    if (validateRequiredFields(evento)) {
                        retorno = 'Você deve preencher todos os campos para solicitar aprovação';
                    } else if (
                        String.isNotEmpty(evento.Tipo_Conta_Agricultor__c) && String.isEmpty(evento.CNPJ_CPF_Agricultor__c)
                    ) {
                        retorno = 'É obrigatório informa o ' + evento.Tipo_Conta_Agricultor__c + ' do agricultor';
                    } else if (validateRequiredFieldsItems(evento, true, true)) {
                        retorno = 'Você deve especificar: Área plantada, Data de plantio, Volume Doado, População de plantas, Espaçamento e Cultura antecessora para o produto principal';
                    } else if (validateRequiredFieldsItems(evento, true, false)) {
                        retorno = 'Você deve especificar: Área plantada, Data de plantio, População de plantas, Espaçamento e Cultura antecessora para o produto comparado';
                    } else if (validateRequiredFieldsItems(evento, false, true)) {
                        retorno = 'Você deve especificar: Área colhida, Data de colheida e Produtividade';
                    } else if (validateRequiredFieldsItems(evento, false, false)) {
                        retorno = 'Você deve especificar: Área colhida, Data de colheida e Produtividade';
                    }
                } else if (tipoEvento == 'Emplacamento') {
                    // validaciones US 11595
                    if (validateRequiredFields(evento)) {
                        retorno = 'Você deve preencher todos os campos para solicitar aprovação';
                    }
                }
            }
        }

        return retorno;
    }

    /**
     * Método que valida los campos requeridos para solicitar la aprobación de un CRM Evento de Lado a Lado o Emplacamento (US 11580 y US 11595).
     * Si el CRM Evento no es de tipo Lado a Lado o Emplacamento, retorna false, si no se ingresa el parámetro evento se valida la información en el wrapper evento2.
     */
    private Boolean validateRequiredFields(CRM_Calendario_de_Eventos__c evento) {
        String[] fields = null;

        if (evento != null) {
            fields = new List<String>{
                evento.Nome_Cidade__c,
                evento.Estado__c,
                evento.Nome_do_agricultor_2__c,
                evento.Tipo_Conta_Agricultor__c,
                String.valueOf(evento.Latitud__c),
                String.valueOf(evento.Longitud__c)
            };

            if (tipoEvento == 'Test a campo') {
                fields.add(evento.Divulgar_em_nome_de__c);
            } else if (tipoEvento == 'Emplacamento') {
                fields.add(evento.Direccion__c);
            }
        } else {
            fields = new List<String>{
                evento2.ciudad_nombre,
                evento2.estado,
                evento2.agricultor,
                evento2.tipoAgricultor,
                evento2.latitud,
                evento2.longitud
            };

            if (tipoEvento == 'Test a campo') {
                fields.add(evento2.divulgarEmNomeDe);
            } else if (tipoEvento == 'Emplacamento') {
                fields.add(evento2.direccion);
            }
        }

        return fields != null ? validateRequiredFields(fields, 0) : false;
    }

    /**
     * Valida los campos requeridos en los items/productos de un CRM Evento (US 11580). Existen dos momentos de aprobación y cada uno valida un conjunto de campos.
     * Los campos a validar dependen del parámetro de ingreso, verdadero (true) para el primer momento y de ser false se validan los campos requeridos del segundo momento.
     */
    private Boolean validateRequiredFieldsItems(
        CRM_Calendario_de_Eventos__c evento,
        Boolean primerMomento,
        Boolean principal
    ) {
        Integer count = 0;
        Boolean match = false;

        if (evento != null) {
            List<CRM_Detalle_Calendario_de_eventos__c> tmpItems = aEventosManager.getEventosItemsByEvento(evento.Id);

            while (count < tmpItems.size() && !match) {
                String[] fields = null;

                if (principal && tmpItems[count].Produto_Principal__c) {
                    // debe evaluarse el producto principal separado del resto de productos (US 13670)
                    if (primerMomento) {
                        fields = new List<String>{
                            String.valueOf(tmpItems[count].Area_plantada__c),
                            String.valueOf(tmpItems[count].Volume_Doado__c), // el Volume Doado solo es obligatorio para el producto principal (US 13670)
                            String.valueOf(tmpItems[count].Data_de_plantio__c),
                            String.valueOf(tmpItems[count].Populacao_de_plantas__c),
                            String.valueOf(tmpItems[count].Espacamento__c),
                            String.valueOf(tmpItems[count].Cultura_antecessora__c)
                        };
                    } else if (
                        evento.Fase__c == 'Aguardando resultado de colheita' ||
                        evento.Fase__c == 'Edição de dados de colheita'
                    ) {
                        fields = new List<String>{
                            String.valueOf(tmpItems[count].Area_Colhida__c),
                            String.valueOf(tmpItems[count].Produtividade__c),
                            String.valueOf(tmpItems[count].Data_de_colheita__c)
                        };
                    }
                } else if (!principal && !tmpItems[count].Produto_Principal__c) {
                    if (primerMomento) {
                        fields = new List<String>{
                            String.valueOf(tmpItems[count].Area_plantada__c),
                            String.valueOf(tmpItems[count].Data_de_plantio__c),
                            String.valueOf(tmpItems[count].Populacao_de_plantas__c),
                            String.valueOf(tmpItems[count].Espacamento__c),
                            String.valueOf(tmpItems[count].Cultura_antecessora__c)
                        };
                    } else if (
                        evento.Fase__c == 'Aguardando resultado de colheita' ||
                        evento.Fase__c == 'Edição de dados de colheita'
                    ) {
                        fields = new List<String>{
                            String.valueOf(tmpItems[count].Area_Colhida__c),
                            String.valueOf(tmpItems[count].Produtividade__c),
                            String.valueOf(tmpItems[count].Data_de_colheita__c)
                        };
                    }
                }

                if (fields != null) {
                    match = validateRequiredFields(fields, 0);
                }

                count++;
            }
        } else {
            while (count < tmpEventoItems2.size() && !match) {
                String[] fields = null;

                if (principal && tmpEventoItems2[count].produto_principal) {
                    if (primerMomento) {
                        fields = new List<String>{
                            tmpEventoItems2[count].area_plantada,
                            tmpEventoItems2[count].volume_doado,
                            String.valueOf(tmpEventoItems2[count].data_plantio),
                            tmpEventoItems2[count].populacao_de_plantas,
                            tmpEventoItems2[count].espacamento,
                            tmpEventoItems2[count].cultura_antecessora
                        };
                    } else if (
                        evento2.fase == 'Aguardando resultado de colheita' ||
                        evento2.fase == 'Edição de dados de colheita'
                    ) {
                        fields = new List<String>{
                            tmpEventoItems2[count].area_colhida,
                            tmpEventoItems2[count].produtividade,
                            String.valueOf(tmpEventoItems2[count].data_colheita)
                        };
                    }
                } else if (!principal && !tmpEventoItems2[count].produto_principal) {
                    if (primerMomento) {
                        fields = new List<String>{
                            tmpEventoItems2[count].area_plantada,
                            String.valueOf(tmpEventoItems2[count].data_plantio),
                            tmpEventoItems2[count].populacao_de_plantas,
                            tmpEventoItems2[count].espacamento,
                            tmpEventoItems2[count].cultura_antecessora
                        };
                    } else if (
                        evento2.fase == 'Aguardando resultado de colheita' ||
                        evento2.fase == 'Edição de dados de colheita'
                    ) {
                        fields = new List<String>{
                            tmpEventoItems2[count].area_colhida,
                            tmpEventoItems2[count].produtividade,
                            String.valueOf(tmpEventoItems2[count].data_colheita)
                        };
                    }
                }

                if (fields != null) {
                    match = validateRequiredFields(fields, 0);
                }

                count++;
            }
        }

        return match;
    }

    private Boolean validateRequiredFields(String[] fields, Integer count) {
        if (count < fields.size()) {
            return String.isEmpty(fields[count]) ? true : validateRequiredFields(fields, count + 1);
        } else {
            return false;
        }
    }

    /**
     * Verifica que las fechas en el Prazo de Lancamento del CRM Evento sean válidas para solicitar aprobación. Se necesita el Id del plazo y la fase para verificar el período en eventos de Lado a Lado (FEATURE 11614).
     */
    private Boolean validatePrazoDeLancamento(Id plazoId, String fase) {
        Boolean match = false;
        Boolean isOk = false;
        Integer anoInicio;
        Integer anoFinal;
        Date fechaInicio;
        Date fechaTermino;

        Prazo_de_Lancamento__c plazo = [
            SELECT Id, Evento__c, Inicio__c, Termino__c, Cadastro_de_plantio__c, Cadastro_de_colheita__c
            FROM Prazo_de_Lancamento__c
            WHERE Id = :plazoId
        ];

        Date today = Date.today();

        if (plazo.Evento__c == 'Lado a Lado') {
            if (fase == 'Aguardando resultado de colheita' || fase == 'Edição de dados de colheita') {
                fechaInicio = Date.newInstance( // data de colheita
                    today.year(),
                    Integer.valueOf(plazo.Cadastro_de_colheita__c.substringAfter('/')),
                    Integer.valueOf(plazo.Cadastro_de_colheita__c.substringBefore('/'))
                );
            } else {
                fechaInicio = Date.newInstance(
                    today.year(),
                    Integer.valueOf(plazo.Cadastro_de_plantio__c.substringAfter('/')),
                    Integer.valueOf(plazo.Cadastro_de_plantio__c.substringBefore('/'))
                );
            }

            fechaTermino = Date.newInstance(
                today.year(),
                Integer.valueOf(plazo.Termino__c.substringAfter('/')),
                Integer.valueOf(plazo.Termino__c.substringBefore('/'))
            );

            // if (fechaTermino < fechaInicio) {
            //  fechaTermino = fechaTermino.addYears(1);
            // }

            // match = fechaInicio > today || fechaTermino < today;
        } else {
            fechaInicio = Date.newInstance(
                today.year(),
                Integer.valueOf(plazo.Inicio__c.substringAfter('/')),
                Integer.valueOf(plazo.Inicio__c.substringBefore('/'))
            );

            fechaTermino = Date.newInstance(
                today.year(),
                Integer.valueOf(plazo.Termino__c.substringAfter('/')),
                Integer.valueOf(plazo.Termino__c.substringBefore('/'))
            );

            // if (fechaTermino < fechaInicio) { fechaTermino = fechaTermino.addYears(1); }

            // match = fechaInicio > today || fechaTermino < today;
        }

        if (fechaInicio.month() <= fechaTermino.month()) {
            anoInicio = today.year();
            anoFinal = today.year();
        } else if (today.month() <= fechaInicio.month()) {
            anoInicio = today.year() - 1;
            anoFinal = today.year();
        } else {
            anoInicio = today.year();
            anoFinal = today.year() + 1;
        }

        fechaInicio = Date.newInstance(anoInicio, fechaInicio.month(), fechaInicio.day());

        fechaTermino = Date.newInstance(anoFinal, fechaTermino.month(), fechaTermino.day());

        if (today >= fechaInicio && today <= fechaTermino) {
            match = false;
        } else {
            match = true;
        }

        return match;
    }

    /**
     * Solo debe de haber un Producto Principal seleccionado, valida si un item y solo un (1) item fue elegido como principal (US 11589).
     */
    private Boolean validatePrincipalProduct() {
        Integer count = 0;

        for (item i : tmpEventoItems2) {
            if (i.produto_principal) {
                count++;
            }
        }

        return !tmpEventoItems2.isEmpty() && count != 1;
    }

    /**
     * Solo debe de haber un Producto Principal seleccionado, el usuario puede seleccionar un producto principal y debe deseleccionarse el principal actual (US 11589).
     */
    public Pagereference changePrincipalProduct() {
        for (item i : tmpEventoItems2) {
            if (i.produto_principal && i.indice != principalSelected) {
                i.produto_principal = false;
            }
        }

        return null;
    }

    /**
     * Deduce el nombre de la Fase del CRM Evento seleccionado para Lado a Lado y Emplacamento (US 11593 y US 11600).
     * Este método no se utilizará porque su lógica es remplazada por los cambios para la US 13383, de momento este método está deprecado.
     */
    public String getFaseCRMEvento() {
        String fase = '';
        Integer count = 0;

        CRM_Calendario_de_Eventos__c[] relatedEventosAux = relatedEventos.values();

        while (count < relatedEventosAux.size() && fase == '') {
            if (relatedEventosAux[count].Id == recId) {
                fase = relatedEventosAux[count].Fase__c;
            }

            count++;
        }

        if (tipoEvento == 'Test a campo') {
            CRM_Detalle_Calendario_de_eventos__c item = null;
            count = 0;

            while (count < relatedEventoItems.size() && item == null) {
                if (relatedEventoItems[count].Produto_Principal__c) {
                    item = relatedEventoItems[count];
                }

                count++;
            }

            if (item != null) {
                Date today = System.today();

                switch on fase {
                    when 'Pendente' {
                        fase = 'Aguardando validação';
                    }
                    when 'Aprovado' {
                        if (item.Data_de_plantio__c != null && item.Data_de_colheita__c == null) {
                            fase = 'Aguardando resultado de colheita';
                        }
                    }
                    when 'Reprovado' {
                        if (item.Data_de_plantio__c != null) {
                            if (item.Data_de_colheita__c != null) {
                                if (today >= item.Data_de_plantio__c && today <= item.Data_de_colheita__c) {
                                    fase = 'Edição de dados de colheita';
                                } else if (today > item.Data_de_colheita__c) {
                                    fase = 'Reprovados';
                                }
                            } else if (today >= item.Data_de_plantio__c) {
                                fase = 'Edição de dados de plantio';
                            } else {
                                fase = 'Reprovados';
                            }
                        }
                    }
                }
            }
        } else if (tipoEvento == 'Emplacamento') {
            switch on fase {
                when 'Pendente' {
                    fase = 'Aguardando validação';
                }
                when 'Reprovado' {
                    fase = 'Reprovados';
                }
            }
        }

        return fase;
    }

    public PageReference enviarAprobacion() {
        if (String.isNotEmpty(enviarAprobacion)) {
            mensaje = validarAprobacion(enviarAprobacion);

            if (String.isEmpty(mensaje)) {
                aEventosManager.enviarEventoAprobacion(enviarAprobacion);
            } else {
                return null;
            }
        }

        enviarAprobacion = null;
        aAppManager.updateSession(activeSession);

        PageReference pr = new PageReference('/apex/aSiteEventos');
        pr.setRedirect(true);
        pr.getParameters().put('token', token);
        pr.getParameters().put('evento', titulo);
        return pr;
    }

    public void cargarEventosTipoReg() {
        mapEventosTipoReg = aEventosManager.getEventosTipoReg();
    }

    public void cargarObtentores() {
        optionsObtentor = new List<SelectOption>{ new SelectOption('', '') };

        for (String s : aEventosManager.getObtentores()) {
            optionsObtentor.add(new SelectOption(s, s));
        }
    }

    public void agregarItem() {
        item tmp = new item();
        tmp.obtentor = tmpEventoItemsNew2[linea].obtentor;
        tmp.id_producto = tmpEventoItemsNew2[linea].id_producto;
        tmp.desc_producto = tmpEventoItemsNew2[linea].desc_producto;

        mensaje = '';

        if (tmpEventoItems2.size() >= 4) {
            // validaciones US 11590
            mensaje = 'É permitido informar no máximo 4 produtos';
        } else if (!tmp.desc_producto.startsWithIgnoreCase('outro') && containsItem(tmpEventoItems2, tmp.desc_producto)) {
            mensaje = 'Não é permitido informar o mesmo produto mais de uma vez, com exceção do produto outros';
        } else {
            tmp.produto_principal = tmpEventoItems2.isEmpty() && tipoEvento == 'Test a campo'; // en Lado a Lado se especifica un producto principal
            tmpEventoItems2.add(tmp);

            Integer j = 0;

            for (item i : tmpEventoItems2) {
                i.indice = j;
                j++;
            }

            linea = null;
        }
    }

    /**
     * retorna true si la lista de items contiene el nombre de producto especificado, se busca por desc_producto (cultivar/producto/variedad).
     */
    private Boolean containsItem(List<item> tmps, String desc_producto) {
        Integer count = 0;
        Boolean match = false;

        while (count < tmps.size() && !match) {
            match = tmps[count].desc_producto == desc_producto;
            count++;
        }

        return match;
    }

    public void removerItem() {
        if (tmpEventoItems2[linea].Id != null) {
            if (tmpAppItemsRemove == null) {
                tmpAppItemsRemove = new List<item>();
            }
            tmpAppItemsRemove.add(tmpEventoItems2[linea]);
        }

        tmpEventoItems2.remove(linea);
        Integer j = 0;

        for (item i : tmpEventoItems2) {
            i.indice = j;
            j++;
        }

        linea = null;
    }

    public void goVerItems() {
        verItems = true;
    }

    public void verItemsListo() {
        if (tipoEvento == 'Test a campo' && tmpEventoItems2 != null && validatePrincipalProduct()) {
            // validaciones US 11589
            mensaje = 'Você deve especificar: um (1) produto principal';
        } else {
            mensaje = '';
            verItems = false;
            linea = null;
            tmpEventoItemsNew2 = null;
        }
    }

    public void goVerArchivos() {
        saveEvento();
        verArchivos = true;
    }

    public PageReference verArchivosListo() {
        PageReference pr = new PageReference('/apex/aSiteEventoEdit');
        pr.setRedirect(true);
        pr.getParameters().put('e', evento2.Id);
        pr.getParameters().put('token', token);
        pr.getParameters().put('evento', titulo);
        pr.getParameters().put('goArchivos', '0');
        return pr;
    }

    public void editItem() {
        getVariedadesObt_Edit_Evento();
    }

    public void editItemListo() {
        for (item i : tmpEventoItems2) {
            if (i.id_producto != null && mapNombresProd.get(i.id_producto) != null) {
                i.desc_producto = mapNombresProd.get(i.id_producto);
            }
        }

        linea = null;
    }

    public void cargarNombresProds() {
        mapNombresProd = new Map<String, String>();

        for (Product2 p : [SELECT Id, Name FROM Product2 WHERE Obtentor__c != NULL]) {
            mapNombresProd.put(p.Id, p.Name);
        }
    }

    public void changeTipoCuentaAgricultor() {
        evento2.cpf_cnpj_agricultor = null;
    }

    public void changeTipoCuentaRevenda() {
        evento2.cpf_cnpj_revenda = null;
    }

    public List<Schema.FieldSetMember> getFieldsCab() {
        List<Schema.FieldSetMember> retorno = null;

        if (tipoEvento == 'Día de Campo') {
            retorno = SObjectType.CRM_Calendario_de_Eventos__c.FieldSets.Dia_de_Campo.getFields();
        } else if (tipoEvento == 'Emplacamento') {
            retorno = SObjectType.CRM_Calendario_de_Eventos__c.FieldSets.Emplacamento.getFields();
        } else if (tipoEvento == 'Treinamento Tecnico') {
            retorno = SObjectType.CRM_Calendario_de_Eventos__c.FieldSets.Treinamento_Tecnico.getFields();
        } else if (tipoEvento == 'Test a campo') {
            retorno = SObjectType.CRM_Calendario_de_Eventos__c.FieldSets.Test_a_campo.getFields(); // Lado a Lado
        }

        return retorno;
    }

    public List<Schema.FieldSetMember> getFields() {
        List<Schema.FieldSetMember> retorno = null;

        if (tipoEvento == 'Día de Campo') {
            retorno = SObjectType.CRM_Detalle_Calendario_de_eventos__c.FieldSets.Dia_de_Campo.getFields();
        } else if (tipoEvento == 'Emplacamento') {
            retorno = SObjectType.CRM_Detalle_Calendario_de_eventos__c.FieldSets.Emplacamento.getFields();
        } else if (tipoEvento == 'Treinamento Tecnico') {
            retorno = SObjectType.CRM_Detalle_Calendario_de_eventos__c.FieldSets.Treinamento_Tecnico.getFields();
        } else if (tipoEvento == 'Test a campo') {
            retorno = SObjectType.CRM_Detalle_Calendario_de_eventos__c.FieldSets.Test_a_campo.getFields(); // Lado a Lado
        }

        return retorno;
    }

    public List<SelectOption> getOptionDivulgarEmNomeDe() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '-- None --') };
        Schema.DescribeFieldResult fieldResult = CRM_Calendario_de_Eventos__c.Divulgar_em_nome_de__c.getDescribe();

        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        return options;
    }

    public List<SelectOption> getOptionTipoCuenta() {
        return new List<SelectOption>{
            new SelectOption('', '-- None --'),
            new SelectOption('CPF', 'CPF'),
            new SelectOption('CNPJ', 'CNPJ')
        };
    }

    public List<SelectOption> getOptionAttachmentType() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Attachment_Content__c.Attachment_Type__c.getDescribe();

        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        return options;
    }

    public List<SelectOption> getOptionCulturaAntecessora() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '-- None --') };
        Schema.DescribeFieldResult fieldResult = CRM_Detalle_Calendario_de_eventos__c.Cultura_antecessora__c.getDescribe();

        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }

        return options;
    }

    public PageReference gotoEdit() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteEventoEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token', token);
        pr.getParameters().put('e', editId);
        pr.getParameters().put('evento', titulo);
        return pr;
    }

    public PageReference gotoNew() {
        String token = System.currentPageReference().getParameters().get('token');
        PageReference pr = new PageReference('/apex/aSiteEventoEdit');
        pr.setRedirect(true);
        pr.getParameters().put('token', token);
        pr.getParameters().put('evento', titulo);
        return pr;
    }

    public PageReference editCancel() {
        PageReference pr = new PageReference('/apex/aSiteEventos');
        pr.setRedirect(true);
        pr.getParameters().put('token', token);
        pr.getParameters().put('evento', titulo);
        return pr;
    }

    public SiteUser__c getUser() {
        return logUser;
    }

    public Account getAccount() {
        return activeAccount;
    }

    /**
     * Añade un Attachment Content relacionado al CRM Evento especificado en el wrapper evento2, se almacena el archivo subido por el usuario en un Attachment relacionado al Attachment Content.
     */
    public PageReference addAttachment() {
        if (archivo == null || archivo[0].att.Body == null) {
            return null;
        }

        if (evento2.Id != null) {
            Attachment_Content__c attContent = new Attachment_Content__c(CRM_Calendario_de_Eventos__c = evento2.Id);

            if (String.isNotEmpty(archivo[0].tipo)) {
                // Los eventos Lado a Lado permiten especificar un tipo de archivo (US 11591)
                attContent.Attachment_Type__c = archivo[0].tipo;
            }

            Database.SaveResult sr = Database.insert(attContent, false);

            if (sr.isSuccess()) {
                Attachment att = new Attachment(
                    Name = archivo[0].att.Name,
                    Body = archivo[0].att.Body,
                    ParentId = attContent.Id
                );

                insert att;
                archivos.add(new adjunto(attContent.Id, attContent.Attachment_Type__c, att));
            } else {
                for (Database.Error err : sr.getErrors()) {
                    System.debug(err.getMessage());
                }
            }
        }

        PageReference pr = new PageReference('/apex/aSiteEventoEdit');
        pr.setRedirect(true);
        pr.getParameters().put('e', evento2.Id);
        pr.getParameters().put('token', token);
        pr.getParameters().put('evento', titulo);
        pr.getParameters().put('goArchivos', '1');
        return pr;
    }

    /**
     * Elimina el Attachment Content especificado en el parámetro attToRemove, en caso exitoso se elimina el adjunto correspondiente en la lista de archivos adjuntos.
     */
    public PageReference removeAttachment() {
        if (attToRemove != null) {
            Database.DeleteResult dr = Database.delete(attToRemove, false);

            if (dr.isSuccess()) {
                Integer count = 0;

                while (count < archivos.size() && archivos[count].id != attToRemove) {
                    count++;
                }

                archivos.remove(count);
                attToRemove = null;
            } else {
                for (Database.Error err : dr.getErrors()) {
                    System.debug(err.getMessage());
                }
            }
        }

        return null;
    }
}