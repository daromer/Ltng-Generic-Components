({
    getType : {
        "PICKLIST":"Select",
        "STRING":"Text",
        "DATETIME":"DateTime",
        "DATE":"Date",
        "BOOLEAN":"Checkbox",
        "CURRENCY":"Number",
        "DOUBLE":"Number",
        "EMAIL":"Email",
        "ID":"Lookup",
        "MULTIPICKLIST":"Select",
        "PHONE":"Phone",
        "REFERENCE":"Lookup",
        "TEXTAREA":"TextArea"
    },
    
    initializeMetadata:function(component, metadata, fieldName){
        var me = this;
     
        var logger = me.logger(component);
        var cloneMetadata = me.clone(metadata);
           console.log(cloneMetadata,'::cloneMetadata')  ;   
        if (cloneMetadata && cloneMetadata.Type && typeof(cloneMetadata.Type)=='string'){            
            initMeta(component, cloneMetadata);
            logger.info("INITIALIZED...", cloneMetadata, component);
        }else if (cloneMetadata && cloneMetadata[fieldName] && typeof(cloneMetadata[fieldName])=='object' &&  cloneMetadata[fieldName].Type && typeof(cloneMetadata[fieldName].Type)=='string' ){            
            console.log('inside init meta');
            initMeta(component, cloneMetadata[fieldName]);
            logger.info("INITIALIZED...", cloneMetadata, component);
        }else{            
            me.logger(component).error("not able to initialize metadata");
        }
        
        function initMeta(component, meta){
            var m = me.clone(meta);
            logger.warn("META====> ", m);            
            var type = me.getType[m.Type];
            logger.info("Found Type: " + type);             
            component.set('v.type', type? type:'Text');            
            if(m.Type == "MULTIPICKLIST"){                
                component.set('v.InputSelectDefault', true);
                component.set("v.multiple", true);
            }
            component.set('v.labelText',m.Label);
            component.set("v.maxlength", m.Length);                        
            component.set('v.controllerFieldName', m.Controller);
            var controllerValue = component.get('v.controllerFieldValue');
            var dependencyMap = m.DependencyMap?m.DependencyMap:[];
            component.set('v.dependencyMap', dependencyMap );
            var referenceItems = [];
            if (m.Type=='REFERENCE' && m.ReferenceTo){
                console.info('IS REFERENCE...');
                referenceItems =  m.ReferenceTo.split(',');
                component.set('v.refTypes', referenceItems);
                var refObjTypes = [];
                me.each(referenceItems, function(t){
                    var refType = {value:t};
                    refType.label = ( m.Name.toLowerCase() == 'ownerid' && t.toLowerCase()=='group' )? 'QUEUE' : t;
                    refObjTypes.push(refType);
                });
                component.set('v.refObjTypes', refObjTypes);
                
                if(m.ReferenceTo.indexOf('User')==-1)
            		component.set('v.lookupType', referenceItems[0] );
            	else
            		component.set('v.lookupType','User');
            }
            if(m.Name.toLowerCase() =='ownerid'){
                component.set('v.isOwnerField', true);
                component.set('v.subType', 'QUEUE');
            }
            if (meta.isDependentPicklist) {                
                component.set('v.options', dependencyMap[controllerValue]);            
            }else if (m.Type=="PICKLIST" || meta.Type == "MULTIPICKLIST" ){				
                component.set('v.options', m.PicklistValues);
            }
            component.set('v.strictRequired', m.isNillable?false:true);
        }
    },
    
    
	processDependentPicklistValues : function processDependentPicklistValues(component, value, oldValue, dependencyMap, helper) {
        var currentNewValue = helper.getValueFromEvent(component, value); 
        var currentOldValue = helper.getValueFromEvent(component, oldValue);  
        var me = this;
        me.logger(component).info('*** processDependentPicklistValues values... *** ', { 'currentNewValue':currentNewValue, 'currentOldValue':currentOldValue });
		if ( typeof(currentNewValue)!='undefined' && dependencyMap){
            var options = dependencyMap[currentNewValue];                        
            component.set("v.options",options);
        }
	},
    
    getValueFromEvent : function getValueFromEvent(component, value){
        var result;
        if (typeof(value)=='string'){
            return value;
        }else if (typeof(value)=='object' && component.get('v.controllerFieldValue')){
            //Asuming the aura:id is actually the name of the field in the object that the element represents            
            var controllerFieldName = component.get('v.controllerFieldName')
            return value? value[controllerFieldName] : null;
        }
	},
    
    
    getMetadataMapFromServer : function(component, helper, callback){        
        var sobjectName = component.get('v.sobjectName');
        var fieldName = component.get('v.fieldName');
        var recordTypeId = component.get('v.recordTypeId');
        var strictModeOn = component.get('v.strictModeOn');
        var logger = helper.logger(component);
        
        if (sobjectName && fieldName){
            var params = { 
                objectName:sobjectName, 
                fieldName:fieldName,
                recordTypeId : recordTypeId
            };
            helper.callServer(component, 'c.getMetadataMap', params , function metadataSuccess(results){
                var metadata = JSON.parse(results);  
                var metadataForField = {};
                
                if (!strictModeOn){
                    if (metadata && metadata[fieldName] ){ 
                        metadataForField = metadata[fieldName];
                        logger.debug('Metadata for the field : ' + sobjectName+'.'+fieldName, metadata );
                        component.set('v.metadata', metadataForField);                       
                        var dependencyMap = component.get('v.dependencyMap');
                        if (!dependencyMap){
                            if ( metadataForField.Controller && metadataForField.DependencyMap ){
                                logger.info("*** Adding dependency Map for: controller: "+metadataForField.Controller+';   field: '+fieldName, metadataForField.DependencyMap);
                                component.set('v.dependencyMap', metadata.DependencyMap);                        
                            }else if(metadataForField.PicklistValues && metadataForField.PicklistValues.length>0){                        
                                component.set('v.options', helper.clone( metadataForField.PicklistValues) );
                            }
                        }else if(metadataForField.PicklistValues && metadataForField.PicklistValues.length>0){                         
                            component.set('v.options', helper.clone( metadataForField.PicklistValues) );
                        }
                    }
                    if (typeof(callback)=='function')callback( metadataForField );
                }else{
                    if (metadata && metadata[fieldName] ){ 
                        metadataForField = metadata[fieldName];
                        component.set('v.metadata', metadataForField);
                    }
                    if (typeof(callback)=='function')callback( metadata );
                }                
            },function fail(errors){
                helper.foreach(errors,function(err){
                    console.error('Error calling the server for metadata: ', err.message);
                });
            },null, function finallyCallback(){});
        }else{
            if (typeof(callback)=='function')callback(null);
        }
    },
    
    
    
    //-------------- BEGIN MINI VALIDATION FRAMEWORK (NOT IMPLEMENTED YET )------------------    
    startValidation:function(component, helper){  
        var expression = component.get('v.validationExpression');
        var isValid = true;
        var logger = helper.logger(component);
        if (expression && typeof(expression)=="string"){
            logger.info("EXPRESSION FOUND =======> ", expression);
            var valResult = helper.validateFwSections(component, helper.clone(expression));
            isValid = !valResult.result;
            logger.info("Validations results ==> ", valResult);
			var valErrors = [];
            helper.foreach(valResult.errors, function(err){
                valErrors.push({ message : err });
            });
            component.set("v.validationErrors", valErrors);            
        }else{
            logger.warn("No validation expressions found");
        }       
        component.set('v.isValid', isValid);
    },
    getRegexValidators : function(){
        return {
            OR :  /\[BEGIN OR](.*?)\[END OR\]/ig,
            AND : /\[BEGIN AND](.*?)\[END AND\]/ig,
        };
    },
    validateFwConditions: function(component, conditions, processType, helper){
        var self = this;        
        var resultObj = { result:false, errors:[] };
        var conditionsSplit = conditions.split('|');
        processType = processType? processType : 'OR'; //Possible values: AND, OR
        
        var fwResults = [];
        for (var i = 0; i < conditionsSplit.length; i++){
            var singleCondition = { result:false, errors:[] };
            var condition = conditionsSplit[i];
            var conParts = condition.split(';;;');                
            var actualValue = conParts[0];
            var conCheck = conParts[1];
            var valToConpare = conParts[2];
            var validationErrorMessage = conParts[3];            
            var strFieldValue = actualValue? actualValue.toString().trim() : actualValue;
            var numFieldValue = actualValue? Number.parseFloat(actualValue.toString().trim()) : actualValue;
            if (conCheck == 'like' && strFieldValue){
                singleCondition.result = strFieldValue.indexOf(valToConpare)>=0;
            }else if(conCheck == 'notLike' && strFieldValue){
                singleCondition.result = !(strFieldValue.indexOf(valToConpare)>=0);
            }else if(conCheck == 'include' && strFieldValue){
                singleCondition.result = self.picklistContains( strFieldValue, valToConpare );
            }else if(conCheck == 'notInclude' && strFieldValue){
                singleCondition.result = !self.picklistContains( strFieldValue, valToConpare );
            }else if (conCheck == 'otherThan' && strFieldValue){					                    
                singleCondition.result = self.picklistOtherThan(strFieldValue, valToConpare);                    
            }else if (conCheck == 'notOtherThan' && strFieldValue){					                    
                singleCondition.result = !self.picklistOtherThan(strFieldValue, valToConpare);                    
            }else if (conCheck == 'regex' && strFieldValue){
                var regex = new RegExp( valToConpare, 'g' );
                singleCondition.result = regex.test( strFieldValue );
            }else if(conCheck == 'moreThanNum'){
                if (!isNaN(numFieldValue) && !isNaN(valToConpare)){
                    singleCondition.result = numFieldValue > Number.parseFloat(valToConpare);
                }
            }else if(conCheck == 'lessThanNum'){
                if (!isNaN(numFieldValue) && !isNaN(valToConpare)){
                    singleCondition.result = numFieldValue < Number.parseFloat(valToConpare);
                }
            }else if(conCheck == 'is'){
                if (valToConpare=="empty"){
                    singleCondition.result = (strFieldValue)?false:true;
                }else{
                    var regex = self.getRegex()[valToConpare];
                    if(regex && strFieldValue){
                        singleCondition.result = regex.test(strFieldValue);
                    }
                }
            }else if (conCheck == 'isNot'){
                if (valToConpare=="empty"){
                    singleCondition.result = (strFieldValue)?true:false;
                }else{
                    var regex = self.getRegex()[valToConpare];
                    if(regex && strFieldValue){
                        singleCondition.result = !regex.test(strFieldValue);
                    }
                }
            }
            if (singleCondition.result){
                singleCondition.errors.push( validationErrorMessage );
            }     
            fwResults.push(singleCondition);
        };
        
        if (processType == 'OR'){
            var trueFound = false; //true if any value is true
            for (var i =0; i<fwResults.length; i++){
                if( fwResults[i].result ) {
                    if (trueFound == false) trueFound = true;
                }
                resultObj.errors = resultObj.errors.concat( fwResults[i].errors  );
            }
            resultObj.result = trueFound;
        }else if (processType == 'AND'){
            var allValuesAreTrue = true; //false if any value is false
            for (var i =0; i<fwResults.length; i++){
                if( !fwResults[i].result ) {
                    allValuesAreTrue = false;                    
                }
				resultObj.errors = resultObj.errors.concat( fwResults[i].errors  );                
            }
            resultObj.result = allValuesAreTrue;
        }
        
        return resultObj;
    },
    
    validateFwSections : function(component, allSecions){
        var me = this;	
		var separation = '[AND]';
        var resultObj = { result:true, errors:[] };
        var arr = allSecions.split(separation);
        var regex = me.getRegexValidators();
        var arrResults = [];        
        for(var i = 0; i<arr.length; i++){
            var section = arr[i];
            var hasORValidations = false;
            var hasANDValidations = false;
            if ( section.match( regex.OR ) && section.match( regex.OR ).length > 0){
                hasORValidations = true;
                var orResult = { result:false, errors:[] };
                var orMatches = section.match( regex.OR );
                for(var orIdx = 0; orIdx < orMatches.length; orIdx++){
                    var m = orMatches[orIdx]
                    var orSectionValue = m.toString().replace('[BEGIN OR]','').replace('[END OR]','');
                    var r = me.validateFwConditions(component, orSectionValue, 'OR');                                        
                    if (r.errors.length > 0) orResult.errors = orResult.errors.concat(r.errors);
                    orResult.result = r.result;                                        
                };
                arrResults.push(orResult);
            }
            
            if ( section.match( regex.AND ) && section.match( regex.AND ).length > 0){
                hasANDValidations = true;
                var andResult = {result:true, errors:[]};
                var andMatches = section.match( regex.AND );
                for(var andIdx =0; andIdx < andMatches.length; andIdx++){                      
                    var m = andMatches[andIdx];
                    var andSectionValue = m.toString().replace('[BEGIN AND]','').replace('[END AND]','');
                    var r = me.validateFwConditions(component, andSectionValue, 'AND');
                    if (r.errors.length > 0) andResult.errors = andResult.errors.concat(r.errors);
                    andResult.result = r.result;
                };                
                arrResults.push(andResult);
            }            
            if (!hasORValidations && !hasANDValidations){
                resultObj.result = false;
                console.error('not found', section);
            }
        }
        
        var upperValidation = true;
        for (var rdx = 0; rdx < arrResults.length; rdx++){
			var r = arrResults[rdx];
            if (r.errors.length > 0) resultObj.errors = resultObj.errors.concat(r.errors);
            if (!r.result) upperValidation = false;
        }
        resultObj.result = upperValidation;
               
        return resultObj;
  	},   
    picklistContains : function (picklistValues, valueToCompareTo){
        var picklistValuesArray = picklistValues? picklistValues.toLowerCase().split(';'): [];
        var found = false;
        for(var i = 0; i<picklistValuesArray.length; i++){
            if(picklistValuesArray[i] == valueToCompareTo.toLowerCase()){
                found = true;
                break;
            }
        }                    
        return found;
    },   
    picklistOtherThan : function (picklistValues, valueToCompareTo){
        var picklistValuesArray = picklistValues? picklistValues.toLowerCase().split(';'): [];
        var found = false;
        for(var i = 0; i<picklistValuesArray.length; i++){
            if(picklistValuesArray[i] != valueToCompareTo.toLowerCase()){
                found = true;
                break;
            }
        }                    
        return found;
    }
    //-------------- END MINI VALIDATION FRAMEWORK ------------------
})