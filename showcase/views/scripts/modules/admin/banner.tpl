<div id="banner">
		<div id="bannerLogo">
			<img src="/images/admin/m4dcLogo.jpg"  />
		</div>
		<div id="bannerUserInfo">
			Welcome {$user->getName()} | {$smarty.now|date_format:"%A, %B %e, %Y"}
		</div>
		<div id="bannerMenu">
			{foreach name=mainMenu from=$mainMenu item=item}
				{if !$smarty.foreach.mainMenu.first} | {/if}
					<a href="/admin{$item.url}">{$item.print}</a>
			{/foreach}
		</div>
</div>