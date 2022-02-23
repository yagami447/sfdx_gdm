({
    loadDataToCalendar : function(component, data) {
        var calendar = component.find("calendar").getElement();

        $(calendar).fullCalendar({
            header: {
                left: "prev,next today",
                center: "title",
                right: "agendaDay,agendaWeek,month"
            },
            footer: {
                right: "prevYear, nextYear"
            },
            aspectRatio: 1.7,
            locale: $A.get("$Locale.language"),
            timezone: "local",
            editable: true,
            navLinks: true,
            eventLimit: true,
            selectable: true,
            nowIndicator: true,
            events: data,
            select: function(startDate, endDate) {
                var cmpEvent = component.getEvent("calEvent");

                cmpEvent.setParams({
                    recordByEvent: {
                        start: startDate.format(),
                        end: endDate.format(),
                        auditor: component.get("v.auditorSelected")
                    },
                    origin: "insert"
                });

                cmpEvent.fire();
            },
            eventClick: function(calEvent, jsEvent, view) {
                var cmpEvent = component.getEvent("calEvent");

                if (calEvent.end) {
                    cmpEvent.setParams({
                        recordByEvent: {
                            id: calEvent.id,
                            start: calEvent.start.format(),
                            end: calEvent.end.format(),
                            auditor: calEvent.auditor
                        },
                        origin: "update"
                    });
                } else {
                    cmpEvent.setParams({
                        recordByEvent: {
                            id: calEvent.id,
                            start: calEvent.start.format(),
                            auditor: calEvent.auditor
                        },
                        origin: "update"
                    });
                }
        
                cmpEvent.fire();
            },
            eventDrop: function(calEvent, delta, revertFunc) {
                var cmpEvent = component.getEvent("calEvent");
        
                if (calEvent.end) {
                    cmpEvent.setParams({
                        recordByEvent: {
                            id: calEvent.id,
                            start: calEvent.start.format(),
                            end: calEvent.end.format(),
                            auditor: calEvent.auditor
                        },
                        origin: "update"
                    });
                } else {
                    cmpEvent.setParams({
                        recordByEvent: {
                            id: calEvent.id,
                            start: calEvent.start.format(),
                            auditor: calEvent.auditor
                        },
                        origin: "update"
                    });
                }
        
                cmpEvent.fire();
            }
        });
    },

    tranformToFullCalendarFormat : function(events) {
        return events.map(element => {
            return {
                id: element.Id,
                title: element.Plano_de_Auditoria__r.Nombre__c,
                start: element.Start_Time__c,
                end: element.End_Time__c,
                auditor: element.Auditor__c,
                name: element.Name
            }
        });
    },

    fetchEvents : function(component) {
        var action = component.get("c.getEvents");

        action.setParams({ filters : null });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                var eventArr = this.tranformToFullCalendarFormat(response.getReturnValue());
                this.loadDataToCalendar(component, eventArr);
                component.set("v.events", eventArr);
                component.set("v.isLoading", false);
            } else if (state === "ERROR") {
                var errors = response.getError();

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

    refetchEvents : function(component, filters) {
        var action = component.get("c.getEvents");

        action.setParams({ filters : filters });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                var eventArr = this.tranformToFullCalendarFormat(response.getReturnValue());
                var auditorSelected = component.get("v.auditorSelected");
                component.set("v.events", eventArr);

                if (auditorSelected) {
                    this.filterByAuditor(component, auditorSelected);
                } else {
                    this.renderEvents(component, eventArr); // All
                }

                component.set("v.isLoading", false);
            } else if (state === "ERROR") {
                var errors = response.getError();

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

    updateEvent : function(component, recordByEvent) {
        const eventArr = component.get("v.events");
        const index = eventArr.findIndex(element => element.id == recordByEvent.id);
        const event = {
            id: recordByEvent.id,
            title: recordByEvent.title,
            start: recordByEvent.start,
            end: recordByEvent.end,
            auditor: recordByEvent.auditor,
            name: recordByEvent.name
        };

        if (index == -1) {
            eventArr.push(event);
        } else {
            eventArr.splice(index, 1, event);
        }

        if (component.get("v.auditorSelected")) {
            component.set("v.auditorSelected", recordByEvent.auditor); // onChangeAuditor
        } else {
            this.renderEvents(component, eventArr); // All
        }
    },

    filterByAuditor : function(component, auditorId) {
        var eventArr = component.get("v.events");

        if (auditorId) {
            eventArr = eventArr.filter(element => element.auditor == auditorId);
        }

        this.renderEvents(component, eventArr);
    },

    renderEvents : function(component, data) {
        var calendar = component.find("calendar").getElement();
        $(calendar).fullCalendar("removeEventSources");
        $(calendar).fullCalendar("addEventSource", data);
    },

    toastMessage : function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({ "message": message, "type": type });
        toastEvent.fire();
    }
})