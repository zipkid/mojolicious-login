use Mojolicious::Lite;
use Mojo::IOLoop;

# Template with browser-side code
get '/' => 'index';

# WebSocket echo service
websocket '/echo' => sub {
  my $self = shift;

  # Connected
  $self->app->log->debug('WebSocket connected.');

  # Increase inactivity timeout for connection a bit
  Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

  # Incoming message
  $self->on(message => sub {
    my ($self, $message) = @_;
    $self->send("echo: $message");
  });

  # Disconnected
  $self->on(finish => sub {
    my $self = shift;
    $self->app->log->debug('WebSocket disconnected.');
  });
};

app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Echo</title></head>
  <body>
    <script>
      var ws = new WebSocket('<%= url_for('echo')->to_abs %>');

      // Incoming messages
      ws.onmessage = function(event) {
        document.body.innerHTML += event.data + '<br/>';
      };

      // Outgoing messages
      window.setInterval(function() {
        ws.send('Hello Mojo!');
      }, 5000);
    </script>
  </body>
</html>