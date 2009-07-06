<?php


class Showcase_Admin_Menus extends Showcase_Controller_Action 
{
	
	public $mainMenu;
	
	public function __construct ()
	{
		$this->mainMenu = $this->_buildMainMenu();
	}
	
	
	protected function _buildMainMenu ()
	{
		//print_r(Zend_Registry::getInstance()); die;
		$newJob 			= array('identifier'=>'newJob', 'url'=>'/job/new/', 'alt'=>'New Job', 'print'=>'New Job');
		$editJob 			= array('identifier'=>'editJob', 'url'=>'/job/edit/', 'alt'=>'Edit Job', 'print'=>'Edit Job');
		$editPhase			= array('identifier'=>'editPhase', 'url'=>'/content/select', 'alt'=>'Edit Phase', 'print'=>'Edit Phase');
		$adminOptions 		= array('identifier'=>'adminOptions', 'url'=>'/admin/', 'alt'=>'Administration Options', 'print'=>'Admin Options');
		$createClient 		= array('identifier'=>'createClient', 'url'=>'/newClient/', 'alt'=>'Create a Client', 'print'=>'New Client') ;
		$editClient 		= array('identifier'=>'editClient', 'url'=>'/editClient/', 'alt'=>'Edit a Client', 'print'=>'Edit Client') ;
		$this->_mainMenu 	= compact($newJob, $editJob, $editPhase, $adminOptions, $createClient, $editClient);
		return $this->_mainMenu;
	}
	
	

}
