<?php
class fileoperations{
	
	public $fileList ; //this will hold a list of files done with readdir for example.
	public $fileName; 	

	public function readDir($dir){
		$handle = opendir($dir);

		while (false !== ($filename = readdir($handle))) {
				
			$fullfilename = $dir."/".$filename;
			$appDir = substr_replace($fullfilename, "", 0, strlen($this->rootAppDir));
				
			if (is_dir($fullfilename)){
				$this->_readDir($fullfilename);
				continue;
			}
				
				
			$filesize = filesize($fullfilename);
			$this->_writeFileToLog($appDir , $filesize);
			$this->fileList[] = array($appDir , $filesize);
		}
	  
		closedir($handle);
	}

	public function writeToFile($data, $fileName = "" ){
		//get the name directly or from setFile
		if (!$fileName){
			if(empty($this->fileName)){
				return false;
			}
			$fileName = $this->fileName;
		} 
		//write
		$fp = fopen($fileName, "a+");
		fwrite($fp, $data . "\r\n");
		fclose($fp);
		return true;
	}
	
	public function setFileName($filename){
		$this->fileName = $filename;
	}

	public function deleteFile($filename = ""){
		if ($filename=""){
			$filename = $this->fileName;
		}
		@unlink ($filename);
	}

	
}
?>