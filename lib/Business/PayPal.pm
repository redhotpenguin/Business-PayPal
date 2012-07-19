package Business::PayPal;

use 5.6.1;
use strict;
use warnings;

our $VERSION = '0.05';

use Net::SSLeay 1.14;
use Digest::MD5 qw(md5_hex);
use CGI;

our $Cert = <<CERT;
-----BEGIN CERTIFICATE-----
MIIGSzCCBTOgAwIBAgIQLjOHT2/i1B7T//819qTJGDANBgkqhkiG9w0BAQUFADCB
ujELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQL
ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTswOQYDVQQLEzJUZXJtcyBvZiB1c2Ug
YXQgaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYSAoYykwNjE0MDIGA1UEAxMr
VmVyaVNpZ24gQ2xhc3MgMyBFeHRlbmRlZCBWYWxpZGF0aW9uIFNTTCBDQTAeFw0x
MTAzMjMwMDAwMDBaFw0xMzA0MDEyMzU5NTlaMIIBDzETMBEGCysGAQQBgjc8AgED
EwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEdMBsGA1UEDxMUUHJpdmF0
ZSBPcmdhbml6YXRpb24xEDAOBgNVBAUTBzMwMTQyNjcxCzAJBgNVBAYTAlVTMRMw
EQYDVQQRFAo5NTEzMS0yMDIxMRMwEQYDVQQIEwpDYWxpZm9ybmlhMREwDwYDVQQH
FAhTYW4gSm9zZTEWMBQGA1UECRQNMjIxMSBOIDFzdCBTdDEVMBMGA1UEChQMUGF5
UGFsLCBJbmMuMRowGAYDVQQLFBFQYXlQYWwgUHJvZHVjdGlvbjEXMBUGA1UEAxQO
d3d3LnBheXBhbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCd
szetUP2zRUbaN1vHuX9WV2mMq0IIVQ5NX2kpFCwBYc4vwW/CHiMr+dgs8lDduCfH
5uxhyRxKtJa6GElIIiP8qFB5HFWf1uUgoDPC1he4HaxUkowCnVEqjEowOy9R9Cr4
yyrmqmMEDccVsx4d3dOY2JF1FrLDHT7qH/GCBnyYw+nZJ88ci6HqnVJiNM+NX/D/
d7Y3r3V1bp7y1DaJwK/z/uMwNCC+lcM59w+nwAvLutgCW6WitFHMB+HpSsOSJlIZ
ydpj0Ox+javRR1FIdhRUFMK4wwcbD8PvULi1gM+sYsJIzP0mHDlhWRIDImG1zmy2
x7ZLp0HA5WayjI5aSn9fAgMBAAGjggHzMIIB7zAJBgNVHRMEAjAAMB0GA1UdDgQW
BBQxqt0MVbSO4lWE5aB52xc8nEq5RTALBgNVHQ8EBAMCBaAwQgYDVR0fBDswOTA3
oDWgM4YxaHR0cDovL0VWU2VjdXJlLWNybC52ZXJpc2lnbi5jb20vRVZTZWN1cmUy
MDA2LmNybDBEBgNVHSAEPTA7MDkGC2CGSAGG+EUBBxcGMCowKAYIKwYBBQUHAgEW
HGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEwHQYDVR0lBBYwFAYIKwYBBQUH
AwEGCCsGAQUFBwMCMB8GA1UdIwQYMBaAFPyKULqeuSVae1WFT5UAY4/pWGtDMHwG
CCsGAQUFBwEBBHAwbjAtBggrBgEFBQcwAYYhaHR0cDovL0VWU2VjdXJlLW9jc3Au
dmVyaXNpZ24uY29tMD0GCCsGAQUFBzAChjFodHRwOi8vRVZTZWN1cmUtYWlhLnZl
cmlzaWduLmNvbS9FVlNlY3VyZTIwMDYuY2VyMG4GCCsGAQUFBwEMBGIwYKFeoFww
WjBYMFYWCWltYWdlL2dpZjAhMB8wBwYFKw4DAhoEFEtruSiWBgy70FI4mymsSweL
IQUYMCYWJGh0dHA6Ly9sb2dvLnZlcmlzaWduLmNvbS92c2xvZ28xLmdpZjANBgkq
hkiG9w0BAQUFAAOCAQEAisdjAvky8ehg4A0J3ED6+yR0BU77cqtrLUKqzaLcLL/B
wuj8gErM8LLaWMGM/FJcoNEUgSkMI3/Qr1YXtXFvdqo3urqMhi/SsuUJU85Gnoxr
Vr0rWoBqOOnmcsVEgtYeusK0sQbxq5JlE1eq9xqYZrKuOuA/8JS1V7Ss1iFrtA5i
pwotaEK3k5NEJOQh9/Zm+fy1vZfUyyX+iVSlmyFHC4bzu2DlzZln3UzjBJeXoEfe
YjQyLpdUhUhuPslV1qs+Bmi6O+e6htDHvD05wUaRzk6vsPcEQ3EqsPbdpLgejb5p
9YDR12XLZeQjO1uiunCsJkDIf9/5Mqpu57pw8v1QNA==
-----END CERTIFICATE-----
CERT
chomp($Cert);

