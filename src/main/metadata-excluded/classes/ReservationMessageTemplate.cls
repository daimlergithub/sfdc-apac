public class ReservationMessageTemplate {
    
    private static String New_Reservation_To_Customer = '尊贵的{Account_Name} 先生/女士，'
        + '您好！您已经成功预约驾驶培训课程，时间：{Activity_Date} {Activity_Start_Time}至{Activity_End_Time}，本次课程的主要内容为：{Product}-Class的培训。'
        + '您的培训教官将会致电给您并与您确认了上课信息。如您有任何疑问或预约有任何变化，请您提前一天与我们联系。[梅赛德斯-奔驰客服中心4008181188]';
    
    private static String New_Reservation_To_Instructor = '{Instructor_Name}教官，{Account_Name} 先生/女士，预定{Activity_Date} {Activity_Start_Time}'
        + '至{Activity_End_Time}上课，电话：{Account_Mobile_Phone}，接车地点：{Activity_Location}。身份证{Id_Number}，预约备注：{Activity_Description}。'
        + '请3小时之内与该客户电话确认上课信息，如需要更改请致电客服中心。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';

    private static String Cancel_Reservation_To_Customer = '尊贵的{Account_Name} 先生/女士，您好！您已经成功取消了这次预约：{Activity_Date} {Activity_Start_Time}'
        + '至{Activity_End_Time}，如您有任何疑问或预约有任何变化，请您随时与我们联系。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';

    private static String Cancel_Reservation_To_Instructor = '{Instructor_Name}教官，您好！{Account_Name} 先生/女士，已经取消{Activity_Date} {Activity_Start_Time}至{Activity_End_Time}的驾驶课程，'
        + '如您有任何疑问，请您随时与我们联系。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';

    private static String Update_Reservation_To_Customer = '尊贵的{Account_Name} 先生/女士，您好！您已经成功更改预约,更改后的预约为：陪练时间：{Activity_Date} {Activity_Start_Time}' 
        + '至{Activity_End_Time}，电话：{Account_Mobile_Phone}，接车地点：{Activity_Location}，预约备注：{Activity_Description}。如您有任何疑问或预约有任何变化，请您随时与我们联系。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';
    
    
    private static String Update_Reservation_To_Instructor = '{Instructor_Name}教官，您好！{Account_Name} 先生/女士，已经成功更改预约,更改后的预约为：' 
        + '陪练时间：{Activity_Date} {Activity_Start_Time}至{Activity_End_Time}，电话：{Account_Mobile_Phone}，接车地点：{Activity_Location}，' 
        + '预约备注：{Activity_Description}。如您有任何疑问，请您随时与我们联系。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';
    
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
    public static String Lead_Follow_Up_To_Customer_With_Dealer = '尊贵的{Contact_Name}先生/女士，您好！感谢您对梅赛德斯-奔驰驾驶学院培训课程的关注。在刚才电话中我们为您推荐的经销商为{Dealer_Name}， 地址{Dealer_Address}。如您有任何问题，请随时致电。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';
    public static String Lead_Follow_Up_To_Customer_Without_Dealer = '尊贵的{Contact_Name}先生/女士，您好！感谢您对梅赛德斯-奔驰驾驶学院培训课程的关注，我们的教官会在近期与您联系进一步为您介绍课程。如您有任何问题，请随时致电。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';
    public static String Lead_Follow_Up_To_Instructor = '{Instructor_Name}教官，您好！{Account_Name} 先生/女士，希望对{Product}-class 的驾驶课程进行详细了解，客户电话为{Account_Mobile_Phone}请尽快与客户取得联系，如您有任何疑问，请您随时与我们联系。[梅赛德斯-奔驰客服中心4008181188] 回复TD退订。';
    
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