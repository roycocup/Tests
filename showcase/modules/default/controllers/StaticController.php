<?php

class StaticController extends Showcase_Controller_Action
{
	public function includeAction()
	{
		$this->_helper->ViewRenderer->setUseStage(false);
		
		if ( ($include = $this->_getParam('include', null)) && ($extension = $this->_getParam('extension', null)) ) {
			
			if (!strpos($include,'/')) {
				$include	= Package::buildPath($extension, $include);
			}

			switch($extension)
			{
				case 'css';
					header("Content-type: text/css");
				break;
				
				case 'js';
				break;
			}
			
			$this->view->assign('include', $include . '.' . $extension);
		}
		
	}

	public function downloadAction()
	{	
		$this->_helper->ViewRenderer->setNoRender();
		
		$mediaIdentifier	= $this->_getParam('mediaIdentifier',null);
		$extension			= $this->_getParam('extension',null);
		
		$media				= $this->_helper->Media->download($mediaIdentifier,$extension);
	
	}
	
	public function filepreviewAction()
	{
		$mediaIdentifier	= $this->_getParam('mediaIdentifier',null);
		$extension			= $this->_getParam('extension',null);
		
		$media				= $this->_helper->Media->filepreview($mediaIdentifier,$extension);
	}

}