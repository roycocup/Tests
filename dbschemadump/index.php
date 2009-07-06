<?php

require('../adodb/adodb5/adodb.inc.php');
require('../adodb/adodb5/adodb-xmlschema.inc.php');



$_server = "IMAGESERVER,1433";
$_dbServer = "3170-090204";
$_dbServer = "disney-live";
$_dbUsername = "sa";
$_dbPassword = "1mage";
$dsn = "Driver={SQL Server};Server=".$_server.";Database=".$_dbServer.";";


$db = & NewADOConnection('odbc_mssql');
$db->Connect($dsn, $_dbUsername, $_dbPassword); 

$dict = NewDataDictionary($db);

$schema = new adoSchema($db);
$ext = $schema->ExtractSchema(true);


//print_r($ext); die;

?>