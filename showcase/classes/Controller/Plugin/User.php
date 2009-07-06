<?php
/***************************************************************************
 *                             User.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Barney Hanlon, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Controller_Plugin
 *	@version		v 1.0 Wednesday, June 13, 2007			
 *
 ***************************************************************************
 *
 */

class Showcase_Controller_Plugin_User extends Showcase_Controller_Plugin_Cacheable_Abstract
{
	const NO_USERNAME			= 'Please enter your username';
	const NO_PASSWORD			= 'No password was entered';
	const LOGIN_FAILED			= 'Sorry, we couldn\'t log you in. Please check you details and try again';
	
	protected $_cachedStaticClass = 'Showcase_User';
	
	protected $_exceptions	= array();
	

	public function __construct()
	{
		$this->_initCache('user');
	}
	
    public function dispatchLoopStartup(Zend_Controller_Request_Abstract $request)
    {	
		
	}

	public function routeShutdown(Zend_Controller_Request_Abstract $request)
	{
		$auth = Zend_Auth::getInstance();
		$auth->setStorage(Showcase_Auth_Storage_Db::factory($request));
		if ($request->isPost()) {
			if ($request->getPost('login')){
				if ( !$this->_login($request) ){
					$request->getParam('View')->assign('exceptions', $this->_exceptions);
				}
			}
		}
		$user = Showcase_User::factory($auth->getIdentity());
		$request->setParam('User', $user);
		//$request->getParam('View')->register_object('user', $user);
		$request->getParam('View')->assign('user', $user);
	}
	
	protected function _login( Zend_Controller_Request_Abstract $request )
	{
		$userLogin	= $request->getPost('login');
		$userName	= trim($userLogin['alias']);
		$userPass	= trim($userLogin['pass']);
		
		if ($userName == '') {
			$this->_exceptions[] = self::NO_USERNAME;
			return false;
		}
		
		if ($userPass == '') {
			$this->_exceptions[] = self::NO_PASSWORD;
			return false;
		}
		
		$auth 			= Zend_Auth::getInstance();
		$adapter		= new Showcase_Auth_Adapter( $userName, $userPass );
		
		$result	= $auth->authenticate($adapter);
		
		if ( $result ){
			if ($result->getCode() !== Zend_Auth_Result::SUCCESS){
				// Let form know that login has failed...
				$this->_exceptions[]	= self::LOGIN_FAILED;
				return false;
			}
			
			// YAY! Authentication was a success
			return true;
		}
		
		return false;
	}
	
}