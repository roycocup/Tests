<?php

class Showcase_Article
{
	protected $_id;
	protected $_title;
	protected $_body;
	protected $_html;

	private $_loaded;

	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			if (!$this->$var && !$this->_loaded) {
				$this->_load();
			}
			
			return $this->$var;
		}
		
		return false;
	}
	
	public static function factory(stdClass $result)
	{
		$self	= new self();
		$self->_init($result);
		
		return $self;
	}
	
	public function __construct($id = null)
	{
		if ($id) {
			$this->_id	= $id;
		}
	}
	
	public function __toString()
	{
		if (!$this->_body && !$this->_loaded) {
			$this->_load();
		}
		
		return strval( ($this->_html) ? $this->_body : self::_toHtml($this->_body) );
	}
	
	protected static function _toHtml($text)
	{
		$len = strlen($text);
		$res = "";
		for ($i = 0; $i < $len; ++$i) {
			$ord = ord($text{$i});
			// check only non-standard chars          
			if ($ord >= 126){ 
				$res .= "&#" . $ord .";";
			} else {
				$res .= htmlentities($text{$i});                  
			}
		}
		return nl2br($res);	
	}
	
	protected function _init(stdClass $result)
	{
		$this->_id		= isset($result->id) ? $result->id : NULL;
		$this->_title	= isset($result->title) ? $result->title : NULL;
		$this->_body	= isset($result->body) ? $result->body : NULL;
		$this->_html	= isset($result->html) ? $result->html : NULL;
	}
	
	protected function _load()
	{
		$id = $this->_id;
		
		if (!$id) {
			return false;
		}
		
		try {
			$stmt = Zend_Registry::get('dbh')->proc('load_article_by_id');
			$stmt->bindParam(':id', $id, PDO::PARAM_INT);
			$stmt->execute();
			
			$result = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		}catch(Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		if ($result) {
			$this->_init($result);
		}
		
		$this->_loaded	= true;
	}
	
}