<?php

class Showcase_Controller_Action_Helper_Admin_Content extends Showcase_Controller_Action_Helper_Abstract
{
	
	public function __call($method, $args)
	{
		$method = '_' . $method;
		
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $args);
		}
	}
	
	
	private function _saveNewContent(array $postedVars)
	{
		$jobId 			= 	$postedVars['jobId'];
		$client 		=	$postedVars['client'];
		$article		=	$postedVars['article'];
		$image			= 	$postedVars['image'];
		$status			= 	$postedVars['status'];
		$published		= 	date("Ymdhis", $postedVars['published']->get());
		
		
		/*
		 * Atom save
		 */
		//get the handler
		$stmt = Zend_Registry::get('dbh');
		$stmt->beginTransaction();
		try {
				//image save
				if (isset($postedVars['image']))
				{
					$sql = $stmt->prepare("CALL `save_image`(:imgPath, :imgAlt); ");
					$sql->bindParam(':imgPath', $image['path'], PDO::PARAM_STR);
					$sql->bindParam(':imgAlt', $image['description'], PDO::PARAM_STR);
					$sql->execute();
					$imageId = $sql->fetch(PDO::FETCH_ASSOC);
				}
				
				//save article
				if (isset($postedVars['article']))
				{
					$html = '0';
					$type = '0';
					$sql = $stmt->prepare("CALL `save_article`(:title, :description, :html, :type); ");
					$sql->bindParam(':title', $article['title'], PDO::PARAM_STR);
					$sql->bindParam(':description', $article['description'], PDO::PARAM_STR);
					$sql->bindParam(':html', $html, PDO::PARAM_STR);
					$sql->bindParam(':type', $type, PDO::PARAM_STR);
					$sql->execute();
					$articleId = $sql->fetch(PDO::FETCH_ASSOC);
				}
				
				
				//save content
				$sql = $stmt->prepare("CALL `save_content`(:jobId, :imgId, :articleId, :published, :status); ");
				$sql->bindParam(':jobId', $jobId, PDO::PARAM_INT);
				$sql->bindParam(':imgId', $imageId['id'], PDO::PARAM_INT);
				$sql->bindParam(':articleId', $articleId['id'], PDO::PARAM_INT);
				$sql->bindParam(':published', $published, PDO::PARAM_INT);
				$sql->bindParam(':status', $status, PDO::PARAM_STR);
				$sql->execute();
				//$contentId = $sql->fetch(PDO::FETCH_ASSOC);
				$sql->closeCursor();		   
				
				//final commit
				$stmt->commit();
				
			} 
			catch (Zend_Db_Statement_Exception $e) 
			{
		 	  	$stmt->rollBack();
		 	  	echo $e->getMessage(); 
		  	  	return false;
			}
		
		return true;
	}
	
	private function _updateContent(array $postedVars)
	{
		$contentId			= 	$postedVars['contentId'];
		$article			=	$postedVars['article'];
		$article['html'] 	= 	0;
		$article['type'] 	= 	0;
		$image				= 	$postedVars['image'];
		$image['imageType'] = 	4;
		$status				= 	$postedVars['status'];
		$published			= 	date("Ymdhis", $postedVars['published']->get());

		/*
		 * Atom update
		 */
		//get the handler
		$stmt = Zend_Registry::get('dbh')->proc('update_content');
		try {	
				//update content
				$stmt->bindParam(':contentId', $contentId, PDO::PARAM_INT);
				$stmt->bindParam(':articleTitle', $article['title'], PDO::PARAM_STR);
				$stmt->bindParam(':articleBody', $article['description'], PDO::PARAM_STR);
				$stmt->bindParam(':html', $article['html'], PDO::PARAM_STR);
				$stmt->bindParam(':articleType', $article['type'], PDO::PARAM_STR);
				$stmt->bindParam(':imgPath', $image['path'], PDO::PARAM_STR);
				$stmt->bindParam(':imgAlt', $image['description'], PDO::PARAM_STR);
				$stmt->bindParam(':imgType', $image['imageType'], PDO::PARAM_INT);
				$stmt->bindParam(':status', $status, PDO::PARAM_INT);
				$stmt->bindParam(':published', $published, PDO::PARAM_STR);
				$stmt->execute();
				$stmt->closeCursor();		   
			} catch (Zend_Db_Statement_Exception $e) {
		 	  	echo $e->getMessage(); 
		  	  	return false;
			}
		return true;
		
	}
	
	private function _deleteContent($contentId)
	{
		//get the handler
		if ($contentId != null)
		{
			//get the handler for job insert
			$stmt = Zend_Registry::get('dbh')->proc('delete_content');
			$stmt->bindParam(':contentId', $contentId, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				print($e->getMessage()); return false;
			}
			return true;
		}
		
	}
		
	
}