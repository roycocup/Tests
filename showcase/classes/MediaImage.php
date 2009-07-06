<?php

class Showcase_MediaImage extends Showcase_Media_Abstract
{
	
	protected $_type;
	protected $_height;
	protected $_width;
	
	public static function factory(stdClass $result)
	{
		$self	= new self();
		//print_r($result); die;
		$self->_id					= $result->id;
		$self->_path				= $result->imagepath;
		$self->_alt					= $result->alt;
		$self->_type				= $result->imagetype;
		$self->_height				= $result->height;
		$self->_width				= $result->width;
		
		return $self;
	}
	
	public function __toString()
	{
		return strval($this->_path);
	}
	
	public function __set($v, $val)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			$this->$var = $val;
		}
		
		return false;
	}
	
	
}