<?php

/***************************************************************************
 *                             Acl.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Chris Churchill, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		showcase.markettiers4dc.com
 *	@subpackage		Showcase
 *	@category		Controller_Plugin
 *	@version		v 2.0 Thursday, November 01, 2007			
 *
 ***************************************************************************
 *
 */

class Showcase_Controller_Plugin_Client extends Showcase_Controller_Plugin_Cacheable_Abstract
{
	protected $_cachedStaticClass = 'Showcase_Client';
	protected $_client;
	
	public function __construct()
	{
		$this->_initCache('client');
	}
	
	public function preDispatch(Zend_Controller_Request_Abstract $request)
	{
		if ( ($acl = Zend_registry::get('Acl')) ) {
			if ( $user = $request->getParam('User', null) ){
				if ( ($roles = $user->getRoles()) && (count($roles)) ) {
					$clientRole	= $roles[0];
					$clientHelper = Zend_Controller_Action_HelperBroker::getStaticHelper('Client');
					$client	= $clientHelper->loadByGroup($clientRole->id);
					
					$request->setParam('Client', $client);
					$request->getParam('View')->register_object('client', $client);
				}
			}
		}
	}
}