our $Certcontent = <<CERTCONTENT;
Subject Name: /1.3.6.1.4.1.311.60.2.1.3=US/1.3.6.1.4.1.311.60.2.1.2=Delaware/businessCategory=Private Organization/serialNumber=3014267/C=US/postalCode=95131-2021/ST=California/L=San Jose/street=2211 N 1st St/O=PayPal, Inc./OU=PayPal Production/CN=www.paypal.com
Issuer  Name: /C=US/O=VeriSign, Inc./OU=VeriSign Trust Network/OU=Terms of use at https://www.verisign.com/rpa (c)06/CN=VeriSign Class 3 Extended Validation SSL CA
CERTCONTENT
chomp($Certcontent);


# creates new PayPal object.  Assigns an id if none is provided.
sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = {
        id => undef,
        address => 'https://www.paypal.com/cgi-bin/webscr',
        @_,
    };
    bless $self, $class;
    $self->{id} = md5_hex(rand()) unless $self->{id};
    return $self;
}

# returns current PayPal id
sub id {
    my $self = shift;
    return $self->{id};
}

#creates a PayPal button
sub button {
    my $self = shift;
    my %buttonparam = (
        cmd                 => '_ext-enter',
        redirect_cmd        => '_xclick',
        button_image        => CGI::image_button(
            -name => 'submit',
            -src => 'http://images.paypal.com/images/x-click-but01.gif',
            -alt => 'Make payments with PayPal',
            ),
        business            => undef,
        item_name           => undef,
        item_number         => undef,
        image_url           => undef,
        no_shipping         => 1,
        return              => undef,
        cancel_return       => undef,
        no_note             => 1,
        undefined_quantity  => 0,
        notify_url          => undef,
        first_name          => undef,
        last_name           => undef,
        shipping            => undef,
        shipping2           => undef,
        quantity            => undef,
        amount              => undef,
        address1            => undef,
        address2            => undef,
        city                => undef,
        state               => undef,
        zip                 => undef,
        night_phone_a       => undef,
        night_phone_b       => undef,
        night_phone_c       => undef,
        day_phone_a         => undef,
        day_phone_b         => undef,
        day_phone_c         => undef,
        receiver_email      => undef,
        invoice             => undef,
        currency_code       => undef,
        custom              => $self->{id},
        @_,
    );
    my $key;
    my $content = CGI::start_form( -method => 'POST',
        -action => $self->{'address'},
                                 );
    foreach (keys %buttonparam) {
        next unless defined $buttonparam{$_};
        if ($_ eq 'button_image') {
            $content .= $buttonparam{$_};
        }
        else {
            $content .= CGI::hidden( -name => $_,
                                     -default => $buttonparam{$_},
                                   );
        }
    }
    $content .= CGI::endform();
    return $content;
}


# takes a reference to a hash of name value pairs, such as from a CGI query
# object, which should contain all the name value pairs which have been
# posted to the script by PayPal's Instant Payment Notification
# posts that data back to PayPal, checking if the ssl certificate matches,
# and returns success or failure, and the reason.
sub ipnvalidate {
    my $self = shift;
    my $query = shift;
    $$query{cmd} = '_notify-validate';
    my $id = $self->{id};
    my ($succ, $reason) = $self->postpaypal($query);
    return (wantarray ? ($id, $reason) : $id)
        if $succ;
    return (wantarray ? (undef, $reason) : undef);
}

