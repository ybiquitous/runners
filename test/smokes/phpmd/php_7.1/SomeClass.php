<?php

class SomeClass
{
    /**
    * const visibility keywords causing error when using pdepend 2.5.0
    * https://github.com/phpmd/phpmd/issues/436
    **/
    private const SOME_CONST = 1;
    private $someVariable;
    private $unusedVariable;

    public function __construct($someVariable)
    {
            $this->someVariable = $someVariable;
    }
}
