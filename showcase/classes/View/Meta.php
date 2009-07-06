<?php

class Showcase_View_Meta
{
	protected $_name;
	protected $_type;
	protected $_content;
	
	protected static $_allowedTypes = array('name', 'http-equiv');
	
	public function __toString()
	{
		return $this->_content;
	}
	
	public function __get($var)
	{
		$var = '_' . $var;
		if ( isset($this->$var) ) {
			return $this->$var;
		}
		return null;
	}
	
	protected function __construct($name, $content, $type)
	{
		$this->_name 	= (string) $name;
		$this->_type 	= (string) $type;
		$this->_content	= (string) $content;
	}
	
	public static function factory($name, $content, $type = 'name')
	{
		$type = (in_array($type, self::$_allowedTypes)) ? $type : 'name';
		return new self($name, $content, $type);
	}
}