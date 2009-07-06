<?php

class Showcase_Admin_Job  extends Showcase_Controller_Action_Admin
{
	protected $_post;
	protected $_clientName;
	protected $_uploadPathImages;
	protected $_uploadPathMedia;
	protected $_dbMediaPath;
	protected $_dbImagePath;
	
	
	public function __construct($post)
	{
		$this->_post = $post;
		$this->_clientName = strtolower($this->_post['client']['name']);
		$this->_uploadPathImages = Package::buildPath(DOC_DIR, 'document_root', 'images', 'clients', strtolower($this->_clientName), 'campaigns').DIRECTORY_SEPARATOR;
		$this->_uploadPathMedia = Package::buildPath(DOC_DIR, 'document_root', 'media', strtolower($this->_clientName)).DIRECTORY_SEPARATOR;
		$this->_dbImagePath = DIRECTORY_SEPARATOR.Package::buildPath('images','clients', strtolower($this->_clientName),'campaigns').DIRECTORY_SEPARATOR;
		$this->_dbMediaPath = DIRECTORY_SEPARATOR.Package::buildPath('media', strtolower($this->_clientName)).DIRECTORY_SEPARATOR;
	}
	
	/*
	 * will validate the post, upload files and prepare the $post for db insert
	 */
	public function saveNewJob()
	{
		if ($this->_post)
		{ 	
			//clean possible scriptings
			foreach ($this->_post as $key=>$value)
			{	
				if ($key == 'client' ||  $key == 'media')
				{
					continue;
				} else {
					$this->_post[$key] = Zend_Filter::get($value, 'StripTags');
				}
			}
			
			//validate the post
			$validation = $this->validate($this->_post);
			if (isset($validation['Error']))
			{
				$validation['post'] = $this->_post; 
				return $validation;
			}  
			
			//convert date into zend date object
			$this->_post['datePublished'] = new Zend_Date($this->_post['datePublished']);
			
			//prepare the files for db insertion (add paths(full and db), identifier ...)
			$this->_prepareFilesForDb($this->_post['media']);
			
			
			//upload the files
			$return = $this->_upload($this->_post['media']);
			//print_r($return); die;
			if ($return !== true )
			{ 
				//return the post for the form population
				$return['post'] = $this->_post; 
				return $return;
				
			}
			
			//save data to db
			$oJob = new Showcase_Controller_Action_Helper_Admin_Job;
			$return = $oJob->saveNewJob($this->_post);
			
			//confirm
			if ($return == false)
			{ 
				//delete the files
				foreach ($this->_post['media'] as $aFiles)
				{
					$this->_deleteFiles($aFiles);
				}
					
				//report error to screen
				$return['post'] = $this->_post; 
				$return['Error'] = 'There was a problem saving to the database. Please try again later.';
				return $return;
				
			} else {
				//flush cache
				Showcase_Admin::flushCache();
						
				//return success
				return true;	
			}
			
		}
	}
	
	public function updateJob()
	{
		if ($this->_post)
		{ 	
			//print_r($this->_post); die;
			//clean possible scriptings
			foreach ($this->_post as $key=>$value)
			{	//TODO: the files and pahses through the sanit.
				if ($key == 'client' ||  $key == 'media')
				{
					continue;
				} else {
					$this->_post[$key] = Zend_Filter::get($value, 'StripTags');
				}
			}
			
			//validate the post
			$validation = $this->validate($this->_post);
			if (isset($validation['Error']))
			{
				$validation['post'] = $this->_post; 
				return $validation;
			} 
			
			//convert date into zend date object
			$this->_post['datePublished'] = new Zend_Date($this->_post['datePublished']);
			
			 
			//prepare the files for db insertion (add paths(full and db), identifier ...)
			if (isset($this->_post['media'])){
				$this->_prepareFilesForDb($this->_post['media']);
			}
			
			
			//upload the new files 
			if (isset($this->_post['media']))
			{
				$return = $this->_upload($this->_post['media']);
				if ($return !== true )
				{  
					//return the post for the form population
					$return['post'] = $this->_post; 
					return $return;
				}
			}

			
			//update data in db
			$oJob = new Showcase_Controller_Action_Helper_Admin_Job;
			$return = $oJob->updateJob($this->_post);
			
			//confirm
			if ($return == false)
			{
				//delete the uploaded files
				if (isset($this->_post['media']))
				{
					//Delete the files
					foreach ($this->_post['media'] as $aFiles)
					{
						$this->_deleteFiles($aFiles);
					}
				}
				
				//report error to screen
				$return['post'] = $this->_post; 
				$return['Error'] = 'There was a problem saving to the database. Please try again later.';
				return $return;
				
			} else {
				
				if (isset($this->_post['media']))
				{
					//delete old files since the new ones are there now.
					foreach ($this->_post['media'] as $key=>$value)
					{
						if ($key == 'images')
						{ //print $this->_uploadPathImages.$this->_post['oldImage']; die;
							if(file_exists($this->_uploadPathImages.$this->_post['oldImageName']))
							{ 
								@unlink($this->_uploadPathImages.$this->_post['oldImageName']);
								@unlink($this->_uploadPathImages.$this->_post['oldThumbName']);
							}
						}
						
						if ($key == 'documents')
						{
							if(file_exists($this->_uploadPathMedia.$this->_post['oldDocName']))
							{
								@unlink($this->_uploadPathMedia.$this->_post['oldDocName']);
							}
						}
					}
				}
				
				
				//flush cache
				Showcase_Admin::flushCache();
						
				//return success
				return true;	
			}
			
		}
		
	}
	
