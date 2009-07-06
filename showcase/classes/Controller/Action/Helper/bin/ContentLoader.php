<?php

class Showcase_Controller_Action_Helper_ContentLoader extends Zend_Controller_Action_Helper_Abstract
{

	/* -----------------------------------------------------------------------
		Flush Cache function
	----------------------------------------------------------------------- */
	public static function flushCache(array $tags = array()) {
	
		Showcase_Content_Cache::flushCache();
		
	}

	/* -----------------------------------------------------------------------
		Make ID function
	-----------------------------------------------------------------------	*/
	protected function _makeId($method, $parameters) {
	
		return md5(get_class($this) . $method . serialize($parameters));
		
	}

	/* -----------------------------------------------------------------------
		Direct (Default) function
	----------------------------------------------------------------------- */
	public function direct($showId = null)
	{
		return $this->load($showId);
	}

	// -----------------------------------------------------------------------
	// _call function
	// -----------------------------------------------------------------------	
	public function __call($method, $params)
	{
		$parameters = array_merge(array($method), $params);
		return call_user_func_array(array($this, '_load'), $parameters);
	}

	// -----------------------------------------------------------------------
	// Public Load function
	// -----------------------------------------------------------------------
	public function load($showId = null)
	{
		return $this->_load($showId);
	}

	// -----------------------------------------------------------------------
	// Cache function
	// -----------------------------------------------------------------------
	public function _cache()
	{
		return Showcase_Content_Cache::fetchCache();
	}
	
	// -----------------------------------------------------------------------
	// Protected Load function
	// -----------------------------------------------------------------------	
	protected function _load( 
		$showId 		= null,
		$method			= null,
		$preview 		= 0, 
		$offset 		= 0, 
		$limit 			= null, 
		array $portals 	= array(), 
		array $channels = array(),
		$series 		= null,
		$start 			= null,
		$finish 		= null,
		$exclude 		= null,
		$searchTerm 	= null,
		$searchFilter 	= null,
		$transcript 	= null
	) 
	{
		$user = $this->getRequest()->getParam('User');
		$args = array(
			'type'			=> ($method) ? $method : $this->getRequest()->getParam('action', null),
			'userId'		=> $user->id,
			'ip'			=> Showcase_Session::getRemoteIp($this->getRequest()),
			'cache'			=> ($user->isCmsUser) ? false : true,
			'preview'		=> ($user->isCmsUser) ? $preview : 0,
			'portals'		=> ($user->isCmsUser) ? (count($portals) ? implode(', ', $portals) : null ) : $this->getRequest()->getParam('Portal')->id,
			'channels'		=> count($channels) ? implode(', ', $channels) : ($this->getRequest()->getParam('Channel', null) ? $this->getRequest()->getParam('Channel')->id : null ),
			'series'		=> $series,
			'offset'		=> $offset,
			'limit'			=> $limit,
			'start'			=> ($start) ? new Zend_Date($start, Zend_registry::get('locale')) : null,
			'finish'		=> ($finish) ? new Zend_Date($finish, Zend_registry::get('locale')) : null,
			'show'			=> $showId,
			'exclude'		=> $exclude,
			'search'		=> $searchTerm,
			'filter'		=> $searchFilter,
			'transcript'	=> $transcript,
		);
		$return = null;

		if ($args['cache']) {
			$id = $this->_makeId($method, $args);
			if ($this->_cache()->test($id)) {
				$return = unserialize($this->_cache()->load($id));
			}
		}
		if (!$return) {
			$return = call_user_func_array(array($this, '_factory'), $args);
			if ($args['cache']) {
				$this->_cache()->save(serialize($return), $id);
			}
		}
		
		return $return;
	}

	// -----------------------------------------------------------------------
	// Factory function
	// -----------------------------------------------------------------------
	protected function _factory(
		$type,
		$userId, 
		$userIp, 
		$cache							= true,
		$preview 						= null,
		$portals 						= null,
		$channels 						= null, 
		$seriesId	 					= null, 
		
		$offset 						= 0, 
		$limit 							= null, 
		
		Zend_Date $start 				= null,
		Zend_Date $finish 				= null,
		$showId 						= null,
		$exclude 						= null, 
		$searchTerm 					= null,
		$searchFilter 					= null,
		
		$transcript						= null
	)
	{

		$validator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_DNS, true, false);
		$userIp = $validator->isValid($userIp) ? $userIp : null;
		unset($validator);
		$start		= ($start) ? strval($start) : null;
		$finish		= ($finish) ? strval($finish) : null;
		$stmt = Zend_Registry::get('dbh')->proc('page_content_load');

		
		$stmt->bindParam(':preview', $preview, PDO::PARAM_INT);
		$stmt->bindParam(':portals', $portals, PDO::PARAM_INT);
		$stmt->bindParam(':channels', $channels, PDO::PARAM_INT);
		
		/*
		$stmt->bindParam(':series', $seriesId, PDO::PARAM_INT);
		$stmt->bindParam(':exclude', $exclude, PDO::PARAM_INT);
		$stmt->bindParam(':show', $showId, PDO::PARAM_STR);
		$stmt->bindParam(':start', $start, PDO::PARAM_STR);
		$stmt->bindParam(':finish', $finish, PDO::PARAM_STR);		
		$stmt->bindParam(':search', $searchTerm, PDO::PARAM_STR);
		$stmt->bindParam(':filter', $searchFilter, PDO::PARAM_STR);
		$stmt->bindParam(':user', $user->id, PDO::PARAM_INT);
		$stmt->bindParam(':ip', $userIp, PDO::PARAM_STR);
		$stmt->bindParam(':offset', $offset, PDO::PARAM_INT);
		$stmt->bindParam(':limit', $limit, PDO::PARAM_INT);
		$stmt->bindParam(':type', $type, PDO::PARAM_STR);
		*/
		
		$results = array();
		try {
			$stmt->execute();
			$pageContent = array();
			$rowCount = 0;
			do {
				$results[] = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			} while ($stmt->nextRowset());
			$stmt->closeCursor();
		} catch (Zend_Db_Statement_Exception $e) {
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
					$pageContent[] = Showcase_Content::factory($row, $cache);
				}
			}
		}
		
		$binds	= array($user->id,$userIp,$offset,$limit,$type,$portals,$channels,$seriesId,$exclude,$showId,$start,$finish,$searchTerm,$searchFilter,$preview);
		//print_r($binds);
		//print_r($results);
		//echo "CALL page_content_load(".implode($binds,',').")";
		
		return array('contents' => ($showId) ? $pageContent[0] : $pageContent, 'rows' => (!$rowCount) ? count($pageContent) : $rowCount);
		
	}

}