<?php
/***************************************************************************
 *                             Acl.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Chris Churchill, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Controller_Plugin
 *	@version		v 2.0 Thursday, November 01, 2007			
 *
 ***************************************************************************
 *
 */

class Showcase_Controller_Plugin_Acl extends Showcase_Controller_Plugin_Cacheable_Abstract
{
	protected $_cachedStaticClass = 'Showcase_Acl';
	protected $_acl;
	
	public function __construct()
	{
		$this->_initCache('acl');
	}
	
	public function routeShutdown(Zend_Controller_Request_Abstract $request)
	{
		$displayLogin = true;
		
		if ( $user = $request->getParam('User', null) ) {
			if ( "-1" !== $user->getUserId() ) {
				$displayLogin = false;
				$acl = Showcase_Acl::factory($user->getRoles());		// Only load the Users ACL roles and resources
				Zend_registry::set('Acl', $acl);						// Register the Acl for user access
			} else {
				$displayLogin = true;
				Zend_registry::set('Acl', NULL);						// Register the Acl for user access
			}
		}
		
		if ($displayLogin) {
			if ( ("include" !== strtolower($request->getActionName())) && ("static" !== strtolower($request->getControllerName())) ) {
				$request->setModuleName('default')
						->setControllerName('Login')
						->setActionName('index')
						->setDispatched(false);
			}
		}
	}
}