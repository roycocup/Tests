<?php

$module = Zend_Controller_Front::getInstance()->getRequest()->getModuleName();

if ( (!defined('CMS_ACCESS')) || (CMS_ACCESS !== 'L33T') || ('admin' != strtolower($module)) ) {
	die ('CMS MODE IS NOT FOR J00, N00B!');
}

abstract class Showcase_Controller_Action_Helper_Admin_Abstract extends Showcase_Controller_Action_Helper_Abstract
{

	public function __construct()
	{
		// check that the Admin object exists.  This is the thing with all the save power so it's pretty uber
		if (!Showcase_Admin::getInstance()) {
			die("You cannot instantiate an admin helper without the appropriate permissions.  Which you don't have!");
		}
	}
	
	
}