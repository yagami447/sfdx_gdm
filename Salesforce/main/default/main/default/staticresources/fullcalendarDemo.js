/**
 * Initializing fullcalendar with appropriate option and handlers
 * using Singleton Pattern 
 * */
const CalendarSingleton = (function() {
    let calendarInstance;

    function createCalendar() {
        //Initialize Full Calender
        //and render inside 'calendar' div
        const calendar = $('#calendar').fullCalendar({

            //Toolbar header
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'agendaDay,agendaWeek,month'
            },

            //Changing text for different buttons
            buttonText: {
                today: 'Today',
                month: 'Month',
                week: 'Week Agenda',
                day: 'Day Agenda',
                list: 'List',
                prevYear: 'Previous Year',
                nextYear: 'Next Year',
                prev: 'Previous',
                next: 'Next'
            },
            //Toolbar footer with previous year and next year controls
            footer: {
                right: 'prevYear, nextYear'
            },

            aspectRatio: 2,
            selectable: true,

            //dayClick handler
            select: function(start, end) {
                //alert('a day has been clicked!');

                // $('#createEventTitle').val("");
                // $('#createStartTime').val(start);
                // $('#createEndTime').val(end);
                //handleSelect(start, end);
                var offset = new Date().getTimezoneOffset()/60;
                console.log(offset);
                console.log('Start: ' + start);

                $('#updateEvent').css("display", "block");
                $('.updatePlanoClass').val("");
                $('#CuentaPrincipalID').css("display", "none");
                $('#submitAuditar').css("display", "none");
                $('#submitUpsert').val("Create Event");
                $('#recordId').val("nuevo");
                $('#updateEventTitle').val("");
                $('#updateStartTime').val(formatDate(start));
                $('#updateEndTime').val(formatDate(end));
                $('#updateCity').val("");
                $('#updateUF').val("");

                console.log('el click loco');
                document.querySelectorAll('input[id$="updateAuditor_lkid"]')[0].value = '';
                document.querySelectorAll('input[id$="updateAuditor_lkold"]')[0].value = '';
                document.querySelectorAll('input[id$="updateAuditor"]')[0].value = '';
                origin = 'insert';

                // $("#dialog").dialog();
            },

            //Handle event click
            eventClick: function(calendarEvent, browserEvent, view) {
                // console.log('calendarEvent: ', calendarEvent);
                // console.log(calendarEvent);
                // console.log('browserEvent: ', browserEvent);
                // console.log(browserEvent);
                $('#CuentaPrincipalID').css("display", "");
                $('#submitAuditar').css("display", "");
                $('#submitUpsert').val("Update Event");

                $('#updateEvent').css("display", "block");
                $('.updatePlanoClass').val(calendarEvent.nombre);
                $('#updatePlanoCuenta').val(calendarEvent.cuentaPrincipal);
                $('#updateEventTitle').val(calendarEvent.name);
                $('#updateStartTime').val(calendarEvent.start);
                $('#updateEndTime').val(calendarEvent.end);
                $('#updateCity').val(calendarEvent.city);
                $('#updateUF').val(calendarEvent.uf);
                $('.updateEtapaClass').val(calendarEvent.etapa);
                // const auditor = document.querySelectorAll('input[id$="updateAuditor_lkid"]')[0].value;
                // newEvent.auditorId = event.Auditor__c;
                // newEvent.auditorName = event.Auditor__r.Name;
                // $('#updateAuditor').val(calendarEvent.auditorName);
                if (calendarEvent.auditorId != undefined) {
                    document.querySelectorAll('input[id$="updateAuditor_lkid"]')[0].value = calendarEvent.auditorId;
                    document.querySelectorAll('input[id$="updateAuditor_lkold"]')[0].value = calendarEvent.auditorName;
                    document.querySelectorAll('input[id$="updateAuditor"]')[0].value = calendarEvent.auditorName;
                } else {
                    document.querySelectorAll('input[id$="updateAuditor_lkid"]')[0].value = '';
                    document.querySelectorAll('input[id$="updateAuditor_lkold"]')[0].value = '';
                    document.querySelectorAll('input[id$="updateAuditor"]')[0].value = '';
                }

                $('.updateResponsavelClass').val(calendarEvent.responsavel);
                $('#recordId').val(calendarEvent.Id);
                // $("#dialog").dialog("close");
                console.log('origin');
                console.log(origin);
                origin = 'update';
                console.log(origin);
                //handleEventClick(calendarEvent, browserEvent, view);
            },

            auxUpsertEventCalendar: function() {

            },

            //Hanadle drag-drop of event
            eventDrop: function(event, delta, revertFunc) {
                //alert(event.title + " was dropped on " + event.start.format());
                if (!confirm("Are you sure about this change?")) {
                    revertFunc();
                } else {
                    handleEventDrop(event);
                }
            }
        });

        return calendar;
    }

    return {
        getCalendar: function() {
            if (!calendarInstance) {
                calendarInstance = createCalendar();
            }
            return calendarInstance;
        },
    }
})();

