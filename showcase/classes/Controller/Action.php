<?php

class Showcase_Controller_Action extends Zend_Controller_Action
{
    public function __construct(Zend_Controller_Request_Abstract $request, Zend_Controller_Response_Abstract $response, array $invokeArgs = array())
    {
        $this->setRequest($request)
             ->setResponse($response)
             ->_setInvokeArgs($invokeArgs);
             
        $this->_helper = new Showcase_Controller_Action_HelperBroker($this);
        $this->init();
    }



}