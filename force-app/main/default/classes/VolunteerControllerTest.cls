@isTest
private class VolunteerControllerTest{

      @testSetup static void setup(){

        DateTime now = System.now();

        Campaign campaignRecord = new Campaign(Name = 'Test Campaign ' + now,  IsActive = true);
        insert campaignRecord;

        GW_Volunteers__Volunteer_Job__c  volunteerJob  = new GW_Volunteers__Volunteer_Job__c(Name = 'Test Job ' + now,
        GW_Volunteers__Campaign__c = campaignRecord.Id,
            GW_Volunteers__Display_on_Website__c = true);
        insert volunteerJob;

        Account accountRecord = new Account(Name='TestAccount' + now);
        insert accountRecord;
        
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0;i<5;i++) {
            testContacts.add(new Contact(FirstName='V4S',
            LastName='TestContact' + i,
            Email= 'v4s'+i+'@test.com',
            AccountId = accountRecord.Id));
        }
           insert testContacts;

           Contact contact1 = [SELECT Id FROM Contact WHERE LastName='TestContact1' ORDER BY Id];
        Contact contact2 = [SELECT Id FROM Contact WHERE LastName='TestContact3' ORDER BY Id];
        Contact contact3 = [SELECT Id FROM Contact WHERE LastName='TestContact4' ORDER BY Id];
/*        Id contactId1 = contacts[0].Id;*/
        Id contactId2 = contact1.Id;
        Id contactId3 = contact2.Id;
        Id contactId4 = contact3.Id;
/*        Id contactId3 = contacts[2].Id;*/


