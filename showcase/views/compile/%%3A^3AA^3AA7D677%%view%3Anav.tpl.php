<?php /* Smarty version 2.6.18, created on 2008-04-29 17:49:44
         compiled from view:nav.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'dotree', 'view:nav.tpl', 5, false),)), $this); ?>
<div id="header">
	<img src="/images/clients/vodafone/navtab_coverage.gif"/>
</div>
<div id="navigation">
	<?php echo smarty_function_dotree(array('tree' => $this->_tpl_vars['tree']), $this);?>

</div>