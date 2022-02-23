@IsTest
private class CultivarsTechnicalInformationTest {

    @TestSetup static void setup() {
        Variedad__c[] variedades = new Variedad__c[6];

        variedades[0] = Build.aVariedad()
            .withName('BRASMAX RAIO IPRO')
            .withNombredeRegistro('50I52RSF IPRO')
            .withMarcacomercial('Brasmax')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[0].Tecnologia__c = 'IPRO';
        variedades[0].Marca__c = 'BRMX';

        variedades[1] = Build.aVariedad()
            .withName('BRASMAX TROVÃO I2X')
            .withNombredeRegistro('51IX51RSF I2X')
            .withMarcacomercial('Brasmax')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[1].Tecnologia__c = 'I2X';
        variedades[1].Marca__c = 'BRMX';

        variedades[2] = Build.aVariedad()
            .withName('DM53i54 IPRO')
            .withNombredeRegistro('53I54RSF IPRO')
            .withMarcacomercial('DM Sementes')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[2].Tecnologia__c = 'IPRO';
        variedades[2].Marca__c = 'DSEM';

        variedades[3] = Build.aVariedad()
            .withName('BRASMAX ZEUS IPRO')
            .withNombredeRegistro('55I57RSF IPRO')
            .withMarcacomercial('Brasmax')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[3].Tecnologia__c = 'IPRO';
        variedades[3].Marca__c = 'BRMX';

        variedades[4] = Build.aVariedad()
            .withName('DM56i59 IPRO')
            .withNombredeRegistro('56I59RSF IPRO')
            .withMarcacomercial('DM Sementes')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[4].Tecnologia__c = 'IPRO';
        variedades[4].Marca__c = 'DSEM';

        variedades[5] = Build.aVariedad()
            .withName('NEO730 RR')
            .withNombredeRegistro('730 RR')
            .withMarcacomercial('Neogen')
            .withAtiva(true)
            .withDisponivelVendaBasica(true)
            .build();

        variedades[5].Tecnologia__c = 'RR';
        variedades[5].Marca__c = 'NEOG';

        insert variedades;

        Variedad_Datos_Complementares__c[] datosComplementares = new Variedad_Datos_Complementares__c[]{
            new Variedad_Datos_Complementares__c(
                Name = 'BRASMAX RAIO IPRO',
                Variedad__c = variedades[0].Id
            ),
            new Variedad_Datos_Complementares__c(
                Name = 'BRASMAX TROVÃO I2X',
                Variedad__c = variedades[1].Id
            ),
            new Variedad_Datos_Complementares__c(
                Name = 'DM53i54 IPRO',
                Variedad__c = variedades[2].Id
            ),
            new Variedad_Datos_Complementares__c(
                Name = 'BRASMAX ZEUS IPRO',
                Variedad__c = variedades[3].Id
            ),
            new Variedad_Datos_Complementares__c(
                Name = 'DM56i59 IPRO',
                Variedad__c = variedades[4].Id
            ),
            new Variedad_Datos_Complementares__c(
                Name = 'NEO730 RR',
                Variedad__c = variedades[5].Id
            )
        };

        insert datosComplementares;

        Recomenda_o_de_variedade__c[] recomendaciones = new Recomenda_o_de_variedade__c[]{
            new Recomenda_o_de_variedade__c(
                Name = 'Campos de Cima da Serra do RS (104)',
                Variedad__c = variedades[0].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Leste de SC (104)',
                Variedad__c = variedades[0].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Oeste de SC (103)',
                Variedad__c = variedades[0].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Campos de Cima da Serra do RS (104)',
                Variedad__c = variedades[1].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Leste de SC (104)',
                Variedad__c = variedades[1].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Oeste de SC (103)',
                Variedad__c = variedades[1].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Campos de Cima da Serra do RS (104)',
                Variedad__c = variedades[2].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Leste de SC (104)',
                Variedad__c = variedades[2].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Norte do PR alto (203)',
                Variedad__c = variedades[2].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Campos de Cima da Serra do RS (104)',
                Variedad__c = variedades[3].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Leste de SC (104)',
                Variedad__c = variedades[3].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Missões do RS (102)',
                Variedad__c = variedades[3].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Campos de Cima da Serra do RS (104)',
                Variedad__c = variedades[4].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Leste de SC (104)',
                Variedad__c = variedades[4].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Missões do RS (102)',
                Variedad__c = variedades[4].Id,
                Regi_o__c = 'SUL'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Alto Paranaíba e Triângulo MG (303)',
                Variedad__c = variedades[5].Id,
                Regi_o__c = 'Cerrado'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'DF (304)',
                Variedad__c = variedades[5].Id,
                Regi_o__c = 'Cerrado'
            ),
            new Recomenda_o_de_variedade__c(
                Name = 'Noroeste de MG (304)',
                Variedad__c = variedades[5].Id,
                Regi_o__c = 'Cerrado'
            )
        };

        insert recomendaciones;
    }

