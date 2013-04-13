package Test::Routine::AutoClear;
# ABSTRACT: Enables autoclearing attrs in Test::Routines
use Test::Routine ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    with_meta => [qw{has}],
    also => 'Test::Routine',
);

sub init_meta {
    my($class, %arg) = @_;

    my $meta = Moose::Role->init_meta(%arg);
    my $role = $arg{for_class};
    Moose::Util::apply_all_roles($role, 'Test::Routine::DoesAutoClear');

    return $meta;
}

sub has {
    my($meta, $name, %options) = @_;

    if (delete $options{autoclear}) {
        push @{$options{traits}}, 'AutoClear'
    }

    $meta->add_attribute(
        $name,
        %options,
    );
}

1;
__END__

=head1 SYNOPSIS

    use Test::Routine::AutoClear;
    use Test::More;
    use File::Tempdir;

    has _tempdir => (
        is        => 'ro',
        isa       => 'Int',
        builder   => '_build_tempdir',
        lazy      => 1,
        autoclear => 1,
        handles   => {
            tempdir => 'name',
        },
    );

    sub _build_tempdir {
        File::Tempdir->new();
    }

And now all the tests that use a tempdir in your test routine will get a
fresh Tempdir

=head1 DESCRIPTION

When I'm writing tests with L<Test::Routine> I find myself writing code like
this all the time:

    has counter => (
        is      => ro,
        lazy    => 1,
        default => 0
        lazy    => 1,
        clearer => 'reset_counter',
    );

    after run_test => sub {
        shift->reset_counter;
    };

And after about the first time, I got bored of doing this. So I started to fix
it, and here's my first cut.

L<Test::Routine::AutoClear> addresses this by adding a new C<autoclear> key to
the C<has> arguments. If you set C<autoclear> to a true value on an attribute
then, after each test is run, all the autoclearing attributes will be reset.

=head2 Clearing logic

Consider the following Test::Routine:

    use Test::More;
    use Test::Routine::AutoClear;
    use Test::Routine::Util;

    has some_attrib => (
        is        => 'ro',
        default   => 10,
        lazy      => 1,
        autoclear => 1,
        clearer   => 'reset_attrib',
    );

    test "This should be invariant" => sub {
        my $self = shift;
        my $attrib = $self->attrib;
        $self->reset_attrib;
        is $self->attrib, $attrib;
    };

    run_me "Test defaults";
    run_me "Test initialising", { attrib => 20 };
    done_testing;

It seems to me that, in a perfect world at least, that test should pass. Which
it does. Huzzah!

=head1 BUGS

Lots. Including, but not limited to:

=over 4

=item *

The interface is still very fluid. I make no promises about interface
stability.

=item *

I'm pretty sure that if you end up mixing in multiple roles that use
this role then you'll end up clearing your attributes lots of times.

=item *

Resetting to the initializing value only works for non reference values. Need
some way of passing in a builder for hashrefs etc.

=back

=head1 SEE ALSO

=for :list
* L<Test::Routine>
