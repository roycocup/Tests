<?php

abstract class Showcase_Controller_Action_Helper_Abstract extends Zend_Controller_Action_Helper_Abstract
{

	public function _cache()
	{
		return Showcase_Content_Cache::fetchCache();
	}

	
	
	public static function flushCache(array $tags = array())
	{
		Showcase_Content_Cache::flushCache();
	}
	
	protected function _makeId($method, $parameters) {
		return md5(get_class($this) . $method . serialize($parameters));
	}
	

	public function __call($method, $parameters)
	{
		$args = func_get_args();
		$id = $this->_makeId($method, $args);
		if ($this->_cache()->test($id)) {
			$return = $this->_cache()->load($id);
		} else {
			$name = '_' . $method;
			$return = call_user_func_array(array($this, $name), $parameters);
			$this->_cache()->save($return, $id);
		}
		return $return;
	}
	
	
}