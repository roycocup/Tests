{form id="addContent" name="addContent" method="post" action=$requestUri enctype="multipart/form-data"}
	<strong>{$title}</strong><br>
	<span style="color:red;">
		{foreach from=$errorMessages item=error}
			{$error} <br>
		{/foreach}
	</span>
		<div id="formDiv">
			  
			<label for="addContent[title]">Title</label>
				<br>
				<input type="text" class="medium" name="addContent[title]"  
				{if $posted.title} value="{$posted.title}" {/if} /> 
			<br><br>
			  
			<label for="addContent[description]">Description</label>
			<br>
			<textarea class="medium" name="addContent[description]" cols="50">{if $posted.description}{$posted.description}{/if}</textarea> 
			<br><br>
		
			<label for="addContent[image]">Please upload an image</label>
			<br>
			<input type="file" size="25" name="image" />
			{if $posted->image} Preview {$posted->image->name}<img src="{$posted->image->path}" height="50" width="50" onclick="window.open('{$posted->image->path}'); " />{/if} 
			Alter description (optional) <input type="text" name="addContent[imageAlt]" class="medium" {if $posted->images neq ''} value="{$posted->images}" {/if} />
			<br><br>
			
					
			<label for="addContent[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
			<br>
			<div id="date">
				<input type="text" id="addContent[datePublished]" name="addContent[datePublished]" 
				{if $posted.published neq ''} value="{$posted.published}" {/if} />
				<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
			</div>
			<br><br>
				
			<label for="select">Please select a status</label><br>
			<select name="addContent[status]" id="addContent[status]" class="medium">
				{foreach from=$status item=state}
					<option {if $posted->status->id eq $state.id} selected {/if} value="{$state.id}">{$state.name}</option>
				{/foreach}
			</select>
			<br><br>
			
			<fieldset><legend>Media present</legend></fieldset>
			<div id="addContent[mediaFiles]">
			{foreach from=$posted->media item=mediaItem}
				<div id="addContent[mediaFiles]" style="margin: 7px;">
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
			    <input type="submit" name="Submit" value="Save">
			    <a href="/admin/media/add/{$jobId}">
			    	<input type="submit" name="addMedia" value="add media"></input>
			    </a>
			  	
		</div>
{/form}

{literal}
		<script type="text/javascript">
		  Calendar.setup(
		    {
		      inputField  : "addContent[datePublished]",         // ID of the input field
		      ifFormat    : "%d/%m/%Y",    				// the date format
		      button      : "calendar"    				   // ID of the button
		    }
		  );
		</script>
	{/literal}