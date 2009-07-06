<?php

class Showcase_Controller_Action_Helper_Admin_Editorial extends Showcase_Controller_Action_Helper_Admin_Abstract
{
	public function save($chatId, array $post = array())
	{
		$user = $this->getRequest()->getParam('User');
		if ($editorialId = Showcase_Admin::saveEditorial($user, $chatId, $post)) {
			if (!is_array($editorialId)){
				$this->getRequest()->setParam('editorialId', $editorialId);		
			}
			return $editorialId;
		}
	}
	
	public function saveImage($editorialId, $file, $type)
	{
		$user = $this->getRequest()->getParam('User');
		if ($imageId = Showcase_Admin::saveImage($user, $editorialId, $file, $type)) {
			if (!is_array($imageId)){
				$this->getRequest()->setParam('imageId', $imageId);		
			}
			return $imageId;
		}
	}
	
	public function direct($chatId, $editorialId, $portal)
	{
		return $this->load($chatId, $editorialId, $portal);
	}
	
	public function load($chatId, $editorialId = null, $portal = null)
	{
		$sql = 'CALL `admin_editorial_fetch`(:chatId, :editorialId, :portalId)';
		$stmt = Zend_Registry::get('dbh')->prepare($sql);
		$stmt->bindParam(':chatId', $chatId, PDO::PARAM_INT);
		$stmt->bindParam(':editorialId', $editorialId, PDO::PARAM_INT);
		$stmt->bindParam(':portalId', $portal->id, PDO::PARAM_INT);
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor();
			$editorials = array();

			foreach ($result as $row) {
				$editorial = new Showcase_Content_Editorial;
				$editorial->unlock(Showcase_Admin::getInstance());
				$editorial->id 			= $row->editorial;
				$editorial->chatId		= $row->chat;
				$editorial->headline	= $row->headline;
				$editorial->alias		= $row->alias;
				$editorial->sponsor		= Showcase_Sponsor::factory($row->sponsorId, $row->sponsorName, $row->sponsorUrl);
				$editorial->channel		= Showcase_Channel::factory($portal, $row->channel);
				$editorial->lock();
				$editorials[$editorial->id] = $editorial;
			}
			return $editorials;
		} catch (Zend_Db_Statement_Exception $e) {
			echo $e->getMessage();
		}
	}
	
}