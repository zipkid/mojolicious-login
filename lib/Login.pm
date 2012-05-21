package Login;

use strict;
use warnings;

use base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    $self->plugin('I18N');
   
    $self->secret('LiErTqO7arWN');
    
    # Routes
    my $r = $self->routes;
    
    # Normal route to controller
    $r->route('/')->to('index#welcome' )->name('index');
    $r->route('/login')->via('get')->to('auth#index' )->name('login_form');
    $r->route('/login')->via('post')->to('auth#login' )->name('login');
    $r->route('/logout')->to('auth#logout' )->name('logout');
    
    my $auth = $r->bridge->to('Auth#protected');
    
    $auth->route('/customers')->via('get')->to('customers#index' )->name('customers');
 
}

1;
