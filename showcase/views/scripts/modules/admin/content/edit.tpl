{form id="editContent" name="editContent" method="post" action=$requestUri enctype="multipart/form-data"}
	<strong>{$title}</strong><br>
	<span style="color:red;">
		{foreach from=$errorMessages item=error}
			{$error} <br>
		{/foreach}
	</span>
		<div id="formDiv">
			  
			<label for="editContent[title]">Title</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				{if $posted->article->title} value="{$posted->article->title}" {/if} /> 
			<br><br>
			  
			<label for="editContent[description]">Description</label>
			<br>
			<textarea class="medium" name="editContent[description]" cols="50">{if $posted->article->body}{$posted->article->body}{/if}</textarea> 
			<br><br>
		
			<label for="editContent[image]">Please upload an image</label>
			<br>
			<input type="file" size="25" name="image" />
			{if $posted->image} Preview {$posted->image->name}<img src="{$posted->image->path}" height="50" width="50" onclick="window.open('{$posted->image->path}'); " />{/if} 
			Alter description (optional) <input type="text" name="editContent[imageAlt]" class="medium" {if $posted->images neq ''} value="{$posted->images}" {/if} />
			<br><br>
			
					
			<label for="editContent[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
			<br>
			<div id="date">
				<input type="text" id="editContent[datePublished]" name="editContent[datePublished]" 
				{if $posted->published neq ''} value="{$posted->published->tostring('dd/MM/YYYY')}" {/if} />
				<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
			</div>
			<br><br>
				
			<label for="select">Please select a status</label><br>
			<select name="editContent[status]" id="editContent[status]" class="medium">
				{foreach from=$status item=state}
					<option {if $posted->status->id eq $state.id} selected {/if} value="{$state.id}">{$state.name}</option>
				{/foreach}
			</select>
			<br><br>
			
			<fieldset><legend>Media present</legend></fieldset>
			<div id="editContent[mediaFiles]">
			{foreach from=$posted->media item=mediaItem}
				<div id="editContent[mediaFiles]" style="margin: 7px;">
				<strong>Filename</strong> - {$mediaItem->name} - 
				<strong>Type</strong> - {$mediaItem->type->name} - 
				<strong>Category</strong> - {$mediaItem->category->name} - 
				<strong>Status</strong> - {$mediaItem->status->name}
				<br>
				<a href="#"><button>Edit</button></a>
				<a href="#"><button>Preview</button></a>
				<a href="#"><button>Download</button></a> 
				<a href="#"><button>Delete</button></a>
				<br>
				</div>
			{/foreach}
			</div>
			  
			<br><br><br> 
			<input type="hidden" value="{$posted->image->name}" name="editContent[oldImageName]" /> 
			<input type="hidden" value="{$posted->id}" name="editContent[contentId]" /> 	
			<input type="submit" name="Submit" value="Save">
			<a href="/admin/media/add/{$jobId}"><input type="submit" name="addMedia" value="Add Media"></input></a>
			  	
		</div>
{/form}
<div id="formDiv">
	{assign var='contentId' value=$posted->id} 
	{form action="/admin/content/delete/$contentId/$clientId" Method="POST" name="deleteContent" }
		<input type="hidden" value="{$posted->image->name}" name="deleteContent[oldImageName]" />
		<button onclick="return confirm('Are you sure you want to delete?');"> Delete Phase</button>
	{/form}
</div>

{literal}
		<script type="text/javascript">
		  Calendar.setup(
		    {
		      inputField  : "editContent[datePublished]",       // ID of the input field
		      ifFormat    : "%d/%m/%Y",    						// the date format
		      button      : "calendar"    				   		// ID of the button
		    }
		  );
		</script>
	{/literal}