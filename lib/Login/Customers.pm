package Login::Customers;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    $self->render(message => 'Welcome to the Mojolicious Web Framework!');
}

1;