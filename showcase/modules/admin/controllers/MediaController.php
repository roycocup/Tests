<?php

class Admin_MediaController extends Showcase_Controller_Action_Admin
{
	
	protected $_types;
	protected $_status;
	protected $_categories;
	protected $_contentId;
	
	
	
	public function init()
	{
		$mainMenu = new Showcase_Admin_Menus;
		$this->view->assign('mainMenu', $mainMenu->mainMenu);
		$this->_contentId = $this->_getParam('contentId');
		$this->_status = Showcase_Admin::getStatus();
		$this->_categories = Showcase_Admin::getCategories();
		$this->_types = Showcase_Admin::getTypes();
	}
	
	
	public function addAction()
	{
		$this->view->assign('types', $this->_types);
		$this->view->assign('status', $this->_status);
		$this->view->assign('categories', $this->_categories);
		$this->view->assign('title', 'Add/Edit a media');
	}

}