<?php

/* -------------------------------------------------
 Channels Class for loading Channel info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Category extends Showcase_Controller_Action_Helper_Abstract 
{
	
	protected $_categories;
	
	public function direct($clientId, $status = null)
	{
		$categories = $this->_getCategories($clientId, $status);
		return $categories;
	}
	
	public function __call($method, $vars)
	{
		$method	= "_" . $method;
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $vars);
		}
		return false; 
	}

	// get a flat list of all categories present
	protected function _getCategories($clientId, $status = NULL, $returnToMe = null) {
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
				if ($returnToMe != null){ return $categories; }
				$categories = $this->onlyWithContent($clientId, $categories);
				return $categories;
			} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
	}
	
	// get the ones that have content associated with this client
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
		
		
		$categories = $this->_setCategories($catWithContent, $categories);
		//print_r($categories); die;
		return $categories;
	}
	
	// make an array of all the categories that have content including childs and parents
	protected function _setCategories($catWithContent, $categories)
	{
		//iterate trough the categories that have content
		$numCat = count($catWithContent)-1;
		$newArray = array();
		for ($i=0; $i<=$numCat; $i++){
			// if the category has parents just find its parents and put to the new array
			if ($catWithContent[$i]->inherits != null){
				//get the parent
				$parent[$i] = $this->getParent($catWithContent[$i]->inherits, $categories);
				
				//find if the parent is already there and return the index of the parent in the newArray 
				$pIndex = $this->isParentThere($parent[$i]->id, $newArray); 
				
				//if it has a parent already there just push it into the array 
				if (is_numeric($pIndex)){
					$catWithContent[$i] = Showcase_Category::factory($catWithContent[$i]);
					$newArray[$pIndex]->children[] = $catWithContent[$i];					
				}else{
					// if not, combine the two and put them into the new array
					$parent[$i] = Showcase_Category::factory($parent[$i]);
					$catWithContent[$i] = Showcase_Category::factory($catWithContent[$i]);
					$parent[$i]->children = array($catWithContent[$i]);
					$newArray[$i] = $parent[$i]; 
				}
			}
			//if the category does not have parents just add to the new array
			else{
				$catWithContent[$i]->children = "";
				$newArray[] = Showcase_Category::factory($catWithContent[$i]);
			}
		}
		return $newArray;
	}	
	
	private function getParent($id, $arr)
	{ 
		$numArr = count($arr)-1;
		for ($i=0; $i<=$numArr; $i++){
			if($arr[$i]->id == $id){
				return $arr[$i];
			}
		}
	}
	
	private function isParentThere($parentId, $arr){
		 
		foreach ($arr as $key=>$value)
		{
			if ($value->id != $parentId){
				continue;
			}else{
				return $key;
			}
			return false;
		}
		
	}
	
	// get a category belonging to a specific media
	protected function _getCategory($mediaId) {
			try {
				$stmt = Zend_Registry::get('dbh')->proc('get_categories_by_media_id');
				$stmt->bindParam(':id', $mediaId, PDO::PARAM_INT);
				try {
					$stmt->execute();
					$category = $stmt->fetch(PDO::FETCH_OBJ);
					$stmt->closeCursor();
				} catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
				return $category;
			} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}
		$category   = Showcase_Category::factory($category); 
		return $category;
	}
	
	
}