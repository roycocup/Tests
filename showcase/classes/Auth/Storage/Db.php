<?php
/***************************************************************************
 *                             Db.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Barney Hanlon, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Auth
 *	@version		v 1.0 Wednesday, June 13, 2007			
 *
 ***************************************************************************
 *
 */
class Showcase_Auth_Storage_Db extends Zend_Auth_Storage_Session
{
	protected $_sessionData;									// An instance of the handler
	
	protected $_handler 	= 'Showcase_Auth_Storage_Handler';	// the handler to use
	
	protected $_pSalt;											// salt for the hashes
	protected $_userAgent;										// the user agent used by the user
	protected $_remoteIp;										// user's remote IP
	protected $_sessionMethod;									// whether the user is accepting session cookies or not
	
	protected $_request;										// the request object
	
	const SESSION_EXPIRY 	= 3600;								// how long before sessions expire in seconds
	const SESSION_CHECK		= 30;								// how long before each database refresh
	const USER_ANONYMOUS 	= -1;								// the id to use for users who are not registered
	const SESSION_GET		= 101;								// code for a get method 
	const SESSION_COOKIE	= 102;								// code for cookie/session method
	
	protected static $_instance = null;							// keeps this unique

	public static function factory(Zend_Controller_Request_Abstract $request)
	{
		if (!self::$_instance) {
			self::$_instance = new self($request);
		}

		return self::$_instance;
	}
	
	public function __get($var)
	{
		$this->_init();
		switch ($var) {
			case 'id' :
				return $this->_sessionData->key;
			break;
			case 'userId' :
				return $this->_sessionData->getUserId();
			break;
		}
	}
	
	public function __clone()
	{}
	
	public function __construct(Zend_Controller_Request_Abstract $request)
	{
		if (self::$_instance instanceof Showcase_Auth_Storage_Db ) {
			throw new Exception('Db was already instantiated');
		}
		$this->_request 	= $request;
		$this->_remoteIp 	= Showcase_Session::getRemoteIp($this->_request);
		$this->_timeStamp 	= time();
		$this->_pSalt 		= Showcase_Session_Salt::factory();
		parent::__construct();
	}	

	public function isEmpty()
	{
		return !(bool) $this->read();
	}
	
	public function clear()
	{
	
	}
	
	
	protected function _init($id = false)
	{
		// initiate the session data as required
		if (!$this->_sessionData) {
			$this->_loadSession();
		}	
		
		if ( ($id) || (Showcase_Session::isRegenerated()) ) {
			// if we're passed a new ID then we should rebuild this
			//echo '<br/>we called insert: ' . implode(', ', (array(strval(intval($id)), strval(intval(Prometheus_Session::isRegenerated())), $this->_portalCheck() ))) . '<br />';

			$id = ($id) ? $id : $this->_sessionData->getUserId();
			
			$this->_insert($id);
		} else {
			if ($this->_sessionData->hasExpired(self::SESSION_CHECK)) {
				// We check against the database every SESSION_CHECK seconds
				// This means that we can still retain the relationship with the database 
				// without having to rely on it or hit it too often
				$this->_update();
			}
		}
		$this->_writeSession();
	}
	
	public function _loadSession()
	{
		$session = parent::read();

		if (extension_loaded('mhash')) {
			$key 		= substr($session, 0, 40);
			$session	= substr($session, 40);
			if (!$key == bin2hex(mhash(MHASH_SHA1, $session, $this->_pSalt)) ) {
				$this->clear();
			} else {
				
			}
		}
		
		$session = @unserialize($session);
		$this->_sessionData = ($session instanceof $this->_handler) ? $session : new $this->_handler;
	}
	
	public function _writeSession()
	{
		
		$user 	= serialize($this->_sessionData);

		if (extension_loaded('mhash')) {
			$hmac 		= bin2hex(mhash(MHASH_SHA1, $user, $this->_pSalt));
			$user	 	= $hmac . $user;
		}
		parent::write($user);
		
	}

	

	public function write($userId)
	{
		// Simply init with a new Id
		$this->_init($userId);
	}
	
	public function read()
	{
		$this->_init();
		$id = $this->_sessionData->getUserId();
		
		return (self::USER_ANONYMOUS == $id) ? false : $id;
	}


	protected static function salt($string, $salt = '') 
	{
		// Private function
		// Used to make the hash *really* hard to bust
		// Returns a hash
		return sha1($string . $salt);
		// better security with sha1
	}

	protected function _getSessionKey()
	{
		// Collect the pseudo session ID - this is not the real session ID, it's a hash
		if ($this->_sessionData->key) {
			$sessionKey = $this->_sessionData->key;
			$this->_sessionMethod = self::SESSION_COOKIE;	
		} else {
			$sessionKey 	= Showcase_Session::getSessionKey();
			$this->_sessionMethod = self::SESSION_GET;		
			// hmm still using the querystring - wrapper to extract this coming
		}
		if ( !preg_match('/^[A-Za-z0-9]*$/', $sessionKey) ) { // weird chars in session, kill it
			$sessionKey = false;
		}	
		return $sessionKey;
	}
	