# this method should not normally be used unless you need to test, or if
# you are overriding the behaviour of ipnvalidate.  It takes a reference
# to a hash containing the query, posts to PayPal with the data, and returns
# success or failure, as well as PayPal's response.
sub postpaypal {
    my $self = shift;
    my $address = $self->{address};
    my $query = shift; # reference to hash containing name value pairs
    my ($site, $port, $path);

    #following code splits an url into site, port and path components
    my @address = split /:\/\//, $address, 2;
    @address = split /(?=\/)/, $address[1], 2;
    if ($address[0] =~ /:/) {
        ($site, $port) = split /:/, $address[0];
    }
    else {
        ($site, $port) = ($address[0], '443');
    }
    $path = $address[1];
    my ($page,
        $response,
        $headers,
        $ppcert,
        ) = Net::SSLeay::post_https3($site,
                                         $port,
                                         $path,
                                         '',
                                         Net::SSLeay::make_form(%$query));


    my $ppx509 = Net::SSLeay::PEM_get_string_X509($ppcert);
    my $ppcertcontent =
    'Subject Name: '
        . Net::SSLeay::X509_NAME_oneline(
               Net::SSLeay::X509_get_subject_name($ppcert))
            . "\nIssuer  Name: "
                . Net::SSLeay::X509_NAME_oneline(
                       Net::SSLeay::X509_get_issuer_name($ppcert))
                    . "\n";

    chomp $ppx509;
    chomp $ppcertcontent;
    return (wantarray ? (undef, "PayPal cert failed to match: $ppx509\n$Cert") : undef)
        unless $Cert eq $ppx509;
    return (wantarray ? (undef, "PayPal cert contents failed to match $ppcertcontent") : undef)        unless $ppcertcontent eq "$Certcontent";
    return (wantarray ? (undef, 'PayPal says transaction INVALID') : undef)
        if $page eq 'INVALID';
    return (wantarray ? (1, 'PayPal says transaction VERIFIED') : 1)
        if $page eq 'VERIFIED';
    warn "Bad stuff happened\n$page";
    return (wantarray ? (undef, "Bad stuff happened") :undef);
}



1;

=head1 NAME

Business::PayPal - Perl extension for automating PayPal transactions

=head1 ABSTRACT

Business::PayPal makes the automation of PayPal transactions as simple
as doing credit card transactions through a regular processor.  It includes
methods for creating PayPal buttons and for validating the Instant Payment
Notification that is sent when PayPal processes a payment.

=head1 SYNOPSIS

To generate a PayPal button for use on your site
Include something like the following in your CGI

  use Business::PayPal;
  my $paypal = Business::PayPal->new;
  my $button = $paypal->button(
      business => 'dr@dursec.com',
      item_name => 'CanSecWest Registration Example',
      return => 'http://www.cansecwest.com/return.cgi',
      cancel_return => 'http://www.cansecwest.com/cancel.cgi',
      amount => '1600.00',
      quantity => 1,
      notify_url => http://www.cansecwest.com/ipn.cgi
  );
  my $id = $paypal->id;

store $id somewhere so we can get it back again later
store current context with $id
Apache::Session works well for this
print button to the browser
note, button is a CGI form, enclosed in <form></form> tags



To validate the Instant Payment Notification from PayPal for the
button used above include something like the following in your
'notify_url' CGI.

  use CGI;
  my $query = CGI->new;
  my %query = $query->Vars;
  my $id = $query{custom};
  my $paypal = Business::PayPal->new(id => $id);
  my ($txnstatus, $reason) = $paypal->ipnvalidate(\%query);
  die "PayPal failed: $reason" unless $txnstatus;
  my $money = $query{payment_gross};
  my $paystatus = $query{payment_status};

check if paystatus eq 'Completed'
check if $money is the ammount you expected
save payment status information to store as $id


To tell the user if their payment succeeded or not, use something like
the following in the CGI pointed to by the 'return' parameter in your
PayPal button.

  use CGI;
  my $query = CGI->new;
  my $id = $query{custom};

  #get payment status from store for $id
  #return payment status to customer


=head1 DESCRIPTION

=head2 new()

Creates a new Business::PayPal object, it can take the
following parameters:

=over 2

=item id

The Business::PayPal object id, if not specified a new
id will be created using md5_hex(rand())

=item address

The address of PayPal's payment server, currently:
https://www.paypal.com/cgi-bin/webscr

=item cert

The x509 certificate for I<address>, see source for default

=item certcontent

The contents of the x509 certificate I<cert>, see source for
default

