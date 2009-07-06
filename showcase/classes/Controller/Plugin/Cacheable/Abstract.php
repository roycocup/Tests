<?php
/***************************************************************************
 *                                Abstract.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Barney Hanlon, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Controller_Plugin
 *	@version		v 1.0 Wednesday, June 13, 2007	
 *	@abstract		
 *
 ***************************************************************************
 *
 */

abstract class Showcase_Controller_Plugin_Cacheable_Abstract extends Showcase_Controller_Plugin_Abstract
{
	protected function _initCache($class = 'cache')
	{
		$cache = '_' . $class;
		if (! (isset($this->$cache)) || ($this->$cache instanceof Zend_Cache) ) {
			if ( ($this->_cachedStaticClass) && (class_exists($this->_cachedStaticClass)) ) {
				// build a cache object based around the $_cachedEntity
				$this->$cache = Showcase_Cache::buildClassCache($this->_cachedStaticClass, get_class($this));
			}
		}
	}
}