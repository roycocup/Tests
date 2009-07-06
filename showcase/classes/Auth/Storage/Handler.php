<?php

class Showcase_Auth_Storage_Handler
{
		public $agent;
		public $page;
		public $start;
		public $update;
		//public $portal;
		
		public $key;

		protected $_userId;
		
		protected $_td;
		protected $_iv;
		protected $_ks;
		
		
		protected function _initCrypt()
		{
			/*
			if (extension_loaded('mcrypt')) {
				if (!$this->_td) {
					$this->_td = mcrypt_module_open(MCRYPT_RIJNDAEL_256, null, MCRYPT_MODE_ECB, null);
					$this->_iv = mcrypt_create_iv (mcrypt_enc_get_iv_size($this->_td), MCRYPT_RAND);
					$this->_ks = mcrypt_enc_get_key_size($this->_td);		
				}
				$this->_salt = substr(sha1($this->start . $this->key), 0, $this->_ks);	
				mcrypt_generic_init($this->_td, $this->_salt, $this->_iv);
				return true;
			}
			*/
			return false;
		}
		
		
		
		public function __construct()
		{
		}
		
		
		public function setUserId($userId, $session = false)
		{
			if ($this->_initCrypt()) {
				$userId = mcrypt_generic($this->_td, $userId);	
				mcrypt_generic_deinit($this->_td);
			}
			$this->_userId = $userId;
    
		}
		
		public function getUserId()
		{
			$userId = $this->_userId;
			if ($this->_initCrypt()) {
				$userId = mdecrypt_generic($this->_td, $userId);
				mcrypt_generic_deinit($this->_td);
			}
			return $userId;
		}
		
		public function hasExpired($sessionExpire)
		{
			if (! ((int) strtotime($this->update) + $sessionExpire > time()) ) {
				return true;
			}
			return false;
		}
		
		
}