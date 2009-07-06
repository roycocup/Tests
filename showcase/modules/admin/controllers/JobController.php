<?php

class Admin_JobController extends Showcase_Controller_Action_Admin
{
	
	protected $_clients;
	protected $_status;
	protected $_clientName;
	protected $_jobNumbers;
	
	
	public function init ()
	{
		$mainMenu = new Showcase_Admin_Menus;
		$this->view->assign('mainMenu', $mainMenu->mainMenu);
		
		$this->_clients 		= $this->_helper->Job->loadClient(1); //the 1 is the status... should be string saying live?
		$this->_status		 	= Showcase_Admin::getStatus();
	}
	
	public function newAction ()
	{
		$title = 'Create a new job';
		$this->view->assign('title', $title);
		
		/*
		 * select a client and add a job number
		 */
		//populate the list of clients
		$this->view->assign('clients', $this->_clients);
		
		//fetch all the status available in the db
		$this->view->assign('status', $this->_status);
		$this->view->assign('requestUri', $this->getRequest()->getRequestUri());
		$this->view->assign('errorMessages', array());
		
		// if the form has come back...
		if ($this->getRequest()->isPost())
		{
			if ($post = $this->getRequest()->getPost('newJob'))
			{ 	
				// if the user forgot to set the client			
				if ($post['client'] == '')
				{
					$this->view->assign('errorMessages', array('Please select a client.'));
					$this->view->assign('posted', $post);
					return false; 
				} 
				
				//Turn client into an array with id and name
				$clientName = Showcase_Admin::seekName($this->_clients, $post['client']);
				$post['client'] = array('name'=>$clientName, 'id' => $post['client']);
				
				
				//put the files into the main post
				$this->getFilesIntoPost('image', $post, 'images', 'imageAlt');
				$this->getFilesIntoPost('thumb', $post, 'thumbs', 'thumbAlt');
				$this->getFilesIntoPost('document', $post, 'documents', 'docdescription');
				
				
				//validate, upload and saveDB
				$oJob = new Showcase_Admin_Job($post);
				$return = $oJob->saveNewJob();
				
				//print the errors returned with the sanitized post 
				if (isset($return['Error']))
				{
					// TODO: should be an array of messages 
					// TODO: How to keep the phases open and save the post data
					$this->view->assign('errorMessages', $return['Error']);
					$this->view->assign('posted', $return['post']);
					return false;
				}
				
				$this->_redirect('/admin/job/success');
			}
			
			$this->view->assign('errorMessages', array('There was a problem with your form, please submit again.'));
		}
				
	}

