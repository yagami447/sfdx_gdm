@isTest
global class WSNFeMock implements HttpCalloutMock {
    global integer setStatusResponse {get;set;}
    global string Mock {get;set;}

    public WSNFeMock (integer status, string MockSting){
        setStatusResponse = status;
        Mock = MockSting;
    }
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(Mock);
        response.setStatusCode(setStatusResponse);
        return response; 
    }
}