=back

=head2 id()

Returns the id for the Business::PayPal object.

=head2 button()

Returns the HTML for a PayPal button.  It takes a large number of
parameters, which control the look and function of the button, some
of which are required and some of which have defaults.  They are
as follows:

=over 2

=item cmd

required, defaults to '_ext-enter'

This allows the user information to be pre-filled in.
You should never need to specify this, as the default should
work fine.

=item redirect_cmd

required, defaults to '_xclick'

This allows the user information to be pre-filled in.
You should never need to specify this, as the default should
work fine.

=item button_image

required, defaults to:

    CGI::image_button(-name => 'submit',
                      -src  => 'http://images.paypal.com/x-click-but01.gif'
                      -alt  => 'Make payments with PayPal',
                     )

You may wish to change this if the button is on an https page
so as to avoid the browser warnings about insecure content on a
secure page.

=item business

required, no default

This is the name of your PayPal account.

=item item_name

This is the name of the item you are selling.

=item item_number

This is a numerical id of the item you are selling.

=item image_url

A URL pointing to a 150 x 50 image which will be displayed
instead of the name of your PayPal account.

=item no_shipping

defaults to 1

If set to 1, does not ask customer for shipping info, if
set to 0 the customer will be prompted for shipping information.

=item return

This is the URL to which the customer will return to after
they have finished paying.

=item cancel_return

This is the URL to which the customer will be sent if they cancel
before paying.

=item no_note

defaults to 1

If set to 1, does not ask customer for a note with the payment,
if set to 0, the customer will be asked to include a note.

=item currency_code

Currency the payment should be taken in, e.g. EUR, GBP.
If not specified payments default to USD.

=item address1

=item undefined_quantity

defaults to 0

If set to 0 the quantity defaults to 1, if set to 1 the user
can edit the quantity.

=item notify_url

The URL to which PayPal Instant Payment Notification is sent.

=item first_name

First name of customer, used to pre-fill PayPal forms.

=item last_name

Last name of customer, used to pre-fill PayPal forms.

=item shipping

I don't know, something to do with shipping, please tell me if
you find out.

=item shipping2

I don't know, something to do with shipping, please tell me if you
find out.

=item quantity

defaults to 1

Number of items being sold.

=item amount

Price of the item being sold.

=item address1

Address of customer, used to pre-fill PayPal forms.

=item address2

Address of customer, used to pre-fill PayPal forms.

=item city

City of customer, used to pre-fill PayPal forms.

=item state

State of customer, used to pre-fill PayPal forms.

=item zip

Zip of customer, used to pre-fill PayPal forms.

=item night_phone_a

Phone

=item night_phone_b

Phone

=item night_phone_c

Phone

=item day_phone_a

Phone

=item day_phone_b

Phone

=item day_phone_c

Phone

=item receiver_email

Email address of customer - I think

=item invoice

Invoice number - I think

=item custom

defaults to the Business::PayPal id

Used by Business::PayPal to track which button is associated
with which Instant Payment Notification.

=back

=head2 ipnvalidate()

Takes a reference to a hash of name value pairs, such as from a
CGI query object, which should contain all the name value pairs
which have been posted to the script by PayPal's Instant Payment
Notification posts that data back to PayPal, checking if the ssl
certificate matches, and returns success or failure, and the
reason.

=head2 postpaypal()

This method should not normally be used unless you need to test,
or if you are overriding the behaviour of ipnvalidate.  It takes a
reference to a hash containing the query, posts to PayPal with
the data, and returns success or failure, as well as PayPal's
response.

=head1 MAINTAINER

Gabor Szabo, E<lt>gabor@szabgab.comE<gt>

phred, E<lt>fred@redhotpenguin.comE<gt>

=head1 AUTHOR

mock, E<lt>mock@obscurity.orgE<gt>

=head1 SEE ALSO

L<CGI>, L<perl>, L<Apache::Session>.

https://www.cansecwest.com/register.cgi is currently using this module
to do conference registrations.  If you wish to see it working, just
fill out the forms until you get to the PayPal button, click on the button,
and then cancel before paying (or pay, and come to CanSecWest :-) ).

=head1 LICENSE

Copyright (c) 2010, phred E<lt>fred@redhotpenguin.comE<gt>. All rights reserved.

Copyright (c) 2002, mock E<lt>mock@obscurity.orgE<gt>.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
