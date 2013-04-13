package Test::Routine::Meta::Attribute::Trait::AutoClear;
use Moose::Role;

Moose::Util::meta_attribute_alias('AutoClear');
has initial_value => (
    is        => 'rw',
    predicate => '_has_initial_value',
);

around set_initial_value => sub {
    my ($orig, $self, $instance, $value) = @_;
    
    $self->initial_value($value);
    $self->$orig($instance, $value);
};

around clear_value => sub {
    my ($clear_value, $self, $instance) = @_;

    if ($self->_has_initial_value) {
        $self->set_value($instance, $self->initial_value);
    }
    else {
        $self->$clear_value($instance);
    }
};

sub _inline_clear_value {
    my $self = shift;
    my $instance = shift;
    my $slot_name = $self->name;
    "\$_[0]->meta->get_attribute('$slot_name')->clear_value(\$_[0]);";
}


1;
