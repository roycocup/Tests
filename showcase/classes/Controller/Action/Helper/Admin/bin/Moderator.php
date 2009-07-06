<?php

class Showcase_Controller_Action_Helper_Admin_Moderator extends Showcase_Controller_Action_Helper_ChatPosts {

	// *******************************************************
	// set up vars
	protected $_flush = false;

	// *******************************************************
	// get name function	
	public function getName() {
		return 'Moderator';
	}

	// *******************************************************
	// flush	
	protected function _flush() {
	
		$chatId = $this->getActionController()->chat->id;
		
		Showcase_Content_Cache::flushCache($chatId);
	}

	// *******************************************************
	// edit function	
	public function edit($id, $status, $alias = null, $body = null)	{
	
		$stmt = Zend_Registry::get('dbh')->proc('post_moderator_edit');
		$stmt->bindParam(':id', $id, PDO::PARAM_INT);
		$stmt->bindParam(':status', $status, PDO::PARAM_INT);
		$stmt->bindParam(':alias', $alias, PDO::PARAM_STR);
		$stmt->bindParam(':body', $body, PDO::PARAM_STR);
		$stmt->execute();
		
	}
	
	// *******************************************************
	// flush
	public function flush(){
		$this->_flush();
	}

	// *******************************************************
	// load chats
	public function loadChats() {
		$chats = false;
		$stmt = Zend_Registry::get('dbh')->proc('chats_moderator_list');
		$stmt->execute();
		$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
		$stmt->closeCursor();
		
		if ($result) {
			$chats = array();
			foreach ($result as $row) {
				if ($chat = $this->_buildChat($row)) {
					$chats[] = $chat;
				}
			}
		}
		return $chats;
	}
	
	// *******************************************************
	// get posts	
	public function getPosts() {
		return self::fetchPosts($this->getActionController()->chat->id, get_class($this));
	}

	// *******************************************************
	// builds the chat array from database results	
	protected function _buildChat($result){
		if ($result instanceof stdClass) {
			return Showcase_Chat::factory($result->type, $result->id, $result->start, $result->finish, $result->status, $result->handle, $result->job_id, $result->job_number);
		}
		return null;
	}
	
	// *******************************************************
	// builds the post array from database results	
	protected function _buildPost($result){
		if ($result instanceof stdClass) {
			return Showcase_Admin_Post::factory($result);
		}
		return null;
	}
	
	// *******************************************************
	// builds the post array from database results	
	protected function _buildShow($result){
		if ($result instanceof stdClass) {
			return Showcase_Admin_Show::factory($result);
		}
		return null;
	}

	// *******************************************************
	// loads current chat	
	public function load($id) {
		$stmt = Zend_Registry::get('dbh')->proc('chats_moderator_load');
		$stmt->bindParam(':chat', $id, PDO::PARAM_INT);
		$stmt->execute();
		$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
		$stmt->closeCursor();
		return $this->_buildChat($result);
	}

	// *******************************************************
	// loads current questions for a valid Show		
	public function loadQuestions($show_id, $post_id, $status_id = null) {
	
		$questions 	= 	null;
		
		$stmt = Zend_Registry::get('dbh')->proc('posts_moderator_fetch');
		$stmt->bindParam(':showid', $show_id, PDO::PARAM_INT);
		$stmt->bindParam(':postid', $post_id, PDO::PARAM_INT);	
		$stmt->bindParam(':statusid', $status_id, PDO::PARAM_INT);
		
		try {
			$stmt->execute();	  
			$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor();
		} catch (Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		if ($result) {
			$questions = array();
			foreach ($result as $row) {
				if ($question = $this->_buildPost($row)) {
					$questions[] = $question;
				}
			}
		}

		return $questions;
	}
	
	// *******************************************************
	// edits the question	
	public function editQuestion($id, $body) {

		$stmt = Zend_Registry::get('dbh')->proc('posts_moderator_edit');
		$stmt->bindParam(':post', $id, PDO::PARAM_INT);
		$stmt->bindParam(':postbody', $body, PDO::PARAM_INT);	
		$stmt->execute();  
	
		$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
		$stmt->closeCursor();
		
		return null;	
		
	}
	
	// *******************************************************
	// edits the question	
	public function updateQuestionRanks($showid, $ul1, $ul2) {
	
		$stmt = Zend_Registry::get('dbh')->proc('posts_moderator_rank_clear');
		$stmt->bindParam(':showid', $showid, PDO::PARAM_INT);	
		$stmt->execute(); 
		$stmt->closeCursor();
	
		$ul1array	=	explode(",", $ul1);
		if (is_array($ul1array)) {
			$rankcount	=	1;
			$listid		=	2;
			foreach ($ul1array as $ulitem) {
				$postarr	=	explode("_", $ulitem);
				$postrev	=	array_reverse($postarr);
				$postid		=	$postrev[0];
				$stmt = Zend_Registry::get('dbh')->proc('posts_moderator_rank');
				$stmt->bindParam(':showid', $showid, PDO::PARAM_INT);
				$stmt->bindParam(':postid', $postid, PDO::PARAM_INT);
				$stmt->bindParam(':rank', $rankcount, PDO::PARAM_INT);
				$stmt->bindParam(':listid', $listid, PDO::PARAM_INT);
				$stmt->execute();
				$stmt->closeCursor();
				$rankcount++;
			}
		}
		
		$ul2array	=	explode(",", $ul2);
		if (is_array($ul2array)) {
			$rankcount	=	1;
			$listid		=	1;
			foreach ($ul2array as $ulitem) {
				$postarr	=	explode("_", $ulitem);
				$postrev	=	array_reverse($postarr);
				$postid		=	$postrev[0];
				$stmt = Zend_Registry::get('dbh')->proc('posts_moderator_rank');
				$stmt->bindParam(':showid', $showid, PDO::PARAM_INT);
				$stmt->bindParam(':postid', $postid, PDO::PARAM_INT);
				$stmt->bindParam(':rank', $rankcount, PDO::PARAM_INT);
				$stmt->bindParam(':listid', $listid, PDO::PARAM_INT);
				$stmt->execute();
				$stmt->closeCursor();
				$rankcount++;
			}
		}		
	
		return null;
	}
	
	// *******************************************************
	// loads current questions for a valid Show		
	public function loadSchedule() {
		
		$result		=	null;

		try {
			$stmt = Zend_Registry::get('dbh')->proc('shows_current_load');
			$stmt->execute(); 
			$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor(); 
		} catch (Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}

		if ($result) {
			$questions = array();
			foreach ($result as $row) {
				if ($question = $this->_buildShow($row)) {
					$questions[] = $question;
				}
			}
		}

		return $questions;
	}
	
	// *******************************************************
	// updates the show status	
	public function updateStatus($showId, $statusId) {

		try {	
			$stmt = Zend_Registry::get('dbh')->proc('admin_shows_status');
			$stmt->bindParam(':showid', $showId, PDO::PARAM_INT);	
			$stmt->bindParam(':statusid', $statusId, PDO::PARAM_INT);
			$stmt->execute(); 
			$stmt->closeCursor();
		} catch (Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
	}
	
	
}