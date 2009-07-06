<?php
/***************************************************************************
 *                                Resources.php
 *                            -------------------
 *   begin                : Tuesday, June 26, 2007
 *   copyright            : (C) 2005 markettiers4dc
 *   email                : webmaster@markettiers4dc.com
 *	 developed by		  : Chris Churchill, Web Developer
 *							Barney Hanlon, Technical Lead
 *	
 **************************************************************************/
 
if (!defined('NAMESPACE')) {
	die('Error #1: This site cannot be deployed without a namespace that matches the environment');
}

class Showcase_View_Smarty implements Zend_View_Interface
{    
    /**
     * Configuration Filename
     * @var XML filename
     */
	protected $_configFile	= null;
	
    /**
     * Smarty base path
     * @var string basePath
     */
	protected $_basePath	= null;
	
    /**
     * Smarty preload parameters
     * @var array smartyParams
     */
	protected $_smartyParams = array();
	
    /**
     * Smarty preload methods
     * @var array smartyMethods
     */
	protected $_smartyMethods = array();
	
    /**
     * Smarty object
     * @var Smarty
     */
    protected $_smarty;
	
    /**
     * factory()
     *
     * @param string $tmplPath
     * @param array $extraParams
     * @return object Prometheus_View_Smarty
     */
	public static function factory($configFile = null)
	{
		$smarty	= new self;
		
		$smarty->setConfigFile($configFile);
		
		return $smarty;
	} 
	
    /**
     * Constructor
     *
     * @param string $tmplPath
     * @param array $extraParams
     * @return void
     */
    public function __construct($tmplPath = null, $extraParams = array())
    {
        if (null !== $tmplPath) {
            $this->setScriptPath($tmplPath);
        }

        $this->setParams($extraParams);
    }
		
	public function __call($method, $parameters) 
	{
		$this->_setSmartyMethod($method, $parameters);
		//if (method_exists($this->_smarty(), $method)) {	
		//	return call_user_func_array(array(&$this->_smarty, $method), $parameters);
		//}
	}
	
    /**
     * Assign a variable to the template
     *
     * @param string $key The variable name.
     * @param mixed $val The variable value.
     * @return void
     */
    public function __set($key, $val)
    {
		$this->_setSmartyParams($key, $val);
    }

    /**
     * Retrieve an assigned variable
     *
     * @param string $key The variable name.
     * @return mixed The variable value.
     */
    public function __get($key)
    {
        return $this->get_template_vars($key);
    }

    /**
     * Allows testing with empty() and isset() to work
     *
     * @param string $key
     * @return boolean
     */
    public function __isset($key)
    {
        return (null !== $this->get_template_vars($key));
    }

    /**
     * Allows unset() on object properties to work
     *
     * @param string $key
     * @return void
     */
    public function __unset($key)
    {
		$this->_setSmartyMethod('clear_assign', array($key));
        //$this->_smarty()->clear_assign($key);
    }

    /**
     * Initiate the lazy load of the smarty object
     *
     * @return object Smarty
     */
	protected function _smarty()
	{
		if (! $this->_smarty instanceof Smarty ) {
			// build me a smarty object fool
			$this->_smarty = new Smarty();
			
			// Set the predefined parameters
			$this->setParams($this->_smartyParams);
			
			// Set the predefined methods
			$this->_callSmartyMethods();
			unset($this->_smartyParams, $this->_smartyMethods);
			// Set the smarty as a property
			// $this->_smarty = $smarty;
		}
		
		return $this->_smarty;
	}
	
