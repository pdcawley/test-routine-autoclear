package Test::Routine::Meta::Attribute::Trait::AutoClear;
use Moose::Role;

package Moose::Meta::Attribute::Custom::Trait::AutoClear;
sub register_implementation {
    'Test::Routine::Meta::Attribute::Trait::AutoClear';
}

package Test::Routine::AutoClear;
use Moose::Role;

with 'Test::Routine::DoesAutoClear';

1;
# ABSTRACT: Enables autoclearing attrs in Test::Routines
