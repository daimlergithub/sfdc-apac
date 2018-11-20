@isTest
public class AddressDTOTest {
	
    @IsTest
    public static void testStrings()
    {
        Test.startTest();
        AddressDTO adto = new AddressDTO();
        adto.Organization='Test';
        System.assertEquals('Test',adto.Organization);
        adto.Department='Department';
        System.assertEquals('Department',adto.Department);
        adto.Contact='Contact';
        System.assertEquals('Contact',adto.Contact);
        adto.Email='Email';
        System.assertEquals('Email',adto.Email);
        adto.Building='Building';
        System.assertEquals('Building',adto.Building);
        adto.SubBuilding='SubBuilding';
        System.assertEquals('SubBuilding',adto.SubBuilding);
        adto.Street='Street';
        System.assertEquals('Street',adto.Street);
        adto.HouseNumber='HouseNumber';
        System.assertEquals('HouseNumber',adto.HouseNumber);
        adto.DeliveryService='DeliveryService';
        System.assertEquals('DeliveryService',adto.DeliveryService);
        adto.Locality='Locality';
        System.assertEquals('Locality',adto.Locality);
        adto.PreferredLocality='PreferredLocality';
        System.assertEquals('PreferredLocality',adto.PreferredLocality);
        adto.PostalCode='PostalCode';
        System.assertEquals('PostalCode',adto.PostalCode);
        adto.Province='Province';
        System.assertEquals('Province',adto.Province);
        adto.Country='Country';
        System.assertEquals('Country',adto.Country);
        adto.Residue='Residue';
        System.assertEquals('Residue',adto.Residue);
        adto.RecipientLines='RecipientLines';
        System.assertEquals('RecipientLines',adto.RecipientLines);
        adto.DeliveryAddressLines='DeliveryAddressLines';
        System.assertEquals('DeliveryAddressLines',adto.DeliveryAddressLines);
        adto.CountrySpecificLocalityLine='CountrySpecificLocalityLine';
        System.assertEquals('CountrySpecificLocalityLine',adto.CountrySpecificLocalityLine);
        adto.FormattedAddress='FormattedAddress';
        System.assertEquals('FormattedAddress',adto.FormattedAddress);
        adto.AddressComplete='AddressComplete';
        System.assertEquals('AddressComplete',adto.AddressComplete);
        Test.stopTest();
    }
    
}