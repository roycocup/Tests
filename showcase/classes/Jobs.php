<?php

class Showcase_Jobs
{
	protected $_id;
	protected $_number;
	protected $_image;
	protected $_thumb;
	protected $_article;
	protected $_document;
	protected $_published;
	protected $_created;
	protected $_updated;
	protected $_status;
	protected $_content;
	
	
	

	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	
	public function __set($v, $val)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			$this->$var = $val;
		}
		
		return false;
	}

	protected function __construct (){
	
		$this->_published		= new Zend_Date();
		$this->_created			= new Zend_Date();
		$this->_updated			= new Zend_Date();
	}
	
	public static function factory(stdClass $result)
	{
		$self	= new self();
		
		
		$self->_id				= $result->id;
		$self->_number			= $result->job_number;
		$self->_image			= array('THUMB'=>$result->thumb, 'MAIN'=>$result->image);
		$self->_article			= $result->article;
		$self->_published		->set($result->date_published);
		$self->_created			->set($result->created);
		$self->_updated			->set($result->updated);
		$self->_status			= $result->status;
		$self->_content			= $result->content;
		$self->_document 		= $result->document;
		

		return $self;
	}	
	
	
}