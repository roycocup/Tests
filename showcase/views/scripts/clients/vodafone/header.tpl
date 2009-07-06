<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	{foreach from=$metaTags item=metaType name=metaTypes}
		{foreach from=$metaType item=meta name=metaTags}
		<meta {$meta->type}="{$meta->name}" content="{$meta->content}" />
		{/foreach}
	{/foreach}
	<title>{$pageTitle}</title>
	
	<script src="/javascript/scriptaculous_181/prototype.js" type="text/javascript"></script>
	<script src="/javascript/scriptaculous_181/scriptaculous.js?load=effects" type="text/javascript"></script>
	<script src="/javascript/animate.js" type="text/javascript"></script>

	<link href="/include/css/vodafone" rel="stylesheet" type="text/css" />
</head>
