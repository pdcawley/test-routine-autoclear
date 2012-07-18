package Test::Routine::Meta::Attribute::Trait::AutoClear;
use Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::AutoClear;
sub register_implementation {
    'Test::Routine::Meta::Attribute::Trait::AutoClear';
}

1;
