<?php

class loginController extends Showcase_Controller_Action
{
	public function __call($method, $paramters)
	{
		$this->_helper->ViewRenderer->setUseStage(false);
	}
}