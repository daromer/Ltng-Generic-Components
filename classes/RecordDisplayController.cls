/**************************************
Author             : Danny Robles
Purpose            : Controller for the RecordDisplay lighting component		
Req-no/Release     : Req-09556
Created Date       : 2/10/2017
Reviewed By        : 
Last Modified By   : 
**************************************/
global class RecordDisplayController {
    
    global class RecordDataResponseWrapper {
        global string id {get;set;}
        global string name {get;set;}
        global string url {get;set;}
        public RecordDataResponseWrapper(){}
        public RecordDataResponseWrapper(string id, string name, string url){this.id = id; this.name = name; this.url = url;}
    }
    global class RecordDataResponse extends ResponseWrapperBase { global RecordDataResponseWrapper data {get;set;} }
    
    @remoteaction
    @AuraEnabled
    global static string getRecordData(string recordId) {
        RecordDataResponse result = new RecordDataResponse();        
        try{
            string keyPrefix = recordId.substring(0,3);
            EntityDefinition[] entities = [Select QualifiedAPIName from EntityDefinition where KeyPrefix=:keyPrefix limit 1];            
            if (entities.size() == 0){
                result.success = false;
                system.debug('ERROR RecordDisplayController.doRequest: Object not found');
            }                
            for(EntityDefinition ed : entities){
                string sObjectName = ed.QualifiedAPIName;
                string defaultNameField;
                Schema.DescribeSObjectResult objDescribe = Schema.getGlobalDescribe().get(sObjectName).getDescribe(); 
                map<string, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                for (string fieldName : fieldMap.keySet()){
                    Schema.DescribeFieldResult fr = fieldMap.get(fieldName).getDescribe();
                    if ( fr.isNameField() ) defaultNameField = fr.getName();
                }
                if (sObjectName != null && defaultNameField != null){
                    string query = 'SELECT Id, ' + defaultNameField + ' FROM ' + sObjectName + ' WHERE id =:recordId limit 1';
                    
                    system.debug('RecordDisplayController.doRequest - query: ' + query );
                    
                    List<SObject> queryResult =  Database.query(query);
                    
                    if(queryResult.size() > 0){
                        result.data = new RecordDataResponseWrapper(
                           string.valueOf( queryResult[0].get('Id') ),
                           string.valueOf( queryResult[0].get( defaultNameField ) ),
                           string.valueOf( getBaseUrl(recordId ) )
                        );
                    }else{
                        result.success =false;
                        system.debug('ERROR RecordDisplayController.doRequest: Record not found.');
                    }
                }else{
                    result.success =false;
                    system.debug('ERROR RecordDisplayController.doRequest: SObject does not have a default name field.');
                }
            }        	 
        }
        catch(Exception e) {
            result.success =false;
            result.addError(e);
            system.debug('ERROR RecordDisplayController.doRequest: ' + e.getMessage() + ';	' + e.getStackTraceString());
        }
    	return JSON.serialize(result);
    }
    
    global static string getBaseUrl(Id recordId){
        Id netId = Network.getNetworkId();
        if (netId != null){
            for(Network n : [select urlpathprefix from network where id=:netId]){
                return '/' + n.urlpathprefix + '/'+recordId;
            }
        }
        return '/'+recordId;
    }
}