<?php

interface ArrayAccess {
	function offsetSet($offset, $value);
	function offsetGet($offset);
	function offsetUnset($offset);
	function offsetExists($offset);
}