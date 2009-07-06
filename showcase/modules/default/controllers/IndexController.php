<?php
class indexController extends Showcase_Controller_Action {


	/* *******************************************************
	 init function	
	******************************************************* */
	public function init() {
	// Main page load
	
	$client	= $this->_getParam('Client', null);
	
	$limitJobs 	= 5;
	$status 	= 1;
	
	$offset 	= $this->_getParam('offset', null);
	if (!$offset){
		$offset = 0;
	}
	
	$client	= $this->_helper->Client($client->id, $offset, $limitJobs, $status);
	$this->view->assign('banner', $client->banner);
	$this->view->assign('offset', $offset);
	
	$this->view->assign('jobs', $client->jobs);	 
	//print_r($client); die;
	
	// category tree for this client
	$tree = $client->categories;
	$this->view->assign('tree', $tree);		
	}
	
	
	
	
	/* *******************************************************
	 call function	
	******************************************************* */		
	public function __call($method, $paramters) 
	{
		
	}
	

}