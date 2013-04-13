use Test::Routine::AutoClear;
use Test::Routine::Util;
use Test::More;

use namespace::autoclean;

has counter => (
    is        => 'rw',
    isa       => 'Int',
    default   => 0,
    lazy      => 1,
    autoclear => 1,
);

has attrib => (
    is        => 'ro',
    isa       => 'Int',
    default   => 0,
    lazy      => 1,
    clearer   => 'reset_attrib',
    autoclear => 1,
);

test "first" => sub {
    my($self) = @_;

    is($self->counter, 0, "Always starting from zero");
    $self->counter( 1 );
    is($self->counter, 1, "And going to 1");
};

test "second" => sub {
    my($self) = @_;

    is($self->counter, 0, "Always starting from zero");
    $self->counter( 1 );
    is($self->counter, 1, "And going to 1");
};

test "clear resets to initial arg if given, not default" => sub {
    my($self) = @_;
    is($self->attrib, 20);
    $self->reset_attrib;
    is($self->attrib, 20);
};


run_tests "Tests", ['main'], {attrib => 20};
done_testing;
