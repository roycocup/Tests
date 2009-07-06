<?php

abstract class Showcase_Media_Abstract
{

	protected $_id;
	protected $_name;
	protected $_path;
	protected $_type;
	protected $_mime;
	
	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	
	
	
}