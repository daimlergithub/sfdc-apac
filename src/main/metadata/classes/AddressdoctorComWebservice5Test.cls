@isTest
global class AddressdoctorComWebservice5Test {
  global void doInvoke(
                Object stub,
                Object request,
                Map<String,Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
                    String login;
                    String password;
                    validator5AddressdoctorComWebservice5.ArrayOfAddress response_x = new validator5AddressdoctorComWebservice5.ArrayOfAddress();
                    validator5AddressdoctorComWebservice5.ArrayOfEnrichment response_y = new validator5AddressdoctorComWebservice5.ArrayOfEnrichment();
                    validator5AddressdoctorComWebservice5.Parameters response_z = new validator5AddressdoctorComWebservice5.Parameters();
                    response_x.Address=null;
                    response_y.Enrichment=null;
                    response_z.ProcessMode='test';
                    response.put('response_x',response_x);
                    response.put('response_y',response_y);
                    response.put('response_z',response_z);
                } 
    public static testMethod void coverTypes()
    {
        new validator5AddressdoctorComWebservice5.Enrichment();
        new validator5AddressdoctorComWebservice5.ArrayOfProvinceDetailed();
        new validator5AddressdoctorComWebservice5.ContactDetailed();
        new validator5AddressdoctorComWebservice5.Address();
        new validator5AddressdoctorComWebservice5.StreetDetailed();
        new validator5AddressdoctorComWebservice5.LocalityDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfEnrichment();
        new validator5AddressdoctorComWebservice5.Process_element();
        new validator5AddressdoctorComWebservice5.ArrayOfBuildingDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfDeliveryServiceDetailed();
        new validator5AddressdoctorComWebservice5.Result();
        new validator5AddressdoctorComWebservice5.Standardize();
        new validator5AddressdoctorComWebservice5.ProcessResponse_element();
        new validator5AddressdoctorComWebservice5.ValidationParameters();
        new validator5AddressdoctorComWebservice5.ArrayOfSubBuildingDetailed();
        new validator5AddressdoctorComWebservice5.AddressDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfCountryDetailed();
        new validator5AddressdoctorComWebservice5.CountryDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfResultData();
        new validator5AddressdoctorComWebservice5.AdditionalInformation();
        new validator5AddressdoctorComWebservice5.ProvinceDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfResult();
        new validator5AddressdoctorComWebservice5.Parameters();
        new validator5AddressdoctorComWebservice5.ArrayOfContactDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfStreetDetailed();
        new validator5AddressdoctorComWebservice5.HouseNumberDetailed();
        new validator5AddressdoctorComWebservice5.DeliveryServiceDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfLocalityDetailed();
        new validator5AddressdoctorComWebservice5.AddressCode();
        new validator5AddressdoctorComWebservice5.ArrayOfAdditionalInformation();
        new validator5AddressdoctorComWebservice5.ArrayOfAddress();
        new validator5AddressdoctorComWebservice5.OrganizationDetailed();
        new validator5AddressdoctorComWebservice5.BuildingDetailed();
        new validator5AddressdoctorComWebservice5.PostalCodeDetailed();
        new validator5AddressdoctorComWebservice5.Response();
        new validator5AddressdoctorComWebservice5.AddressOptions();
        new validator5AddressdoctorComWebservice5.ResultData();
        new validator5AddressdoctorComWebservice5.ArrayOfString();
        new validator5AddressdoctorComWebservice5.ArrayOfPostalCodeDetailed();
        new validator5AddressdoctorComWebservice5.ArrayOfHouseNumberDetailed();
        new validator5AddressdoctorComWebservice5.ServiceParameters();
        new validator5AddressdoctorComWebservice5.ArrayOfResidueDetailed();
        new validator5AddressdoctorComWebservice5.ResidueDetailed();
         new validator5AddressdoctorComWebservice5.ArrayOfOrganizationDetailed();
         new validator5AddressdoctorComWebservice5.SubBuildingDetailed();
         new validator5AddressdoctorComWebservice5.AddressValidationSoap();
    }
}