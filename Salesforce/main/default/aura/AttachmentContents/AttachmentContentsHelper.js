({
    sendAttachmentRequest : function(component, att) {
        const self = this;
        const tipoArquivo = component.find('select').get('v.value');
        const action = component.get("c.addAttachmentContent");
        const reader = new FileReader();

        reader.readAsBinaryString(att);
        reader.onload = (function() {
            return function(e) {
                const binaryData = e.target.result;
                const base64String = window.btoa(binaryData);

                action.setParams({
                    eventoId : component.get("v.recordId"),
                    tipoArquivo : tipoArquivo,
                    name : att.name,
                    type : att.type,
                    body : base64String
                });

                action.setCallback(this, function(response) {
                    const state = response.getState();

                    if (state === "SUCCESS") {
                        self.attachmentContentsRequest(component);
                        $A.util.toggleClass(component.find("spinner"), "slds-hide");
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
                });

                $A.enqueueAction(action);
            };
        })(att);
        reader.onerror = function(error) {
            console.error(error);
            $A.util.toggleClass(component.find("spinner"), "slds-hide");
        };
    },

    attachmentContentsRequest : function(component) {
        const action = component.get("c.getAttachmentContents");

        action.setParams({ eventoId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                const retorno = response.getReturnValue();
                component.set("v.data", retorno);
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
        });

        $A.enqueueAction(action);
    },

    downloadAttachment : function(component, row) {
        const action = component.get("c.downloadAttachmentContent");

        action.setParams({ attContentId : row.id });

        action.setCallback(this, function(response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                window.open("/servlet/servlet.FileDownload?file=" + response.getReturnValue());
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
        });

        $A.enqueueAction(action);
    },

    removeAttachment : function(component, row, spinner) {
        $A.util.toggleClass(spinner, "slds-hide");
        const action = component.get("c.removeAttachmentContent");

        action.setParams({ attContentId : row.id });

        action.setCallback(this, function(response) {
            const state = response.getState();

            if (state === "SUCCESS") {
                $A.util.toggleClass(spinner, "slds-hide");
                this.attachmentContentsRequest(component);
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
        });

        $A.enqueueAction(action);
    },

    toastMessage : function(message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"message": message, "type": type});
        toastEvent.fire();
    }
})