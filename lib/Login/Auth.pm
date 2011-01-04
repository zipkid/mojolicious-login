package Login::Auth;

use strict;
use warnings;

use base 'Mojolicious::Controller';

my $USERS = {
        user => 'secr3t',
    };


sub index {
    my $c = shift;

    return unless my $login_redirect_path = $c->flash('login_redirect_path');

    $c->flash(login_redirect_path => $login_redirect_path);
    
}

sub login {
    my $c = shift;

    my $login_redirect_path = $c->flash('login_redirect_path') || '/';
    
    my $user = $c->param('user') || '';
    my $pass = $c->param('pass') || ''; 
    
    if( ! ( $USERS->{$user} && $USERS->{$user} eq $pass ) ) {
    	$c->flash(login_redirect_path =>  $login_redirect_path);
    	$c->flash(login_error =>  "Login Error");
        return $c->redirect_to('login_form');
    }
    
    $c->session( user => $user );

    $c->redirect_to($login_redirect_path);

}

sub protected {
	 my $c = shift;

    unless ( $c->session('user') ) {
        $c->flash(login_redirect_path => $c->req->url->to_abs->path);
        $c->redirect_to('login_form');
        return;
    }

    return 1;
	
}

sub logout {
    my $c = shift;
    
    $c->app->log->debug( "Ds::Auth::logout" );
    
    $c->session(expires => 1);
    $c->redirect_to('index');
    
}

1;
