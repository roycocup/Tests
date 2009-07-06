<?php

class Showcase_Controller_Plugin_View extends Showcase_Controller_Plugin_Abstract
{
	protected $_portalAppended = false;
	
	public function routeStartup(Zend_Controller_Request_Abstract $request)
	{

		$request->setParam('View', Showcase_View_Smarty::factory('view.xml'));
		$request->getParam('View')->cache_handler_func = 'zend_cache_handler';
		$request->getParam('View')->caching = 0;
		$viewRenderer 	= new Showcase_Controller_Action_Helper_ViewRenderer();
		$viewRenderer	->setViewSuffix('tpl')
						->setView($request->getParam('View'))
						->setViewBasePathSpec(Package::buildPath(SITE_DIR, 'views'))
		;
		Zend_Controller_Action_HelperBroker::removeHelper('viewRenderer');
		Zend_Controller_Action_HelperBroker::addHelper($viewRenderer);
	}
	

}