<?php

class Showcase_Config
{
	protected $_id;
	protected $_name;
	protected $_type;
	protected $_ipRestricted;
	protected $_keyRestricted;
	protected $_ageRestricted;
	protected $_userRestricted;
	protected $_mountPoint;
	protected $_default;
	
	protected $_initialized;
	
	protected static $_configs = array();
	
	public static function factory($id, $type)
	{
		$config = new self;
		$config->_id 	= $id;
		$config->_type	= $type;
		return $config;
	}
	
	public function __toString()
	{
		if (!$this->_name){
			$this->_init();
		}
		
		return strval($this->_name);
	}

	public function __get($v)
	{
		$var = '_' . $v;
		if (property_exists($this, $var)) {
			return $this->$var;
		}
		return null;
	}

	protected function _init(stdClass $row = null)
	{
		if ( (!$this->_initialized) && (!$row) ) {
			$stmt = Zend_Registry::get('dbh')->prepare('CALL `config_load_by_id`(?)');
			//$stmt->bindParam(':config', $this->_id, PDO::PARAM_INT);
			$stmt->execute(array($this->_id));
			$row = $stmt->fetch(Zend_Db::FETCH_OBJ);
		}
		$this->_id 				= $row->id;
		$this->_name			= $row->name;
		$this->_type			= $row->type;
		$this->_ipRestricted	= (bool) $row->restrict_ip;
		$this->_userRestricted	= (bool) $row->restrict_user;
		$this->_keyRestricted	= (bool) $row->restrict_key;
		$this->_default			= (bool) $row->default;
		$this->_mountPoint		= $row->mount_point;
		$this->_initialized		= true;
	}
	
	public function isPreRecord()
	{
		return ('on demand' == $this->_type);
	}
	
	public function isVideo()
	{
		return ('text' == $this->_type) ? false : true;
	}
	
	private static function _fetchAll(Showcase_Admin $admin)
	{
		// static method used by the admin section to get back all instances of 
		if (!count(self::$_configs)) {
			$stmt = Zend_Registry::get('dbh')->prepare('CALL `admin_configs_fetch`(?, ?)');
			$stmt->execute(array($id, $type));
			$result = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
			$stmt->closeCursor();
			foreach ($result as $row) {
				$config = new self;
				$config->_init($row);
				self::$_configs[$config->id] = $config;
			}
		}	
	}
	
	public static function fetch(Showcase_Admin $admin, $type = null, $id = null)
	{
		self::_fetchAll($admin);
		return self::$_configs;
	}
	
	public static function getDefault(Showcase_Admin $admin)
	{
		self::_fetchAll($admin);
		foreach (self::$_configs as $config) {
			if ($config->_default) {
				return $config;
			}
		}
	}
}