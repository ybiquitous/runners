<?php

namespace custom\rules;

// See https://phpmd.org/documentation/writing-a-phpmd-rule.html
class NoMethods extends \PHPMD\AbstractRule implements \PHPMD\Rule\MethodAware
{
    public function apply(\PHPMD\AbstractNode $node)
    {
        $this->addViolation($node);
    }
}
