<?php /* Smarty version 2.6.18, created on 2008-04-29 17:05:00
         compiled from view:media/add.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'form', 'view:media/add.tpl', 1, false),)), $this); ?>
<?php $this->_tag_stack[] = array('form', array('id' => 'addMedia','name' => 'addMedia','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
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
			<label for="addMedia[file]">Please upload a Media File</label>
			<br>
			<input type="file" size="25" name="image" />
			<?php if ($this->_tpl_vars['posted']->image): ?> Preview <?php echo $this->_tpl_vars['posted']->image->name; ?>
<img src="<?php echo $this->_tpl_vars['posted']->image->path; ?>
" height="50" width="50" onclick="window.open('<?php echo $this->_tpl_vars['posted']->image->path; ?>
'); " /><?php endif; ?> 
			<br><br>
	    
	    
	    	<label for="select">Please select a category</label><br>
			<select name="addMedia[category]" id="addMedia[category]" class="medium">
				<?php $_from = $this->_tpl_vars['categories']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['category']):
?>
					<option <?php if ($this->_tpl_vars['posted']->category->id == $this->_tpl_vars['category']['id']): ?> selected <?php endif; ?> value="<?php echo $this->_tpl_vars['category']['id']; ?>
"><?php echo $this->_tpl_vars['category']['name']; ?>
</option>
				<?php endforeach; endif; unset($_from); ?>
			</select>
			<br><br>
	  
	    	<label for="editContent[title]">Description</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				<?php if ($this->_tpl_vars['posted']->article->title): ?> value="<?php echo $this->_tpl_vars['posted']->article->title; ?>
" <?php endif; ?> /> 
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
	  
	 		<label for="select">Please select a type</label><br>
			<select name="editContent[status]" id="editContent[status]" class="medium">
				<?php $_from = $this->_tpl_vars['types']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['type']):
?>
					<option <?php if ($this->_tpl_vars['posted']->type->id == $this->_tpl_vars['type']['id']): ?> selected <?php endif; ?> value="<?php echo $this->_tpl_vars['type']['id']; ?>
"><?php echo $this->_tpl_vars['type']['name']; ?>
</option>
				<?php endforeach; endif; unset($_from); ?>
			</select>
			<br><br>
	
		  	<label for="editContent[title]">Streaming link (if streaming)</label>
				<br>
				<input type="text" class="medium" name="editContent[title]"  
				<?php if ($this->_tpl_vars['posted']->article->title): ?> value="<?php echo $this->_tpl_vars['posted']->article->title; ?>
" <?php endif; ?> /> 
			<br><br>
	  
	  <input type="submit" name="Submit" value="Save">
	</div>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>

