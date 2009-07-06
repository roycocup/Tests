<?php

abstract class Showcase_Cache extends Zend_Cache
{

	public static		$availableBackends = array('File', 'Sqlite', 'Memcached', 'Apc', 'Zendplatform');

	protected static 	$_cacheEngine;
	protected static 	$_frontend	= array();
	protected static 	$_backend 	= array();
	
	
	public static function buildClassCache($cachedEntity, $prefix)
	{	
		if (!is_object($cachedEntity)) {
			// this should be a string of a class name and we are going to use static caching
			if (!class_exists($cachedEntity)) {
				// OK valid class
				return null;
			}
		}
		try {
			$cache = self::factory(
				'Class',
				self::_getBackendEngine(),
				self::_getFrontendOptions($cachedEntity),
				self::_getBackendOptions($prefix)
			);
		} catch (Zend_Exception $e) {
			die($e->getMessage());
		}
		if ($cache) {
			return $cache;
		}
	}
	
	protected static function _getBackendEngine()
	{
		if (!self::$_cacheEngine) {
			if ( (Zend_Registry::isRegistered('site_cache_settings')) && (Zend_Registry::get('site_cache_settings') instanceof Zend_Config) ) {
				$_cacheEngine = Zend_Registry::get('site_cache_settings')->backend->type;
			} else {
				self::$_cacheEngine = 'File';
			}
		
		}
		return self::$_cacheEngine;
	}
	
	protected static function _getFrontendOptions($cachedEntity)
	{
		return array(
			'cached_entity'	=> $cachedEntity,
		);
	}

	protected static function _getbackendOptions($prefix)
	{
		return array(
			'file_name_prefix'			=> $prefix,
			'cache_dir'					=> ZEND_CACHE_DIR,
			'hashed_directory_level'	=> 2,
		);
	}
}
