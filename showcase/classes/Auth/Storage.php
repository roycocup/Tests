<?php
/***************************************************************************
 *                             Db.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Barney Hanlon, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Auth
 *	@version		v 1.0 Wednesday, June 13, 2007			
 *
 ***************************************************************************
 *
 */
class Showcase_Auth_Storage_Db extends Zend_Auth_Storage_Session
{
	protected $_sessionData;
	
	protected $_pKey;
	protected $_userAgent;
	protected $_remoteIp;
	protected $_sessionMethod;
	protected $_portal;
	
	const SESSION_EXPIRY 	= 30;
	const USER_ANONYMOUS 	= -1;
	const SESSION_GET		= 101;
	const SESSION_COOKIE	= 102;
	

	public static function factory(Prometheus_Portal $portal)
	{
	
	}
	
	public function __construct()
	{
		parent::__construct();
		$this->_timeStamp = time();
		$this->_pKey = Prometheus_Session_Key::factory();

		$this->_remoteIp 	= $this->_encodeIp( (!empty($_SERVER['REMOTE_ADDR']) ) ? $_SERVER['REMOTE_ADDR'] : ( ( !empty($_ENV['REMOTE_ADDR']) ) ? $_ENV['REMOTE_ADDR'] : $_SERVER['HTTP_X_FORWARDED_FOR'] ));
		$this->_userAgent	= $_SERVER['HTTP_USER_AGENT']; // This is useful not only for spoofing but also for statistics
	}	
	
	public function getRemoteIp()
	{
		return $this->_decodeIp();
	}
	
	protected function _encodeIP($dotQuadIp) 
	{
		// Used to encode an IP into a hexaddecimal value
		$ipSep = explode('.', $dotQuadIp);
		return sprintf('%02x%02x%02x%02x', $ipSep[0], $ipSep[1], $ipSep[2], $ipSep[3]);
	}

	protected function _decodeIP ($intIp = $this->_remoteIp) 
	{
		// Used to decode hex back into a real IP
		$hexIpBang = explode('.', chunk_split($intIp, 2, '.'));
		return hexdec($hexIpBang[0]). '.' . hexdec($hexIpBang[1]) . '.' . hexdec($hexIpBang[2]) . '.' . hexdec($hexIpBang[3]);
	}	

	protected static function salt($string, $salt = '') 
	{
		// Private function
		// Used to make the hash *really* hard to bust
		// Returns a hash
		return sha1($string . $salt);
		// better security with sha1
	}
}