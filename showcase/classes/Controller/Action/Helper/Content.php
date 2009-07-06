<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Content extends Showcase_Controller_Action_Helper_Abstract {

	
	protected $_id;
	protected $_image;
	protected $_media;
	protected $_article;
	protected $_category; 	

	public function direct($clientId, $contentId, $contentStatus = 1)
	{
		$return = $this->_loadContent($clientId, $contentId, $contentStatus);
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
	
	// get a specific content by its id
	protected function _loadContent($clientId, $contentId, $contentStatus) {
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_content_by_id');
			$stmt->bindParam(':clientId', $clientId, PDO::PARAM_INT);
			$stmt->bindParam(':contentId', $contentId, PDO::PARAM_INT);
			$stmt->bindParam(':contentStatus', $contentStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$content = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		// handle empty pull 
		if (empty($content))
		{
			/*
			$redirect = new Zend_Controller_Action_Helper_Redirector;
			$redirect->setGotoUrl('index');
			*/
			return false;
		}
		
		$article				= Zend_Controller_Action_HelperBroker::getStaticHelper('Article');
		$status					= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		$image					= Zend_Controller_Action_HelperBroker::getStaticHelper('MediaImage');
		$media					= Zend_Controller_Action_HelperBroker::getStaticHelper('Media');
		
		$content->image 		= $image->direct($content->image);
		$content->article 		= $article->getArticle($content->article);
		$content->status 		= $status->getStatus($content->status);
		$content->media 		= $media->direct($content->id);
		$content				= Showcase_Content::factory($content);
		
		return $content;
	}
	
	
	// get an array of objects based on the jobid
	protected function _getContent($jobId, $contentStatus = 1){
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_content_by_jobid');
			$stmt->bindParam(':id', $jobId, PDO::PARAM_INT);
			$stmt->bindParam(':status', $contentStatus, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$content = $stmt->fetchall(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		$image			= Zend_Controller_Action_HelperBroker::getStaticHelper('MediaImage');
		$media			= Zend_Controller_Action_HelperBroker::getStaticHelper('Media');
		$article		= Zend_Controller_Action_HelperBroker::getStaticHelper('Article');
		$status			= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		$numConts = count($content)-1;
			for ($i=0; $i<=$numConts; $i++){
				$content[$i]->image 		= $image->direct($content[$i]->image);
				$content[$i]->media 		= $media->direct($content[$i]->id);
				$content[$i]->article 		= $article->getArticle($content[$i]->article);
				$content[$i]->status 		= $status->getStatus($content[$i]->status);
				$content[$i]				= Showcase_Content::factory($content[$i]);			
			}
		
		return $content;
	}
	
	
}
	
	
	
	
