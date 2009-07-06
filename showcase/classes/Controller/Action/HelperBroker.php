<?php

class Showcase_Controller_Action_HelperBroker extends Zend_Controller_Action_HelperBroker
{
    static public function addPath($path, $prefix = 'Zend_Controller_Action_Helper')
    {
	
        // make sure it ends in a PATH_SEPARATOR
        if (substr($path, -1, 1) != DIRECTORY_SEPARATOR) {
            $path .= DIRECTORY_SEPARATOR;
        }

        // make sure it ends in a PATH_SEPARATOR
        $prefix = rtrim($prefix, '_') . '_';
        
        $info['dir']    = $path;
        $info['prefix'] = $prefix;
        self::$_paths = array_merge(array($info), self::$_paths);
        return;
    }
}