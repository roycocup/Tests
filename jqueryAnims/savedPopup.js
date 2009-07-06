var popupStatus = 0;

function loadPopup(){  
	//loads popup only if it is disabled  
	if(popupStatus==0){  
		$("#popupSaved").css({  
			"opacity": "0.7"  
		});    
		$("#popupSaved").fadeIn("slow");  
		popupStatus = 1;  
	}  
	setTimeout("disablePopup()", 3000);
	clearTimeout();
	
}  

//disabling popup with jQuery magic!  
function disablePopup(){  
	//disables popup only if it is enabled  
	if(popupStatus==1){   
		$("#popupSaved").fadeOut("slow");  
		popupStatus = 0;  
	}  
}


function centerPopup(){  
//request data for centering  
var windowWidth = document.documentElement.clientWidth;  
var windowHeight = document.documentElement.clientHeight;  
var popupHeight = $("#popupContact").height();  
var popupWidth = $("#popupContact").width();  
//centering  
$("#popupContact").css({  
"position": "absolute",  
"top": windowHeight/2-popupHeight/2,  
"left": windowWidth/2-popupWidth/2  
});  
//only need force for IE6  
  
$("#backgroundPopup").css({  
"height": windowHeight  
});  
}  

