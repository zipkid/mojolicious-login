use Mojo::UserAgent;
use Mojo::Util 'encode';

# Fresh user agent
my $ua = Mojo::UserAgent->new;

# Fetch the latest news about Mojolicious from Twitter
my $search = 'http://search.twitter.com/search.json?q=Mojolicious';
for $tweet (@{$ua->get($search)->res->json->{results}}) {

  # Tweet text
  my $text = $tweet->{text};

  # Twitter user
  my $user = $tweet->{from_user};

  # Show both
  say encode('UTF-8', "$text --$user");
}