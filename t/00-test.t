use strict;
use warnings;

use Test::More;
use Business::PayPal;

my $n = 1;
plan tests => 3;

subtest pretest => sub {
	plan tests => 9;

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
	is($reason, 'PayPal says transaction INVALID') or do {
	  open my $fh, '>', 'cert.txt' or die;
	  print $fh $reason;
	  close $fh;
	}; #test if cert is correct
	is scalar($pp1->ipnvalidate(\%query)), undef, 'undef in scalar context';
};

subtest loop => sub {
	plan tests => 3*$n;

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
	
		like $button, qr{action="https://www.paypal.com/cgi-bin/webscr"}, 'address';
		like $button, qr{foo\@bar\.com}, 'email';
		like $button, qr{<input type="hidden" name="amount" value="99.99" />}, 'amount';
	}
};


subtest 'sandbox' => sub {
	plan tests => 7;

	my $pp = Business::PayPal->new( address  => 'https://www.sandbox.paypal.com/cgi-bin/webscr' );
	my $button = $pp->button(
		cmd            => '_xclick-subscriptions',
		business       => 'foo@bar.com',
		item_name      => 'Instant water',

		src            => 1,
		a3             => 9,
		p3             => 1,
		t3             => 'M',

		quantity       => 1,
		return         => 'http://bar.com/water',
		cancel_return  => 'http://bar.com/nowwater',
		notify_url     => 'http://bar.com/hello_water',
	);
	#diag $button;
	like $button, qr{action="https://www.sandbox.paypal.com/cgi-bin/webscr"}, 'address';
	like $button, qr{foo\@bar\.com}, 'email';
	unlike $button, qr{amount}, 'no amount when recurring';
	like $button, qr{<input type="hidden" name="a3" value="9" />};
	like $button, qr{<input type="hidden" name="p3" value="1" />};
	like $button, qr{<input type="hidden" name="src" value="1" />};
	like $button, qr{<input type="hidden" name="t3" value="M" />};
};

