({
	afterScriptsLoaded : function(component, event, helper) {
        
        console.log("LC_JqueryTestLocker_Controller.afterScriptsLoaded: entered");
        

        helper.getContacts(component);
        
        	var d = document;
        	//$(".demo").text("Helloe from Jquery inside of LS");

        $('#box').keyup(function(){
		   var valThis = $(this).val().toLowerCase();
		    if(valThis == ""){
		        $('.myList > li').show();           
		    } else {
		        $('.myList > li').each(function(){
		            var text = $(this).text().toLowerCase();
		            (text.indexOf(valThis) >= 0) ? $(this).show() : $(this).hide();
		        });
		   };
		});
        

        console.log("LC_JqueryTestLocker_Controller.afterScriptsLoaded: exit");
        
	}
})