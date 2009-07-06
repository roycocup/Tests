<?php

class Showcase_User_Details
{
	protected $_username;
	protected $_firstname;
	protected $_lastname;
	protected $_email;
	protected $_created;
	protected $_updated;
	protected $_clientId;
	protected $_loaded;
	
	public static function factory(stdClass $result)
	{
		$self	= new self;
		$self->_load($result);
		return $self;
	}
	
	public function __construct()
	{
		$this->_created 		=  new Zend_Date(null, Zend_Registry::get('locale'));
		$this->_updated 		=  new Zend_Date(null, Zend_Registry::get('locale'));
	}
	
	public function __toString()
	{
		return $this->getName();
	}
	
	public function __get($v)
	{
		$var	= '_' . $v;
		
		if (property_exists($this, $var)) {
			if ( (!$this->$var) && (!$this->_loaded) ) {
				$this->_init();
			}
			
			return $this->$var;
		}
		
		return false;
	}
	
	protected function _init()
	{
		$auth	= Zend_Auth::getInstance();
		
		if ($auth->hasIdentity()) {
			$userId	= $auth->getIdentity();
			
			try {
				$stmt 	= Zend_Registry::get('dbh')->proc('user_load_details');
				$stmt->bindParam(':user', $userId, PDO::PARAM_INT);
				$stmt->execute();
				
				$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();
				
				$this->_load($result);
				
			} catch(Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		}
		
	}
	
	protected function _load(stdClass $result)
	{
		$this->_username	= (isset($result->username)) 	? $result->username 	: NULL;
		$this->_firstname	= (isset($result->firstname)) 	? $result->firstname 	: NULL;
		$this->_lastname	= (isset($result->lastname)) 	? $result->lastname 	: NULL;
		$this->_email		= (isset($result->email)) 		? $result->email 		: NULL;
		$this->_clientId	= (isset($result->clientId)) 	? $result->clientId 	: NULL;
		
		if (isset($result->created)) {
			$this->_created->set($result->created, Zend_Date::TIMESTAMP);
		}
		
		if (isset($result->updated)) {
			$this->_updated->set($result->updated, Zend_Date::TIMESTAMP);
		}
		
		$this->_loaded	= true;
	}
	
	public function getName()
	{
		if (!$this->firstname) {
			$string	= $this->_username;
		} else {
			$string	= $this->firstname;
			if ($this->lastname) {
				$string	.= " " . $this->lastname;
			}
		}
		
		return strval($string);
	}
}