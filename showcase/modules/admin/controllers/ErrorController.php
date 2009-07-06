<?php
/** Zend_Controller_Action */
require_once 'Zend/Controller/Action.php';

class ErrorController extends Zend_Controller_Action_Admin
{
    public function errorAction()
    {
	print "error catched"; die;
    }
}

