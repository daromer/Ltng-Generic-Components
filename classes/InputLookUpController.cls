global class InputLookUpController {
    
    global class SearchResult{        
        global String value{get;set;}
        global String id{get;set;}
    }
    
    global static string  getSObjectNameFromPrefix(string prefix){ 
        for(EntityDefinition ed : [Select QualifiedApiName from EntityDefinition where keyPrefix=:prefix limit 1]){
            return ed.QualifiedApiName;
        }
        return null;
    }
    
    global static string getBaseUrl(){
        return ((Network.getNetworkId() != null)? Site.getBaseUrl() : '') ;
    }
    
    global static string  getNameFieldFromSObject(string sobjectName){        
        Schema.DescribeSObjectResult dor = Schema.getGlobalDescribe().containsKey(sobjectName)?Schema.getGlobalDescribe().get(sobjectName).getDescribe():null;
        if (dor != null){
            for (string fieldName : dor.fields.getMap().keySet()){
                Schema.DescribeFieldResult field = dor.fields.getMap().get(fieldName).getDescribe();
                if(field.isNameField()){
                    return field.getName();
                }
            } 
        }
        return null;
    }
    
    @AuraEnabled
    global static String getCurrentValue(String type, String value){
        map<string, object> resultMap = new map<string,object>();
        try{
            
            Id lookUpId = (ID)value;
            
            String subId = Id.valueOf(lookUpId);
            
            SObjectType objType = Schema.getGlobalDescribe().get(type);
            
            String nameField = getSobjectNameField(objType);
            
            String mainQuery = 'SELECT Id, ' +nameField+ ' FROM ' +type+ ' Where Id =:lookupId'; 
            
            System.debug('getCurrentValue - mainQuery --> '+mainQuery);
            
            List<SObject> oList = Database.query(mainQuery);
            
            if(oList.size() > 0){
                SObject o = olist[0];
                resultMap.put('id', o.get('Id'));
                resultMap.put('value', o.get(nameField));
            }
        }catch(Exception ex){
            system.debug('Error on getCurrentValue:	' + ex.getMessage() + ' ||| ' + ex.getStackTraceString());
            resultMap.put('error', ex.getMessage() + ' - ' + ex.getStackTraceString());
            
        }
        System.debug('Result --> ' + resultMap);
        
        return JSON.serialize(resultMap);
    }
    
    private static String getSobjectNameField(SobjectType sobjType){
        String nameField = 'name';
        Schema.DescribeSObjectResult dfrLkp = sobjType.getDescribe();
        for(schema.SObjectField soType : dfrLkp.fields.getMap().values()){
            Schema.DescribeFieldResult fieldDescObj = soType.getDescribe();
            if(fieldDescObj.isNameField()){
                nameField = fieldDescObj.getName();
                System.debug('nameField --> ' + nameField);
                break;
            }
        }        
        return nameField;
    }
    
    @AuraEnabled //RETURN THE USER OR GROUP - OWNERS
    global static String getOwnerSearch(String OwnerType, String searchString){
        String ownerQuery;
        SObject[] result;
        List<SearchResult> resultList = new List<SearchResult>();
        try{
            string likeSearch = '%'+searchString+'%';
            if(OwnerType == 'User'){
                if(searchString != '*')
                    result = [Select Id, Name from User where name like :likeSearch limit 20];
                else
                    result = [Select Id, Name from User limit 20];
            }else if(OwnerType == 'Queue'){
                if(searchString != '*')
                    result = [Select Id, Name from Group where name like :likeSearch and type='QUEUE' limit 20];
                else
                    result = [Select Id, Name from Group where type='QUEUE' limit 20];
            }
            for(Sobject o : result){
                SearchResult sr = new SearchResult();
                sr.id = (String) o.get('Id');
                sr.value = (String) o.get('Name');
                resultList.add(sr);
                
            }
            System.debug('resultList --> ' + resultList);
        }catch(Exception ex){
            
        }
        return JSON.serialize(resultList);
    }
    
    
    @AuraEnabled
    global static String getSearchResults(String searchString, String sobjectType, string sobjectSubType, string staticSearchString){
        ResponseWrapper resp = new ResponseWrapper();
        resp.success = true;        
        String ownerQuery;        
        try{
        	
        	system.debug ('staticSearchString >>> ' + staticSearchString);
        	system.debug ('searchString >>> ' + searchString);
        	
            List<SearchResult> resultList = new List<SearchResult>();
            
            string likeSearch = '%'+searchString+'%';
            
            String nameField = getSobjectNameField(Schema.getGlobalDescribe().get(sobjectType));
            
            string[] whereParts = new list<string>();
            
            string wherePart = ' ';
            
            integer resultLimit = 20;
            
            if( string.isempty(searchString) ||  (searchString != '*') ) 
            	whereParts.add(' (' + nameField + ' like :likeSearch ) ');
            
            if(sobjectType == 'GROUP' && sobjectSubType =='QUEUE'){
                whereParts.add(' ( TYPE = :sobjectSubType )');
            }
            
            if (staticSearchString != '' && staticSearchString != null)
            	whereParts.add (staticSearchString);
            
            wherePart = (whereParts.size()>0) ? (' WHERE ' + string.join(whereParts, ' AND ') + ' ') : ' ';
            
            string query = 'Select Id, ' + nameField + ' from ' + sobjectType + wherePart + ' ORDER BY ' + nameField + ' limit :resultLimit';
            
            system.debug ('query >>> ' + query);
            
            for (SObject o : Database.query(query)){
                SearchResult sr = new SearchResult();	
                sr.id = (String) o.get('Id');
                sr.value = (String) o.get( nameField );
                resultList.add(sr);
            }
            
            map<string, object> resultMap = new map<string, object>();
            
            resultMap.put('records', resultList);
            
            resultMap.put('nameField', nameField);
            resultMap.put('sobjectType', sobjectType);
            resultMap.put('sobjectSubType', sobjectSubType);
            
            resp.data = resultMap;
            
            System.debug('getSearchResults - resultList --> ' + resultList);
        }catch(Exception ex){
            resp.success = false;
            resp.errors.add(new ResponseWrapper.Error(ex.getMessage(), ex.getStackTraceString(), null));
        }
        return JSON.serialize(resp);
    }
    
    @AuraEnabled //RETURN THE SPECIFIC USER OR GROUP BY ITS ID
    global static String getGroupOrUser(String ownerType, String value){
        System.debug('ownerType ' + ownerType);
        System.debug('value ' + value);
        
        List<SearchResult> resultList = new List<SearchResult>();

        SObject[] result;
        
        if(ownerType == 'User' && value != null){
            
            Id lookUpId = (ID)value;
            result = [SELECT Id, Name From User WHERE Id =: lookUpId];
            
            if(result.size() > 0){
                for(SObject o : result){
                    SearchResult sr = new SearchResult();
                    sr.id = (String) o.get('Id');
                    sr.value = (String) o.get('Name');
                    resultList.add(sr);
                }
            }
        }else if(ownerType == 'Queue' && value != null){
            
            Id lookUpId = (ID)value;
            result = [SELECT Id, Name FROM Group WHERE Group.Id = :lookUpId and Group.Type = 'Queue'];
            
            if(result.size() > 0){
                for(SObject o : result){
                    SearchResult sr = new SearchResult();
                    sr.id = (String) o.get('Id');
                    sr.value = (String) o.get('Name');
                    resultList.add(sr);
                }
            }
            
        }
        System.debug('resultList -->' + resultList);
        return JSON.serialize(resultList);
    }
    
    @AuraEnabled
    global static String searchSObject(String type, String searchString){
        system.debug('searchSObject --> type: '+ type);
        system.debug('searchSObject --> searchString : '+ searchString);
        
        List<SearchResult> output = new List<SearchResult>();
        
        if(String.isBlank(type) || String.isBlank(searchString)) return 'Set a type and a search';
        
        SObjectType objType = Schema.getGlobalDescribe().get(type);
        
        if(objType == null) return 'Type not found';
        
        String nameField = getSobjectNameField(objType);
        
        string likeSearch = '%'+searchString+'%';
        string likeStatement = (string.isempty(searchString) || string.isEmpty(searchString.trim()) || searchString.trim()=='*')? '' : (' WHERE '+nameField + ' LIKE :likeSearch ');
        string query = 'SELECT Id, ' + nameField + ' FROM ' + type + likeStatement+' ORDER BY ' + nameField + ' LIMIT 20';
        
        system.debug('search SObject query: ['+query+']');
        SObject[] soqlResult = database.query(query);
        for(Sobject sobj : soqlResult){
            SearchResult sr = new SearchResult();
            sr.id = (String)sobj.get('Id');
            sr.value = (String)sobj.get(nameField);
            output.add(sr);
        }
        System.debug('output --> ' + output);
        return JSON.serialize(output);
        
        
        searchString = '\'*'+searchString+'*\'';
        
        String soslQuery = 'FIND : searchString IN NAME FIELDS RETURNING ' + type + '(Id, ' +nameField+ ' ORDER BY ' +nameField+ ') LIMIT 20';
        System.debug('getCurrentValue - SOSL QUERY --> ' + soslQuery);
        
        List<List<SObject>> results = search.query(soslQuery);
        
        
        
        if(results.size() > 0){
            for(SObject sobj : results[0]){
                SearchResult sr = new SearchResult();
                sr.id = (String)sobj.get('Id');
                sr.value = (String)sobj.get(nameField);
                output.add(sr);
            }
        }
        System.debug('output --> ' + output);
        return JSON.serialize(output);
    }
    
    
    
    @AuraEnabled
    global static string getLookupRecord(string recordId){
        ResponseWrapper resp = new ResponseWrapper();
        resp.success = true;
        map<string,object> mapResult = new map<string,object>();
        try{
            if (!string.isempty(recordId)){
                string prefix = string.valueOf(recordId).substring(0,3);
                string sobjectName = getSObjectNameFromPrefix(prefix);
                string nameField = getNameFieldFromSObject(sobjectName);
                if ( !string.isEmpty(sobjectName) && !string.isEmpty(nameField) ){                                                            
                    List<SObject> queryResult =  Database.query('SELECT Id, ' + nameField + ' FROM ' + sobjectName + ' WHERE id =:recordId limit 1');
                    if(queryResult.size() > 0){
                        mapResult.put('id', (string)queryResult[0].get('Id') );
                        mapResult.put('attributeName', nameField );
                        mapResult.put('value', queryResult[0].get(nameField) );
                        mapResult.put('record', queryResult[0] );
                        mapResult.put('prefix', prefix);
                        mapResult.put('sobjectName', sobjectName);                        
                        mapResult.put('url', getBaseUrl() + '/' +  (string)queryResult[0].get('Id') );
                        resp.data = mapResult;
                    }else{                        
                        resp.success = false;
                    }
                }else{
                    resp.success = false;
                    resp.errors = new list<ResponseWrapper.Error>();
                    resp.errors.add( new ResponseWrapper.Error('record not found', null, null) );
                }
            }
        }catch(Exception ex){
            resp.success = false;
            resp.errors = new list<ResponseWrapper.Error>();
            resp.errors.add(new ResponseWrapper.Error(ex.getMessage(), ex.getStackTraceString(), null));
        }
        return JSON.serialize(resp);
    }
    
}