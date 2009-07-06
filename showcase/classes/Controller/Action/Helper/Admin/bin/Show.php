<?php

class Showcase_Controller_Action_Helper_Admin_Show extends Showcase_Controller_Action_Helper_Admin_Abstract
{
	public function save($chatId, array $post = array())
	{
	
		$user = $this->getRequest()->getParam('User');
		if ($showId = Showcase_Admin::saveShow($user, $chatId, $post)) {
			$this->getRequest()->setParam('showId', $showId);		
			return $showId;
		}
	
		
	}
	
	public function load($chatId, $showId)
	{
		$sql	= 'CALL `admin_shows_fetch`(:chatId, :showId)';
		
		$stmt = Zend_Registry::get('dbh')->prepare($sql);
		$stmt->bindParam(':chatId', $chatId, PDO::PARAM_INT);
		$stmt->bindParam(':showId', $showId, PDO::PARAM_INT);
		$stmt->execute();
		$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
		$stmt->closeCursor();
		$shows = array();
		foreach ($result as $row) {
			$show = Showcase_Content_Show::factory($row);
			$shows[$show->id] = $show;
		}
		return $shows;
	}

	
}