<?php /* Smarty version 2.6.18, created on 2008-04-29 17:51:00
         compiled from view:header.tpl */ ?>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<?php $_from = $this->_tpl_vars['metaTags']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['metaTypes'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['metaTypes']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['metaType']):
        $this->_foreach['metaTypes']['iteration']++;
?>
		<?php $_from = $this->_tpl_vars['metaType']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['metaTags'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['metaTags']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['meta']):
        $this->_foreach['metaTags']['iteration']++;
?>
		<meta <?php echo $this->_tpl_vars['meta']->type; ?>
="<?php echo $this->_tpl_vars['meta']->name; ?>
" content="<?php echo $this->_tpl_vars['meta']->content; ?>
" />
		<?php endforeach; endif; unset($_from); ?>
	<?php endforeach; endif; unset($_from); ?>
	<title><?php echo $this->_tpl_vars['pageTitle']; ?>
</title>
	<link href="/include/css/admin" rel="stylesheet" type="text/css" />
	
	<!--calendar style and js-->
	<style type="text/css">@import url(/javascript/jscalendar/calendar-win2k-1.css);</style>
	<script type="text/javascript" src="/javascript/jscalendar/calendar.js"></script>
	<script type="text/javascript" src="/javascript/jscalendar/lang/calendar-en.js"></script>
	<script type="text/javascript" src="/javascript/jscalendar/calendar-setup.js"></script>
	
	<!-- scriptaculous and prototype-->
	<script src="/javascript/scriptaculous_181/prototype.js" type="text/javascript"></script>
	<script src="/javascript/scriptaculous_181/scriptaculous.js?load=effects" type="text/javascript"></script>
	<script src="/javascript/animate.js" type="text/javascript"></script>
	
	<!-- addmore (phases)-->
	<script type="text/javascript" src="/javascript/addFields.js"></script>

	
</head>