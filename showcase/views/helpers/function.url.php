<?php

function smarty_function_url($params, Smarty $smarty)
{
	$url = null;
	if ( ($urlHelper = Showcase_Controller_Action_HelperBroker::getStaticHelper('url')) && ($urlHelper instanceof Showcase_Controller_Action_Helper_Url)  ) {
		$assignVar = null;
		$uriParams = array();
		foreach ($params as $key => $val) {
			if ('assign' == $key) {
				$assignVar = $val;
			} elseif (!$val) {
			} else {
				$uriParams[$key] = strval($val);
			}
		}

		if (array_key_exists('route', $uriParams)) {
			// this is a route
			$routeName = $uriParams['route'];
			unset($uriParams['route']);
			try {
				$url = $urlHelper->url($uriParams, $routeName, true);
			} catch (Zend_Exception $e) {
				echo $e->getMessage();
			}
		} else {
			foreach (array('action', 'controller', 'module') as $key) {
				if (array_key_exists($key, $uriParams)) {
					$$key = $uriParams[$key];
					unset($uriParams[$key]);
				} else {
					$$key = null;
				}
			}
			$url = $urlHelper->simple($action, $controller, $module, $uriParams, true);
		}
		
		if (0 !== strpos(strrev($url), '/')) {
			$url.= '/';
		}
		
		if ($sessionId = Showcase_Session::getSessionKey()) {
			$url.= "sid/$sessionId";
		}
		$url = ($url) ? ( (0 === strpos($url, '/')) ? $url : '/' . $url ) : '#';
		if (!$assignVar) {
			echo $url;
		} else {
			$smarty->assign($assignVar, $url);
		}
	}
}