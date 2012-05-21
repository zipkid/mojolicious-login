use Mojolicious::Lite;
use Mojo::IOLoop;

# Template with browser-side code
get '/' => 'index';

# EventSource for log messages
get '/events' => sub {
  my $self = shift;

  # Increase inactivity timeout for connection a bit
  Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

  # Change content type
  $self->res->headers->content_type('text/event-stream');

  # Subscribe to "message" event and forward "log" events to browser
  my $cb = $self->app->log->on(message => sub {
    my ($log, $level, $message) = @_;
    $self->write("event:log\ndata: [$level] $message\n\n");
  });

  # Unsubscribe from "message" event again once we are done
  $self->on(finish => sub {
    my $self = shift;
    $self->app->log->unsubscribe(message => $cb);
  });
};

app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>LiveLog</title></head>
  <body>
    <script>
      var events = new EventSource('<%= url_for 'events' %>');

      // Subscribe to "log" event
      events.addEventListener('log', function(event) {
        document.body.innerHTML += event.data + '<br/>';
      }, false);
    </script>
  </body>
</html>

@@ events.html.ep
<!DOCTYPE html>
</html>