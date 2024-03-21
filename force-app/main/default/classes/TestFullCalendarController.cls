@isTest
private class TestFullCalendarController{

    @testSetup static void setup(){
        DateTime now = System.now();
        Campaign campaignRecord = new Campaign(Name = 'Test Campaign ' + now,  IsActive = true);
        insert campaignRecord;

        GW_Volunteers__Volunteer_Job__c  volunteerJob  = new GW_Volunteers__Volunteer_Job__c(Name = 'Test Job ' + now,
        GW_Volunteers__Campaign__c = campaignRecord.Id,
            GW_Volunteers__Display_on_Website__c = true);
        insert volunteerJob;

       
           List<GW_Volunteers__Volunteer_Shift__c> testShifts = new List<GW_Volunteers__Volunteer_Shift__c>();
           for(Integer i=0;i<3;i++) {
            testShifts.add(new GW_Volunteers__Volunteer_Shift__c(
            GW_Volunteers__Volunteer_Job__c = volunteerJob.Id,
            GW_Volunteers__Duration__c = 2,
            GW_Volunteers__Start_Date_Time__c = System.today().addDays(i)
           ));
           }
           insert testShifts;

    }

    @isTest static void testgetEventsNearbyDynamicMethod() {
        // code_block   

        System.assertNotEquals(0, FullCalendarController.getEventsNearbyDynamic(System.today(),System.today().addDays(10),'GW_Volunteers__Volunteer_Shift__c','Job_Name__c','GW_Volunteers__Start_Date_Time__c','Shift_End_Date_Time__c','Calendar_Shift_Color__c',null,null).size(),'Expect a value to be returned.');
        System.assertEquals(0, FullCalendarController.getEventsNearbyDynamic(Date.today()+100,Date.today()+100,'Event','Subject','StartDateTime','EndDateTime',null,null,null).size(),'Did not expect a value to be returned.');

    }

}