	public function deleteJob()
	{
		//prepare the files for db insertion (add paths(full and db), identifier ...)
		$this->_prepareFilesForDb($this->_post['media']);
		
		//Delete the files
		//TODO: move to bin and if errors put'em back
		foreach ($this->_post['media'] as $aFiles)
		{
			$this->_deleteFiles($aFiles);
		}
		
		//delete job in db
		$oJob = new Showcase_Controller_Action_Helper_Admin_Job;
		$return = $oJob->deleteJob($this->_post['jobId']);
		if ($return == true)
		{
			//flush cache
			Showcase_Admin::flushCache();
			return true;
		}else{
			return false;
		}
	}
	
	public function validate ($post) 
	{
		$validation = array();
		
		if (empty($post))
		{
			$validation['Error'][] = 'No information submitted!';
			return $validation;
		}
		
		//instatiate a new validator
		$validator = new Showcase_Admin_Validator();
		
		
		//job number validation
		if (empty($post['number']))
		{
			$validation['Error'][] = 'Please enter a Job Number.';
		} elseif (!is_numeric($post['number'])) {
			
			$validation['Error'][] = 'Job number is not exclusively numeric';
		}
		

		//title validation
		if 	(empty($post['title']))
		{
			$validation['Error'][] = 'Please fill in a title.';
		} else {
			if ($titleValidation = $validator->isValidText($post['title'], 150))
			{
				if(is_array($titleValidation))
				{
					if (isset($titleValidation['Error']))
					{
						$validation['Error'][] = $titleValidation['Error'];  
					}
				}
			}
		}
		
		//description validation	
		if ($descriptionValidation = $validator->isValidText($post['description'], 1000))
		{
			if(is_array($descriptionValidation))
			{
				if (isset($descriptionValidation['Error']))
				{
					$validation['Error'][] = $descriptionValidation['Error'];  
				}
			}
		}
		
			
		//image validation 
		if (isset($post['media']['images']) && $images = $post['media']['images'])
		{
			foreach ($images as $image)
			{
				if ($image['error'] != 0 && $image['error']!= 4)
				{	
					$validation['Error'][] = 'Corrupt image. Please upload again.';
					
				} else {
					if ($image['error']!= 4 && $imageValidation = $validator->isValidImage($image, '500000', '200', '250', array('image/jpg', 'image/gif') ))
					{
						if (isset($imageValidation['Error']))
						{
							$validation['Error'][] = $imageValidation['Error']; 
						}
					}
				}
			}
		}
		
		//thumb validation 
		if (isset($post['media']['thumbs']) && $thumbs = $post['media']['thumbs'])
		{
			foreach ($thumbs as $thumb)
			{
				if ($thumb['error'] != 0 && $thumb['error']!= 4)
				{	
					$validation['Error'][] = 'Corrupt image. Please upload again.';
					
				} else {
					if ($thumb['error']!= 4 && $thumbValidation = $validator->isValidImage($thumb, '500000', '200', '250', array('image/jpg', 'image/gif') ))
					{
						if (isset($thumbValidation['Error']))
						{
							$validation['Error'][] =  $thumbValidation['Error'];
						}
					}
				}
			}
		}
		
		
		//document validation
		if (isset($post['media']['documents']))
		{
			foreach ($post['media']['documents'] as $document)
			{
				if ($document['error']!= 0 && $document['error']!= 4)
				{
					$validation['Error'][] = 'Corrupt document or empty field. Please upload again.';
				
				} else {
					if ($document['error']!= 4 && $docValidation = $validator->isValidDocument($document, '500000', array('doc', 'pdf') ))
					{
						if (isset($docValidation['Error']))
						{
							$validation['Error'][] = $docValidation['Error'];   
						}
					}
				}
			}
		}
		
		
		//date validation
		if ($dateValidation = $validator->isValidDate($this->_post['datePublished'], 'dd/mm/YYYY'))
		{
			if(is_array($dateValidation))
			{
				if (isset($dateValidation['Error']))
				{
					$validation['Error'][] = $dateValidation['Error'];  
				}
			}
		}
		
		//return true or errors
		if (!empty($validation))
		{ 
			return $validation;
		}else {
			return true;	
		}
		
		
	}
	
