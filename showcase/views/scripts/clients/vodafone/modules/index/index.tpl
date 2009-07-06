
<div id="title">
	<img src="/images/clients/vodafone/title_campaigns.png"/>
</div>

{if $jobs}

{foreach from=$jobs item=item}
	{if $item->id}
	<div class="jobs">
		<h4><a href="/jobs/{$item->id}">{$item->article->title}</a></h4>
		
		<div class="leftCol">
			<div class="thumb">
				<a href="/jobs/{$item->id}"><img src="{$item->image.THUMB->path}"/></a>
			</div>
			<ul>
				<li class="first"><strong>Published:</strong> {$item->published->toString("dd MMMM yy")}</li>
				<li><strong>Job Number: </strong>{$item->number}</li>
				<li><a href="/jobs/{$item->id}">more details...</a></li>
			</ul>
		</div>
		
		<div class="rightCol">
			
			<div class="bg_324">
				<div class="contentBox">
					<div class="heading">
						<span class="animateControl" onclick="animate(this, document.getElementById('description_{$item->id}'),0.4)" title="Contract">-</span>
						Description
					</div>
					<div id="description_{$item->id}">
						<div class="content">
							{$item->article->body}
						</div>
					</div>
				</div>
			</div>
			
			{if $item->content neq null}
            	<!--
				<ul class="tabs">
					<li class="on"><a href="javascript:;">Television</a></li>
					<li><a href="javascript:;">Radio</a></li>
					<li><a href="javascript:;">Documents</a></li>
				</ul>
				-->
				<div class="bg_324">
					{foreach from=$item->content item=cont name=cont}
					{if $cont->media}
					<div class="contentBox">
							<div class="heading">
								<span class="animateControl" onclick="animate(this, document.getElementById('phase_{$item->id|cat:$smarty.foreach.cont.index}'),0.4)" title="{if !$smarty.foreach.cont.first}Expand{else}Contract{/if}">{if !$smarty.foreach.cont.first}+{else}-{/if}</span>
								{$cont->article->title}
							</div>
							<div id="phase_{$item->id|cat:$smarty.foreach.cont.index}"{if !$smarty.foreach.cont.first} style="display:none;"{/if}>
								<div class="content">
									<div class="specs">
										<div class="key">Published</div>
										<div class="value">{$cont->published->toString("dd MMMM yy")}</div>
										<div class="key">Media</div>
										<div class="value">
											{catIcons obj=$cont}
										</div>
									</div>
									<a href="/content/{$cont->id}/{$item->id}" class="details">more...</a>
								</div>
							</div>
					</div>
					{/if}
					{/foreach}
				</div>
			
			{/if}
		</div>
		
	</div>
	{/if}
{/foreach}

{assign var='limit' value=$jobs.limit}
{assign var='rows' value=$jobs.totalrows}
<!--
offset: {$offset}<br/>
rows: {$rows}<br/>
limit: {$limit}<br/>
-->
{pager rowcount=$rows limit=$limit posvar='pages' pos=$offset}

{/if}