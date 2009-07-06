<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		{foreach from=$metaTags item=metaType name=metaTypes}
			{foreach from=$metaType item=meta name=metaTags}
			<meta {$meta->type}="{$meta->name}" content="{$meta->content}" />
			{/foreach}
		{/foreach}
		<title>Login</title>
		
		<link href="http://www.markettiers4dc.com/assets/css/markettiers4dc.css" rel="stylesheet" type="text/css">
		
		{literal}
		
		<script language="JavaScript">
		<!--
		// PRELOADING IMAGES
		if (document.images) {
		
			 pr_award_over =new Image();  pr_award_over.src ="http://www.markettiers4dc.com/assets/images/common/prweek_award_color.jpg"; 
			 pr_award_off=new Image();  pr_award_off.src="http://www.markettiers4dc.com/assets/images/common/prweek_award_grey.jpg"; 
		
			 cipr_over =new Image();  cipr_over.src ="http://www.markettiers4dc.com/assets/images/common/cipr_color.jpg"; 
			 cipr_off=new Image();  cipr_off.src="http://www.markettiers4dc.com/assets/images/common/cipr_grey.jpg"; 
			 
			 iab_over =new Image();  iab_over.src ="http://www.markettiers4dc.com/assets/images/common/iab_color.jpg"; 
			 iab_off=new Image();  iab_off.src="http://www.markettiers4dc.com/assets/images/common/iab_grey.jpg"; 
			 
			 prca_over =new Image();  prca_over.src ="http://www.markettiers4dc.com/assets/images/common/prca_color.jpg"; 
			 prca_off=new Image();  prca_off.src="http://www.markettiers4dc.com/assets/images/common/prca_grey.jpg"; 
			 
			 prweek_over =new Image();  prweek_over.src ="http://www.markettiers4dc.com/assets/images/common/prweek_color.jpg"; 
			 prweek_off=new Image();  prweek_off.src="http://www.markettiers4dc.com/assets/images/common/prweek_grey.jpg"; 
		}
		
		// Pr Week Awards Image Rollover
		
		function prweek_awardOver() { 
			if (document.images) document.imgAwards.src=pr_award_over.src;
		}
		
		function prweek_awardOut() {
			if (document.images) document.imgAwards.src=pr_award_off.src;
		}
		
		
		
		// CIPR Image Rollover
		
		function ciprOver() { 
			if (document.images) document.imgCipr.src=cipr_over.src;
		}
		
		function ciprOut() {
			if (document.images) document.imgCipr.src=cipr_off.src;
		}
		
		
		// IAB Image Rollover
		
		function iabOver() { 
			if (document.images) document.imgIab.src=iab_over.src;
		}
		
		function iabOut() {
				if (document.images) document.imgIab.src=iab_off.src;
		}
		
		
		// PRCA Image Rollover
		
		function prcaOver() { 
			if (document.images) document.imgPrca.src=prca_over.src;
		}
		
		function prcaOut() {
				if (document.images) document.imgPrca.src=prca_off.src;
		}
		
		
		// PRWEEK Image Rollover
		
		function prweekOver() { 
			if (document.images) document.imgPrweek.src=prweek_over.src;
		}
		
		function prweekOut() {
				if (document.images) document.imgPrweek.src=prweek_off.src;
		}
		//-->
		</script>
		
		
		
		
		
		
		<style>
			
			label
			{
				font-size:					1em;
				font-weight:				bold;
				display:					block;
				float:						left;
				clear:						both;
				width:						90px;
				margin-right: 				10px;
				text-align:					right;
				margin-bottom: 				3px;
			}
			
			form input
			{
				background-color:			#FFFFFF !important;
				border:						1px solid #000000;
				width:						200px;
				margin-bottom: 				3px;
			}
			
			#exceptions
			{
				position:					relative;
				width:						195px;
				color:						#F00;
				margin:						0 0 0 100px;
				border-top:					1px dotted #8899A9;
				border-bottom:				1px dotted #8899A9;
				padding:					5px;
			}
		</style>
		{/literal}
		
	</head>
	<body>
	
	
	
