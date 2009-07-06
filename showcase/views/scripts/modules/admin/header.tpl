<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	{foreach from=$metaTags item=metaType name=metaTypes}
		{foreach from=$metaType item=meta name=metaTags}
		<meta {$meta->type}="{$meta->name}" content="{$meta->content}" />
		{/foreach}
	{/foreach}
	<title>{$pageTitle}</title>
	<link href="/include/css/admin" rel="stylesheet" type="text/css" />
	
	<!--calendar style and js-->
	<style type="text/css">@import url(/javascript/jscalendar/calendar-win2k-1.css);</style>
	<script type="text/javascript" src="/javascript/jscalendar/calendar.js"></script>
	<script type="text/javascript" src="/javascript/jscalendar/lang/calendar-en.js"></script>
	<script type="text/javascript" src="/javascript/jscalendar/calendar-setup.js"></script>
	
	<!-- scriptaculous and prototype-->
	<script src="/javascript/scriptaculous_181/prototype.js" type="text/javascript"></script>
	<script src="/javascript/scriptaculous_181/scriptaculous.js?load=effects" type="text/javascript"></script>
	<script src="/javascript/animate.js" type="text/javascript"></script>
	
	<!-- addmore (phases)-->
	<script type="text/javascript" src="/javascript/addFields.js"></script>

	
</head>
