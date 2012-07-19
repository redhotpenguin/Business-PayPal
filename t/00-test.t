# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 8 };
use Business::PayPal;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

my $pp1 = Business::PayPal->new();
my $pp2 = Business::PayPal->new(id => 'foobar');
ok($pp1); #test constructor
ok($pp2); #test constructor with arg

my $id1 = $pp1->id;
ok($id1, qr/[a-f0-9]{32}/); #test if id is hex

my $id2 = $pp2->id;
ok($id2, 'foobar'); #test if id is set to arbitrary string 

my $button1 = $pp1->button();
ok($button1); #test if button created
ok($button1, 
    qr/name\s*=\s*"{0,1}custom"{0,1}\s+value\s*=\s*"{0,1}$id1"{0,1}/i
  ); #test if 'custom' param eq id

my %query = (
    item_name => 'IPN Test',
);
my ($success, $reason) = $pp1->ipnvalidate(\%query);
ok($reason, 'PayPal says transaction INVALID'); #test if cert is correct


