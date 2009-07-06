<?php

class Showcase_Content
{
	protected $_id;
	protected $_media;
	protected $_article;
	protected $_image;
	protected $_status;
	protected $_published;
	protected $_updated;
	protected $_created;
	

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
	
		$this->_published		= new Zend_Date(null, Zend_Registry::get('locale'));
		$this->_created			= new Zend_Date(null, Zend_Registry::get('locale'));
		$this->_updated			= new Zend_Date(null, Zend_Registry::get('locale'));
	}
	
	public static function factory(stdClass $result)
	{
		$self	= new self();
		
		$self->_id				= $result->id;
		$self->_media			= $result->media;
		$self->_article			= $result->article;
		$self->_image			= $result->image;
		$self->_status			= $result->status;
		$self->_published		->set($result->published);
		$self->_updated			->set($result->updated);
		$self->_created			->set($result->created);
		
		
		return $self;
	}
	
	public function getMediaByIdentifier($identifier)
	{
		if ( (!$this->media) || (is_array($this->media) && 1 > count($this->media)) ) {
			return false;
		}
		
		foreach($this->media as $media){
			if ($media instanceof Showcase_Media) {
				if (trim(strtolower($identifier)) === strtolower($media->identifier) ) {
					return $media;
				}
			}
		}
		
		return false;
	}
	
	
}