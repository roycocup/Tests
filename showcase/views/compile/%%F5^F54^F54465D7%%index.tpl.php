<?php /* Smarty version 2.6.18, created on 2008-04-29 17:48:10
         compiled from view:content/index.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'form', 'view:content/index.tpl', 1, false),)), $this); ?>
<?php $this->_tag_stack[] = array('form', array('id' => 'selectContent','name' => 'selectContent','method' => 'post','action' => $this->_tpl_vars['requestUri'],'enctype' => "multipart/form-data")); $_block_repeat=true;smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
	<div id="formDiv">
		<?php echo $this->_tpl_vars['message']; ?>
	
		<?php if ($this->_tpl_vars['hasContent'] != ''): ?>
			<br><br>
			<select name="selectContent[contentId]" id="selectContent[contentId]" class="medium" onchange="submit();" >
				<?php $_from = $this->_tpl_vars['content']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['content'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['content']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['contentItem']):
        $this->_foreach['content']['iteration']++;
?>
					<?php if (($this->_foreach['content']['iteration'] <= 1)): ?>
						<option value=""> </option>
					<?php endif; ?>
					<option value="<?php echo $this->_tpl_vars['contentItem']->id; ?>
"><?php echo $this->_tpl_vars['contentItem']->article->title; ?>
</option>
				<?php endforeach; endif; unset($_from); ?>
			</select>
			<br><br>OR
		<?php endif; ?>
		<br><br>
		<a href="<?php echo $this->_tpl_vars['newPhaseLink']; ?>
"><button>Create a new Phase for this job</button></a>	
	</div>
<?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_form($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
