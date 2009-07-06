<?php

class Showcase_User_Resource
{
	protected $_id;				// Resource Id
	protected $_name;			// Resource Name
	protected $_whitelist;		// Whitelist Status
	protected $_description;	// Description of resource
	
	public static function factory(stdClass $resource = null)
	{
		$self	= new self;
		$self->_init($resource);
		return $self;
	}
	
	public function __toString()
	{
		return $this->_name;
	}

	protected function _init(stdClass $resource = null)
	{
		if (null === $resource){
			return false;
		}
		
		$this->_id			= (int) $resource->resource_id;
		$this->_name		= $resource->resource_name;
		$this->_whitelist	= (bool) $resource->resource_whitelist;
		$this->_description	= $resource->resource_description;
	}
	
	public function __get($v)
	{
		$var = '_' . $v;
		
		if (property_exists($this, $var)) {
			return $this->$var;
		}
	}
}