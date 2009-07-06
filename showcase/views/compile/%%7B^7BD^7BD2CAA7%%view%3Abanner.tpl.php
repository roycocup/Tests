<?php /* Smarty version 2.6.18, created on 2008-04-29 17:51:00
         compiled from view:banner.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'date_format', 'view:banner.tpl', 6, false),)), $this); ?>
<div id="banner">
		<div id="bannerLogo">
			<img src="/images/admin/m4dcLogo.jpg"  />
		</div>
		<div id="bannerUserInfo">
			Welcome <?php echo $this->_tpl_vars['user']->getName(); ?>
 | <?php echo ((is_array($_tmp=time())) ? $this->_run_mod_handler('date_format', true, $_tmp, "%A, %B %e, %Y") : smarty_modifier_date_format($_tmp, "%A, %B %e, %Y")); ?>

		</div>
		<div id="bannerMenu">
			<?php $_from = $this->_tpl_vars['mainMenu']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['mainMenu'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['mainMenu']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['item']):
        $this->_foreach['mainMenu']['iteration']++;
?>
				<?php if (! ($this->_foreach['mainMenu']['iteration'] <= 1)): ?> | <?php endif; ?>
					<a href="/admin<?php echo $this->_tpl_vars['item']['url']; ?>
"><?php echo $this->_tpl_vars['item']['print']; ?>
</a>
			<?php endforeach; endif; unset($_from); ?>
		</div>
</div>