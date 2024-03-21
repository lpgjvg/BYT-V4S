public without sharing class VolunteerController {
  

    @AuraEnabled(cacheable=true scope='global')
    public static List<GW_Volunteers__Volunteer_Hours__c> getShiftsByContact(String contactid) {
        Date today = Date.today();
        String[] targetStatuses = new String[]{'Confirmed', 'Web Sign Up'};
        String status='Confirmed';
        String filter = ' WHERE GW_Volunteers__Contact__c = :contactid AND GW_Volunteers__Status__c IN :targetStatuses AND GW_Volunteers__Planned_Start_Date_Time__c >= :today';
        List<GW_Volunteers__Volunteer_Hours__c> result = Database.query ('SELECT Id, GW_Volunteers__Planned_Start_Date_Time__c, GW_Volunteers__Volunteer_Job__r.Name FROM GW_Volunteers__Volunteer_Hours__c ' + filter);
        return result;
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<GW_Volunteers__Volunteer_Hours__c> getHistoricalShiftsByContact(String contactid) {
        Date today = Date.today();
        String status='Completed';
        String filter = ' WHERE GW_Volunteers__Contact__c = :contactid AND GW_Volunteers__Status__c = :status';
        String sortOrder = ' Order by GW_Volunteers__Start_Date__c Desc';
        List<GW_Volunteers__Volunteer_Hours__c> resultHist = Database.query ('SELECT Id, GW_Volunteers__Planned_Start_Date_Time__c,	GW_Volunteers__Start_Date__c, GW_Volunteers__Volunteer_Job__r.Name,GW_Volunteers__Hours_Worked__c FROM GW_Volunteers__Volunteer_Hours__c ' + filter + sortOrder);
        return resultHist;
    }

    @AuraEnabled(cacheable=true scope='global')
      public static  List<chartData> getChartData(string contactid){
        integer cMonths = 12;
        string strChartDateFormat = 'MMM yyyy';
        Date dtStart = date.today().addMonths(-cMonths + 1).toStartOfMonth();
        List<chartData> formattedresult = new List<chartData>();
        String status='Completed';
        list<AggregateResult> listAG = Database.query ('SELECT CALENDAR_YEAR(GW_Volunteers__Start_Date__c) theYear, CALENDAR_MONTH(GW_Volunteers__Start_Date__c) theMonth, SUM(GW_Volunteers__Total_Hours_Worked__c) sumHours from GW_Volunteers__Volunteer_Hours__c where GW_Volunteers__Contact__c = :contactId and GW_Volunteers__Status__c = :status and GW_Volunteers__Start_Date__c >= :dtStart group by CALENDAR_YEAR(GW_Volunteers__Start_Date__c), CALENDAR_MONTH(GW_Volunteers__Start_Date__c) order by CALENDAR_YEAR(GW_Volunteers__Start_Date__c), CALENDAR_MONTH(GW_Volunteers__Start_Date__c)' );

            Date dtNext = dtStart;
            Time timeT = Time.newInstance(1, 0, 0, 0);
            for (AggregateResult ag : listAG) {
                Date dt = date.newInstance(integer.valueOf(ag.get('theYear')), integer.valueOf(ag.get('theMonth')), 1);
                
                // handle months with no data
                while (dtNext < dt) {
                    formattedresult.add(new ChartData(datetime.newInstance(dtNext,timeT).format(strChartDateFormat), 0));    
                    dtNext = dtNext.addMonths(1);       
                }
                
                formattedresult.add(new ChartData(datetime.newInstance(dt,timeT).format(strChartDateFormat), integer.valueOf(ag.get('sumHours'))));
                dtNext = dt.addMonths(1);
            }
        

        return formattedresult;
    }

     //  wrapper class to hold chart data for each of the last N months
     public class ChartData {   
        @AuraEnabled     
        public string strDateLabel { get; set; }
        @AuraEnabled
        public integer sumHours { get; set; }       
        public ChartData (string strDateLabel, integer sumHours) {
            this.strDateLabel = strDateLabel;
            this.sumHours = sumHours;           
        }
    }


    @AuraEnabled(cacheable=true scope='global')
    public static String getRankingInfo(String contactid) {

       
        
        Decimal contactTotalHours = [SELECT Id, GW_Volunteers__Volunteer_Hours__c FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED LIMIT 1].GW_Volunteers__Volunteer_Hours__c;

            if (contactTotalHours == null || contactTotalHours == 0) {
                return string.valueof(1);
            }

            String hoursField = String.valueOf(Contact.GW_Volunteers__Volunteer_Hours__c);
            String totalVolunteersQuery = 'SELECT count() FROM Contact WHERE ' + hoursField + ' > 0';
            String totalVolunteersWithMoreHoursQuery = totalVolunteersQuery + ' AND ' + hoursField + ' > ' + contactTotalHours;
           
            Integer totalVolunteers = Database.countQuery(totalVolunteersQuery);

            if (totalVolunteers <= 2) {
                return string.valueof(1);
            }
            
            Integer totalVolunteersWithMoreHours = Database.countQuery(totalVolunteersWithMoreHoursQuery);

            Integer rank = Integer.valueOf(
                100 * (
                    Decimal.valueOf(totalVolunteersWithMoreHours)
                    / Decimal.valueOf(totalVolunteers - 1)
                )
            );

            if (rank == 0) {
                rank = 1;
            }

            return string.valueof(rank);
    }
//  wrapper class to fetch records - Salesforce Diares - Reusable Lookup Field In LWC
@AuraEnabled(cacheable=true scope='global')
public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
    try {
        if (inputWrapper == null) {
            return null;
        }
        
        String query = buildQuery(inputWrapper);
        List<ResultWrapper> returnWrapperList = executeQuery(query, inputWrapper);


        // Query for the count of child records and append it to the result wrapper
        if (inputWrapper.objectApiName == 'GW_Volunteers__Volunteer_Job__c') {
            Map<String, Integer> childCounts = queryChildCount(inputWrapper);
            for (ResultWrapper wrap : returnWrapperList) {
                Integer childCount = childCounts.get(wrap.id);
                if (childCount != null) {
                    wrap.childCount = childCount;
                    System.debug('Entered Childcount Wrap>>> ' + childCount + '!');
                }
            }
        }
        System.debug('returnWrapperList>>> ' + returnWrapperList + '!');
        return returnWrapperList;
    } catch (Exception err) {
         System.debug('An error occurred: ' + err.getMessage());
        throw new AuraHandledException(err.getMessage());
    }
}

private static String buildQuery(SearchWrapper inputWrapper) {
    String fieldsToQuery = 'SELECT Id, ';

    
    if (String.isNotBlank(inputWrapper.fieldApiName)) {
            fieldsToQuery += inputWrapper.fieldApiName;
    }
    
    if (String.isNotBlank(inputWrapper.otherFieldApiName)) {
        fieldsToQuery += ', ' + inputWrapper.otherFieldApiName;
    }
    
    String query = fieldsToQuery + ' FROM ' + inputWrapper.objectApiName;
    String filterCriteria;

    if(fieldisDateTime(inputWrapper.objectApiName, inputWrapper.fieldApiName))
    {
        
        DateTime pastDate = DateTime.now().addDays(-30);
        DateTime futureDate = DateTime.now();
         filterCriteria = inputWrapper.fieldApiName + ' >= ' + pastDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' AND ' + inputWrapper.fieldApiName + ' <= ' + futureDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' ORDER BY ' + inputWrapper.fieldApiName + ' DESC';
         System.debug('Entered Date>>> ' + filterCriteria + '!');
    }
    else{
                 filterCriteria = inputWrapper.fieldApiName + ' LIKE ' + '\'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) +  '%\' LIMIT 10';
         
    }
    
    if (String.isNotBlank(inputWrapper.selectedRecordId)) {
        query += ' WHERE Id = \'' + inputWrapper.selectedRecordId + '\'';
    } else if ( String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)) {
        query += ' WHERE ' + inputWrapper.parentFieldApiName + ' = \'' + inputWrapper.parentRecordId + '\'';
        query += ' AND ' + filterCriteria;
        System.debug('Entered Parent>>> ' + inputWrapper.parentRecordId + '!');
    } else  if(inputWrapper.objectApiName == 'GW_Volunteers__Volunteer_Job__c'){
               query += ' WHERE GW_Volunteers__Inactive__c = :jobInActive AND GW_Volunteers__Display_on_Website__c = true AND '+ filterCriteria;               
    }else
    {
		query +=  filterCriteria;        
    }
    System.debug('Query>>> ' + query + '  parent Record Id>>>'+ inputWrapper.parentRecordId);
    return query;
}

