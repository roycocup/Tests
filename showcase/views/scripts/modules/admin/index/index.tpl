<div id="bodyInner">
	{$welcome}<p>
	<div id="mainMenu">
		{foreach name=mainMenu from=$mainMenu item=item}
			<a href="/admin{$item.url}">{$item.print}</a><br>
		{/foreach}
	</div>
</div>