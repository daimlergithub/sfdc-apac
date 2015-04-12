public class ReservationMessageTemplate {
    
    private static String New_Reservation_To_Customer = 'Honorable{Account_Name} Sir / Madam,'
        + 'How do you do! You have successfully booked your driving training courses on:{Activity_Date} {Activity_Start_Time}To{Activity_End_Time}，The main contents of this course are:{Product}-Class training .'
        + 'Your training instructors will call you and work with you to confirm the class information . If you have any questions or to schedule any changes , please contact us one day in advance . [ Mercedes - Benz Service Center 4008181188 ] ';
    
    private static String New_Reservation_To_Instructor = '{Instructor_Name}Instructors{Account_Name} Sir / Madam,Book{Activity_Date} {Activity_Start_Time}'
        + 'To{Activity_End_Time}Class, Telephone：{Account_Mobile_Phone}, Pick-up location :{Activity_Location}. ID card{Id_Number}，Appointment Notes：{Activity_Description}。'
        + 'Please call to confirm class information within three hours of the client , such as the need to change , please call the customer service center. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply ';

    private static String Cancel_Reservation_To_Customer = 'Honorable{Account_Name} Sir / Madam,Hello! You have successfully canceled the appointment :{Activity_Date} {Activity_Start_Time}'
        + 'To{Activity_End_Time}, If you have any questions or any change in reservation , please feel free to contact us. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';

    private static String Cancel_Reservation_To_Instructor = '{Instructor_Name}Instructors Hello !{Account_Name} Sir / Madam, Has been canceled{Activity_Date} {Activity_Start_Time}To{Activity_End_Time}Driving courses'
        + 'If you have any questions, please feel free to contact us. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';

    private static String Update_Reservation_To_Customer = 'Honorable{Account_Name} Sir / Madam,Hello! You have successfully changed the reservation , the reservation is changed : sparring time :{Activity_Date} {Activity_Start_Time}' 
        + 'To{Activity_End_Time}，Phone：{Account_Mobile_Phone}, Pick-up location :{Activity_Location}，Appointment Notes：{Activity_Description}. If you have any questions or any change in reservation , please feel free to contact us. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';
    
    
    private static String Update_Reservation_To_Instructor = '{Instructor_Name}Instructors Hello!{Account_Name} Sir / Madam, Has successfully changed the reservation , the reservation is changed :' 
        + 'Sparring time：{Activity_Date} {Activity_Start_Time}To{Activity_End_Time}，Phone：{Account_Mobile_Phone}, Pick-up location :{Activity_Location}，' 
        + 'Appointment Notes：{Activity_Description}. If you have any questions, please feel free to contact us. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';
    
    public static String getNewReservationToCustomerMessage(Event tempEvent, Contact tempCustomer, Order tempOrder) {
        String tempContent = New_Reservation_To_Customer;
        String productName = '';
        if(tempOrder.OrderItems.size() > 0)
        {
            productName = tempOrder.OrderItems[0].PricebookEntry.Product2.Name;
        }
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        tempContent = tempContent.replace('{Account_Name}', tempCustomer.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime).replace('{Product}', productName);
        return tempContent;
    }
    
    public static String getNewReservationToInstructorMessage(Event tempEvent, User tempInstructor, Contact tempCustomer, Order tempOrder) {
        String tempContent = New_Reservation_To_Instructor;
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        String description = (tempEvent.Description == null)? '' : tempEvent.Description;
        String tempMobile = (tempCustomer.MobilePhone == null)? '': tempCustomer.MobilePhone;
        String tempLocation = (tempEvent.location == null)? '': tempEvent.location;
        String idNumber = (tempCustomer.Account.ID_Number__c == null)? '': tempCustomer.Account.ID_Number__c;
        tempContent = tempContent.replace('{Instructor_Name}', tempInstructor.Name).replace('{Account_Name}', tempCustomer.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime).replace('{Account_Mobile_Phone}', tempMobile).replace('{Activity_Location}', tempLocation).replace('{Id_Number}', idNumber).replace('{Activity_Description}', description);
        return tempContent;
    }
    
    public static String getCancelReservationToCustomerMessage(Event tempEvent, Contact tempCustomer) {
        String tempContent = Cancel_Reservation_To_Customer;
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        tempContent = tempContent.replace('{Account_Name}', tempCustomer.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime);
        return tempContent;
    }

    public static String getCancelReservationToInstructorMessage(Event tempEvent, User tempInstructor, Contact tempCustomer) {
        String tempContent = Cancel_Reservation_To_Instructor;
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        tempContent = tempContent.replace('{Instructor_Name}', tempInstructor.Name).replace('{Account_Name}', tempCustomer.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime);
        return tempContent;
    }
    
    public static String getUpdateReservationToCustomerMessage(Event tempEvent, Contact tempCustomer) {
        String tempContent = Update_Reservation_To_Customer;
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        String mobilePhone = (tempCustomer.MobilePhone == null)? '': tempCustomer.MobilePhone;
        String tempLocation = (tempEvent.location == null)? '': tempEvent.location;
        String tempDescription = (tempEvent.Description == null)? '': tempEvent.Description;
        tempContent = tempContent.replace('{Account_Name}', tempCustomer.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime).replace('{Account_Mobile_Phone}', mobilePhone).replace('{Activity_Location}', tempLocation).replace('{Activity_Description}', tempDescription);
        return tempContent;
    }

    public static String getUpdateReservationToInstructorMessage(Event tempEvent, User tempInstructor, Contact tempCustomer) {
        String tempContent = Update_Reservation_To_Instructor;
        String startTime = getTimeStr(tempEvent.StartDateTime);
        String endTime = getTimeStr(tempEvent.EndDateTime);
        String activityDateStr = formatDate(tempEvent.ActivityDate);
        String mobilePhone = (tempCustomer.MobilePhone == null)? '': tempCustomer.MobilePhone;
        String tempLocation = (tempEvent.location == null)? '': tempEvent.location;
        String tempDescription = (tempEvent.Description == null)? '': tempEvent.Description;
        tempContent = tempContent.replace('{Account_Name}', tempCustomer.Name).replace('{Instructor_Name}', tempInstructor.Name).replace('{Activity_Date}', activityDateStr).replace('{Activity_Start_Time}', startTime).replace('{Activity_End_Time}', endTime).replace('{Account_Mobile_Phone}', mobilePhone).replace('{Activity_Location}', tempLocation).replace('{Activity_Description}', tempDescription);
        return tempContent;
    }
    
    private static String formatDate(Date tempDate) {
        if(tempDate == null) {
                return '';
        }
        return tempDate.year() + '-' + ((tempDate.month() < 10)? ('0' + tempDate.month()) : ('' + tempDate.month())) + '-' + ((tempDate.day() < 10)? ('0' + tempDate.day()): ('' + tempDate.day()));
    }
    
    private static String getTimeStr(Datetime tempTime) {
        if(tempTime == null) {
                return '';
        }
        return tempTime.hour() + ':' + ((tempTime.minute() < 10)? ('0' + tempTime.minute()) : ('' + tempTime.minute()));
    }
    
    // For Lead SMS
    public static String Lead_Follow_Up_To_Customer_With_Dealer = 'Honorable{Contact_Name}Sir / Madam,Hello! Thank you for your Mercedes - Benz Driving Academy attention training courses . In just the phone for you , we recommend the dealer .{Dealer_Name}， Address{Dealer_Address}. If you have any questions , please feel free to call . [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';
    public static String Lead_Follow_Up_To_Customer_Without_Dealer = 'Honorable{Contact_Name}Sir / Madam,Hello! Thank you for your Mercedes - Benz Driving Academy training courses concerned , our instructors will contact you in the near future to further introduce you to the course . If you have any questions , please feel free to call . [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';
    public static String Lead_Follow_Up_To_Instructor = '{Instructor_Name}Instructors Hello!{Account_Name} Sir / Madam,Hope for {Product}-class Driving courses to learn more about customer telephone{Account_Mobile_Phone}Please get in touch with the customer as soon as possible , if you have any questions , please feel free to contact us. [ Mercedes - Benz Service Center 4008181188 ] TD unsubscribe reply .';
    
    public static String getLeadFollowUpToCustomerWithDealer(Lead__c tempLead, Account tempCustomer, User tempInstructor, Account tempDealer) {
        String tempContent = Lead_Follow_Up_To_Customer_With_Dealer; //Lead_Follow_Up_To_Instructor;
        String dealerName = ''; 
        if(tempDealer != null) {
            dealerName = (tempDealer.Name == null)? '' : tempDealer.Name;
        }
        String orderAddress = ''; 
        if(tempDealer != null && tempDealer.Dealer_Address_CN__c != null) {
            orderAddress = tempDealer.Dealer_Address_CN__c;
        }
        String contactname = (tempCustomer == null)? '':tempCustomer.Name;
        tempContent = tempContent.replace('{Contact_Name}', contactname).replace('{Dealer_Name}', dealerName).replace('{Dealer_Address}', orderAddress);
        return tempContent;
    }
    
    public static String getLeadFollowUpToInstructor(Lead__c tempLead, Account tempCustomer, User tempInstructor) {
        String tempContent = Lead_Follow_Up_To_Instructor;
        String tempProduct = (tempLead.Interested_Vehicle_Class__c == null)? '': tempLead.Interested_Vehicle_Class__c;
        String tempMobile = '';
        if(tempCustomer != null) {
                tempMobile = (tempCustomer.PersonMobilePhone == null)? '': tempCustomer.PersonMobilePhone;
        }
        String contactName = '';
        if(tempCustomer != null) {
                contactName = (tempCustomer.Name == null)? '': tempCustomer.Name ;
        }
        String instructorName = '';
        if(tempInstructor != null && tempInstructor.Name != null) {
            instructorName = tempInstructor.Name;
        }
        tempContent = tempContent.replace('{Instructor_Name}', instructorName).replace('{Account_Name}', contactName).replace('{Product}', tempProduct).replace('{Account_Mobile_Phone}', tempMobile);
        return tempContent;
    }
    
    public static String getLeadFollowUpToCustomerWithoutDealer(Lead__c tempLead, Account tempCustomer, User tempInstructor) {
        String tempContent = Lead_Follow_Up_To_Customer_Without_Dealer;
        String contactname = (tempCustomer == null)? '':tempCustomer.Name;
        tempContent = tempContent.replace('{Contact_Name}', contactname);
        return tempContent;
    }
    
    public static String getSMSContent(Lead__c tempLead, Account tempCustomer, User tempInstructor, Account tempDealer, String templateTitle) {
            
            if(templateTitle == 'Lead_Follow_Up_To_Customer_Without_Dealer') {
                return getLeadFollowUpToCustomerWithoutDealer(tempLead, tempCustomer, tempInstructor);
            }
            else if(templateTitle == 'Lead_Follow_Up_To_Instructor') {
                return getLeadFollowUpToInstructor(tempLead, tempCustomer, tempInstructor);
            }
            else {
                return getLeadFollowUpToCustomerWithDealer(tempLead, tempCustomer, tempInstructor, tempDealer);
            }
    }
}