({
    data : null,
    sldsListBoxOptions : null,
    markedOptions: null,

    doesArrayContainsValue : function(array, value) {
        try {
            return array.indexOf(value) >= 0;
        }
        catch(e) {
            console.error('Error occured while trying to find value in array: ', e);
        }
    },

    removeElementFromArray : function(component, array, element) {
		array.splice( array.indexOf(element), component.get('v.QUANTITY_OF_ELEMENTS_REMOVED_EACH_TIME') );
	},

    removeElementsInMainArrayFromArray : function(component, mainArray, array) {
        array.forEach( function(a){
        	this.data = {};
            this.data.position = mainArray.indexOf(a);
			this.data.isContained = this.data.position >= 0;

			if( this.data.isContained )
            	mainArray.splice( this.data.position, component.get('v.QUANTITY_OF_ELEMENTS_REMOVED_EACH_TIME') );
		});
	},

	convertArrayToSemicolonSeparatedString : function(array) {
		return (array  && array.length > 0) ? array.join(';') : null;
	},

	concatArrays : function(array1, array2) {
        var  tempArray1;
        var  tempArray2;

        if( Array.isArray(array1) === false ) {
          tempArray1 = new Array();
          tempArray1.push(array1);
        }
        else
            tempArray1 = array1;

       if( Array.isArray(array2) === false ) {
          tempArray2 = new Array();
          tempArray2.push(array2);
        }
         else
            tempArray2 = array2;

		return tempArray1.concat(tempArray2);
	},

	updateBoxes : function(component,availableOptionsBox, selectedOptionsBox) {
        component.set("v.availableOptions", availableOptionsBox);
        component.set("v.selectedOptions", selectedOptionsBox);
        component.set("v.grabbedOptions", [] );
	},

    getCurrentlyGrabbedItemsByUser: function(component) {
        var grabbedItems = component.get("v.value");
		var grabbedItemsAsArray = grabbedItems ? grabbedItems.split(';') : [];
        return grabbedItemsAsArray;
    },
	handleGrab : function(component, event) {
        var grabbedOptions = component.get("v.grabbedOptions");
        var lastGrab = event.target.innerHTML;

        if(event.ctrlKey) {
            if (! helper.doesArrayContainsValue(grabbedOptions, lastGrab) )
            	grabbedOptions.push( lastGrab );
            else
                helper.removeElementFromArray(grabbedOptions, lastGrab);

            component.set("v.grabbedOptions", grabbedOptions);
        }
        else if( !event.ctrlKey )
       		component.set("v.grabbedOptions", lastGrab);
	},
	handleCtrlGrab : function(component, target) {
        var grabbedOptions = component.get("v.grabbedOptions");
        var lastGrab = target.innerHTML;

        if (! this.doesArrayContainsValue(grabbedOptions, lastGrab) ) {
            grabbedOptions.push( lastGrab );
            target.setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), true );
        }
        else {
            this.removeElementFromArray(component, grabbedOptions, lastGrab);
            target.setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), false );
        }
        component.set("v.grabbedOptions", grabbedOptions);
	},
	handleSingleGrab: function( component, target  ) {
        var lastGrab = target.innerHTML;

        this.MarkClickedElementOnly_NodeList_Impl( component, target );
        component.set("v.grabbedOptions", lastGrab);
    },


    setListBoxOptions: function() {
        this.sldsListBoxOptions = document.getElementsByClassName('slds-listbox__option');
	},
	MarkClickedElementOnly_HTMLCollection_Impl : function(component, target ) {
       	for (var i = 0; i < this.sldsListBoxOptions.length; i++)
				this.sldsListBoxOptions[i].setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), false);

		target.setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), true );
	},

	MarkClickedElementOnly_NodeList_Impl : function(component, target ) {

    	this.markedOptions = document.querySelectorAll( component.get('v.UI_OPTIONS_WHICH_ARE_SELECTED') );

        Array.from(this.markedOptions)
        .forEach( function(opt){
            opt.setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), false )
        });

		target.setAttribute( component.get('v.UI_SELECTED_OPTION_ATTRIBUTE'), true );
	}
})