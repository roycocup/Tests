<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	{foreach from=$metaTags item=metaType name=metaTypes}
		{foreach from=$metaType item=meta name=metaTags}
		<meta {$meta->type}="{$meta->name}" content="{$meta->content}" />
		{/foreach}
	{/foreach}
	<title>{$pageTitle}</title>
	<link href="/include/css" rel="stylesheet" type="text/css" />
</head>