	/*
	protected function _cleanUpExpiredSessions($time = null)
	{
		
		$expiry = ($time) ? $time : self::SESSION_EXPIRY;
		$key 	= Showcase_Session::getSessionKey();
		$stmt 	= Zend_Registry::get('dbh')->proc('session_delete_expired');
		$stmt->bindParam(':expiry', $expiry, PDO::PARAM_INT);
		$stmt->bindParam(':key', $key, PDO::PARAM_STR);
		try {
			$stmt->execute();
		} catch (Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
	}
	*/
	protected function _insert($id = null, $flag = null)
	{
		if ($flag) {
			echo $flag;
		}
		$sessionKey = $this->_getSessionKey();
		
		if (!$sessionKey) {
			$sessionKey = $this->_generateSessionKey(); // session_id was empty, regenerate
			$newSessionKey = $sessionKey;
		} else {
			$newSessionKey = $this->_generateSessionKey();
		}	
		
		// If we're rebuilding the session we should really regenerate the ID as well

		if (!Showcase_Session::isRegenerated()) {
			Showcase_Session::regenerateId();
		}  
		
		$userId			= intval ($id);
		if (!$userId) {
			$userId = self::USER_ANONYMOUS;
		}
		$userIp 		= Showcase_Session::encodeIp($this->_remoteIp);				// just ensure that no one is spoofing
		$sessionId		= session_id();
		$agent			= Showcase_Session::getuserAgentId($this->_request);
		
		//$portalId		= Showcase_Portal::resolve($this->_request);

		if ( $stmt = Zend_Registry::get('dbh')->proc('session_update_expired') ) {
			$stmt->bindParam(':old_key', $sessionKey, PDO::PARAM_STR);
			$stmt->bindParam(':new_key', $newSessionKey, PDO::PARAM_STR);
			$stmt->bindParam(':session', $sessionId, PDO::PARAM_STR);
			$stmt->bindParam(':user', $userId, PDO::PARAM_INT);			
			$stmt->bindParam(':agent', $agent, PDO::PARAM_STR);
			$stmt->bindParam(':ip', $userIp, PDO::PARAM_STR);
			//$stmt->bindParam(':portal', $portalId, PDO::PARAM_INT);
			
			try {
				$stmt->execute();
				$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();				
			} catch (Zend_Db_Statement_Exception $e) {
				die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
			}

			
			if ( !$result ) {
				// No session existed to update, re-create
				$stmt 	= Zend_Registry::get('dbh')->proc('session_create');
				$stmt->bindParam(':new_key', $newSessionKey, PDO::PARAM_STR);
				$stmt->bindParam(':session', $sessionId, PDO::PARAM_STR);
				$stmt->bindParam(':user', $userId, PDO::PARAM_INT);
				$stmt->bindParam(':agent', $agent, PDO::PARAM_STR);
				$stmt->bindParam(':ip', $userIp, PDO::PARAM_STR);
				//$stmt->bindParam(':portal', $portalId, PDO::PARAM_INT);
				
				try {
					$stmt->execute();
					$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
					$stmt->closeCursor();				
	
				} catch (Zend_Db_Statement_Exception $e) {
					echo $e->getMessage();
				}

			}
			
		}
		if ($result instanceof stdClass) {
			$sessionKey 					= $result->key;
			$this->_sessionData->key		= $sessionKey;
			$this->_sessionData->agent		= $agent;
			$this->_sessionData->start 		= $result->start;
			$this->_sessionData->update 	= $result->updated;
			//$this->_sessionData->portal 	= $portalId;
			
			$this->_sessionData->setUserId($userId);
			
			Showcase_Session::setSessionKey($newSessionKey);
		}
				
		//$this->_cleanUpExpiredSessions();
	}	

	protected function _generateSessionKey()
	{
		// Creates a unique session key using the "salt" of pkey
		list($sec, $usec) = explode(' ', microtime());
		mt_srand((float) $sec + ((float) $usec * 100000));
		// OK that's pretty random, but now...
		$newSessionKey = sha1( self::salt(uniqid(mt_rand(), true), strval($this->_pSalt)) );
		return $newSessionKey;
	}

	protected function _update()
	{
		$userId = false;
		$sessionKey = $this->_getSessionKey();

		if ($sessionKey) {
			$stmt = Zend_Registry::get('dbh')->proc('session_load');
			$stmt->bindParam(':key', $sessionKey, PDO::PARAM_STR);			
			try {
				$stmt->execute();
			} catch (Zend_Db_Statement_Exception $e) {
				die ('session_load: ' . $e->getMessage());
			}
			$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor();
			$userDetails = false;
			if ( (is_array($result)) && (count($result)) ) {
				$userDetails = $result[0];
			}
			unset($stmt);
			if ($userDetails instanceof stdClass) {
				if (Showcase_Session::checkIpRange(Showcase_Session::encodeIp($this->_remoteIp), $userDetails->ip) ) {
					if ( $userDetails->agent == $this->_sessionData->agent ) {
						
						$stmt = Zend_Registry::get('dbh')->proc('session_update');
						$stmt->bindParam(':new_key', 	$sessionKey, 	PDO::PARAM_STR);						
						try {
							$stmt->execute();
						} catch (Zend_Db_Statement_Exception $e) {
							die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
						}
						$stmt->closeCursor();	
						unset($stmt);
						$this->_sessionData->key		= $sessionKey;
						$this->_sessionData->start 		= $userDetails->start;
						$this->_sessionData->update 	= $userDetails->updated;
						$this->_sessionData->agent		= $userDetails->agent;
						//$this->_sessionData->portal		= $userDetails->portal;
						
						$this->_sessionData->setUserId($userDetails->user);
						
						if (self::SESSION_GET == $this->_sessionMethod) {
							Showcase_Session::setSessionKey($sessionKey);
						}
						//$this->_cleanUpExpiredSessions();
						return true;
					}
				}
			}
		}
		$this->_insert();
	}

}