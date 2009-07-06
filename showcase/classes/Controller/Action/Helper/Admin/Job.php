<?php

class Showcase_Controller_Action_Helper_Admin_Job extends Showcase_Controller_Action_Helper_Abstract
{

	public function __construct ()
	{
		
	}
	
	public function __call($method, $args)
	{
		$method = '_' . $method;
		
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $args);
		}
	}
	
	private function _saveNewJob($postedVars)
	{ 	
		//TODO: This is wrong! I need to insert them and the job as an atom transaction
		//insert images and get the ids
		$imgIds = $this->_saveFiles($postedVars, 'images');
		if($imgIds == false){return false;}
		
		//insert the thumbs and get ids
		$thumbsIds = $this->_saveFiles($postedVars, 'thumbs');
		if($thumbsIds == false){return false;}
		
		//insert documents and get ids
		$docIds = $this->_saveFiles($postedVars, 'documents');
		if($docIds == false){return false;}
		
		//insert job article
		$articleId = $this->_saveArticle($postedVars);
		if($articleId == false){return false;}
		
		//set the date
		$datePublished = date("Ymdhis", $postedVars['datePublished']->get());
		
		
		//get the handler for job insert
		$stmt = Zend_Registry::get('dbh')->proc('save_job');
		
		//insert job
		$stmt->bindParam(':clientId', $postedVars['client']['id'], PDO::PARAM_INT);
		$stmt->bindParam(':number', $postedVars['number'], PDO::PARAM_INT);
		$stmt->bindParam(':article', $articleId[0], PDO::PARAM_INT);
		$stmt->bindParam(':thumb', $thumbsIds[0], PDO::PARAM_INT);
		$stmt->bindParam(':image', $imgIds[0], PDO::PARAM_INT);
		$stmt->bindParam(':status', $postedVars['status'], PDO::PARAM_INT);
		$stmt->bindParam(':document', $docIds[0], PDO::PARAM_INT);
		$stmt->bindParam(':datePublished', $datePublished, PDO::PARAM_STR);
		try {
			$stmt->execute();
			$result[] = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				print($e->getMessage()); return false;
			}
			 
		// handle empty pull 
		if (empty($result))
		{
			return false;
		}
		
		return true;
	}
	
	private function _updateJob($postedVars)
	{	
		$jobId 				= $postedVars['jobId'];
		$number				= $postedVars['number'];
		$jobDescription		= $postedVars['description'];
		$jobTitle			= $postedVars['title'];
		$status				= $postedVars['status'];
		$datePublished 		= date("Ymdhis", $postedVars['datePublished']->get());
		
		/*
		 * Atom update
		 */
		//get the handler
		$stmt = Zend_Registry::get('dbh');
		$stmt->beginTransaction();
		try {
			
			//images update
			if (isset($postedVars['media']['images']))
			{
				foreach ($postedVars['media']['images'] as $image)
				{
					
					$sql = $stmt->prepare("CALL `update_image`(:jobId, :imgPath, :imgAlt); ");
					$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
					$sql->bindParam(':imgPath', $image['path'], PDO::PARAM_STR);
					$sql->bindParam(':imgAlt', $image['description'], PDO::PARAM_STR);
					$sql->execute();
				}
			}
			
			//thumbs update
			if (isset($postedVars['media']['thumbs']))
			{
				foreach ($postedVars['media']['thumbs'] as $thumb)
				{
					$sql = $stmt->prepare("CALL `update_thumb`(:jobId  , :thumbPath , :thumbAlt); ");
					$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
					$sql->bindParam(':thumbPath', $thumb['path'], PDO::PARAM_STR);
					$sql->bindParam(':thumbAlt', $thumb['description'], PDO::PARAM_STR);
					$sql->execute();
				}
			}
			
			//update documents
			if (isset($postedVars['media']['documents']))
			{
				foreach ($postedVars['media']['documents'] as $doc)
				{
					//insert files and overwrites the bindings
					$sql = $stmt->prepare("CALL `update_document`(:jobId  ,:docPath, :docDescription, :docIdentifier, :docFilename); ");
					$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
					$sql->bindParam(':docPath', $doc['path'], PDO::PARAM_STR);
					$sql->bindParam(':docDescription', $doc['description'], PDO::PARAM_STR);
					$sql->bindParam(':docIdentifier', $doc['identifier'], PDO::PARAM_STR);
					$sql->bindParam(':docFilename', $doc['name'], PDO::PARAM_STR);
					$sql->execute();
				}
			}
			
			
			//update article
			$sql = $stmt->prepare("CALL `update_article`(:jobId  ,:jobDescription, :jobTitle); ");
			$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
			$sql->bindParam(':jobDescription', $jobDescription, PDO::PARAM_STR);
			$sql->bindParam(':jobTitle', $jobTitle, PDO::PARAM_STR);
			$sql->execute();
			
			
			//update job
			$sql = $stmt->prepare("CALL `update_job`(:jobId, :number,:status, :datePublished); ");
			$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
			$sql->bindParam(':number', $number, PDO::PARAM_INT);
			$sql->bindParam(':status', $status, PDO::PARAM_INT);
			$sql->bindParam(':datePublished', $datePublished, PDO::PARAM_STR);
			$sql->execute();
			$sql->closeCursor();		   
			
			//final commit
			$stmt->commit();
			
		} catch (Zend_Db_Statement_Exception $e) {
		    $stmt->rollBack();
		    echo $e->getMessage(); 
		    return false;
		}
		
		return true;
	
	}

	private function _deleteJob($jobId)
	{
		//get the handler for job insert
		$stmt = Zend_Registry::get('dbh');
		$stmt->beginTransaction();
		$sql = $stmt->proc('delete_job');
		try {
			$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
			$sql->execute();
			//$sql->closeCursor();
			
			//final commit
			$stmt->commit();
			
		}catch (Zend_Db_Statement_Exception $e) {
			$stmt->rollBack();
		    echo $e->getMessage(); 
		    return false;
		}
		
		return true;
		
		
	}
	
	/*
	 * fetches all the clients in the db (vodafone, camelot....)
	 */
	protected function _loadClient ($status)
	{	
		$stmt = Zend_Registry::get('dbh')->proc('get_all_clients');
		$stmt->bindParam(':status', $status, PDO::PARAM_INT);
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		} catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
		}
		return $result;
	}

	
	//TODO: this is not flexible and should be reused for other files as well
	private function _saveFiles($postedVars, $category)
	{
		// if its uploading images
		if ($category == 'images' || $category == 'thumbs'){
			//get the handler
			$stmt = Zend_Registry::get('dbh')->proc('save_image');
			
			//insert files
			foreach ($postedVars['media'][$category] as $image)
			{
				$stmt->bindParam(':imgPath', $image['path'], PDO::PARAM_STR);
				$stmt->bindParam(':imgAlt', $image['description'], PDO::PARAM_STR);
				try {
					$stmt->execute();
					$result = $stmt->fetch(PDO::FETCH_NUM);
					$stmt->closeCursor();
					}catch (Zend_Db_Statement_Exception $e) {
						print($e->getMessage()); return false;
						//($e->getMessage());
					}
			}
			return $result;
		}else {
			//get the handler
			$stmt = Zend_Registry::get('dbh')->proc('save_media');
			
			//insert files
			foreach ($postedVars['media'][$category] as $file)
			{
				if (!isset($file['description'])){$file['description'] = '';}
				$stmt->bindParam(':fileDescription', $file['description'], PDO::PARAM_STR);
				$stmt->bindParam(':fileIdentifier', $file['identifier'], PDO::PARAM_STR);
				$stmt->bindParam(':filename', $file['name'], PDO::PARAM_STR);
				$stmt->bindParam(':filePath', $file['path'], PDO::PARAM_STR);
				try {
					$stmt->execute();
					$result = $stmt->fetch(PDO::FETCH_NUM);
					$stmt->closeCursor();
					}catch (Zend_Db_Statement_Exception $e) {
						print($e->getMessage()); return false;
						//die($e->getMessage());
					}
			
			}
			
			return $result;
		}
		
	}
	
	private function _saveArticle($postedVars)
	{
		//get the handler
		$stmt = Zend_Registry::get('dbh')->proc('save_article');
		
		if(!isset($postedVars['html'])){$postedVars['html'] = '0';}
		if(!isset($postedVars['type'])){$postedVars['type'] = '0';}
		//insert files
		$stmt->bindParam(':title', $postedVars['title'], PDO::PARAM_STR);
		$stmt->bindParam(':description', $postedVars['description'], PDO::PARAM_STR);
		$stmt->bindParam(':html', $postedVars['html'], PDO::PARAM_INT);
		$stmt->bindParam(':type', $postedVars['type'], PDO::PARAM_INT);
		try {
			$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_NUM);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				print($e->getMessage()); return false;
				//die($e->getMessage());
			}
			
		return $result;
	}
	
	private function _getJobsNumbers($clientId)
	{
		$stmt = Zend_Registry::get('dbh')->proc('get_job_numbers');
		$stmt->bindParam(':clientId', $clientId, PDO::PARAM_INT);
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_OBJ);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		
			return $result;
			
	}
	
	
	
	
}