<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_MediaImage extends Showcase_Controller_Action_Helper_Abstract {
	

	public function direct($imageId)
	{
		$return = $this->_loadImage($imageId);
		return $return;
	}
	
	// load one 
	protected function _loadImage($imageId) {
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_image_by_id');
			$stmt->bindParam(':id', $imageId, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$image = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		
		if ($image) {
			$image						= Showcase_MediaImage::factory($image);
		}
		//print_r($image); die;
		return $image;
	}
	
	
	
}