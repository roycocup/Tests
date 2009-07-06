<?php
class CategoryController extends Showcase_Controller_Action 
{
	public function init()
	{
		$client	= $this->_getParam('Client', null);
		$catIdentifier	= $this->_getParam('categoryIdentifier', null);
		
		$limitJobs 	= 5;
		$status 	= 1;
		$offset 	= $this->_getParam('offset', null);
		if (!$offset){
			$offset = 0;
		}
		
		$clientByCat	= $this->_helper->Jobs->getJobsCategory(
																	$catIdentifier, 
																	$client->id, 
																	$offset, 
																	$limitJobs, 
																	$status
																	);
		
		
		
		$this->view->assign('banner', $client->banner);
		$this->view->assign('offset', $offset);
		$this->view->assign('jobs', $clientByCat);	 
		
		//print_r($client); die;
		$client	= $this->_helper->Client($client->id, $offset, $limitJobs, $status); // just for the banner
		// category tree for this client
		$tree = $client->categories;
		$this->view->assign('tree', $tree);	 
	}
	
	public function __call($method, $vars)
	{
		
	}
	
	
	
	
}