<?php

class Showcase_Media extends Showcase_Media_Abstract
{

	protected $_id;
	protected $_name;
	protected $_path;
	protected $_filetype_name;
	protected $_description;
	protected $_category;
	protected $_identifier;
	protected $_stream_path;
	protected $_documents;
	protected $_type;
	protected $_status;

	public static function factory(stdClass $result)
	{
		$self	= new self();
		
		$self->_id					= (isset($result->id)) ? $result->id : NULL;
		$self->_name				= (isset($result->filename)) ? $result->filename : NULL;
		$self->_description			= (isset($result->description)) ? new Showcase_Article($result->description) : NULL;
		$self->_path				= (isset($result->filepath)) ? $result->filepath : NULL;
		$self->_type				= (isset($result->filetype)) ? Showcase_Type::factory($result->filetype) : NULL;
		$self->_stream_path			= (isset($result->stream_path)) ? $result->stream_path : NULL;
		$self->_filetype_name		= (isset($result->filetype_name)) ? $result->filetype_name : NULL;
		$self->_category			= (isset($result->category)) ? (($result->category instanceof stdClass) ? Showcase_Category::factory($result->category) : new Showcase_Category($result->category) ) : NULL;
		$self->_identifier			= (isset($result->identifier)) ? $result->identifier : NULL;
		$self->_status				= (isset($result->status)) ? $result->status : NULL;
		
		return $self;
	}
	
	public function __toString()
	{
		return $this->getVirtualFilename();
	}
	
	public function getVirtualFilename()
	{
		$virtualFilename	= false;
		
		if ($identifier = $this->_identifier){
			if ($path = $this->_path) {
				$extension			= substr($path, strrpos($path, '.'));
				$virtualFilename	= $identifier . $extension;
			}
		}
		
		return strval($virtualFilename);
	}
	
	public function getFilename()
	{
		if ($path = $this->_path) {
			return substr($path, strrpos($path, '/')+1);
		}
	}
	
	public function __get($v)
	{
		if ( 0 === strpos($v, 'is') ) {
			$return	= false;
			
			if ($this->_type instanceof Showcase_Type) {
				$return	= $this->_type->$v;
			}
			
			return $return;
		}
	
		switch ($v) {
			case 'documents':
			case 'cue':
			case 'schedule':
				if (!is_array($this->_documents)) {
					$this->loadDocuments();
				}
				
				if ('documents' !== $v) {
					if (isset($this->_documents[strtoupper($v)])) {
						return $this->_documents[strtoupper($v)];
					}else{
						return false;
					}
				}
			break;
			
			case 'filesize':
				return $this->getFilesize();
			break;
		}
		
		$var	= "_" . $v;
		return $this->$var;
	}
	
	public function getFilesize()
	{
		if ( (!$this->path) || ($this->isWeblink) ) {
			return false;
		}
		
		$sysPath	= Package::buildPath($_SERVER['DOCUMENT_ROOT'] , $this->path);
		
		
		if (file_exists($sysPath)) {
			$size	= filesize($sysPath) / 1024; 
			
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
		
		return false;
	}
	
	public function loadDocuments()
	{
		$id = $this->_id;
		
		if (!$id) {
			return false;
		}

		try {
			$stmt = Zend_Registry::get('dbh')->proc('load_media_documents');
			$stmt->bindParam(':id', $id, PDO::PARAM_INT);
			$stmt->execute();
			
			$results = $stmt->fetchAll(PDO::FETCH_OBJ);
			$stmt->closeCursor();
		}catch(Zend_Db_Statement_Exception $e) {
			die (__LINE__ . ':' . __FILE__ . ':' . $e->getMessage());
		}
		
		if ($results) {

			if (!is_array($this->_documents)) {
				$this->_documents	= array();
			}

			foreach($results as $result){
				$doc	= array(strtoupper($result->filetype_name) => Showcase_Media::factory($result));
				$this->_documents	= array_merge($this->_documents,$doc);
				unset($doc);
			}
		}
	}
	
	
	
}