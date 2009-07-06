<div id="title">
	<img src="/images/clients/vodafone/title_phase.png"/>
</div>

<div class="jobs">
	<h4>{$cont->article->title}</h4>
	
	<div class="leftCol{if $media}_reversed{/if}">
		{if $media}
		{include file="view:player.tpl"}
		{else}
		<div class="thumb">
			<img src="{$cont->image}"/>
		</div>
		<ul>
			<li class="first"><strong>Published:</strong> {$cont->published->toString("dd MMMM yy")}</li>
			<li><a href="/jobs/{$jobId}">View the whole campaign</a></li>
		</ul>
		{/if}
	</div>


	<div class="rightCol{if $media}_reversed{/if}">
		
		{if !$media}
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_{$cont->id}'))" title="Contract">-</span>Description</div>
			<div id="description_{$cont->id}">
				<div class="content">
					{$cont->article}
				</div>
			</div>
		</div>
		{else}

		<ul class="marginBottom">
			<li class="first"><strong>Published:</strong> {$cont->published->toString("dd MMMM yy")}</li>
		</ul>

        {if $media->description}
		<div class="contentBox">
			<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('description_{$media->id}'))" title="Contract">-</span>Description</div>
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
		
		{if $media}
		<ul class="marginBottom">
			<li class="first"><a href="/jobs/{$jobId}">View the whole campaign</a></li>
			<li><a href="/content/{$cont->id}/{$jobId}">Back</a></li>
		{/if}
		</ul>
		
	</div>


</div>


{categories obj=$cont type=tabs}
<div class="bg_554">
	<div class="contentBox">
		<div class="heading"><span class="animateControl" onclick="animate(this, document.getElementById('media_{$cont->id}'))" title="Contract">-</span>Media Download</div>
		<div id="media_{$cont->id}">
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
						<a href="/download/{$media->cue}">Cue Sheet</a>
					{/if}
					{if $media->schedule}
						<a href="/download/{$media->schedule}">Schedule</a>
					{/if}
					{if $media->stream_path}
						<a href="/content/{$cont->id}/{$jobId}/{$media->identifier}">Play</a>
					{/if}
					{if $media->path}
						{if $media->isWeblink}
							<a href="{$media->path}" target="blank" title="Open {$media->name}">Open Website</a>
						{elseif $media->type eq '5' or $media->type eq '12' or $media->type eq '6' or $media->type eq '7' or $media->type eq '1'}
							<a href="/filepreview/{$media}" target="blank" title="Open">Preview</a> 
							<a href="/download/{$media}">Download</a>
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

