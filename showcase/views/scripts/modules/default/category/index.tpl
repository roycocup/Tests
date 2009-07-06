<div id="bodyInner">
<strong>{$smarty.const.JOB_MAIN_NAME}s that include {$jobs.category} media files</strong>
	{if $jobs}
	
		{foreach from=$jobs item=item}
			{if !$item->id}
			{else}
			<div id="jobs">
				<a href="/jobs/{$item->id}">
					<h2>{$smarty.const.JOB_MAIN_NAME}</h2> 
					<h3>{$item->article->title}</h3> <br />
				</a>
					<strong>Published in:</strong> {$item->published->toString("dd.MMMM.yy")} &nbsp; &nbsp; 
					<strong>Job Number: </strong>{$item->number}<br />
					<div id="thumbnail"><img src="{$item->image.MAIN->path}" alt="{$item->item.MAIN->alt}"></div>
					<div id="simpleSpacer"></div>
					<div id="description"><strong>Description: </strong>{$item->article->body}</div>
				
				<div id="simpleSpacer"></div>
				{if $item->content neq null}
					{foreach from=$item->content item=cont}
						<br />
						<a href="/content/{$cont->id}">
						<strong>{$smarty.const.CONTENT_MAIN_NAME}</strong> 
						{$cont->article->title}<br />
						<strong>Categories: </strong>{foreach from=$cont->media item=media} {$media->category->name} {/foreach} <br /> 
						<strong>Published in: </strong>{$cont->published->toString("dd.MMMM.yy")}<br / >
						<strong>Description: </strong>{$cont->article->body} <br />
						</a>
					{/foreach}
				{/if}
				
			{/if}
			</div>
			<br /><br />
		{/foreach}
		{assign var='limit' value=$jobs.limit}
		{assign var='rows' value=$jobs.totalrows}
		offset: {$offset}<br>
		rows: {$rows}<br>
		limit: {$limit}<br>
		
		{pager rowcount=$rows limit=$limit posvar='pages' pos=$offset}
		
	{/if}
	
</div>