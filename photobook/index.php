<?php
include 'xmlReadWriter/xmlRW.class.php';

$xml = new xmlRW();

$xml->loadXml('orders/10001_32_312_bulk Order.xml');
//print_r($xml->domDoc->getElementsByTagName("Image")->item(0)->getAttribute('filename'));
print_r($xml->domDoc->getElementsByTagName("Image")->item(0)->getAttribute('filename'));

?>