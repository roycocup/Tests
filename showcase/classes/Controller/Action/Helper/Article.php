<?php

/* -------------------------------------------------
 Client Class for loading client info
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Article extends Showcase_Controller_Action_Helper_Abstract {
	
	public function __call($method, $vars)
	{
		$method	= "_" . $method;
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $vars);
		}
		return false; 
	}
	
	// load one article based on its id
	protected function _getArticle($articleId) {
		try {
			$stmt = Zend_Registry::get('dbh')->proc('get_article_by_id');
			$stmt->bindParam(':id', $articleId, PDO::PARAM_INT);
			try {
				$stmt->execute();
				$article = $stmt->fetch(PDO::FETCH_OBJ);
				$stmt->closeCursor();
				}catch (Zend_Db_Statement_Exception $e) {
					die($e->getMessage());
				}
		}catch(Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		$article	= Showcase_Article::factory($article);
		//print_r($article); die;
		return $article;
	}
	
}
	