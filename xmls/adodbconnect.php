<?php
include('adodb/adodb.inc.php');

$DSN = "Driver={SQL Server}; Server=IMAGESERVER; Database=rod-test;";

$db = ADONewConnection('odbc_mssql'); 

$db->debug = false;

$db->Connect($DSN, 'sa', '1mage');
/*
 * test

$rs = $db->Execute('select * from products');
print "<pre>";
print_r($rs->GetRows());
print "</pre>";
*/
?>