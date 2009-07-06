<?php
class Showcase_Controller_Helper_Action_PageMetaTags extends Zend_Controller_Action_Helper_Abstract
{
	protected static $_pageMetas = array();
	
	
	
	public function preDispatch()
	{
		
	}
	
	
	public function direct($name, $content, $type)
	{
		return $this->addTag($name, $content, $type);
	}
	
	protected function _viewInject()
	{
		$metaTags = (is_array($this->_actionController->view->metaTags)) ? $this->_actionController->view->metaTags : array();
		unset($this->_actionController->view->metaTags);
		$metaTags = array_merge($metaTags, self::$_pageMetas);
		$this->_actionController->view->assign('metaTags', $metaTags);
	}
	
	public function addTag($name, $content, $type)
	{
		$tag = Showcase_View_Meta::factory($name, $content, $type);
		if ($tag) {
			if (!isset(self::$_pageMetas[$tag->type])) {
				self::$_pageMetas[$tag->type] = array();
			}
			self::$_pageMetas[$tag->type][$tag->name] = $tag;
		}
		$this->_viewInject();
	}
	
	public function removeTag($name, $type = null)
	{
		if ($type) {
			if (array_key_exists($name, self::$_pageMetas[$type])) {
				unset(self::$_pageMetas[$type][$name]);
				return true;
			} else {
				foreach (self::_pageMetas as $type => $tags) {
					if ( array_key_exists($name, $tags) ) {
						unset(self::$_pageMetas[$type][$name]);
						return true;
					}
				}
			}
		}
		return false;
	}
	
	public function addRefresh($seconds = 10, $uri = null)
	{
		$type 		= 'http-equiv';
		$name 		= 'Refresh';
		$content	= $seconds;
		if ($uri) {
			$content .= ';url=' . $uri;
		}
		$this->addTag($name, $content, $type);
	}
	
	
}