<div id="bodyInner">
	<div id="jobs">
		<h2>{$smarty.const.JOB_MAIN_NAME}</h2> 
		<h3>{$job->article->title}</h3> <br />
		<strong>Published in:</strong> {$job->published->toString("dd.MMMM.yy")} &nbsp; &nbsp; 
		<strong>Job Number: </strong>{$job->number} &nbsp; &nbsp;
		<strong>Main Document: </strong><a href="/download/{$job->document->filepath}">{$job->document->name}</a><br /> 
		<div id="thumbnail"><img src="{$job->image->path}"></div>
		<div id="simpleSpacer"></div>
		<div id="description"><strong>Description: </strong>{$job->article->body}</div>
	</div>
	
	<br />
	{$job->content->id}
	{foreach from=$job->content item=cont}	
		<strong>{$smarty.const.CONTENT_MAIN_NAME}</strong> {$cont->article->title}
		<hr /> 
		<strong>Categories: </strong>{foreach from=$cont->media item=media} {$media->category->name} {/foreach} <br />
		<strong>Description:</strong> {$cont->article->body}<br />
		<strong>Published: </strong> {$cont->published->toString("dd.MMMM.yy")}
		<br /><br />
		{foreach from=$cont->media item=media}
			{if $media->filetype_name}
					<strong>File:</strong> {$media->name} &nbsp;&nbsp;&nbsp; {$media->description} &nbsp;&nbsp;&nbsp;
					{if $media->type eq 1}
						<strong>Category:</strong> {$media->category->name} &nbsp; &nbsp; &nbsp; 
						<button value="Download">Download</button>
					{/if}
					{if $media->type eq 2}
						<strong>Category:</strong> {$media->category->name} &nbsp; &nbsp; &nbsp; 
						<button value="Play">Play</button><button value="Download">Download</button>
					{/if}
			{/if}
			<br />
		{/foreach}
	<br /> <br /> <br />
	{/foreach}
	
</div>

