<?php /* Smarty version 2.6.18, created on 2008-04-29 17:49:45
         compiled from view:footer.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'date_format', 'view:footer.tpl', 4, false),)), $this); ?>
<div id="footer">
	<div class="inner">
		<ul>
			<li>&copy; 2004 - <?php echo ((is_array($_tmp=time())) ? $this->_run_mod_handler('date_format', true, $_tmp, "%Y") : smarty_modifier_date_format($_tmp, "%Y")); ?>
 <a href="http://www.markettiers4dc.com" target="blank">markettiers4dc Limited</a></li>
		</ul>
		<p>
			Markettiers4dc Ltd Registered  office: Northburgh House, 10a Northburgh Street, London, EC1V 0AT Registered in England &amp; Wales No. 4308785 VAT number: 783 037 913
			<br/>
			<br/>
			PRCA Business Affiliate, CIPR Partner, ISO 9001:2000 registered (Certificate  Number GB7041)
		</p>
	</div>
</div>