<?php

class Showcase_Session_Salt
{
	public static function factory()
	{
		return new self;
	
	}
	
	public function __toString()
	{
		return 'foo';
	}
	
}