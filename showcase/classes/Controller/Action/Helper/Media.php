<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Media extends Showcase_Controller_Action_Helper_Abstract {
	

	public function direct($contentId)
	{
		$return = $this->_getMedia($contentId);
		return $return;
	}
	
	//load an array of media for a content
	protected function _getMedia($contentId){
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_media_by_contentid');
			$stmt->bindParam(':id', $contentId, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$media = $stmt->fetchall(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		//print_r($media); die;
		
		$category		= Zend_Controller_Action_HelperBroker::getStaticHelper('Category');
		$status			= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		$numConts = count($media)-1;
		for ($i=0; $i<=$numConts; $i++){
			
			$media[$i]->category 	= $category->getCategory($media[$i]->id);
			$media[$i]->status 		= $status->getStatus($media[$i]->status);
			$media[$i]				= Showcase_Media::factory($media[$i]); 
		}
		//print_r($media); die;
		
		return $media;
	}
	
	//load a media by its id
	public function loadMedia($id = null, $identifier = null){
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_media');
			$stmt->bindParam(':id', $id, PDO::PARAM_INT);
			$stmt->bindParam(':identifier', $identifier, PDO::PARAM_STR);
			$stmt->execute();
			$media = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		}catch(Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		$category			= Zend_Controller_Action_HelperBroker::getStaticHelper('Category');
		$status				= Zend_Controller_Action_HelperBroker::getStaticHelper('Status');
		
		$media->category 	= $category->getCategory($media->id);
		$media->status 		= $status->getStatus($media->status);
		$media	= Showcase_Media::factory($media);
		//print_r($media); die;
		return $media;
	}
	
	
	public function download($mediaIdentifier, $extension)
	{

		$media		= $this->loadMedia(null,$mediaIdentifier);
		
		if ($media instanceof Showcase_Media) {
			$path 		= $media->path;
			$filename	= substr($path, strrpos($path, '/') + 1);
			$sysPath	= $_SERVER['DOCUMENT_ROOT'] . $path;
			$mime		= "";
			
			if (file_exists($sysPath)) {
				header("Pragma: public");
				header("Expires: 0");
				header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
				header("Cache-Control: private",false);
				header("Content-Type: " . $mime);
				header("Content-Disposition: attachment; filename=\"". "$filename" ."\";");
				header("Content-Transfer-Encoding: binary");
				header("Content-Length: ". @filesize($sysPath));
				@readfile($sysPath);
			}
		}
		
		return $media;
	}
	
	
	public function filepreview()
	{
		print "media helper"; die;
	}
	
}