<?php

class Showcase_Admin_Content  extends Showcase_Controller_Action_Admin
{
	protected $_jobId;
	protected $_client;
	protected $_article;
	protected $_image;
	protected $_status;
	protected $_published;
	protected $_uploadPathImages;
	protected $_dbImagePath;
	protected $_operationType;
	protected $_contentId;
	protected $_oldImage;
	
	protected $_post; // the original post to return to view 
	
	public function __construct($content = null)
	{
		$this->_post = $content;
			
		(isset($content['contentId']))? $this->_contentId					= $content['contentId'] : NULL;
		(isset($content['operationType']))? $this->_operationType			= $content['operationType'] : NULL;
		(isset($content['client']))? $this->_client 						= $content['client'] : NULL; 
		(isset($content['jobId']))? $this->_jobId	 						= $content['jobId'] : NULL; 
		(isset($content['title']))? $this->_article['title']	 			= $content['title'] : NULL;
		(isset($content['description']))? $this->_article['description']	= $content['description'] : NULL;
		(isset($content['image']))? $this->_image							= $content['image'] : NULL;
		(isset($content['datePublished']))? $this->_published 				= $content['datePublished'] : NULL;
		(isset($content['status']))? $this->_status							= $content['status'] : NULL;
		(isset($content['client']))? $this->_uploadPathImages 	= Package::buildPath(DOC_DIR, 'document_root', 'images', 'clients', strtolower($this->_client['name']), 'campaigns') : NULL;
		(isset($content['client']))? $this->_dbImagePath 		= "/".Package::buildPath('images','clients', strtolower($this->_client['name']),'campaigns')."/" : NULL;
		(isset($content['oldImageName']))? $this->_oldImage 	= array('name'=>$content['oldImageName'], 'fullPath'=> $this->_uploadPathImages.DIRECTORY_SEPARATOR.$content['oldImageName']) : NULL;
	} 
	
	public function __call($method, $args)
	{
		$method = '_' . $method;
		
		if (method_exists($this, $method)) {
			return call_user_func_array(array($this, $method), $args);
		}
	}
	
	public function __set ($v, $val)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			$this->$var = $val;
		}
		
		return false;
		
	}

	public function __get($v)
	{
		$var	= "_" . $v;
		
		if (property_exists($this, $var)){
			return $this->$var;
		}
		
		return false;
	}
	
	public function processContent()
	{
		//validate
		$validation = $this->validate();
		if ($validation !== true)
		{
			$validation['post'] = $this->_post; 
			return $validation;
		} 
		
		
		//convert date into zend date object
		$this->_published = new Zend_Date($this->_published);
			
		
		//upload
		if ($this->_image['name'])
		{
			//upload the file
			$upload = $this->_uploadFile();
			
			//if its uploaded, lets puts some info next to the file
			$this->_image['fullPath'] = $this->_uploadPathImages.DIRECTORY_SEPARATOR.$this->_image['name'];
			$this->_image['path'] = $this->_dbImagePath.$this->_image['name'];
		}
		
		if (isset($upload['Error']))
		{
			$upload['post'] = $this->_post;
			return $upload;
		}

		//save db
		if ($this->_operationType == 'save')
		{
			$result = $this->_saveContent();
		}
		
		//update db
		if ($this->_operationType == 'update')
		{
			$result = $this->_updateContent();
		}
		
		if (isset($result) && $result == false)
		{
			//delte the file beeing uploaded
			$this->_deleteFile($this->_image);
			$result['post'] = $this->_post;
			$result['Error'][] = 'There was a problem saving to the database. Please try again later.';
			return $result;
		} else {
			//delete the old file
			if (isset($upload) && isset($this->_oldImage)){$this->_deleteFile($this->_oldImage);}
			return true;
		}
		
		
		
		
	}
				
	private function _saveContent()
	{
		//save data to db
		$oContent = new Showcase_Controller_Action_Helper_Admin_Content;
		$content = 	array(
					'jobId' 	=> $this->_jobId,
					'client'	=> $this->_client,
					'article'	=> $this->_article,
					'image'		=> $this->_image,
					'status'	=> $this->_status,
					'published'	=> $this->_published
					);
											
					
		
		$return = $oContent->saveNewContent($content);
		
		return $return;											
											
	}
	
	private function _updateContent()
	{ 
		//save data to db
		$oContent = new Showcase_Controller_Action_Helper_Admin_Content;
		$content = 	array(
					'contentId'	=> $this->_contentId,
					'article'	=> $this->_article,
					'image'		=> $this->_image,
					'status'	=> $this->_status,
					'published'	=> $this->_published
					);
											
					
		$return = $oContent->updateContent($content);
		
		return $return;
	}
	
	private function _deleteContent()
	{
		//delete the db
		$oDelete = new Showcase_Controller_Action_Helper_Admin_Content;
		$return = $oDelete->deleteContent($this->_contentId);
		
		if ($return !== true)
		{	
			$return['Error'][] = array('There is a problem deleting this phase. Please try again later.');
		}else{
			//delete the file
			$this->_deleteFile($this->_oldImage);
			return true;
		}

		return $return;
	}
	
	public function validate()
	{
		$validation = array();
		
		//instatiate a new validator
		$validator = new Showcase_Admin_Validator();
		
		//title validation
		if 	(empty($this->_article['title']))
		{
			$validation['Error'][] = 'Please fill in a title.';
		} else {
			if ($text = $validator->isValidText($this->_article['title'], 150))
			{
				if(is_array($text))
				{
					if (isset($text['Error']))
					{
						$validation['Error'][] = $text['Error'];  
					}
				}
			}
		}
		
		//description validation
		if 	(empty($this->_article['description']))
		{
			$validation['Error'][] = 'Please fill in a description.';
		} else {	
			if ($description = $validator->isValidText($this->_article['description'], 1000))
			{
				if(is_array($description ))
				{
					if (isset($description['Error']))
					{
						$validation['Error'][] = $description['Error'];   
					}
				}
			}
		}
		
		//image validation 
		if (isset($this->_image))
		{
			if ($this->_image['error'] != 0 && $this->_image['error']!= 4)
			{	
				$validation['Error'][] = array('Error'=>'Corrupt image. Please upload again.');
					
			} else {
				if ($this->_image['error']!= 4 && $imageValidation = $validator->isValidImage($this->_image, '500000', '200', '250', array('image/jpg', 'image/gif') ))
				{
					if (isset($imageValidation['Error']))
					{
						$validation['Error'][] = $imageValidation['Error']; 
					}
				}
			}
		}
		
		
		//date validation
		if 	(empty($this->_published))
		{
			$validation['Error'][] = 'Please insert a date.';
		} else {
			if ($dateValidation = $validator->isValidDate($this->_published, 'dd/mm/YYYY'))
			{
				if(is_array($dateValidation))
				{
					if (isset($dateValidation['Error']))
					{
						$validation['Error'][] = $dateValidation['Error'];
					}
				}
			}
		}
			
		
		
		if (!empty($validation))
		{ 
			return $validation;
		}else {
			return true;	
		}
		
		
	}
	
	private function _uploadFile()
	{
		//upload files object
		$upload = new Showcase_Admin_Uploader();
		
		$return = array();
		$upload->setUploadPath($this->_uploadPathImages);
		$upload->setFile($this->_image);
		$r = $upload->execute();
		if ($r !== true)
		{
			$return['Error'][] = $r['Error'];
		}
		
		return $return;
	}
	
	private function _deleteFile($file)
	{
		if(file_exists($file['fullPath']))
		{
			@unlink($file['fullPath']);
		}
	}

	
	
}