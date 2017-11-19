global class LtngFormElementController {
      
    @AuraEnabled
    global static string getMetadataMap(string objectName, string fieldName, string recordTypeId){
        string recordTypeApiName;
        if (recordTypeId != null){
            for (RecordType rt : [select id, DeveloperName from recordtype where id=:recordTypeId limit 1]){
                recordTypeApiName = rt.DeveloperName;
            }
        }
        if (!string.isempty(objectName) && !string.isEmpty(fieldName)){
            //return JSON.serialize(MetadataHelper.getFieldsMetadataMap(objectName, new string[]{fieldName}, false, recordTypeApiName));
            return JSON.serialize(MetadataHelper.getFieldInfos(objectName, new string[]{fieldName}, false, recordTypeApiName));
        }
        return '{}';
    }
    
    
    @AuraEnabled
    global static string getLookupRecord(string recordId){
        return InputLookUpController.getLookupRecord(recordId);
    }
}