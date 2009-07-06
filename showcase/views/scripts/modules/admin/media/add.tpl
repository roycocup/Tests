{form id="addMedia" name="addMedia" method="post" action=$requestUri enctype="multipart/form-data"}
<strong>{$title}</strong><br>
	<span style="color:red;">
		{foreach from=$errorMessages item=error}
			{$error} <br>
		{/foreach}
	</span>
		<div id="formDiv">
			<label for="addMedia[file]">Please upload a Media File</label>
			<br>
			<input type="file" size="25" name="image" />
			{if $posted->image} Preview {$posted->image->name}<img src="{$posted->image->path}" height="50" width="50" onclick="window.open('{$posted->image->path}'); " />{/if} 
			<br><br>
	    
	    
	    	<label for="select">Please select a category</label><br>
			<select name="addMedia[category]" id="addMedia[category]" class="medium">
				{foreach from=$categories item=category}
					<option {if $posted->category->id eq $category.id} selected {/if} value="{$category.id}">{$category.name}</option>
				{/foreach}
			</select>
			<br><br>
	  
	    	<label for="editContent[title]">Description</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				{if $posted->article->title} value="{$posted->article->title}" {/if} /> 
			<br><br>
	
	  
	  		<label for="select">Please select a status</label><br>
			<select name="editContent[status]" id="editContent[status]" class="medium">
				{foreach from=$status item=state}
					<option {if $posted->status->id eq $state.id} selected {/if} value="{$state.id}">{$state.name}</option>
				{/foreach}
			</select>
			<br><br>
	  
	 		<label for="select">Please select a type</label><br>
			<select name="editContent[status]" id="editContent[status]" class="medium">
				{foreach from=$types item=type}
					<option {if $posted->type->id eq $type.id} selected {/if} value="{$type.id}">{$type.name}</option>
				{/foreach}
			</select>
			<br><br>
	
		  	<label for="editContent[title]">Streaming link (if streaming)</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				{if $posted->article->title} value="{$posted->article->title}" {/if} /> 
			<br><br>
	  
	  <input type="submit" name="Submit" value="Save">
	</div>
{/form}


