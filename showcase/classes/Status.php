<?php
class Showcase_Status
{
	protected $_id;
	protected $_name;
	

	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	
	public static function factory(stdClass $result)
	{
		$self	= new self();
		
		$self->_id				= $result->id;
		$self->_name			= $result->name;
		
		return $self;
	}
		
}