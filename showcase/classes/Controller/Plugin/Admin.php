<?php
class Showcase_Controller_Plugin_Admin extends Showcase_Controller_Plugin_Abstract
{
	public function routeShutdown(Zend_Controller_Request_Abstract $request)
	{
		if ( ('admin' == $request->getModuleName()) && ('Login' != $request->getControllerName()) ) {
			// Immediate ACL check to make sure they have identity
			$allowUser = (defined('DEBUG_MODE')) ? true : false;

			// blacklist system
			$user	= $request->getParam('User', null);
			
			if ( $user instanceof Showcase_User ) {
				// OK user has identity, check the roles
				//$allowUser = Zend_registry::get('Acl')->isAllowed($user->getRoles(), "CMS User") ? true : false;
				$allowUser = $user->isCmsaccess;
			}

			if (!$allowUser) {
				$request->setControllerName('Login')
						->setModuleName('index')
						->setActionName('index')
						->setDispatched(false);
			} else {
				Showcase_Controller_Action_HelperBroker::addPath(Package::buildPath(SITE_DIR, 'classes', 'Controller', 'Action', 'Helper', 'Admin'), 'Showcase_Controller_Action_Helper_Admin');	
				// Cretae a new helper path for administrative privileges
				//$request->setParam('Admin', Showcase_Admin::getInstance());
				
				// Set the instance of the Admin object
				//$request->getParam('View')->assign('admin', $request->getParam('Admin'));
				// And inject it into the view so it can help things for Smarty

				// Include the CMS JS scripts
				//$request->getParam('View')->assign('javaScripts', array('/include/js/admin/js/cms'));

				// Check if the user wants to force a manual cache clearance
				//if ($request->getParam('flushCache')) {
				//	Showcase_Content_Cache::flushCache();
				//}

			}
		}
	}


}