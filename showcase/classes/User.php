<?php

class Showcase_User 
{
	protected $_auth;
	protected $_roles;
	protected $_details;
	protected $_firstname;
	protected $_lastName;
	protected $_session;
	
	protected $_tokenSet = 0;

	protected function __construct($id = null)
	{
	
	}

	public static function factory($id)
	{
		$user = new self($id);
		$user->_auth = Zend_Auth::getInstance();
		$user->_init();
		
		return $user;
	}
	
	protected function _init()
	{
		$this->getRoles();
		$this->getDetails();
	}
	
	protected function _session()
	{
		if (!$this->_session instanceof Zend_Session_Namespace) {
			$this->_session = new Zend_Session_Namespace(__CLASS__);
			if (!isset($this->_session->initialized)) {   
				Showcase_Session::regenerateId();    
				$this->_session->initialized = true;
			}
			
			$this->_session->lock();		
		}
		return $this->_session;
	}
	
	
	public function setPostToken($token)
	{
		if (!$this->_session()->formToken) {
			$this->_session()->unlock();
			$this->_session()->formToken = strval($token);
			$this->_session()->lock();
		}
		return $this->_session()->formToken;
	}
	
	public function getPostToken()
	{
		$token = $this->_session()->formToken;
		$this->_session()->unlock();
		$this->_session()->formToken = null;
		unset($this->_session()->formToken);
		$this->_session()->lock();
		return $token;
	}
	
	public function __unset($var)
	{
		if (isset($this->_session()->$var)) {
			$this->_session()->unlock();
			unset($this->_session()->$var);
			$this->_session()->lock();
		} 
	}

	public function __get($v)
	{
		$var = '_' . $v;

		if ( (0 === strpos($v, 'is')) && (strtoupper($v[2]) === $v[2]) ) {
			$allowed = Zend_registry::get('Acl')->has(trim(substr($v, 2)));
			return $allowed;
		}
		if (isset($this->$v)) {
			return $this->$v;
		} else {
			if (isset($this->_session()->$v)) {
				return strval($this->_session()->$v);
			} elseif (isset($this->_details->$v)) {
				return $this->_details->$v;
			}
		}

		return null;
	}
	
	public function __call($method, $args)
	{
		if ($this->_details instanceof Showcase_User_Details) {
			if (method_exists($this->_details, $method)) {
				return call_user_func_array(array($this->_details, $method), $args);
			}
		}
	}
	
	public function __set($key, $val)
	{
		if ($this->_session()->isLocked()) {
			$this->_session()->unlock();
		}
		if (isset($this->_session()->$key)) {
			unset($this->_session()->$key);
		}
		$this->_session()->$key = $val;
		$this->_session()->lock();
	}	
	
	public function getSessionKey()
	{
		return $this->_auth->getStorage()->id;
	}
	
	public function getUserId()
	{
		return $this->_auth->getStorage()->userId;
	}
	
	
	public function getDetails()
	{
		if (!is_array($this->_details)) {
			$this->_loadDetails();
		}
		return $this->_details;
	}
	
	protected function _loadDetails()
	{
		$return 	= false;
		
		if ($this->_auth->hasIdentity()){
			$userId	= $this->_auth->getIdentity();

			try {
				$stmt 	= Zend_Registry::get('dbh')->proc('user_load_details');
				$stmt->bindParam(':user', $userId, PDO::PARAM_INT);
				$stmt->execute();
				
				$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();
				
				$this->_details	= Showcase_User_Details::factory($result);
			} catch(Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		}
		
		return $return;
	}
	
	public function getRoles()
	{
		if (!is_array($this->_roles)) {
			$this->_loadRoles();
		}
		return $this->_roles;
	}
	
	protected function _loadRoles()
	{
		$roles	= null;
		
		if ($this->_auth->hasIdentity()){
			$userId	= $this->_auth->getIdentity();
			
			try {
				$stmt 	= Zend_Registry::get('dbh')->proc('user_load_role');
				$stmt->bindParam(':user', $userId, PDO::PARAM_INT);
				$stmt->execute();
				
				$results = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();
				
				$rolesAssoc	= array();

				foreach($results as $result){
					if ( !array_key_exists($result->role_name, $rolesAssoc) ){
						$rolesAssoc[$result->role_name]	= Showcase_User_Role::factory($result);
					}else{
						$rolesAssoc[$result->role_name]->setResources($result);
					}
				}
				
				$roles	= array();
				foreach($rolesAssoc as $key => $val){
					$roles[]	= $rolesAssoc[$key];
				}
				
				unset($rolesAssoc);
			} catch(Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		}
		
		$this->_roles = $roles;
	}
	
	public function getRemoteAddress()
	{
		return $this->_auth->getStorage()->getRemoteIp();
	}
}