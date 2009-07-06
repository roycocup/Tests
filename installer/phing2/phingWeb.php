<?php

require_once ('Phing.php');
error_reporting(E_ALL);
try {
	
	/* Setup Phing environment */
	Phing::startup();

	// Set phing.home property to the value from environment
	// (this may be NULL, but that's not a big problem.) 
	Phing::setProperty('phing.home', getenv('PHING_HOME'));
	
	// Invoke the commandline entry point
	$args = array();
	Phing::fire($args);
	die('phingweb');
	// Invoke any shutdown routines.
	Phing::shutdown();
	
} catch (ConfigurationException $x) {
	print_r($x); die;
	Phing::printMessage($x);
	exit(-1); // This was convention previously for configuration errors.
}
?>