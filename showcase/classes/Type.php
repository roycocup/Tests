<?php
class Showcase_Type
{
	protected $_id;
	protected $_name;
	
	public static function factory($id)
	{
		$self	= new self($id);
		return $self;
	}
	
	public function __construct($id)
	{
		$this->_id	= $id;
		$this->_load();
	}
	
	public function __get($v)
	{
		if ( 0 === strpos($v, 'is') ) {
			$var	= substr($v, 2);
			if ( strtolower($this->name) == strtolower($var) ) {
				return $this->_name;
			} else {
				return false;
			}
		}
	
		$var	= "_" . $v;
		if (property_exists($this, $var)) {
			if (!$this->$var){
				$this->_load();
			}
			return $this->$var;
		}
	}
	
	public function __toString()
	{
		return strval($this->_id);
	}
	
	protected function _load()
	{
		if (!($id = $this->_id)) {
			return false;
		}
		
		try {
			$stmt = Zend_Registry::get('dbh')->proc('load_type_by_id');
			$stmt->bindParam(':id', $id, PDO::PARAM_INT);
			$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		}catch (Zend_Db_Statement_Exception $e) {
			die($e->getMessage());
		}
		
		
		$this->_id		= $result->id;
		$this->_name	= $result->name;
	}
	
}