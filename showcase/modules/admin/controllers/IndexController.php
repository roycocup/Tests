<?php
class Admin_IndexController extends Showcase_Controller_Action_Admin
{

	/* *******************************************************
	 init function	
	******************************************************* */
	
	public function init ()
	{
		if ($this->_getParam('flushCache')) {
			Showcase_Content_Cache::flushCache();
			$this->view->assign('cacheCleared',true);
		}
		
		$mainMenu = new Showcase_Admin_Menus;
		$this->view->assign('mainMenu', $mainMenu->mainMenu);
		$welcome = 'Welcome to the administration <br> Please select a link from the menu.';
		$this->view->assign('welcome', $welcome);
	}
	
	
	
	/* *******************************************************
	 call function	
	******************************************************* */		
	public function __call($method, $paramters) 
	{
		
	}
	

}