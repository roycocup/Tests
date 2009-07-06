<?php /* Smarty version 2.6.18, created on 2008-04-29 17:49:46
         compiled from view:css/vodafone.css */ ?>
/* CSS Document */
<?php echo '
html
{
	background:					url("/images/clients/vodafone/tiled_background.gif");
}

body
{
	margin: 					8px 0px 10px 0px;
	font-family: 				Verdana, Arial, sans-serif;
	font-size: 					70%;
	color: 						#333333;
}

a
{
	color: 						#333333;
}

a:hover
{
	color: 						#ff0000;
}

a *
{
	cursor: 					pointer;
}

ul, ol 
{
	margin: 					0px 0px 10px 0px;
	padding: 					4px 0px 0px 20px;
}
ul li, ol li
{
	padding: 					1px 0px 3px 0px;
}

p
{
	padding: 					0px;
	margin: 					0px 0px 15px 0px;
}

h1
{
	font-size: 					160%;
	margin: 					10px 0px 30px 0px;
}

h2
{
	font-size: 					150%;
	margin: 					10px 0px 26px 0px;
}

h3
{
	font-size: 					140%;
	margin: 					10px 0px 22px 0px;
}

h4
{
	font-size: 					120%;
	margin: 					10px 0px 20px 0px;
}

h5
{
	font-size: 					110%;
	margin: 					10px 0px 18px 0px;
}

h6
{
	font-size: 					100%;
	margin: 					10px 0px 15px 0px;
}

img
{
	border: 					0px;
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
	width: 						772px;
	margin: 					auto;
}

#main,
#banner,
#footer
{
	background:					#FFFFFF;
}

#banner
{
	position:					absolute;
	top:						0;
	left:						0;
	height:						74px;
	background:					#FFFFFF url(\'/images/clients/vodafone/top_strip.gif\') no-repeat top left;
}

#footer
{
	background:					#FFFFFF url(\'/images/clients/vodafone/top_strip.gif\') no-repeat top left;
	margin:						9px 0 -9px 0;
	font-size:					90%;
}

