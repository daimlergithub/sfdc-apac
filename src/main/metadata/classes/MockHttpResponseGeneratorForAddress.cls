@isTest
global class MockHttpResponseGeneratorForAddress implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        JSONGenerator generator = JSON.createGenerator(true); 
        
        generator.writeStartObject();
        generator.writeStringField('ValidationStatus', 'OK');
        generator.writeBooleanField('AutoFillMode',true);
        generator.writeFieldName('Addresses');
        
        generator.writeStartArray();
        generator.writeStartObject();          
        generator.writeStringField('Address_Code', '12345');   
        generator.writeStringField('Address_Line_1', 'Rajiv Gandhi Technology Park');   
        generator.writeStringField('Address_Line_1_Native', 'IT Park');   
        generator.writeStringField('Address_Line_2', 'Kishangarh');   
        generator.writeStringField('Address_Line_2_Native', 'KG');   
        generator.writeStringField('HouseNumber', '1');   
        generator.writeStringField('Block', 'A Block');   
        generator.writeStringField('Block_Native', 'A');   
        generator.writeStringField('City', 'Chandigarh');   
        generator.writeStringField('City_Native', 'CG');   
        generator.writeStringField('District', 'Chandigarh');   
        generator.writeStringField('District_Native', 'CG');   
        generator.writeStringField('Province', 'Chandigarh');   
        generator.writeStringField('Province_Native', 'Chandigarh');   
        generator.writeStringField('ZipCode', '1601012');   
        generator.writeStringField('MarketDiscriminator', 'JP');   
        generator.writeStringField('ValidFields', 'Address_Line_1__c , Address_Line_2__c, Province__c, Block__c');
        generator.writeBooleanField('Valid', true);   
        generator.writeEndObject();

        generator.writeStartObject();          
        generator.writeStringField('Address_Code', '56789');   
        generator.writeStringField('Address_Line_1', 'Mahatama Gandhi Technology Park');   
        generator.writeStringField('Address_Line_1_Native', 'Tech Park');   
        generator.writeStringField('Address_Line_2', 'Ramgarh');   
        generator.writeStringField('Address_Line_2_Native', 'RG');   
        generator.writeStringField('HouseNumber', '2');   
        generator.writeStringField('Block', 'B Block');   
        generator.writeStringField('Block_Native', 'B');   
        generator.writeStringField('City', 'Hyderabad');   
        generator.writeStringField('City_Native', 'HD');   
        generator.writeStringField('District', 'Hyderabad');   
        generator.writeStringField('District_Native', 'HD');   
        generator.writeStringField('Province', 'Telangana');   
        generator.writeStringField('Province_Native', 'TG');   
        generator.writeStringField('ZipCode', '8596274');   
        generator.writeStringField('MarketDiscriminator', 'JP');   
        generator.writeStringField('ValidFields', 'Address_Line_1__c , Address_Line_2__c, Province__c, Block__c');   
        generator.writeBooleanField('Valid', false);   
        generator.writeEndObject();

        generator.writeEndArray();
        generator.writeEndObject();
        String requestBodyJSON = generator.getAsString();
        response.setBody(requestBodyJSON);
        response.setStatus('OK');
        response.setStatusCode(200);        
        return response;
        
    }
}