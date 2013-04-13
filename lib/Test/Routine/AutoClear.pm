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

I think it's reasonable to expect that resetting an attribute that
didn't get set via a builder should reset the value to the initial
value that was set via the instantiation params. Or maybe
C<< autoclear => 1 >> should imply C<< init_arg => undef >>.

=back

=head1 SEE ALSO

=for :list
* L<Test::Routine>
