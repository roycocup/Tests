<?php

class Showcase_Admin 
{
	protected static $_cache;
	

	//TODO: maybe I should move these two functions someplace more general
	public static function fetchCache()
	{
		if (!self::$_cache instanceof Zend_Cache) {
			$cacheSettings = Zend_Registry::get('site_cache_settings');
			self::$_cache = Zend_Cache::factory(
				'Core',
				$cacheSettings['BACKEND']['TYPE'],
				$cacheSettings['FRONTEND']['OPTIONS'],
				$cacheSettings['BACKEND']['OPTIONS']
			);		
		}	
		return self::$_cache;	
	}
	
	public static function flushCache()
	{
		self::fetchCache()->clean(Zend_Cache::CLEANING_MODE_ALL);
	}
	
	//param: array of objects, param: int
	public static function seekName($array, $id)
	{
		foreach ($array as $obj)
		{
			foreach($obj as $key=>$value)
			{
				if ($obj->id == $id)
				{
				return $obj->name;
				}
			}
		}
	}
	
	public static function getStatus()
	{
		$stmt = Zend_Registry::get('dbh')->proc('get_all_status');
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		
			return $result;
	}
	
	public static function getCategories()
	{
		$stmt = Zend_Registry::get('dbh')->proc('get_all_categories');
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		
			return $result;
	}
	
	public static function getTypes()
	{
		$stmt = Zend_Registry::get('dbh')->proc('get_all_types');
		try {
			$stmt->execute();
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
			$stmt->closeCursor();
			}catch (Zend_Db_Statement_Exception $e) {
				die($e->getMessage());
			}
		
			return $result;
	}
	
	
}
