@isTest
global class onLineDeduplicationCDMTHMock implements HttpCalloutMock {
    global String body;
    global onLineDeduplicationCDMTHMock(String body){
        this.body=body;
    }
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response=new HttpResponse();
        response.setBody(body);
        response.setStatusCode(200);
        return response;
    }
}