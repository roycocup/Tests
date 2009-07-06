<?php

/* -------------------------------------------------
 Client Class for login
------------------------------------------------- */
class Showcase_Controller_Action_Helper_Login extends Showcase_Controller_Action_Helper_Abstract {
	

	public function direct($login)
	{
		$return = $this->_confirmLogin($login);
		return $return;
	}
	
	
	
	//check
	protected function _confirmLogin($login){
		
	}
	
}