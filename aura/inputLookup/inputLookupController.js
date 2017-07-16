({
    handleInputLookupEvt : function(component, event, helper) {
        var searchString = event.getParam("searchString");        
        helper.tryCatch(function(){            
            var type = component.get('v.type');            
            var search = '*';
            var selectedType = component.get('v.selectedType');
            var searchString = component.get('v.searchString');
            var subType = component.get('v.subType');
            
            if(searchString) search = String(searchString);            
            
            var params= {
                searchString : (searchString || '*'),
                sobjectType : (selectedType || type ),
                sobjectSubType : subType                 
            };
            component.set("v.isLoadingModal", true);
            helper.callServer(component, 'c.getSearchResults', params, function success(result,jsonResult){
                if (jsonResult && jsonResult.success){
                    component.set('v.lookupResult', jsonResult.data.records);
                }else{
                    component.set('v.lookupResult', [] );
                }
            },null,null, function(){
             	component.set("v.isLoadingModal", false);   
            });            
        });
    },
    
    onSearchClickedHandler :function(component, event, helper) {
        helper.tryCatch(function(){
            var e = component.getEvent("inputLookupEvent");
            e.setParams({ searchString : component.get("v.searchString") });
            e.fire();            
            if(!component.get("v.isShowModal")) component.set("v.isShowModal", true);
        },null,'onSearchClickedHandler');
    },
    
    onClearClickedHandle : function(component, event, helper){
        component.set('v.value', null);
    },
    
    initTypeAhead : function(component, event, helper){        
        helper.tryCatch(function(){            
            console.info("initTypeAhead - event.getParam()", event);
            console.log("inputLookupController.js - initTypeAhead", component, event, helper);
            
            var type = component.get('v.type');
            var value = component.get('v.value');
            console.log("init value:",value);
            
            helper.callServer(component, 'c.getLookupRecord', { recordId:value }, function(result, jsonResult){                
                helper.tryCatch(function(){
                    if(jsonResult && jsonResult.success){
                         console.log('v.searchString value init',component.get('v.searchString'));
                        console.debug("c.getLookupRecord - RESULTS", jsonResult);
                        component.set('v.recordDisplay', jsonResult.data?jsonResult.data:null);
                        component.set('v.searchString', jsonResult.data? jsonResult.data.value:null);
                        if (jsonResult.data){
                            component.set('v.selectedType', jsonResult.data.sobjectName);
                        }
                    }else{
                        component.set('v.recordDisplay', {});
                    }
                });
            });
        });
        
        component.set("v.isLoading", false);
    },

    onAddSelectedHandle : function(component, event, helper){
console.log('onAddSelectedHandle');        
        var itemId = event.target.title;
        var lookupResult = component.get("v.lookupResult");
        
        for(var i = 0; i < lookupResult.length; i++){            
            if(lookupResult[i].id == itemId){
                var value = lookupResult[i].value;
                console.log('onAddSelectedHandle value',value);
                component.set("v.searchString", value);
                console.log('v.searchString value',component.get('v.searchString'));
                console.log('itemid',itemId);
                component.set("v.value", itemId);
                component.set("v.isShowModal", false);
                var value2 = component.get('v.value');
            console.log("value2:",value2);
            }
        }
    },
    
    onConfirmClick : function(component, event, helper){
        component.set("v.isShowModal", false);
        console.info('sup');
    }
})