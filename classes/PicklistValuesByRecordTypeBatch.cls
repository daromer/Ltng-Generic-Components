global without sharing class PicklistValuesByRecordTypeBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts {
    public static System.Iterable<sobject> start(Database.BatchableContext ctx){
        return Database.getQueryLocator( 'SELECT SobjectType, DeveloperName FROM RecordType' );        
    }
    
    public static void execute(Database.BatchableContext ctx, sobject[] scope){
        RecordType[] scopeRtypes = (RecordType[])scope;
        
        RecordTypeWrapper[] rtResults = getPicklistValuesOfSObjectByRecordType( scopeRtypes );     
        
        delete [Select Id from Picklist_Values_By_RecordType__c];
        
        sobject[] toInsert = new list<sobject>();
        
        for (RecordTypeWrapper rt : rtResults){
            toInsert.add( rt.toSobject() );
        }
        
        if (toInsert.size() > 0) insert toInsert;
    }
    
    public static void finish(Database.BatchableContext ctx){}
    
    global class RecordTypeWrapper{
        global string fullName{get;set;}
        global map<string,set<string>> AvailablePicklistValues{get;set;}
        public Sobject toSobject(){
            return new Picklist_Values_By_RecordType__c(FullName__c = this.fullName, AvailablePicklistValues_Json__c = JSON.serialize(this.AvailablePicklistValues));
        }
    }
    
    global static RecordTypeWrapper[] getPicklistValuesOfSObjectByRecordType(RecordType[] rtList){       
        RecordTypeWrapper[] lstResult = new RecordTypeWrapper[]{};
        
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element(); 
        service.SessionHeader.sessionId = Page.CurrentSessionId.getContent().toString().trim();
        
        string[] fullNames = new list<string>();
        
        for(RecordType rt : rtlist){
            fullNames.add( rt.SobjectType + '.' + rt.DeveloperName );
        }
        
        MetadataService.RecordType[] recordTypeDataList = (MetadataService.RecordType[]) service.readMetadata('RecordType', fullNames).getRecords();
        
        for( MetadataService.RecordType rtData : recordTypeDataList){
            map<string,set<string>> result;
            if ( rtData.picklistValues != null){
                result = new map<string,set<string>>();
                for ( MetadataService.RecordTypePicklistValue rpk : rtData.picklistValues ) { 
                    if( !result.containsKey(rpk.picklist) ) result.put(rpk.picklist, new set<string>());                                              
                    for ( MetadataService.PicklistValue pk : rpk.values ) result.get(rpk.picklist).add( StringUtils.escapeAnsciiPercentEncoding(pk.fullName) );
                    
                }
                RecordTypeWrapper t = new RecordTypeWrapper();
                t.fullName = rtData.fullName;
                t.AvailablePicklistValues = result;
                lstResult.add(t);
            }            
        }
        
        return lstResult;
    }
}