<?php

/* -------------------------------------------------
 Channels Class for loading Channel info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Category extends Showcase_Controller_Action_Helper_Abstract {
	protected $_categories;
	protected $_navTree;
	protected $s = null;

	public function direct($clientId, $status = null)
	{
		$return = $this->_loadCategories($clientId, $status);
		return $return;
	}
	
	protected function _loadCategories($clientId, $status = NULL) {
			try {
				$stmt = Zend_Registry::get('dbh')->proc('get_categories');
				$stmt->bindParam(':status', $status, PDO::PARAM_INT);
				try {
					$stmt->execute();
					$categories = $stmt->fetchAll(PDO::FETCH_OBJ);
					$stmt->closeCursor();
				} catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
				
				
				$categories = $this->setChildren($categories);
				//print_r($categories).die();
				//$categories = $this->onlyWithContent($clientId, $categories);
				return $categories;
			} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
	}
	
	private function setChildren($arr, $id = null, $max = false, $iteration = 0){
		if(!$arr) return false;
		$iteration++;
		if( ($max) && ($iteration > $max) ) return false;
		$children	= array();
		
		reset($arr);
		while($a = current($arr)){
		//print_r($a->inherits); die;
			if($a->inherits == $id){
				$child_array	= $this->setChildren($arr, $a->id, $max, $iteration);
				// put the id as key of the array as pass it trough the object
				$children[$a->id]		= Showcase_Category::factory($a, $child_array);
			}
			next($arr);
		}
		
		return $children;
	}
	
	private function onlyWithContent($clientId,$categories){
		try {
				$stmt = Zend_Registry::get('dbh')->proc('get_categories_for_client_id');
				$stmt->bindParam(':status', $status, PDO::PARAM_INT);
				$stmt->bindParam(':id', $clientId, PDO::PARAM_INT);
				try {
					$stmt->execute();
					$catWithContent = $stmt->fetchAll(PDO::FETCH_OBJ);
					$stmt->closeCursor();
				} catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
		//print_r($catWithContent); die;
		$catWithContent = $this->_setParents($catWithContent, $categories);
		return $catWithContent;
	}
	
	protected function _setParents($catWithContent, $categories){
		foreach ($catWithContent as $key=>$value){
			if ($value->inherits){
				$parentId = $value->inherits;
				$catWithContent[$key] =  $categories[$parentId];
				if (is_null($categories[$parentId]->inherits)){
					continue;
				}else{
					$this->_setParents($catWithContent, $categories);
				}
			}
		}
	//print_r($catWithContent);die;
	}
		
	
}