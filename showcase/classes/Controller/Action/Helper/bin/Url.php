<?php

class Showcase_Controller_Action_Helper_Url extends Zend_Controller_Action_Helper_Url
{
    public function getRequest() 
    {
        if (null === $this->_request) {
            $this->_request = Zend_Controller_Front::getInstance()->getRequest();
        }

        return $this->_request;
    }
}