private static Boolean fieldisDateTime(String objectApiName, String fieldApiName) {
    Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    
    if (globalDescribe.containsKey(objectApiName)) {
        Schema.DescribeSObjectResult objectDescribe = globalDescribe.get(objectApiName).getDescribe();
        
        if (objectDescribe.fields.getMap().containsKey(fieldApiName)) {
            Schema.DescribeFieldResult fieldDescribe = objectDescribe.fields.getMap().get(fieldApiName).getDescribe();
            System.debug('Field Type>>> ' + fieldDescribe.getType() + '!');
            return fieldDescribe.getType() == Schema.Displaytype.DateTime;// Schema.DisplayType.STRING;
        }
    }
    
    return false; // Default to false if object or field is not found
}

private static List<ResultWrapper> executeQuery(String query, SearchWrapper inputWrapper) {
    List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
    Boolean jobInActive = False;
   
    try {
        for (SObject s : Database.query(query)) {
            ResultWrapper wrap = createResultWrapper(s, inputWrapper);
            returnWrapperList.add(wrap);
        }
    } catch (QueryException e) {
       
        System.debug('Query Exception: ' + e.getMessage());
    }

    // If there are no results, the list will be empty
    return returnWrapperList;
}

private static ResultWrapper createResultWrapper(SObject s, SearchWrapper inputWrapper) {
    ResultWrapper wrap = new ResultWrapper();
    
    Schema.DescribeFieldResult fieldDescribe = s.getSObjectType().getDescribe().fields.getMap().get(inputWrapper.fieldApiName).getDescribe();
    
    if (fieldDescribe.getType() == Schema.DisplayType.DATETIME) {
        wrap.mainField = ((DateTime)s.get(inputWrapper.fieldApiName)).format('dd/MM/yyyy HH:mm a');
    } else if (fieldDescribe.getType() == Schema.DisplayType.STRING) {
        wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
    }
    
    wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
    wrap.id = (String)s.get('Id');
    
    return wrap;
}