const addEvents = function(eventsData) {
    const events = [];
    eventsData.forEach(function(event) {
        const newEvent = {};
        newEvent.Id = event.Id;
        newEvent.nombre = event.Plano_de_Auditoria__c;
        newEvent.cuentaPrincipal = event.Plano_de_Auditoria__r.Cuenta_Principal__r.Name;
        newEvent.title = event.Plano_de_Auditoria__r.Nombre__c;
        newEvent.name = event.Name;
        newEvent.start = new Date(event.Start_Time__c);
        newEvent.end = new Date(event.End_Time__c);
        newEvent.city = event.Cidade__c;
        newEvent.uf = event.UF__c;
        newEvent.etapa = event.Etapa__c;
        // newEvent.auditor = event.Auditor__c;

        if (event.Auditor__r != undefined) {
            newEvent.auditorId = event.Auditor__c;
            newEvent.auditorName = event.Auditor__r.Name;
        }
        newEvent.responsavel = event.Responsavel__c;
        newEvent.editable = true;
        // console.log('event: ' + newEvent.Id);
        events.push(newEvent);
    });
    if (events.length > 0) {
        $('#calendar').fullCalendar('removeEventSources');
        $('#calendar').fullCalendar('addEventSource', events);
    }
}

/**
 * This function will be called when the user
 * click on an event
 * */
const handleEventClick = function(calendarEvent, browserEvent, view) {
    $('#updateEvent').css("display", "block");
    $('.updatePlanoClass').val(calendarEvent.nombre);
    $('#updatePlanoCuenta').val(calendarEvent.cuentaPrincipal)
    $('#updateEventTitle').val(calendarEvent.name);
    $('#updateStartTime').val(calendarEvent.start);
    $('#updateEndTime').val(calendarEvent.end);
    $('#updateCity').val(calendarEvent.city);
    $('#updateUF').val(calendarEvent.uf);
    $('.updateEtapaClass').val(calendarEvent.etapa);
    $('#updateAuditor').val(calendarEvent.auditor);
    $('.updateResponsavelClass').val(calendarEvent.responsavel);
    $('#recordId').val(calendarEvent.Id);
    $("#dialog").dialog("close");
}

/**
 * This function will be called when the user
 * select a duration from the calendar
 * */
const handleSelect = function(start, end) {
    $('#createEventTitle').val("");
    $('#createStartTime').val(start);
    $('#createEndTime').val(end);
}

/**
 * Prepare an event object to pass to server side remote call
 * */
const prepareEvent = function(plano, title, startTime, endTime, city, uf, etapa, auditor, responsavel, Id) {
    const calendarEvent = {};
    calendarEvent.Id = Id;
    calendarEvent.Plano_de_Auditoria__c = plano;
    calendarEvent.Name = title;
    calendarEvent.Start_Time__c = new Date(startTime).getTime();
    calendarEvent.End_Time__c = new Date(endTime).getTime();
    calendarEvent.Cidade__c = city;
    calendarEvent.UF__c = uf;
    calendarEvent.Etapa__c = etapa;
    calendarEvent.Auditor__c = auditor;
    calendarEvent.Responsavel__c = responsavel;
    createOrUpdateEvents(JSON.stringify(calendarEvent));
}

