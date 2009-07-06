<?php

class Showcase_Acl
{
	protected $_acl;
	protected $_roles = array();
	
	protected function __construct()
	{
		$this->_acl = new Showcase_Acl_Adapter;
	}

	public function __call($method, $parameters)
	{
		$obj = null;
		if (method_exists($this->_acl, $method)) {
			$obj = $this->_acl;
		}
		if ($obj) {
			return call_user_func_array(array($obj, $method), $parameters);
		} else {
			die("Method $method is not a valid action for the Acl");
		}
	}

	public static function factory( $userRoles = null )
	{
		$self	= new self;
		
		if (null !== $userRoles){
			$self->_init($userRoles);
		}
		
		return $self;
	}
	
	public function hasRole($role)
	{
		return $this->_acl->hasRole($role);
	}
	
	public function has($resource)
	{
		return $this->_acl->has($resource);
	}
	
	protected function _init( $userRoles = null )
	{
		foreach ($userRoles as $userRole) {
			$roleName	= $this->_prepare($userRole);
			
			if ($roleName) {
				$inherits	= null;
				if ($userRole->inherits){
					$inherits	= $this->_prepare($userRole->inherits);
				}
	
				$this->_acl->addRole(new Zend_Acl_Role($roleName), $inherits);
			}

			foreach ($userRole->resources as $resource) {
				$resource	= $this->_prepare($resource);

				if(!$this->_acl->has($resource)){
					$this->_acl->add(new Zend_Acl_Resource($resource));
				}
				
				$this->_acl->allow($roleName, $resource);
				continue;
			}
		}
	}
	
	public function isAllowed($roles = null, $resource = null, $permission = null)
	{
		if ($role){
			$role		= $this->_prepare($role);
		}
		
		if ($resource){
			$resource	= $this->_prepare($resource);
		}
		
		if ($permission){
			$permission	= $this->_prepare($permission);
		}
		
		if (is_array($roles)){
			foreach ($roles as $role)
			{
				echo $role.' : '.$resource.' : '.'<br/>';
				if ( $this->_isAllowed($role, $resource, $permission) ) {
					return true;
				}
			}

			return false;
		}

		return $this->_isAllowed($roles, $resource, $permission) ? true : false;
	}
	
	protected function _isAllowed($role = null, $resource = null, $permission = null)
	{
		try {
			if ( $this->_acl->isAllowed($role, $resource, $permission) ) {
				return true;
			}
		} catch(Zend_Acl_Exception $e) {
			return false;
		}
	}
	
	protected function _prepare($v = null)
	{
		return str_replace(' ', '',ucwords(strtolower($v)));
		//return strtolower(str_replace(' ', '', $v));
	}
}