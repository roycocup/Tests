<?php
class Showcase_Controller_Action_Helper_Admin_Chat extends Showcase_Controller_Action_Helper_Admin_Abstract
{

	// *******************************************************
	// save function	
	public function save($chatId, array $post = array()) {
		// first, parse out the sections into different areas
		$user = $this->getRequest()->getParam('User');
		if ($chatId = Showcase_Admin::saveChat($user, $chatId, $post)) {
			$this->getRequest()->setParam('chatId', $chatId);
			return $chatId;
		}
	}
	
	// *******************************************************
	// direct function
	public function direct($chatId = null, $offset = null, $limit = null, $showId = null, $jobNumber = null) {
		return $this->load($chatId, $offset, $limit, $showId, $jobNumber);
	}

	// *******************************************************
	// loads a chat		
	public function load($chatId = null, $offset = null, $limit = null, $showId = null, $jobNumber = null) {
	
		$stmt 	= Zend_registry::get('dbh')->prepare('CALL `admin_chats_fetch`(:chat, :job, :show, :offset, :limit)');
		$stmt->bindParam(':chat', $chatId, PDO::PARAM_INT);
		$stmt->bindParam(':job', $jobNumber, PDO::PARAM_STR);
		$stmt->bindParam(':show', $showId, PDO::PARAM_INT);
		$stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
		$stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
		$stmt->execute();
		$chats 		= array();
		$results 	= array();
		$rowCount 	= 0;
		try {
			$stmt->execute();
			do {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			} while ($stmt->nextRowset());
			$stmt->closeCursor();			
		} catch (Zend_Db_Statement_Exception $e) {
          	//die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			if ('HYC00' == $stmt->errorCode()) {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			}
		}
		foreach ($results as $rowset) {
			foreach ($rowset as $row) {
				if (isset($row->found_rows)) {
					$rowCount = $row->found_rows;
					continue;
				} else {
					if (!isset($chats[$row->id])) {
						$chats[$row->id] = Showcase_Admin_Chat::factory($row);
					}
					if ($row->show) {
						$chats[$row->id]->add($row);
					}
				}
			}
		}
		return array('chats'	=> $chats, 'count'	=> ($rowCount < count($chats)) ? count($chats) : $rowCount);			
	}
	
	// *******************************************************
	// gets an array of the channels	
	public function getChannels() {
	
		$stmt 	= Zend_registry::get('dbh')->prepare('CALL `admin_channels_fetch`');
		$stmt->execute();
		$results 	= array();
		$rowCount 	= 0;
		try {
			$stmt->execute();
			do {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			} while ($stmt->nextRowset());
			$stmt->closeCursor();			
		} catch (Zend_Db_Statement_Exception $e) {
          	//die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			if ('HYC00' == $stmt->errorCode()) {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			}
		}
		return $results;
	
	}
	
	// *******************************************************
	// gets an array of the channels	
	public function getChatTypes() {
	
		$id			=	NULL;
		$type1		=	NULL;
		
		$stmt 	= Zend_registry::get('dbh')->prepare('CALL `admin_configs_fetch`(:id, :type)');		
		$stmt->bindParam(':id', $id, PDO::PARAM_INT);
		$stmt->bindParam(':type', $type1, PDO::PARAM_STR);

		$results 	= array();
		$rowCount 	= 0;
		try {
			$stmt->execute();
			do {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			} while ($stmt->nextRowset());
			$stmt->closeCursor();			
		} catch (Zend_Db_Statement_Exception $e) {
          	//die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			if ('HYC00' == $stmt->errorCode()) {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			}
		}
		
		return $results;
	
	}
	
	// *******************************************************
	// updates database and builds RTF file from data array	
	public function buildChatPlan($content = NULL) {
	
		if (is_array($content)) {
		
			$stmt 			= 		Zend_Registry::get('dbh')->proc('admin_update_plan');	
			
			$stmt->bindParam(':chatId', 		$content['chat'], 			PDO::PARAM_INT);
			$stmt->bindParam(':showId', 		$content['id'], 			PDO::PARAM_INT);
			$stmt->bindParam(':persons', 		$content['persons'], 		PDO::PARAM_STR);
			$stmt->bindParam(':handler', 		$content['handler'], 		PDO::PARAM_STR);
			$stmt->bindParam(':starthours', 	$content['starthours'], 	PDO::PARAM_STR);
			$stmt->bindParam(':startminutes', 	$content['startminutes'], 	PDO::PARAM_STR);
			$stmt->bindParam(':endhours', 		$content['endhours'], 		PDO::PARAM_STR);
			$stmt->bindParam(':endminutes', 	$content['endminutes'], 	PDO::PARAM_STR);
			$stmt->bindParam(':director', 		$content['director'], 		PDO::PARAM_STR);
			$stmt->bindParam(':producer', 		$content['producer'], 		PDO::PARAM_STR);
			$stmt->bindParam(':camera', 		$content['camera'], 		PDO::PARAM_STR);
			$stmt->bindParam(':hardware', 		$content['hardware'], 		PDO::PARAM_STR);
			$stmt->bindParam(':channel', 		$content['channel'], 		PDO::PARAM_STR);
			$stmt->bindParam(':studio', 		$content['studio'], 		PDO::PARAM_STR);
			
			try {
				$stmt->execute();
				$stmt->closeCursor();
			} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
				if ('HYC00' == $stmt->errorCode()) {
					$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
				}
			}
		
		}
	
	}
	
	// *******************************************************

}