<div id="stage">
  <div id="topNav" class="nav"> <a href="http://www.markettiers4dc.com/index.html"><img src="http://www.markettiers4dc.com/assets/images/common/logo.gif" alt="markettiers4dc" border="0" id="logo" /></a>
      <ul id="navBar">
        <li><a href="http://www.markettiers4dc.com/news25.html"><img src="http://www.markettiers4dc.com/assets/images/common/news.gif" alt="news" border="0" /></a></li>
        <li><a href="http://blog.markettiers4dc.com/"><img src="http://www.markettiers4dc.com/assets/images/common/blog.gif" alt="blog" /></a></li>
        <li><a href="http://www.markettiers4dc.com/work.html"><img src="http://www.markettiers4dc.com/assets/images/common/work.gif" alt="work" border="0" /></a></li>
        <li><a href="http://www.markettiers4dc.com/workshops.html"><img src="http://www.markettiers4dc.com/assets/images/common/workshop.gif" alt="workshops" /></a></li>
        <li><a href="http://www.markettiers4dc.com/about.html"><img src="http://www.markettiers4dc.com/assets/images/common/about.gif" alt="about" /></a></li>
        <li><a href="http://www.markettiers4dc.com/recruitment.html"><img src="http://www.markettiers4dc.com/assets/images/common/recruitment.gif" alt="about" /></a></li>
        <!-- <li><a href="http://www.markettiers4dc.com/location.html"><img src="http://www.markettiers4dc.com/assets/images/common/location.gif" alt="location" /></a></li> -->
        <li><a href="http://www.markettiers4dc.com/contact.html"><img src="http://www.markettiers4dc.com/assets/images/common/contact_nav.gif" alt="contact" /></a></li>
      </ul>
  </div>
  <div id="content">
  
  				<div id="header">
		  			<img src="/images/title_login.gif" alt="Login" />
				</div>
  
  
				{if isset($exceptions)}
				<div id="exceptions">
					{foreach from=$exceptions item=exception name=exceptions}
						{$exception}
					{/foreach}
				</div>
				{/if}

				{form id="loginForm" name="loginForm"}
					<div>
						<label for="login[alias]">Username</label>
						<input type="text" name="login[alias]" />	
					</div>
					
					<div>
						<label for="login[pass]">Password</label>
						<input type="password" name="login[pass]" />
					</div>
					
					<div>
						<label>&nbsp;</label>
						<input type="submit" value="Login" id="submit" name="submit" />
					</div>
				{/form}
  
  
  
  
  
  
  
  
  
  
  
  
  
      <div class="clearContent"></div>
  </div>
  
  <div class="bottomNav_02"> 
  		<img src="http://www.markettiers4dc.com/assets/images/common/left_side_banner.png" class="floatLeft left_10" style="margin-left:10px;" alt="" />
      <div class="bottomNavBanner">
        <div class="relative"> 
			<img src="http://www.markettiers4dc.com/assets/images/common/winner_broadcast.png" class="floatLeft" style="margin-left:10px; margin-top:12px;" alt="" /> 
			<a href="http://www.markettiers4dc.com/news21.html" onMouseOver="prweek_awardOver();" onMouseOut="prweek_awardOut();"><img name="imgAwards" border=0 src="http://www.markettiers4dc.com/assets/images/common/prweek_award_grey.jpg" class="floatLeft" style="margin-top:12px; margin-left:12px;"></a>
			<img src="http://www.markettiers4dc.com/assets/images/common/line_break.jpg" style="float:left; margin-top:8px; margin-left:12px;"><img src="http://www.markettiers4dc.com/assets/images/common/podcast_partner.png" class="floatLeft" style="margin-left:10px; margin-top:12px;" alt="" />
  	 		<a href="http://www.iabuk.net" onMouseOver="iabOver();" onMouseOut="iabOut();" target="_blank"><img name="imgIab" border=0 src="http://www.markettiers4dc.com/assets/images/common/iab_grey.jpg" class="floatLeft" style="margin-top:7px; margin-left:15px;"></a>			
			<a href="http://www.prweek.com/uk" onMouseOver="prweekOver();" onMouseOut="prweekOut();" target="_blank"><img name="imgPrweek" border=0 src="http://www.markettiers4dc.com/assets/images/common/prweek_grey.jpg" class="floatLeft" style="margin-top:17px; margin-left:15px;"></a>
			<img src="http://www.markettiers4dc.com/assets/images/common/line_break.jpg" style="float:left; margin-top:8px; margin-left:12px;">
			<img src="http://www.markettiers4dc.com/assets/images/common/prefered_supplier.png" class="floatLeft" style="margin-left:10px; margin-top:12px;" alt="" />
			<a href="http://www.prca.org.uk" onMouseOver="prcaOver();" onMouseOut="prcaOut();" target="_blank"><img name="imgPrca"  border=0 src="http://www.markettiers4dc.com/assets/images/common/prca_grey.jpg" class="floatLeft" style="margin-top:10px; margin-left:12px;"></a>
			<img src="http://www.markettiers4dc.com/assets/images/common/line_break.jpg" style="float:left; margin-top:8px; margin-left:10px;">
			<img src="http://www.markettiers4dc.com/assets/images/common/partner.png" class="floatLeft" style="margin-left:10px; margin-top:20px;" alt="" />
			<a href="http://www.ipr.org.uk" onMouseOver="ciprOver();" onMouseOut="ciprOut();" target="_blank"><img name="imgCipr" border=0 src="http://www.markettiers4dc.com/assets/images/common/cipr_grey.jpg" class="floatLeft" style="margin-top:14px; margin-left:12px;"></a>
			
		</div>
	  </div>
    <img src="http://www.markettiers4dc.com/assets/images/common/right_side_banner.png" class="floatLeft" alt="" /> 
	</div>
	
  <div id="bottomNav" class="nav">
    <div id="bottomNavBar">
      <ul id="bottomNavBarLeftLinks">
        <!-- <li><a href="showreel.html" title="Showreel"><img src="http://www.markettiers4dc.com/assets/images/common/showreel.gif" alt="showreel" /></a></li> -->
        <li><a href="http://www.markettiers4dc.com/newsletter.html" title="Newsletter"><img src="http://www.markettiers4dc.com/assets/images/common/newsletter.gif" alt="newsletter" /></a></li>
        <!-- <li><a href="sitemap.html" title="Site Map"><img src="http://www.markettiers4dc.com/assets/images/common/sitemap.gif" alt="sitemap" /></a></li>
			<li><a href="contact.html" title="Contact"><img src="http://www.markettiers4dc.com/assets/images/common/contact.gif" alt="contact" /></a></li> -->
        <li><a href="http://www.markettiers4dc.com/links.html" title="Links"><img src="http://www.markettiers4dc.com/assets/images/common/links.gif" alt="links" /></a></li>
        <!--<li><a href="http://www.prca.org.uk" target="_blank"><img src="http://www.markettiers4dc.com/assets/images/common/prca_preferredsupplier_logo.gif" alt="PRCA Business Affiliate" /></a></li>-->
      </ul>
      <div id="bottomNavBarcontent"><a href="http://www.markettiers4dc.com/terms.html">Terms of use</a>&nbsp;|&nbsp;<a href="http://www.markettiers4dc.com/privacy.html">Privacy Policy</a>&nbsp;|&nbsp;Copyright &copy; 2008 markettiers4dc</div>
      <img src="http://www.markettiers4dc.com/assets/images/common/navbar_bottom_left.gif" class="bottomNavLeftCurves"> <img src="http://www.markettiers4dc.com/assets/images/common/navbar_bottom_right.gif" class="bottomNavRightCurves"> </div>
    <div id="bottomNavFill"> </div>
    <img src="http://www.markettiers4dc.com/assets/images/common/nav_bottom_left.png" class="bottomNavLeftCurves"> <img src="http://www.markettiers4dc.com/assets/images/common/nav_bottom_right.png" class="bottomNavRightCurves"> </div>
  <div id="regulations"> <strong>Markettiers4dc Ltd</strong>&nbsp;&nbsp; <strong>Registered  office:</strong> Northburgh House, 10a Northburgh Street, London, EC1V 0AT<br>
      <strong>Registered in England &amp; Wales No.</strong> 4308785&nbsp;&nbsp; <strong>VAT number</strong> 783 037 913
    <div class="marginTop"><a href="http://www.prca.org.uk" target="_blank" style="color:#FFF;">PRCA</a> Business Affiliate, <a href="http://www.ipr.org.uk/" target="_blank" style="color:#FFF;">CIPR</a> Partner, ISO 9001:2000 registered (Certificate  Number GB7041)</div>
  </div>
</div>	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	</body>
</html>