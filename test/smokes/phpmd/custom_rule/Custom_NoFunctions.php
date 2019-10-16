<?php

// See https://phpmd.org/documentation/writing-a-phpmd-rule.html
class Custom_NoFunctions extends \PHPMD\AbstractRule implements \PHPMD\Rule\FunctionAware
{
    public function apply(\PHPMD\AbstractNode $node)
    {
        $this->addViolation($node);
    }
}
