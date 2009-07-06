<?php
class ContentController extends Showcase_Controller_Action 
{

	public function init()
	{
	
		$client 		= $this->_getParam('Client', null);
		$contentId		= $this->_getParam('contentId', null);
		$jobId			= null;
		
		$clientStatus = 1;
		
		$client	= $this->_helper->Client->getClientContent($client->id, $contentId, $clientStatus);
		
		
		//print_r($client); die;
		$jobId	= $this->_getParam('jobId',null);
		if ($jobId) {
			$this->view->assign('jobId',$jobId);
		} else {
			$this->_helper->Redirector->gotoUrl('/');
		}
		
		if ($mediaIdentifier = $this->_getParam('mediaIdentifier', null) ) {
			if ($content = $client->justContent ) {
				if ($displayMedia = $content->getMediaByIdentifier($mediaIdentifier)) {
					$this->view->assign('media', $displayMedia);		
				}
			}
		}


		
		$this->view->assign('banner', $client->banner);
		$this->view->assign('cont', $client->justContent);
		//print_r($client->justContent); die;
		
		// category tree for this client
		$tree = $client->categories;
		$this->view->assign('tree', $tree);
		
	}

	
	public function __call($method, $vars)
	{
	
	}
}