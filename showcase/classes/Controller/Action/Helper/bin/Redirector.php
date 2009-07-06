<?php

class Showcase_Controller_Action_Helper_Redirector extends Zend_Controller_Action_Helper_Redirector
{
	protected function _appendSid(array $urlOptions = array())
	{
		if (!array_key_exists('sid', $urlOptions)) {
			if ($sessionId = Showcase_Session::getSessionKey()) {
				$urlOptions['sid'] = $sessionId;
			}		
		}
		return $urlOptions;
	}
	
	public function setGotoRoute(array $urlOptions = array(), $name = null, $reset = false)
	{
		$urlOptions = $this->_appendSid($urlOptions);
		parent::setGotoRoute($urlOptions, $name, $reset);
	}
	
	public function setGoto($action, $controller = null, $module = null, $params = array())
	{
		if (!is_array($params)) {
			$params = array();
		}
		$params = $this->_appendSid($params);
		parent::setGoto($action, $controller, $module, $params);
	}
	
}