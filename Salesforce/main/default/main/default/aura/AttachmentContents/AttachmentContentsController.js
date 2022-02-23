({
    doInit : function(component, event, helper) {
        const actions = [
            { label: 'Descargar', name: 'descargar' },
            { label: 'Remover', name: 'remover' }
        ];

        component.set('v.columns', [
            { label: 'Arquivo', fieldName: 'AttachmentName',  type: 'text' },
            { label: 'Tipo de Arquivo', fieldName: 'AttachmentType', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);

        helper.attachmentContentsRequest(component);
    },

    loadRecord : function(component, event, helper) {
		let eventParams = event.getParams();

        if (eventParams.changeType === "LOADED") {
            const tipoEvento = component.get("v.simpleRecord.RecordType.Name");
            const marca = component.get("v.simpleRecord.Marca__c");

            if (tipoEvento === "Test a campo" && marca !== "NEOG") {
                component.set("v.isReady", true);
            }
        } else if (eventParams.changeType === "ERROR") {
            helper.toastMessage(component.get("v.recordError"), "error");
        }
	},

    handleFilesChange : function(component, event, helper) {
        let files = event.getSource().get("v.files");
        if (files && files.length === 1) { component.set("v.att", files[0]); }
    },

    addAttachment : function(component, event, helper) {
        let att = component.get("v.att");

        if (att.name) {
            $A.util.toggleClass(component.find("spinner"), "slds-hide");
            helper.sendAttachmentRequest(component, att);
        } else {
            helper.toastMessage("Você deve selecionar um arquivo", "info");
        }
    },

    handleRowAction: function(component, event, helper) {
        const action = event.getParam('action');
        const row = event.getParam('row');

        switch (action.name) {
            case 'descargar':
                helper.downloadAttachment(component, row);
                break;
            case 'remover':
                helper.removeAttachment(component, row, component.find("spinner"));
                break;
        }
    }
})