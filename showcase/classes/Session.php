<?php

abstract class Showcase_Session extends Zend_Session
{
	protected static $_sessionMethod;
	protected static $_sessionKey;
	protected static $_remoteIp;
	protected static $_userAgent;
	
	protected static $_ipValidator;
	
	const SESSION_GET		= 101;
	const SESSION_COOKIE	= 102;
	
	public static function checkIpRange($otherIp, $remoteIp = null)
	{
		$ipCheckDb 		= substr($otherIp, 0, 6);
		$ipCheckUser 	= substr($remoteIp, 0, 6);
		if ($ipCheckDb == $ipCheckUser) {	
			return true;
		} else {
			return false;
		}
	}

	public static function getSessionId(Zend_Controller_Request_Abstract $request)
	{
		$sessionKey = $request->getParam('sid', 0);
		$stmt = Zend_Registry::get('dbh')->proc('session_true_id_from_key');
		$agent = self::getuserAgentId($request);
		$stmt->bindParam(':key', $sessionKey, PDO::PARAM_STR);
		$stmt->bindParam(':agent', $agent, PDO::PARAM_INT);
		$stmt->execute();
		$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
		$stmt->closeCursor();
		if ($result) {
			$ipEncoded  = self::encodeIp(self::getRemoteIp($request));
			if (self::checkIpRange($result->ip, $ipEncoded)) {
				return $result->session;
			}
		}
		return null;
	}
	
	public static function setSessionKey($sessionKey)
	{
		self::$_sessionKey = $sessionKey;
	}
	
	public static function getSessionKey()
	{
		return (self::$_sessionKey) ? self::$_sessionKey : null;
	}
	
	public static function getuserAgentId(Zend_Controller_Request_Abstract $request)
	{
		if (!self::$_userAgent) {
			$agent = $request->getServer('HTTP_USER_AGENT');
			$stmt = Zend_Registry::get('dbh')->proc('session_user_agent');
			$stmt->bindParam(':agent', $agent, PDO::PARAM_STR);
			try {
				$stmt->execute();
			} catch (Zend_Db_Statement_Exception $e) {
				echo $e->getMessage();
			}
			
			
	
			$result = $stmt->fetch(Zend_Db::FETCH_OBJ);
			
			$stmt->closeCursor();
			if ($result) {
				self::$_userAgent = $result->id;
			}
		}
		return self::$_userAgent;
	}
	
	
	
	public static function getRemoteIp(Zend_Controller_Request_Abstract $request)
	{
		if (!self::$_remoteIp) {
			self::$_remoteIp = ($request->getServer('REMOTE_ADDR') ) ? $request->getServer('REMOTE_ADDR') : ( ( $request->getEnv('REMOTE_ADDR') ) ? $request->getEnv('REMOTE_ADDR') : $request->getServer('HTTP_X_FORWARDED_FOR') );
		}
		return self::$_remoteIp;
	}
	
	public static function encodeIp($ip = null)
	{
		// Used to encode an IP into a hexaddecimal value
		if (! $ip ) {
			$ip = self::getRemoteIp();
		}
		if (self::_ipValidate($ip)) {
			$ipSep = explode('.', $ip);
			return sprintf('%02x%02x%02x%02x', $ipSep[0], $ipSep[1], $ipSep[2], $ipSep[3]);
		}
		return null;

	}
	
	protected static function _ipValidate($ip)
	{
		if (!self::$_ipValidator instanceof Zend_Validate_Hostname) {
			self::$_ipValidator = new Zend_Validate_Hostname(Zend_Validate_Hostname::ALLOW_IP);
		}
		return self::$_ipValidator->isValid($ip);
	}
	
	public static function decodeIP($intIp) 
	{
		// Used to decode hex back into a real IP
		$hexIpBang = explode('.', chunk_split($intIp, 2, '.'));
		$ip = hexdec($hexIpBang[0]). '.' . hexdec($hexIpBang[1]) . '.' . hexdec($hexIpBang[2]) . '.' . hexdec($hexIpBang[3]);
		if (self::_ipValidate($ip)) {
			return $ip;
		}
	}	
}