#wrapper
{
	padding:					74px 0 0 0;
	margin:						0 0 0 0;
	background:					url(\'/images/clients/vodafone/bottom_strip.gif\') no-repeat bottom left;
	border-bottom:				1px solid #FFF;
	*border-bottom:				none;
}

#main
{
	overflow:					hidden;
	background:					#FFFFFF url(\'/images/clients/vodafone/bottom_strip.gif\') no-repeat bottom left;
}

/*-----------------------------------------------------
	COMMON
-------------------------------------------------------*/
.inner
{
	margin:						5px;
}

#title
{
	text-align:					center;
}

.bg_324
{
	background:					#FFFFFF url(\'/images/clients/vodafone/background_324.gif\') no-repeat top left;
	padding:					10px 10px 0 10px;
}

.bg_554
{
	position:					relative;
	background:					url("/images/clients/vodafone/background_554.gif") no-repeat top left;
	padding:					10px 10px 0 10px;
	margin:						0 0 10px 0;
	overflow:					hidden;
	_height:					1%;
}

.icon_tv,
.icon_documents,
.icon_radio,
.icon_online,
.icon_word
{
	display:					block;
	background:					#FFFFFF url(\'/images/icons/tv.gif\') no-repeat top left;
	padding:					5px 0 5px 25px;
	margin:						5px 0 0 0;
}

.icon_word
{
	background:					#FFFFFF url(\'/images/icons/chatplan_icon.gif\') no-repeat top left;
	padding:					10px 0 5px 35px;
}

.icon_documents
{
	background:					#FFFFFF url(\'/images/icons/documents.gif\') no-repeat top left;
}

.icon_radio
{
	background:					#FFFFFF url(\'/images/icons/radio.gif\') no-repeat top left;
}

.icon_online
{
	background:					#FFFFFF url(\'/images/icons/online.gif\') no-repeat top left;
}

.marginBottom
{
	margin-bottom:				10px !important;
}

span.animateControl,
.heading span.animateControl
{
	color:						#F00;
	float:						left;
	width:						15px;
	cursor:						pointer;
	font-size:					110%;
	font-weight:				bolder;
	display:					inline;
	text-align:					center;
}

.heading span.animateControl
{
	_font-size:					100%;
	_position:					relative;
	_border-top:				2px solid #F00;
	_border-bottom:				1px dotted #B2B2B2;
	_background:				#f2f7fa;
	_padding:					6px 0;
	_margin:					-8px 0 0 -5px;
}

/*-----------------------------------------------------
	BANNER
-------------------------------------------------------*/
#banner img.logo
{
	margin:						13px 0 0 10px;
}

#banner #userInfo
{
	position:					absolute;
	right:						15px;
	top:						7px;
}

/*-----------------------------------------------------
	FOOTER
-------------------------------------------------------*/
#footer ul,
#footer li
{
	list-style:					none;
	margin-left:				0;
	padding-left:				0;
}


/*-----------------------------------------------------
	MAIN.TPL
-------------------------------------------------------*/
#left
{
	position:					relative;
	overflow:					hidden;
	float:						left;
	display:					inline;
	width:						211px;
	margin:						0;
	padding:					0 0 140px 0;
	background:					url("/images/clients/vodafone/bottom_fade.jpg") no-repeat bottom;
}

#body
{
	position:					relative;
	float:						left;
	width:						554px;
	margin:						0 5px 0 2px;
	display:					inline;
	overflow:					hidden;
}

/*-----------------------------------------------------
	NAV.TPL
-------------------------------------------------------*/
#left #header
{
	background:					url("/images/clients/vodafone/navigation_end.gif") no-repeat top right;
	font-size:					1px;
}

#left #navigation
{
	background:					url("/images/clients/vodafone/navigation_bg.gif") repeat-y top;
}

#left #navigation ul,
#left #navigation li
{
	list-style:					none;
	margin:						0;
	padding:					0;
}

#left #navigation li
{
	margin:						0;
}

#left #navigation li div,
#left #navigation li a
{
	position:					relative;
	display:					block;
	height:						17px;
	margin:						0 5px;
	padding:					5px 0 0 7px;
	text-decoration:			none;
}

#left #navigation li a
{
	background:					url("/images/clients/vodafone/dots.gif") repeat-x top left;
}

#left #navigation li.top a
{
	background:					none;
}

#left #navigation li div
{
	background:					url("/images/clients/vodafone/rollover_gradient.gif") repeat-x top left;
	font-weight:				bold;
}

#left #navigation ul li ul li a
{
	padding:					5px 0 0 17px;
	text-decoration:			none;
}

/*-----------------------------------------------------
	TABS
-------------------------------------------------------*/
ul.tabs,
ul.tabs li
{
	position:					relative;
	padding:					0;
	margin:						0;
	overflow:					hidden;
	_height:					1%;
	z-index:					2;
}

ul.tabs
{
	margin: 					0 0 -3px 10px;
}

.contentBox ul.tabs
{
	margin: 					0 0 0 10px;
}

ul.tabs li
{
	position:					relative;
	float:						left;
	display: 					inline;
	list-style: 				none;
	background: 				url("/images/clients/vodafone/tab_off_left.gif") no-repeat;
}

ul.tabs li a
{
	display:					block;
	padding:					3px 10px 3px 6px;
	background: 				url("/images/clients/vodafone/tab_off_right.gif") no-repeat top right;
	text-decoration: 			none;
}

ul.tabs li.on
{
	background-image: 			url("/images/clients/vodafone/tab_on_left.gif");
}

ul.tabs li.on a
{
	background-image: 			url("/images/clients/vodafone/tab_on_right.gif");
	color: 						#ff0000;
}

/*-----------------------------------------------------
	CAMPAIGN
-------------------------------------------------------*/
.jobs
{
	position:					relative;
	background:					url("/images/clients/vodafone/background_554.gif") no-repeat top left;
	padding:					5px 10px 0 10px;
	margin:						0 0 10px 0;
	overflow:					hidden;
	_height:					1%;
}

.jobs h4
{
	margin:						0;
	padding:					10px 0 15px 0;
}

#phases h4 a
{
	text-decoration:			none;
}

.jobs h4 a
{
	color:						#ff0000;
	text-decoration:			none;
}

#phases h4 a:hover,
.jobs h4 a:hover
{
	text-decoration:			underline;
}

.jobs .leftCol
{
	position:					relative;
	float:						left;
	width:						210px;
}

.jobs .rightCol
{
	position:					relative;
	float:						left;
	width:						324px;
	overflow:					hidden;
}

.jobs .leftCol_reversed
{
	position:					relative;
	float:						left;
	width:						324px;
}

.jobs .rightCol_reversed
{
	position:					relative;
	float:						left;
	width:						205px;
	overflow:					hidden;
	margin-left:				5px;
}

.contentBox
{
	margin:						0 0 10px 0;
}

.contentBox .heading
{
	position:					relative;
	border-top:					2px solid #F00;
	border-bottom:				1px dotted #B2B2B2;
	background:					#f2f7fa;
	padding:					6px 5px;
	font-weight:				bold;
}

.contentBox .content
{
	position:					relative;
	border-bottom:				1px dotted #B2B2B2;
	background:					#FFF;
	padding:					5px;
	overflow:					hidden;
	_height:					1%;
}

.contentBox .content .specs
{
	position:					relative;
	overflow:					hidden;
	_height:					1%;
	margin:						0 0 3px 0;
}

.contentBox .content .key
{
	float:						left;
	width:						121px;
	border-bottom:				1px dotted #C5C5C5;
	margin:						0 3px 0 0;
	padding:					3px 5px 3px 0;
	font-weight:				bold;
}

.contentBox .content .value
{
	position:					relative;
	float:						left;
	width:						160px;
	padding:					3px 5px 3px 0;
	border-bottom:				1px dotted #C5C5C5;
}

.valueCats
{
	position:					relative;
	top:						-18px;
	float:						right;
}
.contentBox .content a.details
{
	position:					relative;
	display:					block;
	background:					url("/images/clients/vodafone/btn_grey.gif") no-repeat right;
	padding:					1px 17px 1px 0;
	width:						109px;
}

.leftCol_reversed ul,
.leftCol_reversed li,
.rightCol_reversed ul,
.rightCol_reversed li,
.jobs .leftCol ul,
.jobs .leftCol li
{
	position:					relative;
	list-style:					none;
	margin:						10px 10px 0 0;
	padding:					0;
}

.rightCol_reversed ul,
.rightCol_reversed li,
{
	list-style:					none;
	margin:						0;
	padding:					0;
}

.leftCol_reversed li.first,
.rightCol_reversed li.first,
.jobs .leftCol li.first
{
	border-top:					1px dotted #C5C5C5;
}

.leftCol_reversed li,
.rightCol_reversed li,
.jobs .leftCol li
{
	display:					block;
	border-bottom:				1px dotted #C5C5C5;
	margin:						0 0 0 0;
	padding:					3px 0;
}

.leftCol_reversed li a,
.rightCol_reversed li a,
.jobs .leftCol li a
{
	display:					block;
	background:					url("/images/clients/vodafone/btn_grey.gif") no-repeat right;
	text-decoration:			none;
}

.media_container
{
	position:					relative;
	overflow:					hidden;
	_height:					1%;
	margin:						0 0 5px 0;
}

.media_name
{
	float:						left;
	width:						350px;
}

.media_filesize
{
	float:						right;
	width:						125px;
}

.media_name
{
	margin:						0 0 5px 0;
}


.media_description
{
	margin:						0 0 5px 0;
	clear:						both;
}

.media_links
{
	position:					relative;
	overflow:					hidden;
	_height:					1%;
}

.media_links a
{
	position:					relative;
	float:						left;
	background:					url("/images/clients/vodafone/btn_red_long.gif") no-repeat top left;
	width:						90px;
	color:						#FFF;
	text-align:					center;
	font-size:					10px;
	text-decoration:			none;
	font-weight:				bold;
	height:						14px;
	margin:						0 5px 0 0;
}

.media_links a:hover
{
	color:						#FFF;
}

.media .icon_tv,
.media .icon_documents,
.media .icon_radio,
.media .icon_online,
.media .icon_word
{
	padding:					0 0 0 30px;
	margin:						0 0 0 0;
}

'; ?>