
{form id="newJob" name="newJob" method="post" action=$requestUri enctype="multipart/form-data"}
	<fieldset class="form">
		<strong>{$title}</strong><br>
			<span style="color:red;">
				{foreach from=$errorMessages item=error}
					{$error} <br>
				{/foreach}
			</span>
			<div id="formDiv">
			
				<label for="select">Please select a client</label><br>
				<select name="newJob[client]" id="newJob[client]" class="medium">
					{foreach from=$clients item=client name=client}
						{if $smarty.foreach.client.first}
							<option value=""> </option>
						{/if}
						<option {if $posted.client.id eq $client->id} selected {/if}value="{$client->id}">{$client->name}</option>
					{/foreach}
				</select>
				<br><br>
				
				<label for="newJob[jobNumber]">Please input a NEW job number</label>
				<br>
				<input type="text" class="medium" name="newJob[number]" {if $posted.number neq ''} value={$posted.number} {/if} />
				<br><br>
				
				<label for="newJob[title]">Please type in a title (Max: 70 Chars)</label>
				<br>
				<input {if $posted.title neq ''}value="{$posted.title}" {/if} type="text" name="newJob[title]" id="newJob[title]" class="medium" size="50" />
				<br><br>
				
				<label for="newJob[description]">Please type in a description</label>
				<br>
				<textarea name="newJob[description]" id="newJob[description]" class="medium">{$posted.description}</textarea>
				<br><br>
				
				<label for="newJob[image]">Please upload an image as main</label>
				<br>
				<input type="file" size="50" name="image" /> Description (optional) <input type="text" name="newJob[imageAlt]" class="medium"></input>
				<br><br>
				
				<label for="newJob[thumb]">Please upload an image as secondary</label>
				<br>
				<input type="file" size="50" name="thumb" /> Description (optional) <input type="text" name="newJob[thumbAlt]" class="medium"></input>
				<br><br>
				
				<label for="newJob[document]">Please upload the briefing document (.doc and .pdf only)</label>
				<br>
				<input type="file" size="50" name="document" /> Description <input type="text" name="newJob[docdescription]" class="medium"></input>
				<br><br>
				
				<label for="newJob[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
				<br>
				<div id="date">
					<!-- <input type="text" id="newJob[datePublished]" name="newJob[datePublished]" {if $posted.datePublished neq ''} value={$posted.datePublished} {/if} /> -->
					<input type="text" id="newJob[datePublished]" name="newJob[datePublished]" {if $posted.datePublished neq ''} value={$posted.datePublished->tostring('dd/MM/YYYY')} {/if} />
					<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
				</div>
				<br><br>
				
				
				<label for="select">Please select a status</label><br>
				<select name="newJob[status]" id="newJob[status]" class="medium">
					{foreach from=$status item=state}
						<option {if $posted.status eq $state.id} selected {/if} value="{$state.id}">{$state.name}</option>
					{/foreach}
				</select>
				
				<!-- previous add a phase 
				<br><br>
				<hr>
				<br>
				<input type="hidden" value="0" id="theValue" />
				<div id="previousPhases"><script>populatePhases('{$phasesPosts}')</script></div>
				<div id="DynamicDiv"></div>
				<br>
				<a style="font-style:italic;" onClick="
				addElement()">Add a phase</a>
				-->
				
				
				<br><br><br>
				<input type="submit" value="Save" />	
			</div>	
	</fieldset>
{/form}
{literal}
<script type="text/javascript">
  Calendar.setup(
    {
      inputField  : "newJob[datePublished]",         // ID of the input field
      ifFormat    : "%d/%m/%Y",    					// the date format
      button      : "calendar"    				   // ID of the button
    }
  );
</script>
{/literal}
