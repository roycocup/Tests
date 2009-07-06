<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Status extends Showcase_Controller_Action_Helper_Abstract {
	
	// load one article based on its id
	public function getStatus($statusId) {
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_status_by_id');
			$stmt->bindParam(':id', $statusId, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$status = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		$status	= Showcase_Status::factory($status);
		
		return $status;
	}
	
}