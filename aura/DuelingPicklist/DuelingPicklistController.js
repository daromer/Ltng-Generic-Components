({
	onInit : function(component, event, helper) {
		console.log('onInit');
        var availableOptions = [];
        var originalSetOfOptions= component.get("v.options");
        var grabbedOptions = helper.getCurrentlyGrabbedItemsByUser(component);

        helper.setListBoxOptions();

        helper.foreach(originalSetOfOptions, function(option) {
            if( ! helper.doesArrayContainsValue(grabbedOptions, option) )
                availableOptions.push( helper.clone(option) );
        });

        component.set("v.availableOptions", availableOptions);
        component.set("v.selectedOptions", grabbedOptions);
	},

	originalOptionsChangedHandler: function(component, event, helper) {
        console.log('originalOptionsChangedHandler');
        try {
            var availableOptions = [];
			var selectedOptions = [];

		    var originalSetOfOptions= event.getParam('value') ? event.getParam('value') : [];
      		var grabbedOptions = helper.getCurrentlyGrabbedItemsByUser(component);

			helper.foreach(originalSetOfOptions, function(option) {
				if( ! helper.doesArrayContainsValue(grabbedOptions, option) )
					availableOptions.push( helper.clone(option) );
			});

			helper.foreach(grabbedOptions, function(option) {
				if( helper.doesArrayContainsValue(originalSetOfOptions, option) )
					selectedOptions.push( option );
			});

			component.set("v.availableOptions", availableOptions);
			component.set("v.selectedOptions", selectedOptions);
		}
		catch(e) {
			console.error("Error on originalOptionsChangedHandler:", e);
		}
	},

	grabbingFromAvailableBox : function(component, event, helper) {
 	console.log('grabbingFromAvailableBox');
        if(event.ctrlKey)
			helper.handleCtrlGrab( component, event.target );

        else if( !event.ctrlKey )
            helper.handleSingleGrab( component, event.target );
	},

    grabbingFromSelectedBox : function(component, event, helper) {
		console.log('grabbingFromAvailableBox');
        if(event.ctrlKey)
			helper.handleCtrlGrab( component, event.target );

        else if( !event.ctrlKey )
            helper.handleSingleGrab( component, event.target );
	},

    addToSelectedBoxHandler : function(component, event, helper) {
        console.log('addToSelectedBoxHandler');
        var originalSetOfOptions= component.get("v.options");
        var availableOptions = component.get("v.availableOptions");
        var selectedOptions = component.get("v.selectedOptions");
        var grabbedOptions = component.get("v.grabbedOptions");

        var resultAvailableOptions = [];
        var resultSelectedOptions = [];

        if(  grabbedOptions.length >= 1 && helper.arrayContainsArray(originalSetOfOptions, grabbedOptions) ) {
            if( helper.arrayContainsArray(availableOptions, grabbedOptions) ) {

                helper.removeElementsInMainArrayFromArray(component, availableOptions, grabbedOptions );
                resultAvailableOptions = availableOptions;

               	resultSelectedOptions = helper.concatArrays(selectedOptions, grabbedOptions);

                helper.updateBoxes(component,resultAvailableOptions,resultSelectedOptions);
            }
        }
	},

    removeFromSelectedBoxHandler : function(component, event, helper) {
          console.log('removeFromSelectedBoxHandler');
		var originalSetOfOptions= component.get("v.options");
        var availableOptions = component.get("v.availableOptions");
        var selectedOptions = component.get("v.selectedOptions");
        var grabbedOptions = component.get("v.grabbedOptions");

        var resultAvailableOptions = [];
        var resultSelectedOptions = [];

        if( grabbedOptions.length >= 1 && helper.arrayContainsArray(originalSetOfOptions, grabbedOptions) ) {
            if( helper.arrayContainsArray(selectedOptions, grabbedOptions) ) {

    	        helper.removeElementsInMainArrayFromArray(component, selectedOptions, grabbedOptions);
                resultSelectedOptions = selectedOptions;

                resultAvailableOptions =  helper.concatArrays(availableOptions, grabbedOptions);

                helper.updateBoxes(component,resultAvailableOptions,resultSelectedOptions);
            }
        }
	},

    grabbedOptionChanged : function(component, event, helper) {
           console.log('grabbedOptionChanged');
	},

    selectedOptionsChangedHandler : function(component, event, helper) {
        console.log('selectedOptionsChangedHandler');
        var selectedOptions = event.getParam('value');
		var selectedOptionsAsString = helper.convertArrayToSemicolonSeparatedString(selectedOptions);

         component.set("v.value", selectedOptionsAsString);
    }
})