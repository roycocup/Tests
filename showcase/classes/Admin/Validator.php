<?php
class Showcase_Admin_Validator
{
	protected $_fileName;
	
	
	public function isValidText($value, $maxLenghtValue)
	{
		
		$validator = new Zend_Validate;
		// Create a validator chain and add validators to it
		$validator		->addValidator(new Zend_Validate_NotEmpty())
					   	->addValidator(new Zend_Validate_StringLength(1, $maxLenghtValue));
		
		// Validate the value
		if ($validator->isValid($value)) {
			return true;
		}else{
		    // value failed validation; print reasons
		    foreach ($validator->getMessages() as $message) {
		        return array('Error'=>$message);
    		}			
		}
	}
		
	public function isValidDate($value, $format) 
	{
		
		if (empty($value))
		{	
			$message = 'Date can not be empty.';
			return array('Error'=>$message);
		}
			
		$validator = new Zend_Validate_Date;
		$validator->setFormat($format);
		
		if ($validator->isValid($value)) {
			return true;
		}else{
		    // value failed validation; print reasons
		    foreach ($validator->getMessages() as $message) {
		        return array('Error'=>$message);
    		}			
		}
	}
	
	public function isValidImage($file, $max, $height, $width, $allowedTypes)
	{

		//check if its a proper image
		if ($file)
		{
			if (!$file['size'] )
			{
				return array('Error'=>'Image: The file does not appear to be a proper image');
			}
		}
		
		//check size
		$validator = new Zend_Validate_Between('1', $max);
		
		if ($validator->isValid($file['size'])) 
		{
			
		}else{
		    // value failed validation; print reasons
		    foreach ($validator->getMessages() as $message) {
		        return array('Error'=>'Image:' . $message);
    		}			
		}
		
		//this validator uses GD
		if ($fileSizes = getimagesize ($file['tmp_name']))
		{
			$mime = $fileSizes['mime'];
			$actualWidth = $fileSizes[0];
			$actualHeight = $fileSizes[1];
			//check sizes
			if ($actualHeight > $height)
			{
				return array('Error' => 'Image height is bigger than ' . $height . ' pixels');
			}
			if ($actualWidth > $width)
			{
				return array('Error' => 'Image width is bigger than ' . $width . ' pixels');
			}
			
			
			//check type
			$validator = new Zend_Validate_InArray($allowedTypes);
			
			if($valid = $validator->isValid($mime))
			{
				if ($valid != '1')
				{
					foreach ($validator->getMessages() as $message) 
					{
		  	      		return array('Error'=>'Image:' . $message);
    				}
				}
			}
		}else{
			return array('Error'=>'Image: Wrong file type');
		}
		
		return true;
	}
	
	public function isValidDocument($file, $max, $allowedTypes)
	{
		//check size
		$validator = new Zend_Validate_Between('1', $max);
		
		if ($validator->isValid($file['size'])) 
		{
			
		}else{
		    // value failed validation; print reasons
		    foreach ($validator->getMessages() as $message) {
		        return array('Error'=>'Document:' . $message);
    		}			
		}
		
		//check the type
		$this->_fileName = $file['name'];
		$return = $this->_checkType($allowedTypes);
		if ($return == false)
		{
			return array('Error'=>'Non-allowed type of document.');
		}
		
	}
	
	protected function _checkType(array $allowedTypes)
	{
		foreach ($allowedTypes as $type){
			if(eregi("\.($type)$",$this->_fileName))
        	{
        		return true;
        	}
		}
		return false;
	}
	
	//not yet used
	public function fileSizeReadable($size)
	{	
		$size = $size / 1024;	
		if($size < 1024) { 
			$size	= number_format($size, 2); 
			$size	.= ' KB'; 
		} else { 
			if ($size / 1024 < 1024) { 
				$size	= number_format($size / 1024, 2); 
				$size	.= ' MB'; 
			}elseif($size / 1024 / 1024 < 1024){ 
				$size	= number_format($size / 1024 / 1024, 2); 
				$size	.= ' GB'; 
			}  
		} 
		return $size; 
	}
	
	
}
