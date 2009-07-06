<div id="bodyInner">

	<strong>Campaign Title:</strong> {$cont->article->title} <br />
	<img src="{$cont->image->path}" alt="{$cont->image->alt}">&nbsp;&nbsp;&nbsp;
	<strong>Description:</strong> {$cont->article->body}
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
</div>