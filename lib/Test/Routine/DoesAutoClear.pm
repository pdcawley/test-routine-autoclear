package Test::Routine::DoesAutoClear;
use Moose::Role;
require Test::Routine::Meta::Attribute::Trait::AutoClear;

after run_test => sub {
    my $self = shift;

    $_->clear_value($self) foreach grep {
        $_->does( 'Test::Routine::Meta::Attribute::Trait::AutoClear' )
    } $self->meta->get_all_attributes;
};

1;
