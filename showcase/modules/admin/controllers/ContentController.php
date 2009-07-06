<?php

class Admin_ContentController extends Showcase_Controller_Action_Admin
{
	
	protected $_jobId;
	protected $_clientId;
	protected $_job;
	protected $_content;
	protected $_status;
	protected $_clients;
	protected $_clientName;
	
	public function init()
	{
		$mainMenu = new Showcase_Admin_Menus;
		$this->view->assign('mainMenu', $mainMenu->mainMenu);
		$this->_jobId = $this->_getParam('jobId');
		$this->_clientId = $this->_getParam('clientId');
		
		//load the job 
		$job = new Showcase_Controller_Action_Helper_Jobs;
		$this->_job =  $job->loadJob($this->_clientId, $this->_jobId, 'NULL', 'get_job_all_status');
		
		//list of status
		$this->_status = Showcase_Admin::getStatus();
		//get the list of clients
		$this->_clients = $this->_helper->Job->loadClient(1); 
		//fetch the name of the client from the id
		$this->_clientName = Showcase_Admin::seekName($this->_clients, $this->_clientId);
		
	}
	
	
	public function indexAction()
	{
		if (empty($this->_job->content[0]))
		{
			$hasContent = false;
		} else {
			$hasContent = true;
		}
		
		
		if ($hasContent !== true)
		{
			$this->view->assign('message', 'There are no phases in this job. Would you like to create one?');
			$this->view->assign('content', $this->_job->content);
			$this->view->assign('newPhaseLink', '/admin/content/new/'.$this->_jobId.'/'.$this->_clientId);
		} 
		
		if ($hasContent === true) 
		{
			//select a phase to edit or do you want to edit an existing phase?
			$this->view->assign('message', 'Please select a Phase to edit or create a new one on the link below.');
			$this->view->assign('content', $this->_job->content);
			$this->view->assign('hasContent', '1');
			$this->view->assign('requestUri', '/admin/content/edit/'.$this->_jobId.'/'.$this->_clientId);
			$this->view->assign('newPhaseLink', '/admin/content/new/'.$this->_jobId.'/'.$this->_clientId);
		}
		
		return false;
	}
	
	public function newAction()
	{	
		$this->view->assign('requestUri', $this->getRequest()->getRequestUri());
		$this->view->assign('jobId', $this->_jobId);
		$this->view->assign('title', 'Add a phase');
		
		//fetch all the status available in the db 
		$this->view->assign('status', $this->_status);
		
		//if save is submitted
		if ($this->getRequest()->isPost())
		{
			if ($post = $this->getRequest()->getPost('addContent'))
			{
				//put the files into the main post
				if ($_FILES['image'])
				{
					$post['image'] = $_FILES['image'];
					$post['image']['description'] = $post['description'];
					unset ($post['imageAlt']);  
				}
				
				// jobId and clientId in the post
				$post['jobId'] 		= $this->_jobId;
				$post['clientId'] 	= $this->_clientId; 
				
				//Turn client into an array with id and name
				$clientName = Showcase_Admin::seekName($this->_clients, $post['clientId']);
				$post['client'] = array('name'=>$clientName, 'id' => $post['clientId']);
				unset($post['clientId']);
				
				//specify the operation type
				$post['operationType'] = 'save'; 
				
				//validate, upload and saveDB
				$oContent = new Showcase_Admin_Content($post);
				$return = $oContent->processContent();
				
				//print errors
				if (isset($return['Error']))
				{
					$this->view->assign('errorMessages', $return['Error']);
					$this->view->assign('posted', $return['post']);
					return false;
				}
				
				//if successful
				$this->_redirect('/admin/content/success');
			}
			
			$this->view->assign('errorMessage', 'There was a problem with your form, please submit again.');
		}
	}
	
	public function editAction()
	{
		$this->view->assign('requestUri', $this->getRequest()->getRequestUri());
		$this->view->assign('jobId', $this->_jobId);
		$this->view->assign('clientId', $this->_clientId);
		$this->view->assign('title', 'Edit a phase');
		
		
		//if update is submitted
		if ($this->getRequest()->isPost())
		{
			if ($contentId = $this->getRequest()->getPost('selectContent'))
			{
				//get content by id out of all contents in a job
				foreach ($this->_job->content as $key=>$cont)
				{	
					if ($cont->id == $contentId['contentId'])
					{
						$this->_content = $cont; 
					}
				}
				
				//get the file name for the image.
				$this->_content->image->name = $this->getFileName($this->_content->image->path);
				
				//populate the form
				$this->view->assign('posted', $this->_content);	
				
				//fetch all the status available in the db 
				$this->view->assign('status', $this->_status);
				
				//set the action and error
				$this->view->assign('requestUri', $this->getRequest()->getRequestUri());
			}
			
			//if submitted
			if ($post = $this->getRequest()->getPost('editContent'))
			{
				if(!empty($_FILES['image']['name']))
				{
					$_FILES['image']['description'] = $post['imageAlt'];
					unset ($post['imageAlt']);
					$post['image'] = $_FILES['image'];
				}
				
				//Turn client into an array with id and name
				$post['client'] = array('name'=>$this->_clientName, 'id' => $this->_clientId);
				
				//insert the jobid in the post
				$post['jobId'] = $this->_jobId;  
				
				//specify the operation type
				$post['operationType'] = 'update'; 
			
				//update the content
				$oContent = new Showcase_Admin_Content($post);
				$return = $oContent->processContent();
				
				//print errors
				if (isset($return['Error']))
				{
					$this->view->assign('errorMessages', $return['Error']);
					$this->view->assign('posted', $return['post']);
					return false;
				}
				
				//if successful
				$this->_redirect('/admin/content/success');
			
			}
			
			
			
			
		}
		
		
		
		
	}
	
	public function deleteAction()
	{
		if ($post = $this->getRequest()->getPost('deleteContent'))
		{
			//get the name of the client
			$post['client'] = array('name'=>$this->_clientName, 'id' => $this->_clientId);
			
			//in this case, im passing the contentId on the url and im getting it on the init as jobId
			$post['contentId'] = $this->_jobId ;
			
			//the post for what to delete comes from hidden fields in the view form into $delete
			$post['image']['name'] = $post['oldImageName'];
			
			//get the object
			$oContent = new Showcase_Admin_Content($post);
			$return = $oContent->deleteContent();	
			
			//print the errors returned with the sanitized post 
			if (isset($return['Error']))
			{
				$this->view->assign('errorMessage', $return['Error']);
				$this->view->assign('posted', $return['post']);
				return false;
			}
			//if no errors
			$this->view->assign('message', 'Phase deleted');
		}
		
		return false;
		
	}
	
	public function selectAction()
	{
		print "select a client, select job... then select phase";
		die;
	}
	
	public function successAction()
	{
		$this->view->assign('successMsg', 'The phase has successfully been saved');
	}
	
	public function getFileName($imagePath)
	{
		$filename = explode('/', $imagePath);
		$total = count($filename)-1;
		return $filename[$total];
	}
	
}