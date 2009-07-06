<?php

class Showcase_User_Role
{
	protected $_id;						// Group Id
	protected $_name;					// Name of the group
	protected $_inherits;				// Id of the group this inherits from
	protected $_code;					// Error code
	protected $_resources;				// Array of resource objects
	
    public static function factory( stdClass $role )
    {
		$self	= new self;
		$self->_set($role);
		
        return $self;
    }

	public function __toString()
	{
		return $this->_name;
	}
	
	public function __get($v)
	{
		$var = '_' . $v;
		
		if (property_exists($this, $var)) {
			return $this->$var;
		}
	}
	
	protected function _set( stdClass $role )
	{
		$this->_id			= (int) $role->role_id;
		$this->_name		= $role->role_name;
		$this->_inherits	= $role->inherit_name;
		$this->_code		= $role->code;
		
		$this->_setResources( $role );
	}
	
	public function setResources( stdClass $role ){
		$this->_setResources( $role );
	}
	
	protected function _setResources( stdClass $role ){
		if(!is_array($this->_resources)){
			$this->_resources	= array();
		}
		
		$this->_resources[]	= Showcase_User_Resource::factory( $role );
	}
}