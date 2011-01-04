package Login::Index;

use strict;
use warnings;

use base 'Mojolicious::Controller';

# This action will render a template
sub welcome {
    my $c = shift;
    
    $c->stash( message => 'Welcome to the Mojolicious Web Framework Login test!');
    
    # Render template "index/welcome.html.ep" with message
    $c->render();
    
}

1;