	public function editAction()
	{
		$title = 'Edit a Job';
		$this->view->assign('title', $title);
		
		//populate the list of clients
		$this->view->assign('clients', $this->_clients);

		// if the form has come back...
		if ($this->getRequest()->isPost())
		{
			//After selecting the client
			if ($client = $this->getRequest()->getPost('selectClient'))
			{
				// if the user sets an empty user		
				if ($client == '')
				{
					$this->view->assign('errorMessages', array('Please select a client.'));
					return false; 
				}
				
				//set the action and error
				$this->view->assign('requestUri', $this->getRequest()->getRequestUri());
				$this->view->assign('errorMessages', array());
				
				//Turn client into an array with id and name
				$clientName = Showcase_Admin::seekName($this->_clients, $client['client']);
				$posted = array('client'=>array('name'=>$clientName, 'id' => $client['client']));
				
				//keeping the selected client open correctly
				$this->view->assign('posted', $client);
				
				//then load and update the jobNumber list 
				$jobNumbers = $this->_helper->Job->getJobsNumbers($posted['client']['id']);
				
				//open the second select in the form and populate with jobs
				$this->view->assign('selectJob', 1);
				$this->view->assign('errorMessages', array());
				$this->view->assign('jobNumbers', $jobNumbers);
				
			}
			
			// after selecting a job number
			if($posted = $this->getRequest()->getPost('selectJob'))
			{
				//print_r($posted); die;
				//Turn client into an array with id and name
				$clientName = Showcase_Admin::seekName($this->_clients, $posted['client']);
				$posted['client'] = array('name'=>$clientName, 'id' => $posted['client']);
				
				//load and update the jobNumber list 
				$this->_jobNumbers 	= $this->_helper->Job->getJobsNumbers($posted['client']['id']);
				$this->view->assign('jobNumbers', $this->_jobNumbers);
				
				//fetch all the status available in the db 
				$this->view->assign('status', $this->_status);
				
				//keep the job number selection form open 
				$this->view->assign('selectJob', 1);
				
				//open the 3rd and last form
				$this->view->assign('jobChosen', $posted['jobId']);
				
				//get job using a already built frontend helper with a twist 
				//that we pass the name for a similar proc without the status requirement
				$dbJob = new Showcase_Controller_Action_Helper_Jobs;
				$posted['job'] =  $dbJob->loadJob($posted['client']['id'], $posted['jobId'], 'NULL', 'get_job_all_status');
				
				//instantiate the job object 
				$oJob = new Showcase_Admin_Job($posted);
				//strip the old frontend object for admin 
				$posted = $oJob->prepareObject($posted);
				
				//populate the form
				$this->view->assign('posted', $posted);
				//print_r($posted); die;
			}
			
			//if it was SUBMITTED for update
			if($posted = $this->getRequest()->getPost('editJob'))
			{
				//print_r($posted); die;
				//Turn client into an array with id and name
				$clientName = Showcase_Admin::seekName($this->_clients, $posted['client']);
				$posted['client'] = array('name'=>$clientName, 'id' => $posted['client']);
				
				if(!empty($_FILES['image']['name']) || !empty($_FILES['thumb']['name']))
				{
					//put the files into the main post
					$this->getFilesIntoPost('image', $posted, 'images', 'imageAlt');
					$this->getFilesIntoPost('thumb', $posted, 'thumbs', 'thumbAlt');
				}
				
				if(!empty($_FILES['document']['name']))
				{
					$this->getFilesIntoPost('document', $posted, 'documents', 'docdescription');
				}
				
				
				//go!
				$oJob = new Showcase_Admin_Job($posted);
				$return = $oJob->updateJob();
				
				//print the errors returned with the sanitized post 
				if (isset($return['Error']))
				{
					//keep the job number selection form open 
					$this->view->assign('selectJob', 1);
				
					//open the 3rd and last form
					$this->view->assign('jobChosen', $posted['jobId']);
					
					// TODO: should be an array of messages 
					$this->view->assign('errorMessages', $return['Error']);
					$this->view->assign('posted', $return['post']);
					return false;
				}
				
				$this->_redirect('/admin/job/success');
				
				
			}
			
		}
	}

	public function deleteAction()
	{
		// if the form has come back...
		if ($this->getRequest()->isPost())
		{
			//After selecting the client
			if ($delete = $this->getRequest()->getPost('deleteJob'))
			{
				//the post for what to delete comes from hidden fields in the view form into $delete
				$posted['client'] = array('id'=>$delete['clientId'], 'name'=>$delete['clientName']);
				$posted['jobId'] = $delete['jobId'];
				$posted['media']['images'][] = array('name'=>$delete['oldImageName']);
				$posted['media']['thumbs'][] = array('name'=>$delete['oldThumbName']);
				$posted['media']['documents'][] = array('name'=>$delete['oldDocName']);
				
				$oJob = new Showcase_Admin_Job($posted);
				$result = $oJob->deleteJob();	
				
				//print the errors returned with the sanitized post 
				if (isset($return['Error']))
				{
					// TODO: should be an array of messages 
					$this->view->assign('errorMessages', $return['Error']);
					$this->view->assign('posted', $return['post']);
					return false;
				}
				$this->view->assign('message', 'Job deleted');
			}
			
		}
	}
	
	public function getFilesIntoPost($gFileName, &$post, $category, $postAlt)
		{
			if ($_FILES[$gFileName]){
				$_FILES[$gFileName]['description']= $post[$postAlt];
				$post['media'][$category][] = $_FILES[$gFileName];	
				unset ($post[$postAlt]);
			}
		}
	
	public function successAction()
	{
		$this->view->assign('successMsg', 'The Job has successfully been saved');
	}	
		
}
