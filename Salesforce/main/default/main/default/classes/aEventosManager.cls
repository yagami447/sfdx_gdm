public class aEventosManager {

    public aEventosManager() {}

    public static String getSafraActualEventos() {
        String safra = null;

        try {
            List<Configuracion_BMX__c> conf = aSiteUtils.queryResults1(Configuracion_BMX__c.SObjectType, null, 'Id != :v1', null);
            safra = conf[0].PM_Safra_Actual_Eventos__c;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return safra;
    }

    public static List<String> getTiposEvento() {
        List<String> lista = new List<String>();
        Schema.DescribeFieldResult eventos = CRM_Calendario_de_Eventos__c.Evento__c.getDescribe();
    
        for (Schema.PickListEntry p : eventos.getPickListValues()) {
            String v = p.getvalue();

            if (v == 'Lado a Lado' || v == 'Emplacamento' || v == 'Palestra' || v == 'Treinamento') {
                lista.add(v);
            }
        }

        return lista;
    }

    public static List<String> getObtentores() {
        List<String> lista = new List<String>();
        Schema.DescribeFieldResult productos = Product2.Obtentor__c.getDescribe();

        for (Schema.PickListEntry p : productos.getPickListValues()) {
            lista.add(p.getvalue());
        }

        return lista;
    }

    public static List<Product2> getProductos(String filtro, String tipoEvento) {
        String qString = 'SELECT Id, Name, Obtentor__c FROM Product2 WHERE Obtentor__c != null';

        if (String.isNotEmpty(filtro)) {
            qString += ' AND (Name LIKE \'%' + filtro + '%\' OR Obtentor__c LIKE \'%' + filtro + '%\')';
        }

        if (tipoEvento == 'Treinamento Tecnico') {
            qString += ' AND Name = \'Outro\'';
        }

        qString += ' LIMIT 21';

        return Database.query(qString);
    }

    public static Map<String, String> getEventosTipoReg() {
        Map<String, String> retorno = new Map<String, String>();

        for (String s : getTiposEvento()) {
            if (s == 'Día de Campo' || s == 'Estação DONMARIO MAS' || s == 'Tour dos Máximos Rendimentos' || s == 'Feiras') {
                retorno.put(s, 'Día de Campo');
            } else if (s == 'Palestra' || s == 'Treinamento' || s == 'Encontro Técnico' || s == 'Jornada Técnica') {
                retorno.put(s, 'Treinamento Tecnico');
            } else if (s == 'Strip Test' || s == 'Lado a Lado' || s == 'CESB' || s == 'Area comercial') {
                retorno.put(s, 'Test a campo');
            } else if (s == 'Emplacamento' || s == 'Outdoor') {
                retorno.put(s, 'Emplacamento');
            }
        }

        return retorno;
    }

    public static String valDatos(aSiteEventosController.evento evento, List<aSiteEventosController.item> items, String tipoEvento) {
        String latitud = String.isEmpty(evento.latitud) ? '0' : evento.latitud;
        String longitud = String.isEmpty(evento.longitud) ? '0' : evento.longitud;
        String participantes = String.isEmpty(evento.participantes) ? '0' : evento.participantes;
        String costo = String.isEmpty(evento.costo) ? '0' : evento.costo;
        String valDatosOblig = '';

        if (tipoEvento == 'Treinamento Tecnico') {
            if (evento.fechaInicio == null || evento.fechaFin == null) {
                valDatosOblig = 'Dados obligatorios: Data e horario inicio - Data e horario termino.';
            }
        } else if (evento.evento == 'Lado a Lado') {      

            if (evento.autorizado && String.isEmpty(evento.divulgarEmNomeDe)) {
                valDatosOblig = 'Você deve especificar: Divulgar em nome de';
            }
        }

        if (valDatosOblig != '') { return valDatosOblig; }

        String valDatosValidos = '';

        if (!Pattern.matches('-?[0-9]+(\\.[0-9]{1,6})?', latitud) || !Pattern.matches('-?[0-9]+(\\.[0-9]{1,6})?', longitud)) {
            valDatosValidos = 'Inseriu algum dado não valido. Por favor verificar Latitud e longitud com 6 decimais. Utilizar ponto (.) como separador de casas decimais.';
        }

        if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', costo) || !Pattern.matches('([0-9]+)', participantes)) {
            valDatosValidos = 'Inseriu algun dado não valido. Por favor verificar Custo e Participantes';
        }
             
        if (valDatosValidos != '') { return valDatosValidos; }

        if (String.isNotEmpty(evento.cpf_cnpj_agricultor)) {
            if (evento.tipoAgricultor == 'CPF') {
                if (!Pattern.matches('[0-9]{11}', evento.cpf_cnpj_agricultor)) {
                    valDatosValidos = 'Deve usar 11 dígitos para o CPF.';
                }
            } else if (evento.tipoAgricultor == 'CNPJ') {
                if (!Pattern.matches('[0-9]{14}', evento.cpf_cnpj_agricultor)) {
                    valDatosValidos = 'Deve usar 14 dígitos para o CNPJ.';
                }
            }
        }

        if (valDatosValidos != '') { return valDatosValidos; }

        if (evento.cpf_cnpj_revenda != null && evento.cpf_cnpj_revenda != '') {
            if (evento.tipoRevenda == 'CPF') {
                if (!Pattern.matches('[0-9]{11}', evento.cpf_cnpj_revenda)) {
                    valDatosValidos = 'Deve usar 11 dígitos para o CPF.';
                }
            } else if (evento.tipoRevenda == 'CNPJ') {
                if (!Pattern.matches('[0-9]{14}', evento.cpf_cnpj_revenda)) {
                    valDatosValidos = 'Deve usar 14 dígitos para o CNPJ.';
                }
            }
        }

        if (valDatosValidos != '') { return valDatosValidos; }

        Integer j = 0;
        String valDatosObligItems = '';

        for (aSiteEventosController.item i : items) {
            if (String.isEmpty(i.obtentor) || String.isEmpty(i.id_producto)) {
                valDatosObligItems += 'Produtos ' + Label.Linea + ' ' + (j + 1) + ': Dados obligatorios: Obtentor - Produto.|';
            }

            j++;
        }

        if (valDatosObligItems != '') { return valDatosObligItems; }

        j = 0;
        String valDatosValidosItems = '';

        for (aSiteEventosController.item i : items) {
            String area_c = String.isEmpty(i.area_colhida) ? '0' : i.area_colhida;
            String area_p = String.isEmpty(i.area_plantada) ? '0' : i.area_plantada;
            String prod = String.isEmpty(i.produtividade) ? '0' : i.produtividade;
            String vol_d = String.isEmpty(i.volume_doado) ? '0' : i.volume_doado;

            if (!Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', area_c) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', area_p) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', prod) || !Pattern.matches('[0-9]+(\\.[0-9]{1,2})?', vol_d)) {
                valDatosValidosItems += 'Produtos ' + Label.Linea + ' ' + (j + 1) + ': Inseriu algun não valido.|';
            }

            j++;
        }

        if (valDatosValidosItems != '') { return valDatosValidosItems; }

        return '';
    }

    public static aSiteUtils.retorno saveEvento(aSiteEventosController.evento evento, List<aSiteEventosController.item> items, List<aSiteEventosController.item> delItems, String tipoEvento, SiteUser__c logUser) {
        Savepoint sp = Database.setSavepoint();
        aSiteUtils.retorno ret = new aSiteUtils.retorno();
        CRM_Calendario_de_Eventos__c evento2 = new CRM_Calendario_de_Eventos__c();

        try {
            String msg = valDatos(evento, items, tipoEvento);

            if (msg != '') {
                ret.mensaje = msg;
                ret.exito = false;
                ret.id = null;
                return ret;
            }

            Map<String, String> accsCNPJ = new Map<String, String>();

            for (Account acc : [SELECT Id, CNPJ_CPF__c FROM Account WHERE CNPJ_CPF__c != null]) {
                String cnpjAux = acc.CNPJ_CPF__c.replace('.','');
                cnpjAux = cnpjAux.replace('-','');
                cnpjAux = cnpjAux.replace('/','');
                accsCNPJ.put(cnpjAux, acc.Id);
            }

            evento2.Data_e_horario_inicio__c = evento.fechaInicio;
            evento2.Data_e_horario_termino__c = evento.fechaFin;
            evento2.Evaluacion__c = evento.evaluacion;
            evento2.Municipio__c = String.isNotEmpty(evento.ciudad) ? evento.ciudad : null;
            evento2.Comentarios__c = evento.comentarios;
            evento2.Custo__c = String.isNotEmpty(evento.costo) ? Double.valueOf(evento.costo) : null;
            evento2.Direccion__c = evento.direccion;
            evento2.Evento__c = evento.evento;

            if (evento.finalizado != null) { evento2.Finalizado__c = evento.finalizado; }
            if (evento.irrigado != null) { evento2.Irrigado__c = evento.irrigado; }
            if (evento.autorizado != null) { evento2.Autorizado__c = evento.autorizado; }
            if (evento.usarCoorCiudad != null) { evento2.Usar_coordenadas_da_Cidade__c = evento.usarCoorCiudad; }

            evento2.Latitud__c = String.isNotEmpty(evento.latitud) ? Double.valueOf(evento.latitud) : null;
            evento2.Longitud__c = String.isNotEmpty(evento.longitud) ? Double.valueOf(evento.longitud) : null;
            evento2.Nome_do_agricultor_2__c = evento.agricultor;
            evento2.Revenda_2__c = evento.revenda;
            evento2.Numero_de_participantess__c = String.isNotEmpty(evento.participantes) ? Integer.valueOf(evento.participantes) : null;
            evento2.Divulgar_em_nome_de__c = evento.divulgarEmNomeDe;
            evento2.Tipo_Conta_Agricultor__c = evento.tipoAgricultor;
            evento2.Tipo_Conta_Revenda__c = evento.tipoRevenda;
            evento2.CNPJ_CPF_Agricultor__c = evento.cpf_cnpj_agricultor;
            evento2.CNPJ_CPF_Revenda__c = evento.cpf_cnpj_revenda;

            if (String.isNotEmpty(evento.cpf_cnpj_agricultor)) {
                evento2.Agricultor__c = accsCNPJ.get(evento.cpf_cnpj_agricultor);
            }

            if (String.isNotEmpty(evento.cpf_cnpj_revenda)) {
                evento2.Revenda__c = accsCNPJ.get(evento.cpf_cnpj_revenda);
            }

            if (evento.id == null) {
                evento2.Fase__c = 'Edição';
                evento2.Cuenta__c = evento.cuenta;
                evento2.Marca__c = evento.marca;
                evento2.Safra__c = evento.safra;
                evento2.Data__c = System.today();
                evento2.Realizado_por__c = 'Multiplicador';
                evento2.Participante__c = 'Multiplicador';
                evento2.Usuario__c = logUser.Id;

                if (tipoEvento == 'Treinamento Tecnico') { evento2.Finalizado__c = true; }

                List<RecordType> rt = aSiteUtils.queryResults2(SObjectType.RecordType.getSObjectType(), null, 'Name = :v1', tipoEvento, 'SObjectType = :v2', 'CRM_Calendario_de_Eventos__c');
                if (!rt.isEmpty()) { evento2.RecordTypeId = rt[0].Id; }

                Account acc = [SELECT Id, Responsavel__c, Reponsavel_DSEM__c, Responsavel_NEOGEN__c, Responsavel_DAGMA__c, Responsavel_LICENCAS__c, Region__r.Region_Comercial__c FROM Account WHERE Id = : evento2.Cuenta__c];
                String usuario = null;

                switch on evento2.Marca__c {

                    when 'BRMX' {
                        if (acc.Responsavel__c != null) {
                            usuario = acc.Responsavel__c;
                        }
                    }

                    when 'DSEM' {
                        if (acc.Reponsavel_DSEM__c != null) {
                            usuario = acc.Reponsavel_DSEM__c;
                        }
                    }

                    when 'NEOG' {
                        if (acc.Responsavel_NEOGEN__c != null) {
                            usuario = acc.Responsavel_NEOGEN__c;
                        }
                    }

                    when 'DAGMA' {
                        if (acc.Responsavel_DAGMA__c != null) {
                            usuario = acc.Responsavel_DAGMA__c;
                        }     
                    }

                    when 'LICENÇAS' {
                        if (acc.Responsavel_LICENCAS__c != null) {
                            usuario = acc.Responsavel_LICENCAS__c;
                        }
                    }
                }

                if (usuario != null) {
                    List<User> u = new List<User>([SELECT Id FROM User WHERE Codigo_SAP__c = :usuario.split('-')[0].trim() AND isActive = true LIMIT 1]);
                    if (!u.isEmpty()) { evento2.OwnerId = u[0].Id; }
                }

                insert evento2;
            } else {
                evento2.Id = evento.id;
                update evento2;
            }

            List<CRM_Detalle_Calendario_de_eventos__c> insertItems = new List<CRM_Detalle_Calendario_de_eventos__c>();
            List<CRM_Detalle_Calendario_de_eventos__c> updateItems = new List<CRM_Detalle_Calendario_de_eventos__c>();

            for (aSiteEventosController.item i : items) {
                CRM_Detalle_Calendario_de_eventos__c itm = new CRM_Detalle_Calendario_de_eventos__c(
                    Id = i.Id,
                    Obtentor__c = i.obtentor,
                    Cultivar__c = i.id_producto,
                    Data_de_plantio__c = i.data_plantio,
                    Data_de_colheita__c = i.data_colheita,
                    Area_Colhida__c = String.isNotEmpty(i.area_colhida) ? Double.valueOf(i.area_colhida) : null,
                    Area_plantada__c = String.isNotEmpty(i.area_plantada) ? Double.valueOf(i.area_plantada) : null,
                    Produtividade__c = String.isNotEmpty(i.produtividade) ? Double.valueOf(i.produtividade) : null,
                    Volume_Doado__c = String.isNotEmpty(i.volume_doado) ? Double.valueOf(i.volume_doado) : null,
                    Populacao_de_plantas__c = String.isNotEmpty(i.populacao_de_plantas) ? Double.valueOf(i.populacao_de_plantas) : null,
                    Espacamento__c = String.isNotEmpty(i.espacamento) ? Double.valueOf(i.espacamento) : null,
                    Cultura_antecessora__c = i.cultura_antecessora
                );

                if (i.produto_principal != null) {
                    itm.Produto_Principal__c = i.produto_principal;
                }

                if (itm.Id == null) {
                    itm.CRM_Calendario_de_eventos__c = evento2.Id;
                    insertItems.add(itm);
                } else {
                    updateItems.add(itm);
                }
            }

            if (!insertItems.isEmpty()) { insert insertItems; }
            if (!updateItems.isEmpty()) { update updateItems; }

            if (delItems != null && !delItems.isEmpty()) {
                Set<String> idItemsDel = new Set<String>();

                for (aSiteEventosController.item i : delItems) {
                    idItemsDel.add(i.id);
                }

                List<CRM_Detalle_Calendario_de_eventos__c> borrarItems = [SELECT Id FROM CRM_Detalle_Calendario_de_eventos__c WHERE Id IN :idItemsDel];
                if (!borrarItems.isEmpty()) { delete borrarItems; }
            }
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('ERROR '+ e.getLineNumber() + ', ' + e.getMessage());
            ret.mensaje = e.getMessage();
            ret.exito = false;
            ret.id = null;
            return ret;
        }

        ret.mensaje = null;
        ret.exito = true;
        ret.id = evento2.Id;
        return ret;
    }

    public static List<Attachment> getArchivosByEvento(Id eventoId) {
        try {
            return aSiteUtils.queryResults1(Attachment.SObjectType, null,'ParentId = :v1', eventoId);
        } catch (Exception e) {
            return null;
        }
    }

    public static List<CRM_Calendario_de_Eventos__c> getEventos(Id accId, String safra, String marca, String tipo) {
        try {
            return aSiteUtils.queryResults5(CRM_Calendario_de_Eventos__c.SObjectType, null,'Cuenta__c = :v1', accId, 'Evento__c = :v2', tipo, 'Safra__c = :v3',safra, 'Marca__c = :v4', marca, 'Realizado_por__c = :v5', 'Multiplicador');
        } catch (Exception e) {
            return null;
        }
    }

    public static List<CRM_Detalle_Calendario_de_eventos__c> getEventosItemsByEvento(Id eventoId) {
        try {
            String queryPlus = 'Cultivar__r.Name';
            return aSiteUtils.queryResults1(CRM_Detalle_Calendario_de_eventos__c.SObjectType, queryPlus ,'CRM_Calendario_de_eventos__c = :v1', eventoId);
        } catch (Exception e) {
            return null;
        }
    }

    public static void enviarEventoAprobacion(String idEvento) {
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
        req1.setObjectId(idEvento);

        List<CRM_Calendario_de_Eventos__c> even = aSiteUtils.queryResults1(CRM_Calendario_de_Eventos__c.SObjectType, null, 'Id = :v1', idEvento);
        List<Id> nextApproverIds = new List<Id>{even[0].OwnerId};
        req1.setNextApproverIds(nextApproverIds);

        if (!Test.isRunningTest()) {
            Approval.ProcessResult result = Approval.process(req1);
        }
    }

    public static aSiteEventosController.evento getEvento(Id eventoId) {
        try {
            String queryPlus = '';            
            aSiteEventosController.evento evento = new aSiteEventosController.evento();
            List<CRM_Calendario_de_Eventos__c> eventos = aSiteUtils.queryResults1(CRM_Calendario_de_Eventos__c.SObjectType, null ,'Id = :v1', eventoId);

            for (CRM_Calendario_de_Eventos__c e : eventos) {
                evento.id = e.Id;
                evento.fase = e.Fase__c;
                evento.prazoDeLancamento = e.Prazo_de_Lancamento__c;
                evento.fecha = e.Data__c;
                evento.fechaInicio = e.Data_e_horario_inicio__c;
                evento.fechaFin = e.Data_e_horario_termino__c;
                evento.cuenta = e.Cuenta__c;
                evento.marca = e.Marca__c;
                evento.estado = e.Estado__c;
                evento.safra = e.Safra__c;
                evento.evaluacion = e.Evaluacion__c;
                evento.ciudad = e.Municipio__c;
                evento.ciudad_nombre = e.Nome_Cidade__c;
                evento.comentarios = e.Comentarios__c;
                evento.costo = String.valueOf(e.Custo__c);
                evento.direccion = e.Direccion__c;
                evento.evento = e.Evento__c;
                evento.finalizado = e.Finalizado__c;
                evento.irrigado = e.Irrigado__c;
                evento.usarCoorCiudad = e.Usar_coordenadas_da_Cidade__c;
                evento.latitud = String.valueOf(e.Latitud__c);
                evento.longitud = String.valueOf(e.Longitud__c);
                evento.agricultor = e.Nome_do_agricultor_2__c;
                evento.revenda = e.Revenda_2__c;
                evento.participantes = String.ValueOf(e.Numero_de_participantess__c);
                evento.tipoAgricultor = e.Tipo_Conta_Agricultor__c;
                evento.tipoRevenda = e.Tipo_Conta_Revenda__c;
                evento.cpf_cnpj_agricultor = e.CNPJ_CPF_Agricultor__c;
                evento.cpf_cnpj_revenda = e.CNPJ_CPF_Revenda__c;
                evento.autorizado = e.Autorizado__c;
                evento.divulgarEmNomeDe = e.Divulgar_em_nome_de__c;
            }

            return evento;            
        } catch (Exception e) {
            return null;
        }
    }
}