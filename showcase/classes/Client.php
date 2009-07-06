<?php

class Showcase_Client
{
	protected $_categories;
	protected $_id;
	protected $_name;
	protected $_identifier;
	protected $_status;
	protected $_created;
	protected $_updated;
	protected $_jobs;
	protected $_banner;
	protected $_justContent;

    /**
     * Singleton instance
     *
     * @var Showcase_Client
     */
    protected static $_instance = null;

    /**
     * Singleton pattern implementation makes "clone" unavailable
     *
     * @return void
     */
    private function __clone()
    {}

    /**
     * Returns an instance of Showcase_Client
     *
     * Singleton pattern implementation
     *
     * @return Showcase_Client Provides a fluent interface
     */
    public static function getInstance()
    {
        if (null === self::$_instance) {
            self::$_instance = new self();
        }

        return self::$_instance;
    }

	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	
	protected function __construct ()
	{
		$this->_created			= new Zend_Date(null, Zend_Registry::get('locale'));
		$this->_updated			= new Zend_Date(null, Zend_Registry::get('locale'));
	}
	
	public static function factory(stdClass $result)
	{
		//$self	= self::getInstance();
		$self 				= new self();
		$self->_id			= $result->id;
		$self->_name		= $result->name;
		$self->_identifier	= $result->identifier;
		$self->_status		= $result->status;
		$self->_created		->set($result->created);
		$self->_updated		->set($result->updated);
		$self->_banner		= $result->banner;
		
		if (isset($result->jobs)){
			$self->_jobs = $result->jobs;
		}
		
		if (isset($result->content)){
			$self->_justContent = $result->content;
		}
		
		if (isset($result->categories)) {
			$self->_categories	= $result->categories;
		}
		
		return $self;
	}	
}