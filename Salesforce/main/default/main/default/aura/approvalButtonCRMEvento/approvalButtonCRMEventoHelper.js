({
    /**
     * Realiza las validaciones necesarias contra el servidor, iniciando por la validación de cantidad de items del CRM Evento (US 17284).
     * @param {Object} component Componente al que pertenece el controlador
     */
     validateItems : function(component) {
        const action = component.get("c.getItems");

        action.setParams({ recordId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const result = response.getReturnValue();
                console.log(JSON.stringify(result));
                if (result.length > 0) {
                    const fase = component.get("v.simpleRecord.Fase__c");
                    let valid;
                    let message;

                    if (fase === "Aguardando resultado de colheita" || fase === "Edição de dados de colheita") {
                        valid = result.reduce((prev, product) => {
                            return prev && product.Area_Colhida__c && product.Produtividade__c && product.Data_de_colheita__c;
                        }, true);

                        if (!valid) {
                            message = "Você deve especificar: Área colhida, Data de colheida e Produtividade";
                        }
                    } else {
                        valid = result.reduce((prev, product) => {
                            return (prev && product.Area_plantada__c && product.Volume_Doado__c && product.Data_de_plantio__c
                                && product.Populacao_de_plantas__c && product.Espacamento__c && product.Cultura_antecessora__c);
                        }, true);

                        if (!valid) {
                            message = "Você deve especificar: Área plantada, Data de plantio, Volume Doado, População de plantas, Espaçamento e Cultura antecessora";
                        }
                    }

                    if (valid) {
                        this.countNumberOfDocuments(component);
                    } else {
                        this.toastMessage(message, "warning")
                        $A.get("e.force:closeQuickAction").fire();
                    }
                } else {
                    this.toastMessage("Para enviar para aprovação o campo Item deve ser preenchido", "warning")
                    $A.get("e.force:closeQuickAction").fire();
                }
            } else if (state === "ERROR") {
                const errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.toastMessage(errors[0].message, "error");
                    }
                } else {
                    console.log("Unknown error");
                }

                $A.get("e.force:closeQuickAction").fire();
            }
        });

        $A.enqueueAction(action);
	},

    countNumberOfDocuments : function(component) {
        const autorizado = component.get("v.simpleRecord.Autorizado__c");

        if (autorizado) {
            const action = component.get("c.countNumberOfDocuments");

            action.setParams({ recordId : component.get("v.recordId") });

            action.setCallback(this, function(response) {
                const state = response.getState();

                if (state === "SUCCESS") {
                    const result = response.getReturnValue();

                    if (result.Total >= 1) {
                        this.sendRequest(component);
                    } else {
                        this.toastMessage("Favor anexar o arquivo de autorização", "warning")
                        $A.get("e.force:closeQuickAction").fire();
                    }
                } else if (state === "ERROR") {
                    const errors = response.getError();

                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.toastMessage(errors[0].message, "error");
                        }
                    } else {
                        console.log("Unknown error");
                    }

                    $A.get("e.force:closeQuickAction").fire();
                }
            });

            $A.enqueueAction(action);
        } else {
            this.sendRequest(component);
        }
    },

    sendRequest : function(component) {
        const action = component.get("c.sendApprovalRequest");

        action.setParams({
            recordId : component.get("v.recordId"),
            ownerId : component.get("v.simpleRecord.OwnerId")
        });

        action.setCallback(this, function(response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const result = response.getReturnValue();

                if (result) {
                    this.toastMessage("O evento foi submetido para aprovação", "success");
                }
            } else if (state === "ERROR") {
                const errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.toastMessage(errors[0].message, "error");
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            $A.get("e.force:closeQuickAction").fire();
        });

        $A.enqueueAction(action);
    },

    showMessage : function(field) {
        this.toastMessage(`Para enviar para aprovação o campo ${field} deve ser preenchido`, "warning");
        $A.get("e.force:closeQuickAction").fire();
    },

    toastMessage : function(message, type) {
        const toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"message": message, "type": type});
        toastEvent.fire();
    }
})