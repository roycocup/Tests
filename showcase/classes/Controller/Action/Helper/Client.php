<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Client extends Showcase_Controller_Action_Helper_Abstract {
	
	protected $_categories; 		// loads the whole tree at once
	protected $_id;
	protected $_name;
	protected $_jobs;
	protected $_identifier;
	protected $_status;
	protected $_created;
	protected $_updated;

	public function direct($clientId = null, $offset = null, $limitJobs = 1, $clientStatus = 1)
	{
		$return = $this->_loadClient($clientId, $offset, $limitJobs, $clientStatus);
		return $return;
	}
	
	/* 
	*	@summary This function loads a client info based on its id 
	*	@param Clientid - the client id coming from the controller or a session
	*	@param Offset - the offset called to display the jobs
	*	@param limitjobs - the limit to display jobs
	*	@param clientStatus - the status of the client we want to fetch 
	* 	@returns - one client only, with an array of jobs and several others inside that last (content-media...)
	*/
	protected function _loadClient($clientId, $offset, $limitJobs, $clientStatus) 
{
		//$coreCache = Zend_Registry::get('coreCache');
		$coreCache = Zend_Registry::get('site_config_cache');
		if(!$client = $coreCache->load('cacheClient')) {
			$stmt = Zend_Registry::get('dbh')->proc('load_client');
			$stmt->bindParam(':id', $clientId, PDO::PARAM_INT);
			$stmt->bindParam(':status', $clientStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$client = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
			} catch (Zend_Db_Statement_Exception $e) {
						die($e->getMessage());
			}
			
			//insert the objects
			$categories				= Zend_Controller_Action_HelperBroker::getStaticHelper('Category');
			$status					= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
			$jobs					= Zend_Controller_Action_HelperBroker::getStaticHelper('Jobs');		//"requiring" the helper Jobs.php
			$client->categories		= $categories->direct($client->id);
			$client->status			= $status->getStatus($client->status);
			$client->jobs 			= $jobs->getJobs($client->id, $offset, $limitJobs); 
			$client		  			= Showcase_Client::factory($client); // pass the object to factory
			
			
			$coreCache->save($client, 'cacheClient'); 
			//print_r ("NOT from cache: ");die();
			return $client; 
		} else {
			//print_r ("coming from cache: ");die();
			return $client;
		}
}
	
	public function loadByGroup($groupId, $clientStatus = null)
	{
		$client	= NULL;
		
		try {
			$stmt = Zend_Registry::get('dbh')->proc('load_client_by_group');
			$stmt->bindParam(':group', $groupId, PDO::PARAM_INT);
			$stmt->bindParam(':status', $clientStatus, PDO::PARAM_INT);
			$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
			$client	= Showcase_Client::factory($result);
		}catch(Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		return $client; 	
	}
	
	// fetches the client information and a specific JOB connected to him
	// The only difference between this function and the one above is that 
	//this one does not need to print a list of items and passes a jobId to the job helper to fetch only one specific job
	// and... TODO: its public hence the jobs and content should be called (url)  by identifier and not id.... 
	public function getClientJob($clientId, $jobId, $jobStatus, $clientStatus = 1) {
			try {
			//echo $clientId, $offset, $limitJobs, $clientStatus; die;
				$stmt = Zend_Registry::get('dbh')->proc('load_client');
				$stmt->bindParam(':id', $clientId, PDO::PARAM_INT);
				$stmt->bindParam(':status', $clientStatus, PDO::PARAM_INT);
				try {
					$stmt->execute();
					$client = $stmt->fetch(PDO::FETCH_OBJ);
					$stmt->closeCursor();
				} catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
				
				// handle empty pull 
				if (empty($client))
				{
					/*
					$redirect = new Zend_Controller_Action_Helper_Redirector;
					$redirect->setGotoUrl('index');
					*/
					die;
				}
				
				$categories				= Zend_Controller_Action_HelperBroker::getStaticHelper('Category');
				$status					= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
				$jobs					= Zend_Controller_Action_HelperBroker::getStaticHelper('Jobs');		//"requiring" the helper Jobs.php
				$client->categories		= $categories->direct($clientId);
				$client->status			= $status->getStatus($clientStatus);
				$client->jobs 			= $jobs->direct($clientId, $jobId, $jobStatus); 
				$client		  			= Showcase_Client::factory($client); // pass the object to factory
				//print_r($client); die;
				
				
				return $client; 	
			}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
	}
	
	// fetches the client information and a specific CONTENT connected to him
	public function getClientContent($clientId, $contentId, $contentStatus, $clientStatus = 1) {
		//echo $clientId, $offset, $limitJobs, $clientStatus; die;
		$stmt = Zend_Registry::get('dbh')->proc('load_client');
		$stmt->bindParam(':id', $clientId, PDO::PARAM_INT);
		$stmt->bindParam(':status', $clientStatus, PDO::PARAM_INT);
		try {
			$stmt->execute();
			$client = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		} catch (Zend_Db_Statement_Exception $e) {
			die($e->getMessage());
		}
		
		// handle empty pull 
		if (empty($client))
		{
			/*
			$redirect = new Zend_Controller_Action_Helper_Redirector;
			$redirect->setGotoUrl('index');
			*/
			die;
		}
		
		//echo $clientId, $contentId, $contentStatus; die;
		$content				= Zend_Controller_Action_HelperBroker::getStaticHelper('Content');
		$categories				= Zend_Controller_Action_HelperBroker::getStaticHelper('Category');
		$status					= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		$client->content 		= $content->direct($clientId, $contentId, $contentStatus);
		$client->categories		= $categories->direct($clientId);
		$client->status			= $status->getStatus($clientStatus);
		$client		  			= Showcase_Client::factory($client); // pass the object to factory
		
		
		
		return $client; 	
	}

	
	
}	