/**
 * This method will be called when event is drag and dropped
 * */
const handleEventDrop = function(event) {
    const calendarEvent = {};
    calendarEvent.Id = event.Id;
    calendarEvent.Name = event.title;
    calendarEvent.Start_Time__c = new Date(event.start).getTime();
    calendarEvent.End_Time__c = new Date(event.end).getTime();
    createOrUpdateEvents(JSON.stringify(calendarEvent));
}

/**
 * This code will be executed on page load
 * and will attach necessary listeners
 * */
const attachListners = function() {

    /**
     * Adding submit event listener on newEventForm
     * */
    // console.log('inici� attachListners');
    $('#newEventForm').submit(function(event) {
        const plano = $('.createPlanoClass').val();
        const title = $('#createEventTitle').val();
        const startTime = $('#createStartTime').val();
        const endTime = $('#createEndTime').val();
        const city = $('#createCity').val();
        const uf = $('#createUF').val();
        const etapa = $('.createEtapaClass').val();
        // const auditor = $('.createAuditorClass').val();
        const auditor = '';
        const responsavel = $('.createResponsavelClass').val();
        if (new Date(startTime).getTime() > new Date(endTime).getTime()) {
            //$("#createStartTime").after('<span style="color:red"><br>Start time must be before End time</span>');
            //return;
            showToastError('Start time must be before End time');  
        } else {
            prepareEvent(plano, title, startTime, endTime, city, uf, etapa, auditor, responsavel);
            $("#dialog").dialog("close");
            event.preventDefault();
        }
    });

    /**
     * Adding submit event listener on updateEventForm
     * */
    $('#updateEventForm').submit(function(event) {
        const plano = $('.updatePlanoClass').val();
        const title = $('#updateEventTitle').val();
        const startTime = $('#updateStartTime').val();
        const endTime = $('#updateEndTime').val();
        const Id = $('#recordId').val();
        const city = $('#updateCity').val();
        const uf = $('#updateUF').val();
        const etapa = $('.updateEtapaClass').val();
        // const auditor = $('#updateAuditor_lkid').val();
        //const auditor = document.getElementById('j_id0:j_id9:updateAuditor_lkid').value;
        const auditor = '';
        const responsavel = $('.updateResponsavelClass').val();
        // console.log('el que manda1: ' + id + ' ' + title);
        if (new Date(startTime).getTime() > new Date(endTime).getTime()) {
            //$("#updateStartTime").after('<span style="color:red"><br>Start time must be before End time</span>');
            //return;
            showToastError('Start time must be before End time');  
        } else {
            prepareEvent(plano, title, startTime, endTime, city, uf, etapa, auditor, responsavel, Id);
            event.preventDefault();
         }       
    });
}

const updateJs = function() {
    const plano = $('.updatePlanoClass').val();
    const title = $('#updateEventTitle').val();
    const startTime = $('#updateStartTime').val();
    const endTime = $('#updateEndTime').val();
    const Id = $('#recordId').val();
    const city = $('#updateCity').val();
    const uf = $('#updateUF').val();
    const etapa = $('.updateEtapaClass').val();
    // const auditor = $('#updateAuditor_lkid').val();

    const auditor = document.querySelectorAll('input[id$="updateAuditor_lkid"]')[0].value;

    const responsavel = $('.updateResponsavelClass').val();
    if (new Date(startTime).getTime() > new Date(endTime).getTime()) {
        //$("#updateStartTime").after('<span style="color:red"><br>Start time must be before End time</span>');
        //return;
        showToastError('Start time must be before End time');  
    } else {
        prepareEvent(plano, title, startTime, endTime, city, uf, etapa, auditor, responsavel, Id);
        event.preventDefault();
    }
}

const formatDate = function(newDate){
    let myDate = new Date(newDate);
    var tzDifference = myDate.getTimezoneOffset() //this gives me timezone difference of local and UTC time in minutes
    var offsetTime = new Date(myDate.getTime() + tzDifference * 60 * 1000); //this will calculate time in point of view local time and set date
    return offsetTime;
}