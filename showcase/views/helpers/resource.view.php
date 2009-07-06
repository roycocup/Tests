<?php
/*
 * Smarty plugin
 * -------------------------------------------------------------------
 * File:     	resource.view.php
 * Type:     	resource
 * Name:     	view
 * Purpose:  	Searches for the template within parent directories
 * Reference:	http://smarty.php.net/manual/en/plugins.resources.php
 * -------------------------------------------------------------------
 */
 
/**
 * smarty_resource_view_source
 *
 * The first function, source() is supposed to retrieve the resource.
 * Its second parameter $tpl_source is a variable passed by reference
 * where the result should be stored. The function is supposed to
 * return TRUE if it was able to successfully retrieve the resource
 * and FALSE otherwise.
 *
 * @param string $tpl_name
 * @param string $tpl_source reference
 * @param object $smarty reference
 * @uses Package::buildPath()
 * @return void
 */
function smarty_resource_view_source($tplName, &$tplSource, Smarty &$smarty)
{
	$templateVars 		= $smarty->get_template_vars();
	$currentModule		= $templateVars['__ZF__']['module'];
	$currentController	= $templateVars['__ZF__']['controller'];
	$resourcePath		= null;

	if (
			("login" !== strtolower($currentController)) && 
			("static" !== strtolower($currentController)) && 
			("admin" !== strtolower($currentModule))
		) 
	{
		$client	= $smarty->get_registered_object('client');
		
		if ( ($path = Package::buildPath($smarty->template_dir, 'clients', $client->identifier, 'modules', $currentModule, $currentController, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'clients', $client->identifier, 'modules', $currentModule, 'default', $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'clients', $client->identifier, 'modules', $currentModule, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'clients', $client->identifier, 'modules', $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;		
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'clients', $client->identifier, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		}
	}
	
	if (!$resourcePath) {
		if ( ($path = Package::buildPath($smarty->template_dir, 'modules', $currentModule, $currentController, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'modules', $currentModule, 'default', $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'modules', $currentModule, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} elseif ( ($path = Package::buildPath($smarty->template_dir, 'modules', $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;		
		} elseif ( ($path = Package::buildPath($smarty->template_dir, $tplName)) && (is_readable($path)) ) {
			$resourcePath = $path;
		} else{	
			return false;
		}
	}

	if ('admin' == $currentModule && isset($resourcePath))
	{
		if ($tpl = $smarty->_read_file($resourcePath) ) {
			$tplSource = $tpl;
		}
		return true;
	}

	if ($resourcePath){
		if ($tpl = $smarty->_read_file($resourcePath) ) {
			$tplSource = $tpl;
		}

		// $tplSource = $path;
		/*
		$smarty->_smarty_include(
			array(
				'smarty_include_tpl_file'	=> $path,
				'smarty_include_vars'		=> array()
			)
		);
		die('we got to here');
		*/
		return true;
	}
	
	return false;
}


/**
 * smarty_resource_view_timestamp
 *
 * The second function, timestamp() is supposed to retrieve the 
 * last modification time of the requested resource, as a UNIX 
 * timestamp. The second parameter $tpl_timestamp is a variable
 * passed by reference where the timestamp should be stored. The
 * function is supposed to return TRUE if the timestamp could be
 * succesfully	determined, or FALSE otherwise.
 *
 * @param string $tpl_name
 * @param int $tpl_timestamp reference
 * @param object $smarty reference
 * @return void
 */
function smarty_resource_view_timestamp($tpl_name, &$tpl_timestamp, Smarty &$smarty)
{
	$tpl_timestamp = time()-1;
	return true;
}


/**
 * smarty_resource_view_secure
 *
 * The third function, secure()is supposed to return TRUE or FALSE,
 * depending on whether the requested resource is secure or not.
 * This function is used only for template resources but should
 * still be defined. 
 *
 * @param string $tpl_name
 * @param object $smarty reference
 * @return void
 */
function smarty_resource_view_secure(string $tpl_name, Smarty &$smarty)
{
	// assume all templates are secure

    return true;
}

/**
 * smarty_resource_view_trusted
 *
 * The fourth function, trusted() is supposed to return TRUE or FALSE,
 * depending on whether the requested resource is trusted or not. This
 * function is used for only for PHP script components requested by
 * {include_php} tag or {insert} tag with the src attribute. However,
 * it should still be defined even for template resources.  
 *
 * @param string $tpl_name
 * @param object $smarty reference
 * @return void
 */
function smarty_resource_view_trusted(string $tpl_name, Smarty &$smarty)
{
}
