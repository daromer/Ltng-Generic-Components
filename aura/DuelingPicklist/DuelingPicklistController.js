({
    onInit : function(component, event, helper) {        
        var options = component.get("v.options");
        var value = component.get("v.value");  
        
        var optionsBasedOnValue = value? value.split(';') : [];        
        var restOfOptions = [];
        var availableOptions = [];
        helper.each(options, function(item){
            var idx = optionsBasedOnValue.indexOf( item );
            if (idx < 0 ) {                
                availableOptions.push( helper.clone(item) );
            }
        });
        
        component.set("v.availableOptions", availableOptions);
        component.set("v.selectedOptions", optionsBasedOnValue);
	},
    
    onValueChange : function(component, event, helper){
        helper.tryCatch(function(){
            console.info("DuelingPicklist - onValueChange", event);
            var value = helper.clone( event.getParam('value') );
            var expIndex = component.get('v.expressionIndex'); 
            var index = event.getParam('index');               
            if(expIndex && !index){
                index = expIndex;
            }else if (!expIndex && index){
                expIndex = index;
                component.set('v.expressionIndex', expIndex);
            }
            
            var realValue = (value && index)? value[index]:value;            
            var valueOptions = realValue? realValue.split(';'): [];
            component.set('v.selectedOptions', valueOptions);
            
        });
    },
    
    optionsChangedHandler: function(component, event, helper) {
        helper.tryCatch(function(){
            var options = event.getParam('value')?event.getParam('value'):[];
            var value = component.get("v.value");  
            
            var selectedOptionsAlsoInOptions = [];
            var optionsBasedOnValue = value? value.split(';') : [];                    
            var availableOptions = [];
            
            helper.foreach(options, function(item){
                var idx = optionsBasedOnValue.indexOf( item );
                if (idx < 0 ) availableOptions.push( helper.clone(item) );                
            });
            helper.foreach(optionsBasedOnValue, function(item){
                if (options.indexOf(item) >= 0) selectedOptionsAlsoInOptions.push( optionsBasedOnValue[i] );
            });
            
            component.set("v.availableOptions", availableOptions);
            component.set("v.selectedOptions", selectedOptionsAlsoInOptions);            
        });
    },
    
	leftOptionSelectedHandler : function(component, event, helper) {        
        var selectedValuesLeft = component.get('v.selectedValuesLeft');
        selectedValuesLeft = selectedValuesLeft?selectedValuesLeft:[];
        var currectValue = event.target.innerHTML;
        
        if (selectedValuesLeft.indexOf(currectValue)>=0){
            event.target.setAttribute("aria-selected", false);
            selectedValuesLeft.splice( selectedValuesLeft.indexOf(currectValue), 1 );
        }else{
            event.target.setAttribute("aria-selected", true);
			selectedValuesLeft.push(currectValue);            
        }
        console.info("selectedValuesLeft",selectedValuesLeft);
        component.set('v.selectedValuesLeft', selectedValuesLeft);        
	},
    
    rightOptionSelectedHandler : function(component, event, helper) {
        var selectedValuesRight = component.get('v.selectedValuesRight');
        selectedValuesRight = selectedValuesRight?selectedValuesRight:[];
        var currectValue = event.target.innerHTML;
        
        if (selectedValuesRight.indexOf(currectValue)>=0){
            event.target.setAttribute("aria-selected", false);
            selectedValuesRight.splice( selectedValuesRight.indexOf(currectValue), 1 );
        }else{
            event.target.setAttribute("aria-selected", true);
			selectedValuesRight.push(currectValue);            
        }
        console.info("selectedValuesRight",selectedValuesRight);
        component.set('v.selectedValuesRight', selectedValuesRight);
	},
    
    addToSelectedHandler : function(component, event, helper) { 
        helper.tryCatch(function(){
            var options = component.get("v.options");
            var availableOptions = component.get("v.availableOptions");
            var selectedOptions = component.get("v.selectedOptions");        
            var selectedValuesLeft = component.get("v.selectedValuesLeft");
            var selectedValuesRight = component.get("v.selectedValuesRight");
            
            var listIdxOptions = [];
            
            helper.foreach(selectedValuesLeft,function(left){
                if (options.indexOf(left)>=0){
                    listIdxOptions.push(left);
                }
            });
            
            var resultAvailableOptions = [];
            var resultSelectedOptions = [];
            
            if (selectedValuesLeft.length > 0 && listIdxOptions.length > 0){    
                
                helper.foreach(listIdxOptions,function(item){
                    if ( availableOptions.indexOf(item)>= 0 ) availableOptions.splice(availableOptions.indexOf(item), 1);
                    if( selectedOptions.indexOf(item) < 0) selectedOptions.push( item );
                });
                
                helper.foreach(availableOptions, function(item){ if (item && item != null) resultAvailableOptions.push( helper.clone(item) ) });
                helper.foreach(selectedOptions, function(item){ if (item && item != null) resultSelectedOptions.push( helper.clone(item) ) });
                
                
                console.debug("resultAvailableOptions", resultAvailableOptions);
                console.debug("resultSelectedOptions", resultSelectedOptions);
                
                component.set("v.availableOptions", resultAvailableOptions);
                component.set("v.selectedOptions", resultSelectedOptions);  
                component.set("v.selectedValuesLeft", []);
                component.set("v.selectedValuesRight", []);
            }  
        });
    },
    
    removeFromSelectedHandler : function(component, event, helper) {		
        helper.tryCatch(function(){
            var options = component.get("v.options");
            var availableOptions = component.get("v.availableOptions");
            var selectedOptions = component.get("v.selectedOptions");        
            var selectedValuesLeft = component.get("v.selectedValuesLeft");
            var selectedValuesRight = component.get("v.selectedValuesRight");
            
            var listIdxOptions = [];
            
            helper.foreach(selectedValuesRight,function(right){
                if (options.indexOf(right)>=0){
                    listIdxOptions.push(right);
                }
            });
            
            var resultAvailableOptions = [];
            var resultSelectedOptions = [];
            
            if (selectedValuesRight.length > 0 && listIdxOptions.length > 0){    
                
                helper.foreach(listIdxOptions,function(item){
                    if ( availableOptions.indexOf(item) < 0 ) availableOptions.push(item);
                    if( selectedOptions.indexOf(item) >= 0) selectedOptions.splice(selectedOptions.indexOf(item),1);
                });
                
                helper.foreach(availableOptions, function(item){ if (item && item != null) resultAvailableOptions.push( helper.clone(item) ) });
                helper.foreach(selectedOptions, function(item){ if (item && item != null) resultSelectedOptions.push( helper.clone(item) ) });
                
                
                console.debug("resultAvailableOptions", resultAvailableOptions);
                console.debug("resultSelectedOptions", resultSelectedOptions);
                
                component.set("v.availableOptions", resultAvailableOptions);
                component.set("v.selectedOptions", resultSelectedOptions);  
                component.set("v.selectedValuesLeft", []);
                component.set("v.selectedValuesRight", []);
            }  
        });       
	},
    
    selectedValueChanged : function(component, event, helper){
        console.info("selectedValueChanged	: ", event.getParam('value'));                
    },
    
    selectedOptionsChangedHandler : function(component, event, helper){
        var selectedOptions = helper.clone(event.getParam('value'));
        var value = (selectedOptions && selectedOptions.length > 0)? selectedOptions.join(';'):null;
        console.info("selectedOptionsChangedHandler - value", value);
        var availableOptions = component.get('v.availableOptions');
        helper.each(selectedOptions,function(item){
            if(availableOptions.indexOf(item) >= 0){
                availableOptions.splice(availableOptions.indexOf(item), 1);
            }
        });        
        component.set("v.value",value); 		                
        component.set('v.selectedValuesRight', selectedOptions);
        component.set('v.selectedValuesLeft', availableOptions);
    }
})