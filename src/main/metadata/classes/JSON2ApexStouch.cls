Global class JSON2ApexStouch {
    public String record_count;
	public List<Person> Output_IDS=new List<Person>();
    public class Person{
        public string LastName;
        public string PersonMobilePhone;
        public string PersonEmail;
        public string Personal_UCID;
        public string Owner;
        public string MBK_Data_Source;
        public String Birthdate;
        public Person(Account_link__c acclink){
            this.LastName=string.ISBlank(acclink.Retail_LastName__c)? ' ' : acclink.Retail_LastName__c;
            this.PersonMobilePhone=string.ISBlank(acclink.Retail_Mobile__c)? ' ' : acclink.Retail_Mobile__c;
            this.PersonEmail=string.ISBlank(acclink.Retail_Email__c)? ' '  : acclink.Retail_Email__c;
            this.Personal_UCID=string.ISBlank(acclink.Retail_UCID__c)? ' '  : acclink.Retail_UCID__c;
            this.Owner=string.ISBlank(acclink.Ownerid)? ' '  : acclink.Ownerid;
            this.MBK_Data_Source=string.ISBlank(acclink.toRole__r.MBK_Data_Source__c)? ' '  : acclink.toRole__r.MBK_Data_Source__c;
            //this.Birthdate=acclink.Retail_PersonBirthdate__c;
            if(acclink.Retail_PersonBirthdate__c==null)
            	this.Birthdate=' ';
        	else
           		this.Birthdate=string.valueOf(acclink.Retail_PersonBirthdate__c);
        }
    }
}