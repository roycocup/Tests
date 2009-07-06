<?php
class JobsController extends Showcase_Controller_Action 
{

	
	public function init()
	{
		
		$client 		= $this->_getParam('Client', null);
		$jobId			= $this->_getParam('jobId', null);
		
		
		$clientStatus = 1;
		
		$client	= $this->_helper->Client->getClientJob($client->id, $jobId, $clientStatus);
		
		$this->view->assign('banner', $client->banner);
		$this->view->assign('job', $client->jobs);
		
		//$media	= $client->jobs->content[0]->media[0]->cue;

		if ($mediaIdentifier = $this->_getParam('mediaIdentifier', null) ) {
			if ($client->jobs instanceof Showcase_Jobs) {
				if (count($client->jobs->content) && ($contents = $client->jobs->content) ) {
					foreach($contents as $content){
						if ($displayMedia = $content->getMediaByIdentifier($mediaIdentifier)) {
							$this->view->assign('media', $displayMedia);		
							break;
						}
					}
				}
			}
		}
		
		// category tree for this client
		$tree = $client->categories;
		$this->view->assign('tree', $tree);		
	}	
	
	
	
	/* *******************************************************
	 call function	
	******************************************************* */		
	public function __call($method, $paramters) 
	{
		
	}

}