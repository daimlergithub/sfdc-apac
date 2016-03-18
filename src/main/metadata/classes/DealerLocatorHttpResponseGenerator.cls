@isTest
global class DealerLocatorHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}