<?php /* Smarty version 2.6.18, created on 2008-04-29 17:51:00
         compiled from view:job/edit.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'form', 'view:job/edit.tpl', 1, false),)), $this); ?>
<?php $this->_tag_stack[] = array('form', array('id' => 'selectClient','name' => 'selectClient','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<fieldset class="form">
		<strong><?php echo $this->_tpl_vars['title']; ?>
</strong><br>
			<span style="color:red;">
				<?php $_from = $this->_tpl_vars['errorMessages']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['error']):
?>
					<?php echo $this->_tpl_vars['error']; ?>
 <br>
				<?php endforeach; endif; unset($_from); ?>
			</span>
			<div id="formDiv">
			
				<label for="select">Please select a client</label><br>
				<select name="selectClient[client]" id="selectClient[client]" class="medium" onchange="submit();">
					<?php $_from = $this->_tpl_vars['clients']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['client'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['client']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['client']):
        $this->_foreach['client']['iteration']++;
?>
						<?php if (($this->_foreach['client']['iteration'] <= 1)): ?>
							<option value=""> </option>
						<?php endif; ?>
						<option <?php if ($this->_tpl_vars['posted']['client']['id'] == $this->_tpl_vars['client']->id): ?> selected <?php endif; ?>value="<?php echo $this->_tpl_vars['client']->id; ?>
"><?php echo $this->_tpl_vars['client']->name; ?>
</option>
					<?php endforeach; endif; unset($_from); ?>
				</select>
				<br><br>
			</div>
	</fieldset>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>

<?php if ($this->_tpl_vars['selectJob'] == 1): ?>
	<?php $this->_tag_stack[] = array('form', array('id' => 'selectJob','name' => 'selectJob','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
		<fieldset class="form">
			<div id="formDiv">
				<label for="selectJob">Please select a job number</label><br>
				<select name="selectJob[jobId]" id="selectJob[jobId]" class="medium" onchange="submit();">
					<?php $_from = $this->_tpl_vars['jobNumbers']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['job'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['job']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['job']):
        $this->_foreach['job']['iteration']++;
?>
						<?php if (($this->_foreach['job']['iteration'] <= 1)): ?>
							<option value=""> </option>
						<?php endif; ?>
						<option <?php if ($this->_tpl_vars['posted']['jobId'] == $this->_tpl_vars['job']->job_id): ?> selected <?php endif; ?> value="<?php echo $this->_tpl_vars['job']->job_id; ?>
"><?php echo $this->_tpl_vars['job']->job_number; ?>
 - <?php echo $this->_tpl_vars['job']->title; ?>
</option>
					<?php endforeach; endif; unset($_from); ?>
				</select>
				<br><br>
			</div>
			<input type="hidden" value=<?php echo $this->_tpl_vars['posted']['client']['id']; ?>
 name="selectJob[client]" />
		</fieldset>
	<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<?php endif; ?>


<?php if ($this->_tpl_vars['jobChosen'] != ''): ?>
	<?php $this->_tag_stack[] = array('form', array('id' => 'editJob','name' => 'editJob','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
		<fieldset class="form">
			<div id="formDiv">	
				<label for="editJob[jobNumber]">Please input a NEW job number</label>
				<br>
				<input type="text" class="medium" name="editJob[number]" <?php if ($this->_tpl_vars['posted']['jobNumber'] != ''): ?> value=<?php echo $this->_tpl_vars['posted']['jobNumber']; ?>
 <?php endif; ?> />
				<br><br>
				
				<label for="editJob[title]">Please type in a title (Max: 70 Chars)</label>
				<br>
				<input <?php if ($this->_tpl_vars['posted']['title'] != ''): ?>value="<?php echo $this->_tpl_vars['posted']['title']; ?>
" <?php endif; ?> type="text" name="editJob[title]" id="editJob[title]" class="medium" size="50" />
				<br><br>
				
				<label for="editJob[description]">Please type in a description</label>
				<br>
				<textarea cols="50" name="editJob[description]" id="editJob[description]" class="medium"><?php echo $this->_tpl_vars['posted']['description']; ?>
</textarea>
				<br><br>
				
				<label for="editJob[image]">Please upload an image as main</label>
				<br>
				<input type="file" size="25" name="image" />
				<?php if ($this->_tpl_vars['posted']['media']['images']['0']['name']): ?> Preview <?php echo $this->_tpl_vars['posted']['media']['images']['0']['name']; ?>
<img src="<?php echo $this->_tpl_vars['posted']['media']['images']['0']['path']; ?>
" height="50" width="50" onclick="window.open('<?php echo $this->_tpl_vars['posted']['media']['images']['0']['path']; ?>
'); " /><?php endif; ?> 
				Alter description (optional) <input type="text" name="editJob[imageAlt]" class="medium" <?php if ($this->_tpl_vars['posted']['media']['images']['0']['description'] != ''): ?> value="<?php echo $this->_tpl_vars['posted']['media']['images']['0']['description']; ?>
" <?php endif; ?> />
				<br><br>
				
				<label for="editJob[thumb]">Please upload an image as secondary</label>
				<br>
				<input type="file" size="25" name="thumb" /> 
				<?php if ($this->_tpl_vars['posted']['media']['thumbs']['0']['name']): ?> Preview <?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['name']; ?>
<img src="<?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['path']; ?>
" height="50" width="50" onclick="window.open('<?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['path']; ?>
'); " /><?php endif; ?>
				Alter description (optional) <input type="text" name="editJob[thumbAlt]" class="medium" <?php if ($this->_tpl_vars['posted']['media']['thumbs']['0']['description'] != ''): ?> value="<?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['description']; ?>
" <?php endif; ?> />
				<br><br><br>
				
				<label for="editJob[document]">Please upload the briefing document (.doc and .pdf only)</label>
				<br>
				<input type="file" size="25" name="document" /> 
				<a href="/download<?php echo $this->_tpl_vars['posted']['media']['documents']['0']['path']; ?>
"><?php echo $this->_tpl_vars['posted']['media']['documents']['0']['name']; ?>
<a/> Description (optional) <input type="text" name="editJob[docdescription]" class="medium" <?php if ($this->_tpl_vars['posted']['media']['documents']['0']['description'] != ''): ?> value=<?php echo $this->_tpl_vars['posted']['media']['documents']['0']['description']; ?>
 <?php endif; ?>></input>
				<br><br>
				
				<label for="editJob[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
				<br>
				<div id="date">
					<input type="text" id="editJob[datePublished]" name="editJob[datePublished]" <?php if ($this->_tpl_vars['posted']['datePublished'] != ''): ?> value=<?php echo $this->_tpl_vars['posted']['datePublished']->tostring('dd/MM/YYYY'); ?>
 <?php endif; ?> />
					<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
				</div>
				<br><br>
				
				<label for="select">Please select a status</label><br>
				<select name="editJob[status]" id="editJob[status]" class="medium">
					<?php $_from = $this->_tpl_vars['status']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['state']):
?>
						<option <?php if ($this->_tpl_vars['posted']['status']->id == $this->_tpl_vars['state']['id']): ?> selected <?php endif; ?> value="<?php echo $this->_tpl_vars['state']['id']; ?>
"><?php echo $this->_tpl_vars['state']['name']; ?>
</option>
					<?php endforeach; endif; unset($_from); ?>
				</select>
				
				<br><br><br>
				<input type="hidden" value=<?php echo $this->_tpl_vars['posted']['client']['id']; ?>
 name="editJob[client]" />
				<input type="hidden" value=<?php echo $this->_tpl_vars['posted']['jobId']; ?>
 name="editJob[jobId]" />
				<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['images']['0']['name']; ?>
" name="editJob[oldImageName]" />
				<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['name']; ?>
" name="editJob[oldThumbName]" />
				<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['documents']['0']['name']; ?>
" name="editJob[oldDocName]" />
				
				<input type="submit" value="Save" />
				<a href="/admin/content/index/<?php echo $this->_tpl_vars['posted']['jobId']; ?>
/<?php echo $this->_tpl_vars['posted']['client']['id']; ?>
"><button> Add/Edit Phases for this job</button></a> 
				
				
			</div>	
		</fieldset>
	<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
	<div id="formDiv">
		<form action="/admin/job/delete/" Method="POST">
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['client']['name']; ?>
" name="deleteJob[clientName]" />
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['client']['id']; ?>
" name="deleteJob[clientId]" />
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['jobId']; ?>
" name="deleteJob[jobId]" />
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['images']['0']['name']; ?>
" name="deleteJob[oldImageName]" />
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['thumbs']['0']['name']; ?>
" name="deleteJob[oldThumbName]" />
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']['media']['documents']['0']['name']; ?>
" name="deleteJob[oldDocName]" />
			<button onclick="return confirm('Are you sure you want to delete?');"> Delete Job</button>
		</form>
	</div>
	
	<?php echo '
		<script type="text/javascript">
		  Calendar.setup(
		    {
		      inputField  : "editJob[datePublished]",         // ID of the input field
		      ifFormat    : "%d/%m/%Y",    					// the date format
		      button      : "calendar"    				   // ID of the button
		    }
		  );
		</script>
	'; ?>

<?php endif; ?>