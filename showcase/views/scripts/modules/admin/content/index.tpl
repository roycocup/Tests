{form id="selectContent" name="selectContent" method="post" action=$requestUri enctype="multipart/form-data"}
	<div id="formDiv">
		{$message}	
		{if $hasContent neq ''}
			<br><br>
			<select name="selectContent[contentId]" id="selectContent[contentId]" class="medium" onchange="submit();" >
				{foreach from=$content item=contentItem name=content}
					{if $smarty.foreach.content.first}
						<option value=""> </option>
					{/if}
					<option value="{$contentItem->id}">{$contentItem->article->title}</option>
				{/foreach}
			</select>
			<br><br>OR
		{/if}
		<br><br>
		<a href="{$newPhaseLink}"><button>Create a new Phase for this job</button></a>	
	</div>
{/form}

