public interface AddressInfo 
{
    AddressInfoDefinition fetchFactoryResponse(String recordId);
    Integer getMaxAddressCount();
    void setMetadataFields(Factory_Fields__mdt addressInfoFactoryFields); 
}