<?php

class Showcase_Controller_Action_Helper_Admin_Article extends Showcase_Controller_Action_Helper_Admin_Abstract
{
	public function save($editorialId, array $post = array())
	{
		$user = $this->getRequest()->getParam('User');
		if ($articleId = Showcase_Admin::saveArticle($user, $editorialId, $post)) {
			return true;
		}		
	}
	
	public function loadType($type = null)
	{
		if (!$type){
			return false;
		}
		
		$sql = 'CALL `editorial_types_load_by_handle`(:type)';
		$stmt = Zend_Registry::get('dbh')->prepare($sql);
		$stmt->bindParam(':type', $type, PDO::PARAM_STR);
		try {
			$stmt->execute();
			$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor();
			return $result;
		} catch (Zend_Db_Statement_Exception $e) {
			echo $e->getMessage();
		}
	}
}