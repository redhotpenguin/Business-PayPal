use strict;
use warnings;

use Test::More;
use Business::PayPal;

my $n = 1;
plan tests => 9 + $n;


my $pp1 = Business::PayPal->new();
my $pp2 = Business::PayPal->new(id => 'foobar');
isa_ok($pp1, 'Business::PayPal');
isa_ok($pp2, 'Business::PayPal');

my $id1 = $pp1->id;
like($id1, qr/^[a-f0-9]{32}$/, 'id is hex');

my $id2 = $pp2->id;
is $id2, 'foobar', 'id set manually';

my $button1 = $pp1->button();
ok($button1, 'button created');
like($button1,
    qr/name\s*=\s*"{0,1}custom"{0,1}\s+value\s*=\s*"{0,1}$id1"{0,1}/i,
   "'custom' param eq id");

my %query = (
    item_name => 'IPN Test',
);
my ($success, $reason) = $pp1->ipnvalidate(\%query);
is($success, undef, 'expected failure');
is($reason, 'PayPal says transaction INVALID'); #test if cert is correct
is scalar($pp1->ipnvalidate(\%query)), undef, 'undef in scalar context';

for (1 .. $n) {
	my $pp = Business::PayPal->new();
	my $button = $pp->button(
		business       => 'foo@bar.com',
		item_name      => 'Instant water',
		amount         => 99.99,
		quantity       => 1,
		return         => 'http://bar.com/water',
		cancel_return  => 'http://bar.com/nowwater',
		notify_url     => 'http://bar.com/hello_water',
	);
	#diag $button;
	like $button, qr{foo\@bar\.com}, 'email';
}