	private function _upload($aMedia)
	{	
		foreach ($aMedia as $key => $aFiles)
		{
			//making a diferent upload path for the images that are not media
			//this is specific to the Job object
			if ($key == 'images' || $key == 'thumbs')
			{
				$uploadPath = $this->_uploadPathImages;
				
			}else{
				$uploadPath = $this->_uploadPathMedia;
			}
			
			foreach ($aFiles as $aFile)
			{
				//TODO: here... if theres a problem with one file, delete the already uploaded
				// do an array with those uploaded (if not the same name of old ones) and use it if error.
				$return = $this->_startUpload($aFile, $uploadPath);
				
				// check if the upload was unsuccessfull
				if ($return !== true)
				{
					$return['post'] = $this->_post;
					return $return;
				}
			}
		}
		return true;
	}
	
	private function _startUpload($aFile, $uploadPath)
	{
		//upload files object
		$upload = new Showcase_Admin_Uploader();
		
		$upload->setUploadPath($uploadPath);
		$upload->setFile($aFile);
		$return = $upload->execute();
		
		return $return;
				
	}
	
	private function _prepareFilesForDb(&$aMedia)
	{
		foreach ($aMedia as $key => $aFiles)
		{
			//making a diferent upload path for the images that are not media
			//this is specific to the Job object
			if ($key == 'images' || $key == 'thumbs')
			{
				$uploadPath = str_replace('\\', '/', $this->_uploadPathImages);
				$dbPath 	= str_replace('\\', '/', $this->_dbImagePath);
			}else{
				$uploadPath = str_replace('\\', '/', $this->_uploadPathMedia);
				$dbPath 	= str_replace('\\', '/', $this->_dbMediaPath);
			}
			
			foreach ($aFiles as $key2=>$aFile)
			{	
				//set identifier
				if (!empty($aFile['name'])){
					$fn = explode('.', $aFile['name']);
					$identifier = str_ireplace(' ','_',strtolower($fn[0]));
				
					$aMedia[$key][$key2]['identifier'] 		= $identifier;
					$aMedia[$key][$key2]['path'] 			= $dbPath.$aFile['name']; 
					$aMedia[$key][$key2]['fullPath']		= $uploadPath.$aFile['name'];
				} else {
					$identifier 							= time();
					$aMedia[$key][$key2]['identifier'] 		= $identifier;
					$aMedia[$key][$key2]['path'] 			= null; 
					$aMedia[$key][$key2]['fullPath']		= null;
				}
			}
		}
				
	}
	
	private function _deleteFiles($aFiles)
	{
		foreach ($aFiles as $file)
		{
			if(file_exists($file['fullPath']))
			{
				@unlink($file['fullPath']);
			}
		}
	}
	
	private function _getFilename($sFile)
	{
		//fetches the name of the file in the end of a path
		$filename = basename($sFile);
		return $filename;
	}
	
	public function prepareObject($object)
	{
		//print_r($object['job']->published->tostring('d/M/y')); die;
		//print_r($object); die;
		$client 		= $object['client'];
		$number 		= $object['job']->number;
		$jobId	 		= $object['jobId'];
		$title 			= $object['job']->article->title;
		$description 	= $object['job']->article->body;
		$datePublished 	= $object['job']->published;
		$dateUpdated	= new Zend_Date(Zend_Date::TIMESTAMP);
		$status			= $object['job']->status;
		
		$imageFilename 	= $this->_getFilename($object['job']->image['MAIN']->path);
		$images[] 		= array(	'id'=>$object['job']->image['MAIN']->id,
									'name'=>$imageFilename, 
									'type'=>'', 
									'tmp_name'=>'', 
									'error'=>'', 
									'size'=>'', 
									'description'=>$object['job']->image['MAIN']->alt
									);
		
		$thumbFilename 	= $this->_getFilename($object['job']->image['THUMB']->path);
		$thumbs[]		= array(	'id'=>$object['job']->image['THUMB']->id,
									'name'=>$thumbFilename, 
									'type'=>'', 
									'tmp_name'=>'', 
									'error'=>'', 
									'size'=>'', 
									'description'=>$object['job']->image['THUMB']->alt
									);
									
		
		$documents[]	= array(	'id'=>$object['job']->document->id,
									'name'=>$object['job']->document->name, 
									'type'=>'', 
									'tmp_name'=>'', 
									'error'=>'', 
									'size'=>'', 
									'description'=>$object['job']->document->description->body
									);
		
		$media = array('images'=>$images, 'thumbs'=>$thumbs, 'documents'=>$documents);
		$phases = $object['job']->content;
		
		$this->_post = array(
							'client'		=>$client, 
							'jobNumber'		=>$number, 
							'jobId'			=>$jobId,
							'title'			=>$title, 
							'description'	=>$description, 
							'datePublished'	=> $datePublished,
							'dateUpdated'	=> $dateUpdated,
							'status'		=>$status,
							'media'			=>$media,
							'phases'		=>$phases
							);
		
		//add a few more info lines into the media arrays
		$this->_prepareFilesForDb($this->_post['media']);	
		
		//print_r($this->_post); die;
		return $this->_post;
		
	}
	
	
	
	
	
}

