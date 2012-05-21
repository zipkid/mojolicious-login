use Mojolicious::Lite;
use Mojo::IOLoop;

# Search Twitter for "perl" and "python"
get '/' => sub {
  my $self = shift;

  # Delay rendering
  my $delay = Mojo::IOLoop->delay(sub {
    my ($delay, @results) = @_;
    $self->render(json => {results => \@results});
  });

  # First request
  $delay->begin;
  $self->ua->get('http://search.twitter.com/search.json?q=perl' => sub {
    my ($ua, $tx) = @_;
    $delay->end($tx->res->json->{results}[0]{text});
  });

  # Second request
  $delay->begin;
  $self->ua->get('http://search.twitter.com/search.json?q=python' => sub {
    my ($ua, $tx) = @_;
    $delay->end($tx->res->json->{results}[0]{text});
  });
};


app->start;
__DATA__

@@ twitter.html.ep
<!DOCTYPE html>
<html>
  <head><title>Twitter results for "perl"</title></head>
  <body>
    % for my $result (@$results) {
      <p><%= $result->{text} %></p>
    % }
  </body>
</html>