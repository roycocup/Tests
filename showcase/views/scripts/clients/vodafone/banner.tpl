<div id="banner">
	<div class="inner">
		<img src="{$banner}" class="logo" />
		
		<div id="userInfo">
			Welcome {$user->getName()} | {$smarty.now|date_format:"%A, %B %e, %Y"}
		</div>
	</div>
</div>