global without sharing class RecordHistoryController {

    global class HistoryItem {
        global string Id{get;set;}
        global string ParentId{get;set;}
        global Object CreatedDate{get;set;}
        global string CreatedById{get;set;}        
        global string Field{get;set;}
        global string FieldLabel{get;set;}
        global Object OldValue{get;set;}
        global Object NewValue{get;set;}
        global HistoryItem(){}
        global HistoryItem(Sobject historyRecord, Schema.DescribeSObjectResult so){
            Id = string.valueOf( historyRecord.get('Id') );
            ParentId = string.valueOf( historyRecord.get('ParentId') );
            CreatedById = string.valueOf( historyRecord.get('CreatedById') );            
            NewValue = historyRecord.get('NewValue');
            OldValue = historyRecord.get('OldValue');
            CreatedDate = DateTime.valueOf( historyRecord.get('CreatedDate') );            
            Field = string.valueOf( historyRecord.get('Field') );            
            if( so.fields.getMap().containsKey(Field) ) FieldLabel = so.fields.getMap().get(Field).getDescribe().getLabel();
        }
    }
        
    global class InitializeComponentResponseWrp{
        global list<HistoryItem> history{get;set;}
        global string sobjectLabel{get;set;}
        global string sobjectName{get;set;}
        public InitializeComponentResponseWrp(Schema.DescribeSObjectResult so, list<sobject> queryResults){                        
            list<HistoryItem> items = new list<HistoryItem>();
            for(Sobject s : queryResults){
                if (s.get('Field') != 'created'){
                    items.add( new HistoryItem(s, so) );
                    
                }
            }
            HistoryItem created = new HistoryItem();
            created.Field='created';
            items.add( created );
            history = items;
			sobjectLabel = so.getLabel();
            sobjectName = so.getName();
        }
    }
    
    global class InitializeComponentResponse extends ResponseWrapperBase{
        InitializeComponentResponseWrp results {get;set;}        
    }
    
    class RecordHistoryException extends Exception{}
    @AuraEnabled
    global static string InitializeComponent(string recordId){
        InitializeComponentResponse resp = new InitializeComponentResponse();        
        try{
			Schema.DescribeSObjectResult so = getSobjectByPrefix( recordId.substring(0,3) );
            if (so != null){
                string query = 'SELECT Id,CreatedById,CreatedBy.Name,CreatedDate,Field,IsDeleted,NewValue,OldValue,ParentId FROM ' + so.getName().replace('__c','__history') + ' WHERE ParentId =:recordId order by createddate desc';
                resp.results = new InitializeComponentResponseWrp(so, Database.query(query)); 
            }else{
                throw new RecordHistoryException('SObject not found');
            }
        }catch(Exception ex){
            resp.success = false;
            resp.addError(ex);
        }
        return resp.toJSON();
    }
    
    static Schema.DescribeSObjectResult getSobjectByPrefix(string prefix){
        map<string, Schema.SObjectType> gmap = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult temp;
        for(string key : gmap.keyset()){
            temp = gmap.get(key).getDescribe();
            if (temp.getKeyPrefix() == prefix ) return temp;
        }
        return null;
    }
}