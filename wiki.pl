#!/usr/bin/perl -w
use strict;

#User-Agent string. This makes the API happy.
my $useragent = "\'wiki.pl/1.3 (spamme446\@gmail.com) BasedOnCURLandPerl\'";

foreach my $arg (@ARGV) {
	$_ .= "$arg ";	#Assign contents of argument to standard variable.
}

$/ = " ";
chomp;
$/ = "\n";	#Remove trailing newlines or spaces.
chomp;

s/^([a-z])/\U$1/g;	#Capitalize first letter. Reduces capitalization problems.

s/ /%20/g;	#Percent-encode spaces (not required, but URL-friendly)

#Prepere URL for API call.
my $curlrequest = "\"https://en.wikipedia.org/w/api.php?format=xml&action=query&prop=extracts&exintro=&explaintext=&titles=" . $_ . "\"";

$_ = `curl --user-agent $useragent -s $curlrequest`;	#Call API; stash result.

s/<[^>]*>//g;	#Strip XML tags.

#Convert HTML specials.
s/&quot;/"/g;
s/&amp;/&/g;
s/&apos;/'/g;
s/&lt;/</g;
s/&gt;/>/g;

print "$_\n";	#Excrete.

