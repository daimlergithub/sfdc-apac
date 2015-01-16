trigger SendReservationMessage on Event (before insert, after insert, after update) {
    if (!UtilCustomSettings.isEnabled('SendReservationMessage')) {
        return;
    }
    
    String reservationEventRecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('MBDA-Reservation').getRecordTypeId();
    String SMSTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SMS').getRecordTypeId();
    String OBTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
    User epUser;
    User SpecialistUser;
    if(trigger.isInsert && trigger.isBefore) {
        List<Event> reservationEvents = new List<Event>();
        Set<Id> contactIds = new Set<Id>();
        for(Event tempEvent : trigger.new) {
            // Filter all 'MBDA-Reservation' Type record.
            if(tempEvent.RecordTypeId == reservationEventRecordTypeId && reservationEventRecordTypeId != null) {
                if(tempEvent.PersonOtherPhone__c == null || tempEvent.PersonMobilePhone__c == null) {
                    contactIds.add(tempEvent.WhoId);
                    reservationEvents.add(tempEvent);
                }
            }
        }
        if(contactIds.size() > 0) {
            Map<Id, Contact> relatedContactMap = new Map<Id, Contact>([select Id, MobilePhone, OtherPhone from Contact where Id in :contactIds]);
            for(Event tempEvent : reservationEvents) {
                    Contact tempContact = relatedContactMap.get(tempEvent.WhoId);
                    if(tempContact == null) {
                        continue;
                    }
                if(tempEvent.PersonOtherPhone__c == null) { 
                    tempEvent.PersonOtherPhone__c = (tempEvent.PersonOtherPhone__c == null)? tempContact.OtherPhone : tempEvent.PersonOtherPhone__c;
                }
                if(tempEvent.PersonMobilePhone__c == null) { 
                    tempEvent.PersonMobilePhone__c = (tempEvent.PersonMobilePhone__c == null)? tempContact.MobilePhone : tempEvent.PersonMobilePhone__c;
                }
            }
        }
    }
    
    if(trigger.isInsert && trigger.isAfter) {
        List<Event> reservationEvents = new List<Event>();
        Set<Id> contactIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        for(Event tempEvent : trigger.new) {
                // Filter all 'MBDA-Reservation' Type record.
                if(tempEvent.RecordTypeId == reservationEventRecordTypeId && reservationEventRecordTypeId != null) {
                contactIds.add(tempEvent.WhoId);
                userIds.add(tempEvent.OwnerId);
                orderIds.add(tempEvent.WhatId);
                reservationEvents.add(tempEvent);
            }
        }
        
        if(reservationEvents.size() > 0) {
            epUser = getEPIntegrationUser();
            SpecialistUser = getMBDASpecialistUser();
            Map<Id, Contact> relatedContactMap = new Map<Id, Contact>([select Id, Name, Account.ID_Number__c, MobilePhone, OtherPhone from Contact where Id in :contactIds]);
            Map<Id, User> relatedUserMap = new Map<Id, User>([select Id, Name, MobilePhone, Phone, ContactId from User where Id in :userIds]);
            Map<Id, Order> relatedOrderMap = new Map<Id, Order>([select Id, (select Id, PricebookEntry.Product2.Name, PricebookEntry.Product2Id from OrderItems order by createdDate desc limit 1) from Order where Id in :orderIds]);
            /*
             Create SMS and OB Task for Customers and Instructors
            */
            List<Task> newTasks = new List<Task>(); // SMS Tasks and OB Tasks.
            for(Event tempEvent : reservationEvents) {   
                List<Task> customerAndInstructorTasks = generateTasksForCreateNewEvent(tempEvent, relatedUserMap.get(tempEvent.OwnerId), relatedContactMap.get(tempEvent.WhoId), relatedOrderMap.get(tempEvent.WhatId));
                if(customerAndInstructorTasks.size() > 0) {
                    newTasks.addAll(customerAndInstructorTasks);
                }
            } 
            insert newTasks;
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter) {
        
        Set<Id> contactIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        
        List<Event> reservationCancelledEvents = new List<Event>();
        List<Event> reservationFieldUpdatedEvents = new List<Event>();
        List<Event> reservationOwnerUpdatedEvents = new List<Event>();
        for(Event tempEvent : trigger.new) {
            if(tempEvent.RecordTypeId == reservationEventRecordTypeId && reservationEventRecordTypeId != null) {
               // Reservation Cancelled
               if(tempEvent.Activity_Status__c == 'Cancelled' && trigger.oldMap.get(tempEvent.Id).Activity_Status__c != 'Cancelled') {
                   reservationCancelledEvents.add(tempEvent);
                   contactIds.add(tempEvent.whoId);
                   userIds.add(tempEvent.OwnerId);
                   orderIds.add(tempEvent.WhatId);
               } else {
                   // Reservation information updated.
                   if(criticalFieldChanged(tempEvent)) {
                      reservationFieldUpdatedEvents.add(tempEvent);
                      contactIds.add(tempEvent.whoId);
                      userIds.add(tempEvent.OwnerId); 
                      orderIds.add(tempEvent.WhatId);
                   }
                   // Reservation Owner changed.
                   if(tempEvent.OwnerId != trigger.oldMap.get(tempEvent.Id).OwnerId) {
                       reservationOwnerUpdatedEvents.add(tempEvent);
                       contactIds.add(tempEvent.whoId);
                       userIds.add(tempEvent.OwnerId); 
                       orderIds.add(tempEvent.WhatId);
                   }
               }
            }
        }
        
        if(reservationCancelledEvents.size() > 0 || reservationFieldUpdatedEvents.size() > 0 || reservationOwnerUpdatedEvents.size() > 0) {
            Map<Id, Contact> relatedContactMap = new Map<Id, Contact>([select Id, Name, Account.ID_Number__c, MobilePhone, OtherPhone from Contact where Id in :contactIds]);
            Map<Id, User> relatedUserMap = new Map<Id, User>([select Id, Name, MobilePhone, Phone, ContactId from User where Id in :userIds]);
            Map<Id, Order> relatedOrderMap = new Map<Id, Order>([select Id, (select Id, PricebookEntry.Product2.Name, PricebookEntry.Product2Id from OrderItems order by createdDate desc limit 1) from Order where Id in :orderIds]);
            epUser = getEPIntegrationUser();
            SpecialistUser = getMBDASpecialistUser();
            
            List<Task> newTasks = new List<Task>();
            
            if(reservationCancelledEvents.size() > 0) {
                for(Event tempEvent : reservationCancelledEvents) {
                    List<Task> customerAndInstructorTasks = generateTasksForCancelReservation(tempEvent, relatedUserMap.get(tempEvent.OwnerId), relatedContactMap.get(tempEvent.WhoId));
                    if(customerAndInstructorTasks.size() > 0) {
                        newTasks.addAll(customerAndInstructorTasks);
                    }
                }
            }
            
            if(reservationFieldUpdatedEvents.size() > 0) {
                for(Event tempEvent : reservationFieldUpdatedEvents) {
                    List<Task> customerAndInstructorTasks = generateTasksForFieldReservation(tempEvent, relatedUserMap.get(tempEvent.OwnerId), relatedContactMap.get(tempEvent.WhoId));
                    if(customerAndInstructorTasks.size() > 0) {
                        newTasks.addAll(customerAndInstructorTasks);
                    }
                }
            }
            
            if(reservationOwnerUpdatedEvents.size() > 0) {
                for(Event tempEvent : reservationOwnerUpdatedEvents) {
                    List<Task> customerAndInstructorTasks = generateTasksForOwnerChangedReservation(tempEvent, relatedUserMap.get(tempEvent.OwnerId), relatedContactMap.get(tempEvent.WhoId), relatedOrderMap.get(tempEvent.WhatId));
                    if(customerAndInstructorTasks.size() > 0) {
                        newTasks.addAll(customerAndInstructorTasks);
                    }
                }
            }
            
            insert newTasks;
        }
    }
    
    // If PersonOtherPhone__c and PersonMobilePhone__c is null on Event, we will override the phone number from related contact.
    private void assignMobileToEvent(Event tempEvent, Contact tempCustomer) {
        if(tempCustomer != null) {
            tempEvent.PersonOtherPhone__c = (tempEvent.PersonOtherPhone__c == null)? tempCustomer.OtherPhone : tempEvent.PersonOtherPhone__c;
            tempEvent.PersonMobilePhone__c = (tempEvent.PersonMobilePhone__c == null)? tempCustomer.MobilePhone : tempEvent.PersonMobilePhone__c;
        }
    }
    
    private List<Task> generateTasksForCreateNewEvent(Event tempEvent, User tempInstructor, Contact tempCustomer, Order tempOrder) {
        List<Task> resultTasks = new List<Task>();
        if(tempEvent != null && tempCustomer != null) {
            resultTasks.add(generateSMSTask(tempEvent, tempCustomer, tempOrder));
        }
        if(tempEvent != null && tempInstructor != null) {
            resultTasks.add(generateSMSTask(tempEvent, tempInstructor, tempCustomer, tempOrder));
        }
        resultTasks.add(generateOBTask(tempEvent, tempCustomer, tempInstructor, '新预约通知'));
        return resultTasks;
    }
    
    private Task generateSMSTask(Event tempEvent, Contact tempCustomer, Order tempOrder) {
        // Get phone number. If no phone on Event, we will get the phone from contact(Customer).
        String tempPhone = tempEvent.Phone__c;
        if(tempPhone == null) {
            tempPhone = tempCustomer.MobilePhone;
        }
        Task newSMSTask = createSMSTask(tempEvent.Id, tempEvent.WhatId, tempPhone, tempCustomer.Id);
        newSMSTask.SMS_Content__c = ReservationMessageTemplate.getNewReservationToCustomerMessage(tempEvent, tempCustomer, tempOrder);
        return newSMSTask;
    }
    
    private Task generateSMSTask(Event tempEvent, User tempInstructor, Contact tempCustomer, Order tempOrder) {
        String tempPhone; // User's Mobile.
        if(tempInstructor.MobilePhone != null) {
            tempPhone = tempInstructor.MobilePhone;
        }
        else {
            tempPhone = tempInstructor.Phone;
        }
        Task newSMSTask = createSMSTask(tempEvent.Id, tempEvent.WhatId, tempPhone, tempInstructor.ContactId);
        newSMSTask.SMS_Content__c = ReservationMessageTemplate.getNewReservationToInstructorMessage(tempEvent, tempInstructor, tempCustomer, tempOrder);
        return newSMSTask;
    }
    
    private Task createSMSTask(String tempEventId, String tempOrderId, String tempPhone, String tempWhoId) {
        Task newSMSTask = new Task(RecordTypeId = SMSTaskRecordTypeId);
        newSMSTask.Subject = 'SMS';
        newSMSTask.WhatId = tempOrderId;
        newSMSTask.WhoId = tempWhoId;
        newSMSTask.Phone__c = tempPhone;
        newSMSTask.Status = 'Closed';
        newSMSTask.Activity_Status__c = 'Sent';
        newSMSTask.OwnerId = epUser.Id;
        newSMSTask.Related_Task_Id__c = tempEventId;
        return newSMSTask;
    }
    
    private List<Task> generateTasksForCancelReservation(Event tempEvent, User tempInstructor, Contact tempCustomer) {
       List<Task> resultTasks = new List<Task>();
       if(tempEvent != null && tempCustomer != null) {
           resultTasks.add(generateSMSTask(tempEvent, tempCustomer, true));
       }
       if(tempEvent != null && tempInstructor != null) {
           resultTasks.add(generateSMSTask(tempEvent, tempInstructor, tempCustomer, true));
       }
       resultTasks.add(generateOBTask(tempEvent, tempCustomer, tempInstructor, '预约取消通知'));
       return resultTasks;
    }
    
    private List<Task> generateTasksForFieldReservation(Event tempEvent, User tempInstructor, Contact tempCustomer) {
        List<Task> resultTasks = new List<Task>();
        if(tempEvent != null && tempCustomer != null) {
           resultTasks.add(generateSMSTask(tempEvent, tempCustomer, false));
        }
        if(tempEvent != null && tempInstructor != null) {
           resultTasks.add(generateSMSTask(tempEvent, tempInstructor, tempCustomer, false));
        }
        resultTasks.add(generateOBTask(tempEvent, tempCustomer, tempInstructor, '预约更改'));
        return resultTasks;
    }
    
    private List<Task> generateTasksForOwnerChangedReservation(Event tempEvent, User tempInstructor, Contact tempCustomer, Order tempOrder) {
        List<Task> resultTasks = new List<Task>();
        resultTasks.add(generateOBTask(tempEvent, tempCustomer, tempInstructor, '新预约通知'));
        resultTasks.add(generateSMSTask(tempEvent, tempInstructor, tempCustomer, tempOrder));
        return resultTasks;
    }
    
    private Task generateSMSTask(Event tempEvent, Contact tempCustomer, Boolean isCancelled) {
        // Get phone number. If no phone on Event, we will get the phone from contact(Customer).
        String tempPhone = tempEvent.Phone__c;
        if(tempPhone == null) {
            tempPhone = tempCustomer.MobilePhone;
        }
        Task newSMSTask = createSMSTask(tempEvent.Id, tempEvent.WhatId, tempPhone, tempCustomer.Id);
        if(isCancelled) {
               newSMSTask.SMS_Content__c = ReservationMessageTemplate.getCancelReservationToCustomerMessage(tempEvent, tempCustomer);
        } else {
               newSMSTask.SMS_Content__c = ReservationMessageTemplate.getUpdateReservationToCustomerMessage(tempEvent, tempCustomer);
        }
        return newSMSTask;
    }
    
    private Task generateSMSTask(Event tempEvent, User tempInstructor, Contact tempCustomer, Boolean isCancelled) {
        String tempPhone; // User's Mobile.
        if(tempInstructor.MobilePhone != null) {
            tempPhone = tempInstructor.MobilePhone;
        }
        else {
            tempPhone = tempInstructor.Phone;
        }
        Task newSMSTask = createSMSTask(tempEvent.Id, tempEvent.WhatId, tempPhone, tempInstructor.ContactId);
        if(isCancelled) {
            newSMSTask.SMS_Content__c = ReservationMessageTemplate.getCancelReservationToInstructorMessage(tempEvent, tempInstructor, tempCustomer);       
        } else {
            newSMSTask.SMS_Content__c = ReservationMessageTemplate.getUpdateReservationToInstructorMessage(tempEvent, tempInstructor, tempCustomer);
        }
        return newSMSTask;
    }
    
    private Task generateOBTask(Event tempEvent, Contact tempCustomer, User tempInstructor, String tempSubject) {
        
        Task newObTask = new Task(RecordTypeId = OBTaskRecordTypeId);
        newObTask.Subject = tempSubject; 
        if(SpecialistUser != null) {
            newObTask.OwnerId = SpecialistUser.Id;
        } 
        else {
            tempEvent.addError('No MBDA Specialist user found. Please assign at least one user to MBDA Specialist role');
        }
        newObTask.WhatId = tempEvent.WhatId;
        newObTask.WhoId = tempInstructor.ContactId;
        newObTask.Related_Task_Id__c = tempEvent.Id;
        return newObTask;
    }
    
    private Boolean criticalFieldChanged(Event tempEvent) {
        Boolean result = false;
        if(tempEvent.StartDatetime != trigger.oldMap.get(tempEvent.Id).StartDatetime) {
            result = true;
        }
        else if(tempEvent.EndDatetime != trigger.oldMap.get(tempEvent.Id).EndDatetime) {
            result = true;
        }
        else if(tempEvent.Location != trigger.oldMap.get(tempEvent.Id).Location) {
            result = true;
        }
        else if(tempEvent.Description != trigger.oldMap.get(tempEvent.Id).Description) {
            result = true;
        }
        /*else if(tempEvent.OwnerId != trigger.oldMap.get(tempEvent.Id).OwnerId) {
            result = true;
        } */
        return result;
    }
    
    private User getEPIntegrationUser() {
        User tempEpUser;
        List<User> epUsers = [select Id, Name from User where Name = 'ep.user1' and Profile.Name = 'IntegrationAPI' and IsActive = true limit 1];
        if(epUsers.size() > 0) {
            tempEpUser = epUsers[0];
        }
        return tempEpUser;
    }
    
    private User getMBDASpecialistUser() {
        User tempSpecialistUser;
        List<User> specialistUsers = [select Id, Name from User where UserRole.Name = 'MBDA specialist' and IsActive = true limit 1];
        if(specialistUsers.size() > 0) {
            tempSpecialistUser = specialistUsers[0];
        }
        return tempSpecialistUser;
    } 
}