({
	onInit : function(component, event, helper) {
        var type = component.get('v.type');;
        var refTypes = component.get('v.refTypes');
        
        var selectedType = component.get('v.selectedType');
        var selectedTypeToUse = selectedType? selectedType:{value:type, label:type};        
        var refTypesToUse = refTypes? refTypes : [ selectedType ];
        
        component.set('v.refTypes', refTypesToUse);
        component.set("v.selectedType", selectedTypeToUse );
        
        alert("refTypes: " + JSON.stringify(refTypesToUse));        
        alert("selectedType: " + JSON.stringify(selectedTypeToUse));        
        
        var value = component.get('v.value');
        if(value){
            var params = {
                value: value
            };
            helper.callServer(component, 'c.getCurrentValue', params, function(r,json){
                if (json && json.success){
                    var selectedItem = {id:json.data.id, name:json.data.value};
                    console.info("SELECTED VALUE VOUND: ",selectedItem);
                    component.set('v.selectedItem', selectedItem);
                }else if(json){
                    console.error(json.errors);
                }
            });
        }else{
            component.set('v.selectedItem', null);
        }
	},
    
    onSelectedRefTypeClickHandler : function(component, event, helper){
        component.set('v.showSelectType', component.get('v.showSelectType')?false:true);
    },
    
    SelectSearchTypeItemClickHandler : function(component, event, helper){
        var element = event.target?event.target:event.getElement();
        var selectedType = {value:element.dataset.value, label:element.dataset.label};
        alert("SelectSearchTypeItemClickHandler: " + JSON.stringify(selectedType));
        console.info('element', element, element.dataset, selectedType);
        component.set('v.selectedType',selectedType);
        component.set('v.showSelectType', false);
    },
    
    onSelectedItemChanged : function(component, event, helper){
        console.info("onSelectedItemChanged", event)
        var value = event.getParam('value');
        if (value && value.id){
            component.set('v.value', value.id);
        }else{
            component.set('v.value', null);
        }
    },
    
    onRemoveSelectedClickHandler:function(component, event, helper){
        component.set('v.selectedItem', null);
        component.set('v.searchResults', []);
    },
    
    inputLookupSearchEvtHandler : function(component, event, helper){},
    
    inputLookupSearchSelectedEvtHandler :  function(component, event, helper){},
    
    listBoxItemClicked :  function(component, event, helper){
        var dataset = event.target.dataset;
        console.info("listBoxItemClicked",event, dataset.id, dataset.value);
        if (event.target.dataset.id){
            var selectedItem = { id:dataset.id, name:dataset.value };
            console.info('selectedItem', selectedItem);
            component.set('v.selectedItem', selectedItem);
            component.set('v.searchResults', []);
        }
    },
    
    onCloseSearchListClickHandler : function (component, event, helper){        
        component.set('v.searchResults', []);
    },
    
    searchButtonClickedHandler : function(component, event, helper){
		helper.search(component);
    },
    
    searchOnFocusOut:function(component, event, helper){
        console.info('focus out....');
    },
    
    searchOnFocus:function(component, event, helper){
        console.info('focus....');
        component.set('v.searchResults', []);
    },
    
    searchOnKeyUP : function(component, event, helper){        
        //console.info("searchOnKeyUP", event.key, event);
        if (event.key == 'Enter'){
			//console.info("searchOnKeyUP - Enter");            
            helper.search(component);
        }
    },
    
    
    listboxOnMouseOut:function(component, event, helper){
		console.info('listboxOnMouseOut....', event.target.dataset.id);
    }
    
    //getSearchResults
})