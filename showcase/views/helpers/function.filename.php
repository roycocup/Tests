<?php


function smarty_function_filename($params, Smarty $smarty)
{
	$path	= $params['path'];
	
	return substr($path,strrpos($path,'/')+1);
}