// Modify the queryChildCount method to return a Map of Id to Integer
private static Map<String, Integer> queryChildCount(SearchWrapper inputWrapper) {
    Map<String, Integer> childCounts = new Map<String, Integer>();
    DateTime pastDate = DateTime.now().addDays(-30);
    DateTime futureDate = DateTime.now();
    String childCountQuery = 'SELECT COUNT(Id) ChildCount, GW_Volunteers__Volunteer_Job__c ParentId FROM GW_Volunteers__Volunteer_Shift__c' +  
    ' WHERE GW_Volunteers__Volunteer_Job__c  IN :parentIds AND GW_Volunteers__Start_Date_Time__c >= ' + 
    pastDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') + ' AND GW_Volunteers__Start_Date_Time__c <= ' + futureDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'') +
                             ' GROUP BY GW_Volunteers__Volunteer_Job__c';
    
    Set<String> parentIds = new Set<String>();
    for (ResultWrapper wrap : executeQuery(buildQuery(inputWrapper), inputWrapper)) {
        parentIds.add(wrap.id);
    }
    
    for (AggregateResult aggregateResult : Database.query(childCountQuery)) {
        String parentId = (String)aggregateResult.get('ParentId');
        Integer count = (Integer)aggregateResult.get('ChildCount');
        childCounts.put(parentId, count);
    }
    
    return childCounts;
}

public class ResultWrapper{
    @AuraEnabled public String mainField{get;set;}
    @AuraEnabled public String subField{get;set;}
    @AuraEnabled public String id{get;set;}
    @AuraEnabled public Integer childCount { get; set; } // Change childCount to Integer
}

public class SearchWrapper {
    @AuraEnabled public String objectApiName{get;set;}
    @AuraEnabled public String fieldApiName{get;set;}
    @AuraEnabled public String otherFieldApiName{get;set;}
    @AuraEnabled public String searchString{get;set;}
    @AuraEnabled public String selectedRecordId{get;set;}
    @AuraEnabled public String parentRecordId{get;set;}
    @AuraEnabled public String parentFieldApiName{get;set;}
}

    
}