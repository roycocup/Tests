<?php

class Showcase_Controller_Action_Helper_LoginPublic extends Zend_Controller_Action_Helper_Abstract
{
	protected $_user;
	
	public function init()
	{
	}
	
	public function getName()
	{
		return 'LoginPublic';
	}	
	
	
	public function checkChatKeyValidity()
	{
		$return = null;
		$showId 	= $this->getRequest()->getParam('User')->currentShow;
		$session	= $this->getRequest()->getParam('User')->getSessionKey();
		$chatKey	= $this->getRequest()->getParam('User')->chatroomKey;

		if ($chatKey) {
			try {
				$stmt = Zend_registry::get('dbh')->proc('show_viewer_authenticate');
				$stmt->bindParam(':show', $showId, PDO::PARAM_INT);
				$stmt->bindParam(':session', $session, PDO::PARAM_STR);
				$stmt->bindParam(':key', $chatKey, PDO::PARAM_STR);
				$stmt->execute();
				$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();
			} catch (Zend_Db_Statement_Exception $e) {
				echo $e->getMessage();
				die(__LINE__);
			}				
			if ($result) {
				$return =  $result->show;
			}

		}
		return $return;
	}

	public function login($form, Showcase_Content $content)
	{
		$errors = array();
		$pass = false; 
		if ( $this->getRequest()->isPost() ) {
			$login = $this->getRequest()->getPost($form);
			$user = $this->getRequest()->getParam('User');					
			if ( (is_array($login)) && (count($login)) ) {
				unset($user->currentChatRoom);
				unset($user->chatroomKey);
				unset($user->alias);
				
				if (empty($login['alias'])) {
					$errors['alias']	= 'You must choose a name, alias or nickname to enter this chat';
				} else {
					$alias 			= trim($login['alias']);
					$showId			= $content->show->id;
					$showPostId	= (!empty($login['cid'])) ? $login['cid'] : null;
					if ($showId == $showPostId) {
						$portalId	= $this->getRequest()->getParam('Portal')->id;
						$sessionKey	= $user->getSessionKey();
						$stmt = Zend_Registry::get('dbh')->proc('show_login_public');
						$stmt->bindParam(':alias', $alias, PDO::PARAM_STR);
						$stmt->bindParam(':show', $showId, PDO::PARAM_INT);
						$stmt->bindParam(':portal', $portalId, PDO::PARAM_INT);
						$stmt->bindParam(':session', $sessionKey, PDO::PARAM_STR);
						try {
							$stmt->execute();
							$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
							$stmt->closeCursor();
							if ($result) {
								$user->currentShow	 	= $showId;
								$user->chatroomKey 		= $result->show_key;
								$user->alias			= $alias;
								$content->userLogin($user);
								$pass = true;
							}
						} catch (Zend_Db_Statement_Exception $e) {
							switch($stmt->errorCode()) {
								case 23000 :
									$errors['unique'] 	= 'That name already exists, please choose another one';
									break;
								default:
									$errors['error']	= 'An unknown error occurred.  Please try again';
	
							}
						}
					}
				}
			}
		}
		return (count($errors)) ? $errors : $pass;
	}
	
	public function direct($form, Showcase_Content $content)
	{
		return $this->login($form, $content);
	}
}