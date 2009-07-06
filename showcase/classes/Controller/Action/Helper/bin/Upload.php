<?php
class Showcase_Controller_Action_Helper_Upload extends Showcase_Controller_Action_Helper_Abstract
{
	const FILE_PERMISSIONS	= 0777;
	
	protected $_errorLog;
	protected $_uploadDir;
	
	public function direct($post, $path = null, $filename = null)
	{
		return $this->upload($post, $path, $filename);
	}
	
	public function upload($post, $path = null, $filename = null)
	{
		$return	= false;

		// Check if a file has been uploaded
		if (is_uploaded_file($post['tmp_name'])){
		
			// Setup the temporary upload path to store the file
			if (!$filename){
				$filename	= $post['name'];
			}
			$uploadPath	= Package::buildPath($this->getUploadDir($path) , $this->formatFileName($filename));
			
			// Move the uploaded file to a temporary location
			if (move_uploaded_file($post['tmp_name'], $uploadPath)) {
			
				// Set the permissions to the uploaded file
				if (chmod($uploadPath, self::FILE_PERMISSIONS)) {
				
					// Strip the document root out of the file if it exists
					if (substr($uploadPath, 0, strlen($_SERVER['DOCUMENT_ROOT'])) == realpath($_SERVER['DOCUMENT_ROOT'])){
						$return	= '/' . substr($uploadPath, strlen($_SERVER['DOCUMENT_ROOT'])+1);
					} else {
						$return	= $uploadPath;
					}
					
				// Declare errors in a log file
				} else {
					$this->errorLog("Could not set the permissions " . $permissions . " to the file " . $post['tmp_name']);
				}
			}else{
				$this->errorLog("Could not move file " . $post['tmp_name'] . " to the path " . $uploadPath);
			}
		} else {
			$this->errorLog("No file was uploaded");
		}
		
		// Return either the absolute path (not system path) or false
		return $return;
	}
	
	public function setUploadDir($path = null)
	{
		$defaultDir	= dirname(Package::buildPath($_SERVER['DOCUMENT_ROOT'], 'upload_temp', 'index.html'));
		$uploadDir	= ($path) ? $path : $defaultDir;
		
		if (!$this->_uploadDir = realpath($uploadDir)){
			$this->errorLog("The upload directory " . $uploadDir . " does not exists");
		}
		
		return $this->_uploadDir;
	}
	
	public function getUploadDir($path = null)
	{
		if (!$this->_uploadDir) {
			$this->setUploadDir($path);
		}
		
		return $this->_uploadDir;
	}
	
	public function formatFileName($filename)
	{
		$filename	= strtolower(str_replace(' ','_',$filename));
		
		return $filename;	
	}
	
	public function errorLog($message)
	{
		if (!$this->_errorLog){
			$this->_errorLog	= Package::buildPath($_SERVER['DOCUMENT_ROOT'], 'fileupload.log');
		}
		
		error_log($message . "\n", 3, $this->_errorLog);
	}
}