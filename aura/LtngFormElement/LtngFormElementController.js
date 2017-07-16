({
    onInit : function onInit(component, event, helper) {    
        
        helper.tryCatch(function(){
            var logger = helper.logger(component);
            var metadata = component.get('v.metadata');
            var metadataMainMap = component.get('v.metadataMainMap');
            var getMetadataOnInit = component.get("v.getMetadataOnInit");
            var strictModeOn = component.get('v.strictModeOn');
            var fieldName = component.get('v.fieldName');
            
            /*if ( metadataMainMap && fieldName && (Object.getOwnPropertyNames(metadataMainMap).indexOf(fieldName)>=0) ){
                metadata = metadataMainMap[fieldName];
            }*/
            
            logger.info('LtngFormElement - onInit', component, event)
            
            if(!strictModeOn){
                if (getMetadataOnInit){
                    helper.getMetadataMapFromServer(component, helper, function getMetadataMapFromServerCallback(retrievedMetadata){
                        helper.tryCatch(function(){
                            var value = component.get('v.controllerFieldValue');
                            var oldValue = null;
                            helper.processDependentPicklistValues(component, value, oldValue, helper.clone(retrievedMetadata.DependencyMap), helper);                            
                        });
                    });
                }else if( metadata ){                                    
                    var clonedDependencyMap = helper.clone(metadata.DependencyMap);
                    if (clonedDependencyMap && metadata.isDependentPicklist){
                        component.set('v.dependencyMap', clonedDependencyMap );
                        var value = component.get('v.controllerFieldValue');
                        var oldValue = null;
                        helper.processDependentPicklistValues(component, value, oldValue, clonedDependencyMap , helper);
                    }else if (metadata && metadata.PicklistValues){
                        component.set('v.options', metadata.PicklistValues);
                    }
                    //validationPart();
                }else if(metadata && metadata.PicklistValues){                
                    component.set('v.options', metadata.PicklistValues);                
                }
            }else{
                if (getMetadataOnInit){
                    helper.getMetadataMapFromServer(component, helper, function getMetadataMapFromServerCallback(retrievedMetadata){                        
                        helper.tryCatch(function(){
                            helper.initializeMetadata(component, retrievedMetadata, fieldName);                            
                        });
                    });
                }else{
                    helper.initializeMetadata(component, metadata, fieldName);
                }               
            }
        });
        event.stopPropagation();
        
    },
    
	controllerFieldValueChangedHandler : function controllerFieldValueChangedHandler(component, event, helper) {
        helper.tryCatch(function(){
            helper.logger(component).info('controllerFieldValueChangedHandler');
            var value = event.getParams().value;
            var oldValue = event.getParams().oldValue;   
            var dependencyMap = component.get('v.dependencyMap');
            var metadata = component.get('v.metadata');
            if ( dependencyMap ){
                helper.processDependentPicklistValues(component, value, oldValue, helper.clone(dependencyMap), helper);      
            }else if(metadata && metadata.DependencyMap){
                helper.processDependentPicklistValues(component, value, oldValue, helper.clone( metadata.DependencyMap), helper);
            }else{
                helper.logger(component).error("processDependentPicklistValues not started");
            }
        });        
        event.stopPropagation();
	},
    
    metadataChangeHandler : function(component, event, helper){
        helper.tryCatch(function(){
            var metadata = event.getParam('value'); 
            var strictModeOn = component.get('v.strictModeOn');
            var fieldName = component.get('v.fieldName');
            
            if (strictModeOn){
                helper.initializeMetadata(component, metadata, fieldName);
            }else{
                var meta;
                if (metadata){
                    if (typeof(metadata.Type) == 'string'){
                        meta = metadata;
                    }else if(metadata[fieldName] && typeof(metadata[fieldName].Type)=='string'){
                        meta = metadata[fieldName];
                    }else{
                        meta = null;
                    }
                }
                if (meta){
                    if (meta && meta.DependencyMap && meta.DependencyMap.length){
                        var field = component.get('v.sobjectName') + '.' + component.get('v.fieldName');                
                        helper.logger(component).info('Metadata DependencyMap', meta.DependencyMap );                    
                        component.set('v.dependencyMap', meta.DependencyMap);
                    }else if(meta && meta.PicklistValues && meta.PicklistValues.length > 0){                
                        helper.logger(component).info('Metadata DependencyMap ', meta.DependencyMap );
                        component.set("v.options",meta.PicklistValues);
                    }
                }
            }
        });
    },
    
    onValueChangedHandler : function(component, event, helper){
        helper.tryCatch(function(){
            var e = component.getEvent('onValueChanged');
            var param = {
                value : {
                    new : event.getParam('value'),
                    old : event.getParam('oldValue')
                }            
            };
            e.setParams( JSON.parse(JSON.stringify( param )) );
            e.fire();
        });
        helper.startValidation(component, helper);        
        event.stopPropagation();
    },
    
    validationExpressionChangeHandler: function (component, event, helper){
        helper.logger(component).info("validationExpressionChangeHandler");
        var expression = component.get('v.validationExpression');
        helper.startValidation(component, helper);
        //event.stopPropagation();
    }
})