    @isTest static void countNumberOfRowsTest1() {
        AggregateResult result = null;

        Test.startTest();
        result = VariedadDatosComplementaresController.countDatosComplementares('', '');
        System.assertEquals(6, result.get('Total'));

        result = VariedadDatosComplementaresController.countDatosComplementares('BRMX', '');
        System.assertEquals(3, result.get('Total'));

        result = VariedadDatosComplementaresController.countDatosComplementares('NEOG', '');
        System.assertEquals(1, result.get('Total'));

        result = VariedadDatosComplementaresController.countDatosComplementares('', 'IPRO');
        System.assertEquals(4, result.get('Total'));

        result = VariedadDatosComplementaresController.countDatosComplementares('DSEM', 'IPRO');
        System.assertEquals(2, result.get('Total'));
        Test.stopTest();
    }

    @isTest static void countNumberOfRowsTest2() {
        AggregateResult result = null;

        Test.startTest();
        result = VariedadRecomendacionesController.countRecomendaciones('', '', '');
        System.assertEquals(18, result.get('Total'));

        result = VariedadRecomendacionesController.countRecomendaciones('BRMX', '', '');
        System.assertEquals(9, result.get('Total'));

        result = VariedadRecomendacionesController.countRecomendaciones('NEOG', '', '');
        System.assertEquals(3, result.get('Total'));

        result = VariedadRecomendacionesController.countRecomendaciones('', 'IPRO', '');
        System.assertEquals(12, result.get('Total'));

        result = VariedadRecomendacionesController.countRecomendaciones('DSEM', 'IPRO', '');
        System.assertEquals(6, result.get('Total'));
        Test.stopTest();
    }

    @isTest static void fetchDataTest1() {
        List<Variedad_Datos_Complementares__c> datosComplementares = null;

        Test.startTest();
        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(10, 0, null, null);

        System.assertEquals(6, datosComplementares.size());

        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(3, 0, null, null);
        System.assertEquals(3, datosComplementares.size());

        Set<Id> auxList = new Set<Id>();

        for (Variedad_Datos_Complementares__c datoComplementar : datosComplementares) {
            auxList.add(datoComplementar.Id);
        }

        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(3, 3, null, null);
        System.assertEquals(3, datosComplementares.size());

        for (Variedad_Datos_Complementares__c datoComplementar : datosComplementares) {
            System.assert(!auxList.contains(datoComplementar.Id));
        }

        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(10, 0, 'DSEM', 'IPRO');
        System.assertEquals(2, datosComplementares.size());

        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(2, 0, null, 'IPRO');
        System.assertEquals(2, datosComplementares.size());

        auxList.clear();

        for (Variedad_Datos_Complementares__c datoComplementar : datosComplementares) {
            auxList.add(datoComplementar.Id);
        }

        datosComplementares = VariedadDatosComplementaresController.getDatosComplementares(2, 2, null, 'IPRO');
        System.assertEquals(2, datosComplementares.size());

        for (Variedad_Datos_Complementares__c datoComplementar : datosComplementares) {
            System.assert(!auxList.contains(datoComplementar.Id));
        }
        Test.stopTest();
    }

    @isTest static void fetchDataTest2() {
        List<Recomenda_o_de_variedade__c> recomendaciones = null;

        Test.startTest();
        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(20, 0, null, null, null);
        System.assertEquals(18, recomendaciones.size());

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(9, 0, null, null, null);
        System.assertEquals(9, recomendaciones.size());

        Set<Id> auxList = new Set<Id>();

        for (Recomenda_o_de_variedade__c recomendacion : recomendaciones) {
            auxList.add(recomendacion.Id);
        }

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(9, 9, null, null, null);
        System.assertEquals(9, recomendaciones.size());

        for (Recomenda_o_de_variedade__c recomendacion : recomendaciones) {
            System.assert(!auxList.contains(recomendacion.Id));
        }

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(20, 0, 'DSEM', 'IPRO', null);
        System.assertEquals(6, recomendaciones.size());

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(6, 0, null, 'IPRO', null);
        System.assertEquals(6, recomendaciones.size());

        auxList.clear();

        for (Recomenda_o_de_variedade__c recomendacion : recomendaciones) {
            auxList.add(recomendacion.Id);
        }

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(6, 6, null, 'IPRO', null);
        System.assertEquals(6, recomendaciones.size());

        for (Recomenda_o_de_variedade__c recomendacion : recomendaciones) {
            System.assert(!auxList.contains(recomendacion.Id));
        }

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(20, 0, null, 'IPRO', 'Cerrado');
        System.assertEquals(0, recomendaciones.size());

        recomendaciones = VariedadRecomendacionesController.getRecomendaciones(20, 0, null, null, 'Cerrado');
        System.assertEquals(3, recomendaciones.size());
        Test.stopTest();
    }
}