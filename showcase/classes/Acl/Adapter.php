<?php

class Showcase_Acl_Adapter extends Zend_Acl
{
    public function getRoleRegistry()
    {
        return parent::_getRoleRegistry();
    }

}