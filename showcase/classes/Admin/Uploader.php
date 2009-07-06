<?php

class Showcase_Admin_Uploader
{

	protected $_errors ;
	protected $_uploadPath;
    protected $_fileName;
    protected $_tmpName;

    
   	public function setUploadPath($path)
   	{
   		$this->_uploadPath = $path.DIRECTORY_SEPARATOR;
   	} 
    
   	public function setFile(array $file)
    {
    	//this file has been validated before
    	//so there is no need to check if it has errors or is empty
    	$this->_fileName 	= $file['name'];
    	$this->_tmpName 	= $file['tmp_name'];
    	$this->_fileSize 	= $file['size'];
    }

   	public function execute ()
   	{
   		if (!empty($this->_errors))
   		{
   			return $this->_errors;
   		}
   		
   		if (!empty($this->_fileName) && !empty($this->_tmpName) && !empty($this->_uploadPath))
   		{
   			$return = $this->_upload();
   			return $return;
   		}
   		
   		return true;
   	}

	protected function _upload()
    {
        if(!is_uploaded_file($this->_tmpName))
        {
        	$this->_errors['Error'] = "File ".$this->_filename." was not correctly uploaded.";	
        }
        
        //construct the full upload path
		$uploadPath = $this->_uploadPath.$this->_fileName ;

		//go for it!
   		if (!file_exists($uploadPath)) 
   		{ 
   		   	//Attempt to move the uploaded file to it's new place
        	if (!@move_uploaded_file($this->_tmpName,$uploadPath)) 
        	{
           		$this->_errors['Error'] =  "Error: A problem occurred during ".$this->_fileName." file upload. Please try again.";
        	} 
      	} else {
        	$this->_errors['Error'] =  "Error: File " . $this->_fileName . " already exists";
      	}
      	
      	if (!empty($this->_errors))
      	{ 
      		return $this->_errors;
      		
      	} else {
      		
      		return true; 
      	}
      	

		
		
    }
	
	
}
