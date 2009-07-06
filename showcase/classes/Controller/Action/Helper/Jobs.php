<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Jobs extends Showcase_Controller_Action_Helper_Abstract {
 	
	
	public function direct($clientId, $jobId, $jobStatus)
	{
		$return = $this->_loadJob($clientId, $jobId, $jobStatus);
		return $return;
	}
	
	public function __call($method, $vars)
	{
		$method	= "_" . $method;
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $vars);
		}
		return false; 
	}
	
	
	//get a job detail 
	protected function _loadJob($clientId, $jobId, $jobStatus, $proc = 'get_jobs_by_id') {
		try {
			$stmt = Zend_Registry::get('dbh')->proc($proc);
			$stmt->bindParam(':clientId', $clientId, PDO::PARAM_INT);
			$stmt->bindParam(':jobId', $jobId, PDO::PARAM_INT);
			$stmt->bindParam(':jobStatus', $jobStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$job = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		// handle empty pull (the job may not exist or not be live or the client may not have access)
		if (empty($job))
		{
			return false;
		}
		//print_r($job);
		//insert the objects
		$media				= Zend_Controller_Action_HelperBroker::getStaticHelper('Media');
		$image				= Zend_Controller_Action_HelperBroker::getStaticHelper('MediaImage');
		$status				= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		$content			= Zend_Controller_Action_HelperBroker::getStaticHelper('Content');
		$article			= Zend_Controller_Action_HelperBroker::getStaticHelper('Article');
		$job->document		= $media->loadMedia($job->document);
		$job->image			= $image->direct($job->image_id);
		$job->thumb			= $image->direct($job->thumb_id);
		$job->content 		= $content->getContent($jobId);
		$job->status		= $status->getStatus($job->status_id);
		$job->article	 	= $article->getArticle($job->article_id);
		$job				= Showcase_Jobs::factory($job);
		
		
		return $job;
	}
	
	
	// get all the jobs for a particular client
	protected function _getJobs($clientId, $offset, $limitJobs, $jobStatus = 1){
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_jobs_by_client_id');
			$stmt->bindParam(':id', $clientId, PDO::PARAM_INT);
			$stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
			$stmt->bindParam(':limit', $limitJobs, PDO::PARAM_INT);
			$stmt->bindParam(':status', $jobStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$jobs = $stmt->fetchAll(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
			}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
			
			// handle empty pull 
			if (empty($jobs))
			{
				return false;
			}
			
			// total rows in jobs belonging to client for pagination 
			$rows = $jobs[0]->rows;	
						
			//insert the objects and set the zend date
			$media								= Zend_Controller_Action_HelperBroker::getStaticHelper('Media');
			$image								= Zend_Controller_Action_HelperBroker::getStaticHelper('MediaImage');
			$status								= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
			$content							= Zend_Controller_Action_HelperBroker::getStaticHelper('Content');
			$article							= Zend_Controller_Action_HelperBroker::getStaticHelper('Article');
			$numJobs = count($jobs)-1;
			for ($i=0; $i<=$numJobs; $i++){		
				$jobs[$i]->document				= $media->loadMedia($jobs[$i]->document);			
				$jobs[$i]->image				= $image->direct($jobs[$i]->image_id);
				$jobs[$i]->thumb				= $image->direct($jobs[$i]->thumb_id);
				$jobs[$i]->status				= $status->getStatus($jobs[$i]->status_id);
				$jobs[$i]->content 				= $content->getContent($jobs[$i]->id);
				$jobs[$i]->article				= $article->getArticle($jobs[$i]->article_id);
				$jobs[$i]						= Showcase_Jobs::factory($jobs[$i]);
			}
			
			
			$jobs['totalrows'] 	= $rows;
			$jobs['limit'] 		= $limitJobs;
			$jobs['offset'] 	= $offset;
			
			return $jobs;
	}

	
	
	// get all the jobs with a particular CATEGORY in them
	protected function _getJobsCategory($catIdentifier, $clientId, $offset, $limitJobs, $jobStatus = 1){
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_jobs_by_category');
			$stmt->bindParam(':catIdentifier', $catIdentifier, PDO::PARAM_INT);
			$stmt->bindParam(':clientId', $clientId, PDO::PARAM_INT);
			$stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
			$stmt->bindParam(':limit', $limitJobs, PDO::PARAM_INT);
			$stmt->bindParam(':status', $jobStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$jobs = $stmt->fetchAll(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
			}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
			
			// handle empty pull 
			if (empty($jobs))
			{
				return false;
			}
			
			// total rows 
			$rows = $jobs[0]->rows;
			
			//category being searched to print a title saying "jobs that include $category media files"
			$category = $jobs[0]->category;
						
			//insert the objects and set the zend date
			$media								= Zend_Controller_Action_HelperBroker::getStaticHelper('Media');
			$image								= Zend_Controller_Action_HelperBroker::getStaticHelper('MediaImage');
			$status								= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
			$content							= Zend_Controller_Action_HelperBroker::getStaticHelper('Content');
			$article							= Zend_Controller_Action_HelperBroker::getStaticHelper('Article');
			$numJobs = count($jobs)-1;
			for ($i=0; $i<=$numJobs; $i++){		
				$jobs[$i]->document				= $media->loadMedia($jobs[$i]->document);			
				$jobs[$i]->image				= $image->direct($jobs[$i]->image_id);
				$jobs[$i]->thumb				= $image->direct($jobs[$i]->thumb_id);
				$jobs[$i]->status				= $status->getStatus($jobs[$i]->status_id);
				$jobs[$i]->content 				= $content->getContent($jobs[$i]->id);
				$jobs[$i]->article				= $article->getArticle($jobs[$i]->article_id);
				$jobs[$i]						= Showcase_Jobs::factory($jobs[$i]);
			}
			
			$jobs['category']	= $category;
			$jobs['totalrows'] 	= $rows;
			$jobs['limit'] 		= $limitJobs;
			$jobs['offset'] 	= $offset;
			

			
			return $jobs;
	}
	
	
	

}