package Cache::Memcached::Tie;

use strict;
use warnings;

use AutoLoader qw(AUTOLOAD);

use base 'Cache::Memcached';
use vars qw($VERSION);
$VERSION = '0.03';

use fields qw(default_expire_seconds);

sub TIEHASH{
    my ($package, $default_expire_seconds, @params) = @_;
    my $self=$package->new(@params);
    $self->{'default_expire_seconds'} = $default_expire_seconds;
    return $self;
}

sub STORE{
    my ($self, $key, $value) = @_;
    $self->set($key, $value, $self->{'default_expire_seconds'});
}

# Check for the existence of a value - same as fetch, but sadly this is
# necessary for when the hash is used by libraries that need EXISTS
# functionality
sub EXISTS {
    my ($self, $key) = @_;
    my $val = $self->FETCH($key);
    return defined($val);
}

# Returns value or hashref (key=>$value)
sub FETCH {
    my $self=shift;
    my @keys=split "\x1C", shift; # Some hack for multiple keys
    my $val;
    if (@keys==1){
        $val = $self->get($keys[0]);
    } else {
        $val = $self->get_multi(@keys);
    }
    return $val;
}

sub DELETE{
    my $self=shift;
    my $key=shift;
    $self->delete($key);
}

sub UNTIE{
    my $self=shift;
    $self->disconnect_all();
}

1;
__END__

=head1 NAME

Cache::Memcached::Tie - Using Cache::Memcached as hash

=head1 SYNOPSIS

    #!/usr/bin/perl -w
    use strict;
    use Cache::Memcached::Tie;
    
    my %hash;
    my $memd=tie %hash,'Cache::Memcached::Tie', {servers=>['192.168.0.77:11211']};
    $hash{b}=['a',{b=>'a'}];
    print $hash{'a'};
    print $memd->get('b');

=head1 DESCRIPTION

Tie for memcached.
Read `perldoc perltie`

=head1 AUTHOR

Andrew Kostenko E<lt>gugu@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

GNU GPL

=cut
