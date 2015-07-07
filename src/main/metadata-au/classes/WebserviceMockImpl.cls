@isTest
global with sharing class WebserviceMockImpl implements WebServiceMock{
global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType){
           RuishiWebService.CreateUserResponse_element resp = new RuishiWebService.CreateUserResponse_element();
           resp.CreateUserResult = true;
           response.put('response_x', resp);           
           }
}