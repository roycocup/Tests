<?php

class Showcase_Category
{
	protected $_id;
	protected $_identifier;
	protected $_url;
	protected $_name;
	protected $_inherits;
	protected $_order;
	protected $_status;
	protected $_howmany;
	protected $_children;
	
	
	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	/*
	public function __set($k, $v) 
	{
		$this->k = $v;
	}
	*/	
	public static function factory(stdClass $result, $children = null, $howmany = null)
	{
		$self	= new self();
		
		$self->_id			= isset($result->id) ? $result->id : NULL;
		$self->_identifier	= isset($result->identifier) ? $result->identifier : NULL;
		$self->_url			= isset($result->url) ? $result->url : NULL;
		$self->_name		= isset($result->name) ? $result->name : NULL;
		$self->_inherits	= isset($result->inherits) ? $result->inherits : NULL;
		$self->_order		= isset($result->order) ? $result->order : NULL;
		$self->_status		= isset($result->status) ? $result->status : NULL;
		
		if (isset($result->howmany)){
			$self->_howmany		= $result->howmany;
		}
		if (isset($result->children)) {
			$self->_children	= $result->children;
		}
		
		
		
		return $self;
	}	
	
	public function __toString()
	{
		return strval($this->_identifier);
	}
	
	public function __construct($id = null)
	{
		if ($id) {
			$this->_id	= $id;
		}
	}
	
	
	
	
}