    /**
     * _config
	 *
	 * Configure the base parameters of the Smarty object from the XML configFile
     *
     * @return void
	 * @uses Package::buildPath()
     */
	private function _config()
	{
		// Get the base path for the smarty base directory
		$basePath	= $this->getBasePath();
		$configFile	= $this->getConfigFile();
		
		if (null === $basePath){
			throw new Exception('No view base path specified');
		}
		
		if (null === $configFile){
			throw new Exception('No config file specified');
		}
		
		// Generate the path to the view xml config file
		if ( file_exists(Package::buildPath( $basePath , $configFile)) ) {
			$viewBuildFile = Package::buildPath( $basePath , $configFile);
		} else {
			throw new Exception("Unable to find config file: " . $configFile);
		}
		 
		// Load the config file
		if (! $viewXml = Zend_Registry::get('site_config_cache')->load('view_config') ) {
			try {
				$xmlSection = (defined('BUILD_ENVIRONMENT')) ? BUILD_ENVIRONMENT : strtolower($_SERVER['SERVER_NAME']);
				$viewXml = new Zend_Config_Xml($viewBuildFile, $xmlSection);
				Zend_Registry::get('site_config_cache')->save($viewXml, 'view_config');
			} catch (Zend_Exception $e) {
				throw new Exception( 'There was a problem caching the config file: ' . $e->getMessage() );
			}
		}
		unset($viewBuildFile, $xmlSection);
		
		
		// Alias' replacements
		$replacements = array(
            ':baseDir'  => $basePath
        ); 
		
        $params = str_replace(array_keys($replacements), array_values($replacements), $viewXml->smarty->params->toArray());

		// Set the base smarty parameters
		$this->setParams($params);
		
		// Register plugins
		/*
		if (isset($viewXml->smarty->plugins)){
			$plugins	= $viewXml->smarty->plugins->toArray();
			
			// Loop each plugin entry
			foreach($plugins as $key => $plugin)
			{
				// Check if a plugin type has been specified
				if (isset($plugin['type'])){
					switch($plugin['type'])
					{
						case 'resource':
							/*
							$methodArgs	= array(
									$key . '_get_source',
									$key . '_get_timestamp',
									$key . '_get_secure',
									$key . '_get_trusted'
								);
							
						break;
						
						default:
							$methodArgs	= (is_array($plugin['parameters'])) ? $plugin['parameters'] : array();
						break;
					}
					//$methodName	= 'register_' . $plugin['type'];
					//$this->_setSmartyMethod($methodName, array($key, $methodArgs));
				}
			}
			
		}
		*/
		
	}
	
    /**
     * Return the template engine object
     *
     * @return Smarty
     */
    public function getEngine()
    {
        return $this->_smarty();
    }

    /**
     * Set the config filename for the Smarty object
     *
     * @return void
     */
	public function setConfigFile($configFile)
	{
		$this->_configFile	= $configFile;
	}
	
    /**
     * Get the config filename for the Smarty object
     *
     * @return void
     */
	protected function getConfigFile()
	{
		return $this->_configFile;
	}
	
    /**
     * Set an array of Smarty parameters
     *
     * @param array params to set.
     * @return void
     */
	public function setParams(array $params)
	{
        foreach ($params as $param => $value) {
			$this->_setSmartyParams($param, $value);
        }
	}
	
    /**
     * Set a Smarty parameter
     *
     * @param array params to set.
     * @return void
     */
	protected function _setSmartyParams($parameter, $value)
	{	
		if ($this->_smarty instanceof Smarty) {
			if ( is_array($this->_smarty->$parameter) ){
				array_push($this->_smarty->$parameter, $value);
				//$this->_smarty->$parameter[] = $value;
			} else {
				$this->_smarty->$parameter = $value;
			}
		} else {
			if( (isset($this->_smartyParams[$parameter])) && (is_array($this->_smartyParams[$parameter])) ){
				array_push($this->_smartyParams[$parameter], $value);
			} else {
				$this->_smartyParams[$parameter] = $value;
			}
		}
	}
		
    /**
     * Get the Smarty parameters
     *
     * @return mixed Smarty param
     */
	protected function _getSmartyParams($param)
	{	
		if ($this->_smarty instanceof Smarty) {
			if(!empty($this->_smarty->$param)){
				return $this->_smarty->$param;
			}
		} elseif ( isset($this->_smartyParams[$param]) ){
			if(!empty($this->_smarty->$param)){
				return $this->_smartyParams[$param];
			}
		}
	}
	
    /**
     * Set the Smarty methods
     *
     * @param array methods to set.
     * @return void
     */
	protected function _callSmartyMethods()
	{
        foreach ($this->_smartyMethods as $methodName => $call) {
			foreach ($call as $args) {
				$this->_setSmartyMethod($methodName, $args);
			}
        }
		unset($this->_smartyMethods);
	}
	
    /**
     * Set the Smarty methods
     *
     * @param string methodName
     * @param array args
     * @return void
     */
	protected function _setSmartyMethod($methodName, array $args)
	{	
		if (is_array($args)){
			
			if ($this->_smarty instanceof Smarty && method_exists($this->_smarty, $methodName)) {
				call_user_func_array(array($this->_smarty, $methodName), $args);
			} else {
				if (isset($this->_smartyMethods[$methodName])){
					$this->_smartyMethods[$methodName][] = $args;
				} else {
					$this->_smartyMethods[$methodName] = array();
					$this->_smartyMethods[$methodName][] = $args;
				}
			}
		}
	}


    /**
     * Set the path to the templates
     *
     * @param string $path The directory to set as the path.
     * @return void
     */
    public function setScriptPath($path)
    {
        if (is_readable($path)) {
            $this->_setSmartyParams('template_dir', $path);
            return;
        }

        throw new Exception('Invalid template path provided');
    }

