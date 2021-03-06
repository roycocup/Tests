<?php /* Smarty version 2.6.18, created on 2008-04-29 17:48:55
         compiled from view:content/edit.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'form', 'view:content/edit.tpl', 1, false),)), $this); ?>
<?php $this->_tag_stack[] = array('form', array('id' => 'editContent','name' => 'editContent','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
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
			  
			<label for="editContent[title]">Title</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				<?php if ($this->_tpl_vars['posted']->article->title): ?> value="<?php echo $this->_tpl_vars['posted']->article->title; ?>
" <?php endif; ?> /> 
			<br><br>
			  
			<label for="editContent[description]">Description</label>
			<br>
			<textarea class="medium" name="editContent[description]" cols="50"><?php if ($this->_tpl_vars['posted']->article->body): ?><?php echo $this->_tpl_vars['posted']->article->body; ?>
<?php endif; ?></textarea> 
			<br><br>
		
			<label for="editContent[image]">Please upload an image</label>
			<br>
			<input type="file" size="25" name="image" />
			<?php if ($this->_tpl_vars['posted']->image): ?> Preview <?php echo $this->_tpl_vars['posted']->image->name; ?>
<img src="<?php echo $this->_tpl_vars['posted']->image->path; ?>
" height="50" width="50" onclick="window.open('<?php echo $this->_tpl_vars['posted']->image->path; ?>
'); " /><?php endif; ?> 
			Alter description (optional) <input type="text" name="editContent[imageAlt]" class="medium" <?php if ($this->_tpl_vars['posted']->images != ''): ?> value="<?php echo $this->_tpl_vars['posted']->images; ?>
" <?php endif; ?> />
			<br><br>
			
					
			<label for="editContent[datePublished]">Please input the date of publishing (dd/mm/YYYY)</label>
			<br>
			<div id="date">
				<input type="text" id="editContent[datePublished]" name="editContent[datePublished]" 
				<?php if ($this->_tpl_vars['posted']->published != ''): ?> value="<?php echo $this->_tpl_vars['posted']->published->tostring('dd/MM/YYYY'); ?>
" <?php endif; ?> />
				<a id="calendar"><img src="/images/icons/calendar.gif" /></a>
			</div>
			<br><br>
				
			<label for="select">Please select a status</label><br>
			<select name="editContent[status]" id="editContent[status]" class="medium">
				<?php $_from = $this->_tpl_vars['status']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['state']):
?>
					<option <?php if ($this->_tpl_vars['posted']->status->id == $this->_tpl_vars['state']['id']): ?> selected <?php endif; ?> value="<?php echo $this->_tpl_vars['state']['id']; ?>
"><?php echo $this->_tpl_vars['state']['name']; ?>
</option>
				<?php endforeach; endif; unset($_from); ?>
			</select>
			<br><br>
			
			<fieldset><legend>Media present</legend></fieldset>
			<div id="editContent[mediaFiles]">
			<?php $_from = $this->_tpl_vars['posted']->media; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['mediaItem']):
?>
				<div id="editContent[mediaFiles]" style="margin: 7px;">
				<strong>Filename</strong> - <?php echo $this->_tpl_vars['mediaItem']->name; ?>
 - 
				<strong>Type</strong> - <?php echo $this->_tpl_vars['mediaItem']->type->name; ?>
 - 
				<strong>Category</strong> - <?php echo $this->_tpl_vars['mediaItem']->category->name; ?>
 - 
				<strong>Status</strong> - <?php echo $this->_tpl_vars['mediaItem']->status->name; ?>

				<br>
				<a href="#"><button>Edit</button></a>
				<a href="#"><button>Preview</button></a>
				<a href="#"><button>Download</button></a> 
				<a href="#"><button>Delete</button></a>
				<br>
				</div>
			<?php endforeach; endif; unset($_from); ?>
			</div>
			  
			<br><br><br> 
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']->image->name; ?>
" name="editContent[oldImageName]" /> 
			<input type="hidden" value="<?php echo $this->_tpl_vars['posted']->id; ?>
" name="editContent[contentId]" /> 	
			<input type="submit" name="Submit" value="Save">
			<a href="/admin/media/add/<?php echo $this->_tpl_vars['jobId']; ?>
"><input type="submit" name="addMedia" value="Add Media"></input></a>
			  	
		</div>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
<div id="formDiv">
	<?php $this->assign('contentId', $this->_tpl_vars['posted']->id); ?> 
	<?php $this->_tag_stack[] = array('form', array('action' => "/admin/content/delete/".($this->_tpl_vars['contentId'])."/".($this->_tpl_vars['clientId']),'Method' => 'POST','name' => 'deleteContent')); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
		<input type="hidden" value="<?php echo $this->_tpl_vars['posted']->image->name; ?>
" name="deleteContent[oldImageName]" />
		<button onclick="return confirm('Are you sure you want to delete?');"> Delete Phase</button>
	<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
</div>

<?php echo '
		<script type="text/javascript">
		  Calendar.setup(
		    {
		      inputField  : "editContent[datePublished]",       // ID of the input field
		      ifFormat    : "%d/%m/%Y",    						// the date format
		      button      : "calendar"    				   		// ID of the button
		    }
		  );
		</script>
	'; ?>