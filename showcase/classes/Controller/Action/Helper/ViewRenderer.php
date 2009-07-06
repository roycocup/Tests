<?php
class Showcase_Controller_Action_Helper_ViewRenderer extends Zend_Controller_Action_Helper_ViewRenderer
{
    /**
     * The default portal template directory name
     * @var string
     */
    protected $_defaultPortal	= 'showcase';
	
    /**
     * The main Smarty template
     * @var string
     */
    protected $_viewScript		= 'stage';
	
	protected $_useStage		= true;
    /**
     * Render a view script (optionally to a named response segment)
     *
     * Sets the noRender flag to true when called.
     * 
     * @param  string $script 
     * @param  string $name 
     * @return void
     */
    public function renderScript($script, $name = null)
    {
		$request = $this->getRequest();
		
        if (null === $name) {
            $name = $this->getResponseSegment();
        }

		$module = $request->getModuleName();
		
        if (null === $module) {
            $module = $this->getFrontController()->getDispatcher()->getDefaultModule();
        }
		
		$controller = $request->getControllerName();

        if (null === $controller) {
            $controller = $this->getFrontController()->getDispatcher()->getDefaultControllerName();
        }

		$action = $request->getActionName();

        if (null === $action) {
            $action = $this->getFrontController()->getDispatcher()->getDefaultActionName();
        }

		// Assign the current portal and the default portal template directories
		$globalVars = '__ZF__';
		
		$this->view->assign($globalVars, array(
				'module'		=> $module,
				'controller'	=> $controller,
				'action'		=> $action
			));
			
		//unset($this->view->$globalVars);
		
		// Assign the controller / action script to the $body of main
		$this->view->assign('body', $script);
		// Render the main stage
        $this->getResponse()->appendBody(
            $this->view->render($this->getViewStageScriptPathSpec($script)),
            $name
        );
		//print_r($this->view);
		//$this->view = null;
        $this->setNoRender();
    }
	
    /**
     * Generate the current views main stage script path specification string
     * 
     * @param  string $stage 
     * @return string
     */
	public function getViewStageScriptPathSpec($script, $stage = null)
	{
		if (!$this->_useStage) {
			$path = $script;
		} else {
			if (null === $stage){
				$stage	= $this->_viewScript;
			}
		
			$path	= $stage . '.' . $this->getViewSuffix();
		}
		return $path;
	}
	
	public function setUseStage($useStage = true)
	{
		$this->_useStage = (bool) $useStage;
	}
	
	public function setStageScript($tage)
	{
		// used to override the default stage.  Not normally necessary
	}
}