    /**
     * Set the path to the compile directory
     *
     * @param string $path The directory to set as the path.
     * @return void
     */
    public function setCompilePath($path)
    {

        if (is_writable($path)) {
            $this->_setSmartyParams('compile_dir', $path);
            return;
        }
		
		$this->_setSmartyParams('compile_dir', Package::buildPath(SITE_DIR, 'views', 'compile'));
		
		return;
        //throw new Exception('Invalid compile path provided: ' . $path);
    }

    /**
     * Retrieve the current template directory
     *
     * @return string
     */
    public function getScriptPaths()
    {
        return array( $this->_getSmartyParams('template_dir') );
    }

    /**
     * Set a base path to all view resources
     *
     * @param  string $path
     * @param  string $classPrefix
     * @return void
     */
    public function setBasePath($path, $classPrefix = 'Zend_View')
    {
		if (is_readable($path)) {
        	return $this->_basePath	= $path;
		}
		
        throw new Exception('Invalid base path provided: ' . $path);
    }

    /**
     * Get the BasePath
     *
     * @return basePath
     */
    public function getBasePath()
    {
        return rtrim($this->_basePath, DIRECTORY_SEPARATOR);
    }

    /**
     * Alias for setScriptPath
     *
     * @param string $path
     * @param string $prefix Unused
     * @return void
     */
    public function addBasePath($path, $prefix = 'Zend_View')
    {
		$path        = rtrim($path, '/');
		$path        = rtrim($path, '\\');
		$path       .= DIRECTORY_SEPARATOR;

		$this->setBasePath($path);
		
		// configure the base details
		$this->_config();
			
		$this->setScriptPath($path . 'scripts');
		$this->setCompilePath($path . 'compile');

        //return $this->_smarty();
    }
	
    /**
     * Returns an array containing template variables
     *
     * @param string $name
     * @return array
     */
	public function get_template_vars($name = null)
	{
		if ($this->_smarty instanceof Smarty) {
			return $this->_smarty->get_template_vars($name);
			
		} else{
			if (!empty($this->_smartyMethods['assign'])) {
				$method		= $this->_smartyMethods['assign'];
				$assigned	= array();
				for($a = 0; $a < count($method); $a++ ){
					if (count($method[$a]) > 1){
						$assigned[$method[$a][0]] = $method[$a][1];
					} elseif (is_array($method[$a][0])) {
						while (list($key, $val) = each($method[$a][0]) ){
							$assigned[$key]	= $val;
						}
					}
				}
				
				if (null === $name){
					return $assigned;
				} elseif ( isset($assigned[$name]) ){
					return $assigned[$name];
				}
			}
		}
		return null;
	}
	
    /**
     * Assign variables to the template
     *
     * Allows setting a specific key to the specified value, OR passing an array
     * of key => value pairs to set en masse.
     *
     * @param string|array $spec The assignment strategy to use (key or array of key
     * => value pairs)
     * @param mixed $value (Optional) If assigning a named variable, use this
     * as the value.
     * @return void
     */
    public function assign($spec, $value = null)
    {
		$this->_setSmartyMethod(__FUNCTION__, array($spec, $value));
		/*
        if (is_array($spec)) {
            $this->_smarty()->assign($spec);
            return;
        }

        $this->_smarty()->assign($spec, $value);
		*/
    }

    /**
     * Clear all assigned variables
     *
     * Clears all variables assigned to Zend_View either via {@link assign()} or
     * property overloading ({@link __get()}/{@link __set()}).
     *
     * @return void
     */
    public function clearVars()
    {
		if ($this->_smarty instanceof Smarty) {
        	$this->_smarty->clear_all_assign();
		} elseif(!empty($this->_smartyMethods['assign'])) {
			unset($this->_smartyMethods['assign']);
		}
    }
	
	
	/**     
	  * Clear the cache     
	  *     
	  * @param int $milliseconds Clears all files over assigned.     
	  *     
	  * @return void     
	  */    
	public function clearCache($milliseconds = false)    
	{        
		$this->_smarty()->clear_all_cache($milliseconds);    
	}    


	/**     
	  * Processes a template and returns the output.     
	  *     
	  * @param string $name The template to process.     
	  * @return string The output.     
	  */    
	public function render($name, $echo = null, $cacheId = null)    
	{  
		// render the page
		if (null !== $echo) {   
			return $this->_smarty()->fetch("view:$name", $cacheId);   
		} else {
			return $this->_smarty()->display("view:$name", $cacheId);
		}
	}
}