           List<GW_Volunteers__Volunteer_Shift__c> testShifts = new List<GW_Volunteers__Volunteer_Shift__c>();
           for(Integer i=0;i<3;i++) {
            testShifts.add(new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
            GW_Volunteers__Duration__c = 1,
            GW_Volunteers__Start_Date_Time__c = System.now() + i
           ));
           }
           insert testShifts;

           List<GW_Volunteers__Volunteer_Shift__c> volunteerShifts = [SELECT Id from GW_Volunteers__Volunteer_Shift__c];
        Id volshift1 = volunteerShifts[0].Id;
        Id volshift2 = volunteerShifts[1].Id;
        Id volshift3 = volunteerShifts[2].Id;

        List<GW_Volunteers__Volunteer_Hours__c> volHours = new List<GW_Volunteers__Volunteer_Hours__c>();
        GW_Volunteers__Volunteer_Hours__c volunteerHours1 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId2,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift1,
                GW_Volunteers__Status__c = 'Completed',
                GW_Volunteers__Start_Date__c = System.today(),
                GW_Volunteers__End_Date__c = System.today(),
                GW_Volunteers__Hours_Worked__c = 1,
               GW_Volunteers__Number_of_Volunteers__c = 1);
               volHours.Add( volunteerHours1);

                GW_Volunteers__Volunteer_Hours__c volunteerHours2 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId2,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift2,
                GW_Volunteers__Status__c = 'Completed',
                GW_Volunteers__Start_Date__c = System.today().addDays(-3),
                GW_Volunteers__End_Date__c = System.today().addDays(-3),
                GW_Volunteers__Hours_Worked__c = 5,
                GW_Volunteers__Number_of_Volunteers__c = 1);
                volHours.Add( volunteerHours2);
         GW_Volunteers__Volunteer_Hours__c volunteerHours4 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId3,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift2,
                GW_Volunteers__Status__c = 'Completed',
                GW_Volunteers__Start_Date__c = System.today().addDays(-3),
                GW_Volunteers__End_Date__c = System.today().addDays(-3),
                GW_Volunteers__Hours_Worked__c = 5,
                GW_Volunteers__Number_of_Volunteers__c = 1);
                volHours.Add( volunteerHours4);
         GW_Volunteers__Volunteer_Hours__c volunteerHours5 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId4,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift2,
                GW_Volunteers__Status__c = 'Completed',
                GW_Volunteers__Start_Date__c = System.today().addDays(-3),
                GW_Volunteers__End_Date__c = System.today().addDays(-3),
                GW_Volunteers__Hours_Worked__c = 5,
                GW_Volunteers__Number_of_Volunteers__c = 1);
                volHours.Add( volunteerHours5);

                GW_Volunteers__Volunteer_Hours__c volunteerHours3 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId2,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift3,
                GW_Volunteers__Status__c = 'Confirmed',
                GW_Volunteers__Start_Date__c = System.today().addDays(3),
                GW_Volunteers__End_Date__c = System.today().addDays(3),
               GW_Volunteers__Hours_Worked__c = 1,
                GW_Volunteers__Number_of_Volunteers__c = 1);
                volHours.Add( volunteerHours3);
          
          GW_Volunteers__Volunteer_Hours__c volunteerHours6 = new GW_Volunteers__Volunteer_Hours__c(
                GW_Volunteers__Contact__c = contactId2,
                GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
                GW_Volunteers__Volunteer_Shift__c = volshift3,
                GW_Volunteers__Status__c = 'Web Sign Up',
                GW_Volunteers__Start_Date__c = System.today().addDays(4),
                GW_Volunteers__End_Date__c = System.today().addDays(4),
               GW_Volunteers__Hours_Worked__c = 1,
                GW_Volunteers__Number_of_Volunteers__c = 1);
                volHours.Add( volunteerHours6);

                insert volHours;

        /*Job_Recurrence_Schedule__c  jrsRecord = new Job_Recurrence_Schedule__c(
            Volunteer_Job__c = volunteerJob.Id,
            Days_of_Week__c = 'Monday;Friday',
            Duration__c = 1.5,
            Schedule_Start_Date_Time__c = datetime.now(),
            Weekly_Occurrence__c = '1st'
        );
        insert jrsRecord;

        Volunteer_Recurrence_Schedule__c vrsRecord = new Volunteer_Recurrence_Schedule__c (
            Contact__c = contactRecord.Id,
            Volunteer_Job__c = volunteerJob.Id,
            Days_of_Week__c = 'Monday;Friday',
            Duration__c = 1.5,
            Schedule_Start_Date_Time__c = datetime.now(),
            Weekly_Occurrence__c = '1st'
        );
        insert vrsRecord;*/

        
    }

    @isTest static void testgetShiftsByContactMethod() {
        Contact contact1 = [SELECT Id FROM Contact WHERE LastName='TestContact0'];
        Contact contact2 = [SELECT Id FROM Contact WHERE LastName='TestContact1'];
        Id conId1 = contact1.Id;
        Id conId2 = contact2.Id;
        
        Date today = Date.today();
         String status='Confirmed';
        String[] targetStatuses = new String[]{'Confirmed', 'Web Sign Up'};
        Integer varHours = [SELECT count()
                 FROM GW_Volunteers__Volunteer_Hours__c WHERE GW_Volunteers__Contact__c = :conId2 AND  GW_Volunteers__Status__c IN :targetStatuses
                            AND GW_Volunteers__Planned_Start_Date_Time__c >= :today];

        List<GW_Volunteers__Volunteer_Hours__c>   con1data = VolunteerController.getShiftsByContact(conId1);
     List<GW_Volunteers__Volunteer_Hours__c> con2data = VolunteerController.getShiftsByContact(conId2);

System.assertEquals(0, con1data.size(), 'Did not expect a value to be returned.'+ con1data);
        /*System.assert.isNull(VolunteerController.getShiftsByContact(conId1));*/
        System.assertNotEquals(0, con2data.size(), 'Expect a value to be returned.'+ con2data);
        System.assertEquals(varHours, con2data.size(), 'Expect a value to be returned.'+ con2data);

 List<GW_Volunteers__Volunteer_Hours__c> con3data = VolunteerController.getShiftsByContact(null);
        
        System.assertEquals(0, con3data.size(), 'Did not expect a value to be returned.'+ con3data);

        /*System.assert.isnotnull(VolunteerController.getShiftsByContact(conId2));*/

    }

    @isTest static void testgetHistoricalShiftsByContactMethod() {
        Contact contact1 = [SELECT Id FROM Contact WHERE LastName='TestContact0'];
        Contact contact2 = [SELECT Id FROM Contact WHERE LastName='TestContact1'];
        Id conId1 = contact1.Id;
        Id conId2 = contact2.Id;
        
        Integer varHours = [SELECT count()
                 FROM GW_Volunteers__Volunteer_Hours__c WHERE GW_Volunteers__Contact__c = :conId2 AND GW_Volunteers__Status__c = 'Completed'];
    
                
        List<GW_Volunteers__Volunteer_Hours__c> con1data = VolunteerController.getHistoricalShiftsByContact(conId1);

        /*System.assert.isNull(con1_data);*/

        System.assertEquals(0, con1data.size(), 'Did not expect a value to be returned.'+ con1data);

        List<GW_Volunteers__Volunteer_Hours__c> con2data = VolunteerController.getHistoricalShiftsByContact(conId2);

        /*System.assert.isnotnull(con2_data);*/
        System.assertNotEquals(0, con2data.size(), 'Expect a value to be returned.'+ con2data);
        System.assertEquals(varHours, con2data.size(), 'Expect a value to be returned.'+ con2data);
        
        List<GW_Volunteers__Volunteer_Hours__c> con3data = VolunteerController.getHistoricalShiftsByContact(null);
        
        System.assertEquals(0, con3data.size(), 'Did not expect a value to be returned.'+ con3data);
        

    }


    @isTest static void testgetChartDataMethod() {
        Contact contact1 = [SELECT Id FROM Contact WHERE LastName='TestContact0'];
        Contact contact2 = [SELECT Id FROM Contact WHERE LastName='TestContact1'];
        Id conId1 = contact1.Id;
        Id conId2 = contact2.Id;
    
        System.assertNotEquals(null, VolunteerController.getChartData(conId2),'Did not expect a value to be returned.');

    }


    @isTest static void testgetRankingInfoMethod() {
        Contact contact1 = [SELECT Id FROM Contact WHERE LastName='TestContact0'];
        Contact contact2 = [SELECT Id FROM Contact WHERE LastName='TestContact1'];
        Id conId1 = contact1.Id;
        Id conId2 = contact2.Id;
       
    
      
        String rank2 = VolunteerController.getRankingInfo(conId1);
        String compVal = '1';
        System.assertEquals(compVal, rank2, 'Did not expect a value to be returned.');

        String rank3 = VolunteerController.getRankingInfo(conId2);
        System.assertEquals(compVal, rank3, 'Did not expect a value to be returned.');
        


    }


        @isTest
    static void testFetchRecords() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = testAccount.Id);
        insert testContact;

        VolunteerController.SearchWrapper inputWrapper = new VolunteerController.SearchWrapper();
        inputWrapper.objectApiName = 'Contact';
        inputWrapper.fieldApiName = 'FirstName';
        inputWrapper.otherFieldApiName = 'LastName';
        inputWrapper.searchString = 'Test';
        inputWrapper.selectedRecordId ='';
        inputWrapper.parentRecordId = testAccount.Id;
        inputWrapper.parentFieldApiName = 'AccountId';

        Test.startTest();
        List<VolunteerController.ResultWrapper> results = VolunteerController.fetchRecords(inputWrapper);
        Test.stopTest();

        // Assertions
        System.assertEquals(1, results.size());
        VolunteerController.ResultWrapper result = results[0];
        System.assertEquals('Test', result.mainField);
        System.assertEquals('Contact', result.subField);
        
        
        
    }
    
    // Test method for fetchRecords with a valid parent record
    @isTest
    static void testFetchRecordsValid() {
        
        
        
        VolunteerController.SearchWrapper inputWrapper1 = new VolunteerController.SearchWrapper();
        inputWrapper1.objectApiName = 'Contact';
        inputWrapper1.fieldApiName = 'FirstName';
        inputWrapper1.otherFieldApiName = 'LastName';
        inputWrapper1.searchString = 'Test';
         inputWrapper1.parentRecordId = '123435';
        inputWrapper1.parentFieldApiName = 'AccountId';
        
 	    List<VolunteerController.ResultWrapper> result1 = VolunteerController.fetchRecords(inputWrapper1);
        
        
        System.assertNotEquals(null, result1);
        System.assertEquals(0, result1.size(), 'Result list should be empty for a valid search string');
        
    }

     // Test method for fetchRecords with a valid parent record
    @isTest
    static void testFetchRecordsWithValidParentRecord() {
        
        GW_Volunteers__Volunteer_Job__c job1 = [SELECT Id FROM GW_Volunteers__Volunteer_Job__c limit 1];
        Id conId1 = job1.Id;
       
        
        VolunteerController.SearchWrapper inputWrapper = new VolunteerController.SearchWrapper();
        inputWrapper.objectApiName = 'GW_Volunteers__Volunteer_Shift__c';
        inputWrapper.fieldApiName = 'GW_Volunteers__Start_Date_Time__c';
        inputWrapper.parentFieldApiName = 'GW_Volunteers__Volunteer_Job__c';
        inputWrapper.parentRecordId = conId1; // Provide a valid parent record Id
        inputWrapper.otherFieldApiName='Job_Name__c';
        inputWrapper.selectedRecordId ='';
        Test.startTest();
        List<VolunteerController.ResultWrapper> result = VolunteerController.fetchRecords(inputWrapper);
		Test.stopTest();        
        System.assertNotEquals(null, result);
        // Add specific assertions based on your test data
    }

    
}