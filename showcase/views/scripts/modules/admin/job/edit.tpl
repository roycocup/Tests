{form id="selectClient" name="selectClient" method="post" action=$requestUri enctype="multipart/form-data"}
	<fieldset class="form">
		<strong>{$title}</strong><br>
			<span style="color:red;">
				{foreach from=$errorMessages item=error}
					{$error} <br>
				{/foreach}
			</span>
			<div id="formDiv">
			
				<label for="select">Please select a client</label><br>
				<select name="selectClient[client]" id="selectClient[client]" class="medium" onchange="submit();">
					{foreach from=$clients item=client name=client}
						{if $smarty.foreach.client.first}
							<option value=""> </option>
						{/if}
						<option {if $posted.client.id eq $client->id} selected {/if}value="{$client->id}">{$client->name}</option>
					{/foreach}
				</select>
				<br><br>
			</div>
	</fieldset>
{/form}

{if $selectJob eq 1}
	{form id="selectJob" name="selectJob" method="post" action=$requestUri enctype="multipart/form-data"}
		<fieldset class="form">
			<div id="formDiv">
				<label for="selectJob">Please select a job number</label><br>
				<select name="selectJob[jobId]" id="selectJob[jobId]" class="medium" onchange="submit();">
					{foreach from=$jobNumbers item=job name=job}
						{if $smarty.foreach.job.first}
							<option value=""> </option>
						{/if}
						<option {if $posted.jobId eq $job->job_id} selected {/if} value="{$job->job_id}">{$job->job_number} - {$job->title}</option>
					{/foreach}
				</select>
				<br><br>
			</div>
			<input type="hidden" value={$posted.client.id} name="selectJob[client]" />
		</fieldset>
	{/form}
{/if}


{if $jobChosen neq ''}
	{form id="editJob" name="editJob" method="post" action=$requestUri enctype="multipart/form-data"}
		<fieldset class="form">
			<div id="formDiv">	
				<label for="editJob[jobNumber]">Please input a NEW job number</label>
				<br>
				<input type="text" class="medium" name="editJob[number]" {if $posted.jobNumber neq ''} value={$posted.jobNumber} {/if} />
				<br><br>
				
				<label for="editJob[title]">Please type in a title (Max: 70 Chars)</label>
				<br>
				<input {if $posted.title neq ''}value="{$posted.title}" {/if} type="text" name="editJob[title]" id="editJob[title]" class="medium" size="50" />
				<br><br>
				
				<label for="editJob[description]">Please type in a description</label>
				<br>
				<textarea cols="50" name="editJob[description]" id="editJob[description]" class="medium">{$posted.description}</textarea>
				<br><br>
				
				<label for="editJob[image]">Please upload an image as main</label>
				<br>
				<input type="file" size="25" name="image" />
				{if $posted.media.images.0.name} Preview {$posted.media.images.0.name}<img src="{$posted.media.images.0.path}" height="50" width="50" onclick="window.open('{$posted.media.images.0.path}'); " />{/if} 
				Alter description (optional) <input type="text" name="editJob[imageAlt]" class="medium" {if $posted.media.images.0.description neq ''} value="{$posted.media.images.0.description}" {/if} />
				<br><br>
				
				<label for="editJob[thumb]">Please upload an image as secondary</label>
				<br>
				<input type="file" size="25" name="thumb" /> 
				{if $posted.media.thumbs.0.name} Preview {$posted.media.thumbs.0.name}<img src="{$posted.media.thumbs.0.path}" height="50" width="50" onclick="window.open('{$posted.media.thumbs.0.path}'); " />{/if}
				Alter description (optional) <input type="text" name="editJob[thumbAlt]" class="medium" {if $posted.media.thumbs.0.description neq ''} value="{$posted.media.thumbs.0.description}" {/if} />
				<br><br><br>
				
				<label for="editJob[document]">Please upload the briefing document (.doc and .pdf only)</label>
				<br>
				<input type="file" size="25" name="document" /> 
				<a href="/download{$posted.media.documents.0.path}">{$posted.media.documents.0.name}<a/> Description (optional) <input type="text" name="editJob[docdescription]" class="medium" {if $posted.media.documents.0.description neq ''} value={$posted.media.documents.0.description} {/if}></input>
				<br><br>
				
				<label for="editJob[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
				<br>
				<div id="date">
					<input type="text" id="editJob[datePublished]" name="editJob[datePublished]" {if $posted.datePublished neq ''} value={$posted.datePublished->tostring('dd/MM/YYYY')} {/if} />
					<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
				</div>
				<br><br>
				
				<label for="select">Please select a status</label><br>
				<select name="editJob[status]" id="editJob[status]" class="medium">
					{foreach from=$status item=state}
						<option {if $posted.status->id eq $state.id} selected {/if} value="{$state.id}">{$state.name}</option>
					{/foreach}
				</select>
				
				<br><br><br>
				<input type="hidden" value={$posted.client.id} name="editJob[client]" />
				<input type="hidden" value={$posted.jobId} name="editJob[jobId]" />
				<input type="hidden" value="{$posted.media.images.0.name}" name="editJob[oldImageName]" />
				<input type="hidden" value="{$posted.media.thumbs.0.name}" name="editJob[oldThumbName]" />
				<input type="hidden" value="{$posted.media.documents.0.name}" name="editJob[oldDocName]" />
				
				<input type="submit" value="Save" />
				<a href="/admin/content/index/{$posted.jobId}/{$posted.client.id}"><button> Add/Edit Phases for this job</button></a> 
				
				
			</div>	
		</fieldset>
	{/form}
	<div id="formDiv">
		<form action="/admin/job/delete/" Method="POST">
			<input type="hidden" value="{$posted.client.name}" name="deleteJob[clientName]" />
			<input type="hidden" value="{$posted.client.id}" name="deleteJob[clientId]" />
			<input type="hidden" value="{$posted.jobId}" name="deleteJob[jobId]" />
			<input type="hidden" value="{$posted.media.images.0.name}" name="deleteJob[oldImageName]" />
			<input type="hidden" value="{$posted.media.thumbs.0.name}" name="deleteJob[oldThumbName]" />
			<input type="hidden" value="{$posted.media.documents.0.name}" name="deleteJob[oldDocName]" />
			<button onclick="return confirm('Are you sure you want to delete?');"> Delete Job</button>
		</form>
	</div>
	
	{literal}
		<script type="text/javascript">
		  Calendar.setup(
		    {
		      inputField  : "editJob[datePublished]",         // ID of the input field
		      ifFormat    : "%d/%m/%Y",    					// the date format
		      button      : "calendar"    				   // ID of the button
		    }
		  );
		</script>
	{/literal}
{/if}