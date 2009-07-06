<?php
class Showcase_Controller_Action_Helper_Model extends Showcase_Controller_Action_Helper_Abstract
{

	protected $_result;
	protected $_procName;
	protected $_bindParams = array();
	protected $_fetchType;
	protected $_stmt;
	
	
	public function __construct()
	{
		$this->_result = null;
		$this->_procName = null;
		$this->_bindParams = null;
		$this->_fetchType = null;
		$this->_stmt = null;
	}
	
	public function setProc ($procName)
	{
		$this->_procName = $procName;
	}
	/*
	public function setFetch ($fetchType)
	{
		$this->_fetchType = $fetchType;
	}
	*/
	public function setBind (array $bindParams)
	{	
		$this->_bindParams = $this->_loadBind($bindParams);
	}
	
	public function exec ()
	{
		$result = $this->_exec();
		return $result;
	}
	
	// $key: variable name / array([value]=>var value, [type]=>type...(int, string))
	protected function _loadBind ($bindParams)
	{
		foreach($bindParams as $key=>$value)
		{
			$this->_bindParams[$key] = $value;
		}
	}
	
	protected function _getStmt ()
	{
		
		$stmt = Zend_Registry::get('dbh');
		$this->_stmt = $stmt;
		return $this->_stmt;
	}
	
	protected function _exec ()
	{
		try{
			$this->_stmt = $this->_getStmt();
			$this->_stmt->proc($this->_procName);
			print_r($this->_bindParams); die();
			foreach($this->_bindParams as $key => $value)
			{
				$this->_stmt->bindParam(':'.$key, $_bindParam[value], (PDO::PARAM."_".strtoupper($_bindParam[type])));
			}
			try 
			{
				$this->_stmt->execute();
				$result = $this->_stmt->fetchAll(PDO::FETCH_OBJ);
				$this->_stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) 
			{
				die($e->getMessage());
			}
		}catch (Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		return $result;
	}

}