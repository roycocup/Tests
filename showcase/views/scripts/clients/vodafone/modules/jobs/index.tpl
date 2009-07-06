<div id="title">
	<img src="/images/clients/vodafone/title_campaign.png"/>
</div>

<div class="jobs">
	<h4>{$job->article->title}</h4>
	
	<div class="leftCol{if $media}_reversed{/if}">
		{if $media}
		{include file="view:player.tpl"}
		{else}
		<div class="thumb">
			<img src="{$job->image.MAIN->path}"/>
		</div>
		<ul>
			<li class="first"><strong>Published:</strong> {$job->published->toString("dd MMMM yy")}</li>
			<li><strong>Job Number: </strong>{$job->number}</li>
		</ul>
		{/if}
	</div>
	
	<div class="rightCol{if $media}_reversed{/if}">
		
		{if !$media}
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_{$job->id}'))" title="Contract">-</span>Description</div>
			<div id="description_{$job->id}">
				<div class="content">
					{$job->article}
				</div>
			</div>
		</div>
		{else}
        {if $media->description}
		<div class="contentBox">
			<div class="heading">
				<span class="animateControl" onclick="animate(this, document.getElementById('description_{$media->id}'))" title="Contract">-</span>
				Description
			</div>
			<div id="description_{$media->id}">
				<div class="content">
					{$media->description}
				</div>
			</div>
		</div>
		{/if}
        
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('download_{$media->id}'))" title="Contract">-</span>Download</div>
			<div id="download_{$media->id}">
				{if $media->cue}
				<div class="content">
					<a href="/download/{$media->cue}" class="icon_documents">{$media->cue->name}</a>
				</div>
				{/if}
				{if $media->schedule}
				<div class="content">
					<a href="/download/{$media->schedule}" class="icon_documents">{$media->schedule->name}</a>
				</div>
				{/if}
				<div class="content">
					<a href="/download/{$media}" class="icon_{$media->category->identifier}">{$media->name}</a>
				</div>
			</div>
		</div>
		
		{/if}
		
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('breif_{$job->id}'), 0.2)" title="Contract">-</span>Download Brief Sheet</div>
			<div id="breif_{$job->id}">
				<div class="content">
					<a href="/download/{$job->document}" class="icon_documents">{$job->document->name}</a>
				</div>
			</div>
		</div>
		
		{if $media}
		<ul class="marginBottom">
			<li class="first"><a href="/jobs/{$job->id}">Back</a></li>
		</ul>
		{/if}
		
	</div>
	
</div>
{if $media}
<div class="bg_554">
	<div class="contentBox">
		<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_{$job->id}'))" title="Contract">-</span>Campaign Description</div>
		<div id="description_{$job->id}">
			<div class="content">
				{$job->article}
			</div>
		</div>
	</div>
</div>
{/if}


<div id="phases">
	
	{foreach from=$job->content item=cont name=cont}
		<div class="bg_554">
			<div style="float:right;">{$cont->published->toString("dd MMMM yy")}</div>
			<h4><span class="animateControl" onclick="animate(this, document.getElementById('media_{$smarty.foreach.cont.index}'))" title="{if !$smarty.foreach.cont.first}Expand{else}Contract{/if}">{if !$smarty.foreach.cont.first}+{else}-{/if}</span><a href="/content/{$cont->id}/{$job->id}">{$cont->article->title}</a></h4>
			
			<div id="media_{$smarty.foreach.cont.index}"{if !$smarty.foreach.cont.first} style="display:none;"{/if}>
				{if $cont->article}
				<div class="marginBottom">
					{$cont->article}
				</div>
				{/if}
				<div class="contentBox">
					{categories obj=$cont type=tabs}
					<div class="heading">Media Download</div>
				
					{assign var=catindex value=0}
					{foreach from=$cont->media item=media name=media}
						{if !$catname || $catname neq $media->category}
							{if $catname neq $media->category && !$smarty.foreach.media.first}
							</div>
							{/if}
							{assign var=catname value=$media->category}
							{math equation='x + y' x=$catindex y=1 assign=catindex}
							<div id="cont{$cont->id}_{$catindex}">
						{/if}
					
						<div class="content media">
						{if $media->filetype_name}
							<div class="icon_{$media->category->identifier}">
									<div class="media_name">
										{$media->name}
									</div>
								<div class="media_container">
									{if $media->filesize}
									<div class="media_filesize">
										<strong>Filesize:</strong> {$media->filesize}
									</div>
									{/if}
								</div>
								<div class="media_description">
									{$media->description}
								</div>
								<div class="media_links">
								{if $media->cue}
									<a href="/download/{$media->cue}" title="Download {$media->cue->name}">Cue Sheet</a>
								{/if}
								{if $media->schedule}
									<a href="/download/{$media->schedule}" title="Download {$media->schedule->name}">Schedule</a>
								{/if}
								{if $media->stream_path}
									<a href="/jobs/{$job->id}/{$media->identifier}">Play</a>
								{/if}
								{if $media->path}
									{if $media->isWeblink}
									<a href="{$media->path}" target="blank" title="Open {$media->name}">Open Website</a>
									{else}
									<a href="/download/{$media}">Download</a>
									{/if}
								{/if}
								</div>
							</div>
						{/if}
						</div>
						
						{if $smarty.foreach.media.last}
							</div>
						{/if}
					{foreachelse}
					<div class="content">
						There is currently no media available to download for this phase
					</div>
					{/foreach}
				</div>

			</div>
		
		</div>
	{/foreach}
	
</div>

