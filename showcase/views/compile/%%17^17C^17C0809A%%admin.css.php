<?php /* Smarty version 2.6.18, created on 2008-04-29 17:51:01
         compiled from view:css/admin.css */ ?>


<?php echo '

/******************************************************************
*	Globals
*	---------------------------------------------------------------
*	Base global styles to affect raw tags
*******************************************************************/
html,
body
{
	margin: 					8px 0px 10px 0px;
	font-family: 				Verdana, Arial, sans-serif;
	font-size: 					85%;
	color: 						#333333;
}

img
{
	border:						5px solid white;
}

a
{
	text-decoration:			none;
	color:						#000;
}

a:hover
{
	text-decoration:			none;
}

a:visited
{
	color:						#000;
}

/* Form elements */
form,
fieldset
{
	border:						none;
	padding:					0;
	margin:						0;
}

textarea
{
	font-family:				Arial, Helvetica, sans-serif;
}

/*-----------------------------------------------------
	GLOBAL LAYOUT
-------------------------------------------------------*/
#stage,
#banner,
#wrapper,
#main
{
	position: 					relative;
	width: 						750px;
	margin: 					auto;
}

#bodyOuter
{
	position:					relative;
	top:						20px;
	border:						1px solid black;
}

#formDiv
{
	padding:					10px;
}

/*-----------------------------------------------------
	BANNER
-------------------------------------------------------*/

#banner
{
	/*background-color:			red;*/
	height:						70px;
	width:						720px;
	padding:					5px 15px 5px 15px;
	border:						1px solid black;
}

#bannerLogo 
{
	margin-top:					15px;
	float: 						left;
}

#bannerUserInfo
{
	float: 						right;
}

#bannerMenu
{
	position:					relative;
	top:						40px;
	float:						right;
}
/*--------------------------------------
	BODY INNER
---------------------------------------*/
#mainMenu
{	
	font-size:					10pt;
}
#mainMenu a:hover 
{
	color:			lightslategray;
}

'; ?>