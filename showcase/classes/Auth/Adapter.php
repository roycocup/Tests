<?php
/***************************************************************************
 *                                Adapter.php
 *                            -------------------    	
 *  @copyright  	Copyright (c) 2007 markettiers4dc
 *	@author			Chris Churchill, Senior Developer <webmaster@markettiers4dc.com>
 *	@package		Webchats.tv
 *	@subpackage		Prometheus
 *	@category		Auth
 *	@version		v 1.0 Monday, October 1, 2007			
 *
 ***************************************************************************
 *
 */
class Showcase_Auth_Adapter implements Zend_Auth_Adapter_Interface
{
    /**
     * $_identity - Identity value
     *
     * @var string
     */
    protected $_identity = null;

    /**
     * $_credential - Credential values
     *
     * @var string
     */
    protected $_credential = null;


    /**
     * __construct() - Sets configuration options
     *
     * @param  string                   $identity
     * @param  string                   $credential
     * @return void
     */
    public function __construct($identity = null, $credential = null)
    {
        if (null !== $identity) {
            $this->setIdentity($identity);
        }

        if (null !== $credential) {
            $this->setCredential($credential);
        }
	}
	
    /**
     * setIdentity() - set the value to be used as the identity
     *
     * @param  string $value
     * @return Zend_Auth_Adapter_DbTable
     */
    public function setIdentity($value)
    {
        $this->_identity = $value;
        return $this;
    }

    /**
     * setCredential() - set the credential value to be used, optionally can specify a treatment
     * to be used, should be supplied in parameterized form, such as 'MD5(?)' or 'PASSWORD(?)'
     *
     * @param  string $credential
     * @return Zend_Auth_Adapter_DbTable
     */
    public function setCredential($credential)
    {
        $this->_credential = $credential;
        return $this;
    }

    /**
     * authenticate() - defined by Zend_Auth_Adapter_Interface.
     *
     * @throws Zend_Auth_Adapter_Exception if answering the authentication query is impossible
     * @return Zend_Auth_Result
     */
	public function authenticate()
	{
        // create result array ready to pass to the Zend_Auth_Result
        $authResult = array(
				'code'     => Zend_Auth_Result::FAILURE,
				'identity' => $this->_identity,
				'messages' => array()
            );

        $exception = null;

        if ($this->_identity == '') {
            $exception = 'A value for the identity was not provided prior to authentication with Showcase_Auth_Adapter.';
        } elseif ($this->_credential === null) {
            $exception = 'A credential value was not provided prior to authentication with Showcase_Auth_Adapter.';
        }

        if (null !== $exception) {
            $authResult['code'] 		= Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID;
            $authResult['messages'][]	= $exception;
            return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
        }

        // query for the identity
		if ( $stmt = Zend_Registry::get('dbh')->proc('user_login') ) {
			$stmt->bindParam(':userName', $this->_identity, PDO::PARAM_STR);
			$stmt->bindParam(':userPass', $this->_credential, PDO::PARAM_STR);
			
			try {
				$stmt->execute();
				$resultIdentities = $stmt->fetchAll(Zend_Db::FETCH_OBJ);
				$stmt->closeCursor();
			} catch (Exception $e) {
				$authResult['code'] 		= Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID;
				$authResult['messages'][]	= 'The supplied details failed, please check the identity and credential for validity.';
				return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
			}
		}

        if (count($resultIdentities) < 1) {
            $authResult['code'] 		= Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND;
            $authResult['messages'][]	= 'A record with the supplied details could not be found.';
            return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
        } elseif (count($resultIdentities) > 1) {
            $authResult['code'] 		= Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS;
            $authResult['messages'][]	= 'More than one record matches the supplied identity.';
            return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
        }
		
        $resultIdentity = $resultIdentities[0];

        if ($resultIdentity->credential_match != '1') {
            $authResult['code'] 		= Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID;
            $authResult['messages'][]	= 'Supplied credential is invalid.';
            return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
        }

        unset($resultIdentity->credential_match);

        $authResult['code'] 		= Zend_Auth_Result::SUCCESS;
        $authResult['identity']		= $resultIdentity->userId;
        $authResult['messages'][]	= 'Authentication successful.';
		
        return new Zend_Auth_Result($authResult['code'], $authResult['identity'], $authResult['messages']);
	}
}