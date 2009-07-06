<?php
/***************************************************************************
 *                                Session.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Barney Hanlon, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Controller_Plugin
 *	@version		v 1.0 Friday, June 15, 2007			
 *
 ***************************************************************************
 *
 */
 
// Check to see that this isn't being called by some little script kiddie
if ( !defined('NAMESPACE') )  {
	die('Hacking attempt');
	exit;
}

class Showcase_Controller_Plugin_Session extends Zend_Controller_Plugin_Abstract
{

	protected $_regex	= '@/sid/([0-9a-f*]+)$@';
	
	public function __construct()
	{
		
	}

	/**
     * routeStartup() - check to see if a session exists versus a given parameter
     *
     * @param  (Zend_Controller_Request_Abstract $request
     * @return void
     */
	public function routeStartup(Zend_Controller_Request_Abstract $request)
	{
		//$request->setParam('ClientId','1');
		$regenerate = false;
		$uri 		= $request->getRequestUri();
		if (preg_match($this->_regex, $uri, $uriKey)) {
			$sessionKey = $uriKey[1];
			unset($uriKey);
			// OK we have a session ID passed to us by $_GET
			// Check to see if a cookie exists for this user
			if (Showcase_Session::sessionExists()) {
				// Cookie exists, remove the SID param from the request
				$request->setParam('sid', null);
			} else {
				if (false === strpos($_SERVER['HTTP_USER_AGENT'], 'Googlebot')) {
					Showcase_Session::setSessionKey($sessionKey);
					// no session for this user
					// a get query and no session means either they are using an old link
					// or that they have really high security settings
					// let's go to the database and see if we can find them
					$regenerate = true;
					$sessionId = Showcase_Session::getSessionId($request); // checks database to get the true PHPSESSID
					if ($sessionId) {
						// they have a session in the database, set their current session as the existing one
						// and then regenerate it anyway as a security measure.
						try {
							Showcase_Session::setId($sessionId);
						} catch (Zend_Exception $e) {
							
							try {
								Showcase_Session::destroy(true);
							} catch (Zend_Exception $e) {						
							}
						}
					}		
					unset($sessionId);	// this is not a variable you want lying around.  Ever.  Unsetting just to be safe.
				}
			}
			$request->setRequestUri(preg_replace($this->_regex, '', $uri));
		}
		
		Showcase_Session::start();
		if ($regenerate) {
			Showcase_Session::regenerateId();
		}
	}
}