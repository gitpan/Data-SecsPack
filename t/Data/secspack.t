#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2004/04/13';
$FILE = __FILE__;


##### Test Script ####
#
# Name: secspack.t
#
# UUT: Data::SecsPack
#
# The module Test::STDmaker generated this test script from the contents of
#
# t::Data::SecsPack;
#
# Don't edit this test script file, edit instead
#
# t::Data::SecsPack;
#
#	ANY CHANGES MADE HERE TO THIS SCRIPT FILE WILL BE LOST
#
#       the next time Test::STDmaker generates this script file.
#
#

######
#
# T:
#
# use a BEGIN block so we print our plan before Module Under Test is loaded
#
BEGIN { 

   use FindBin;
   use File::Spec;
   use Cwd;

   ########
   # The working directory for this script file is the directory where
   # the test script resides. Thus, any relative files written or read
   # by this test script are located relative to this test script.
   #
   use vars qw( $__restore_dir__ );
   $__restore_dir__ = cwd();
   my ($vol, $dirs) = File::Spec->splitpath($FindBin::Bin,'nofile');
   chdir $vol if $vol;
   chdir $dirs if $dirs;

   #######
   # Pick up any testing program modules off this test script.
   #
   # When testing on a target site before installation, place any test
   # program modules that should not be installed in the same directory
   # as this test script. Likewise, when testing on a host with a @INC
   # restricted to just raw Perl distribution, place any test program
   # modules in the same directory as this test script.
   #
   use lib $FindBin::Bin;

   ########
   # Using Test::Tech, a very light layer over the module "Test" to
   # conduct the tests.  The big feature of the "Test::Tech: module
   # is that it takes expected and actual references and stringify
   # them by using "Data::Secs2" before passing them to the "&Test::ok"
   # Thus, almost any time of Perl data structures may be
   # compared by passing a reference to them to Test::Tech::ok
   #
   # Create the test plan by supplying the number of tests
   # and the todo tests
   #
   require Test::Tech;
   Test::Tech->import( qw(plan ok skip skip_tests tech_config finish) );
   plan(tests => 14);

}


END {
 
   #########
   # Restore working directory and @INC back to when enter script
   #
   @INC = @lib::ORIG_INC;
   chdir $__restore_dir__;
}


=head1 comment_out

###
# Have been problems with debugger with trapping CARP
#

####
# Poor man's eval where the test script traps off the Carp::croak 
# Carp::confess functions.
#
# The Perl authorities have Core::die locked down tight so
# it is next to impossible to trap off of Core::die. Lucky 
# must everyone uses Carp to die instead of just dieing.
#
use Carp;
use vars qw($restore_croak $croak_die_error $restore_confess $confess_die_error);
$restore_croak = \&Carp::croak;
$croak_die_error = '';
$restore_confess = \&Carp::confess;
$confess_die_error = '';
no warnings;
*Carp::croak = sub {
   $croak_die_error = '# Test Script Croak. ' . (join '', @_);
   $croak_die_error .= Carp::longmess (join '', @_);
   $croak_die_error =~ s/\n/\n#/g;
       goto CARP_DIE; # once croak can not continue
};
*Carp::confess = sub {
   $confess_die_error = '# Test Script Confess. ' . (join '', @_);
   $confess_die_error .= Carp::longmess (join '', @_);
   $confess_die_error =~ s/\n/\n#/g;
       goto CARP_DIE; # once confess can not continue

};
use warnings;
=cut


   # Perl code from C:
    use File::Package;
    my $fp = 'File::Package';

    my $uut = 'Data::SecsPack';
    my $loaded;

    my ($result,@result);

   # Perl code from C:
my $errors = $fp->load_package($uut, qw(pack_int pack_num str2int unpack_num));


####
# verifies requirement(s):
# L<DataPort::DataFile/general [1] - load>
# 

#####
skip_tests( 1 ) unless skip(
      $loaded, # condition to skip test   
      $errors, # actual results
      '',  # expected results
      "",
      "UUT Loaded");
 
#  ok:  1

ok(  $result = $uut->str2int('033'), # actual results
     27, # expected results
     "",
     "str2int(\'033\')");

#  ok:  2

ok(  $result = $uut->str2int('0xFF'), # actual results
     255, # expected results
     "",
     "str2int(\'0xFF\')");

#  ok:  3

ok(  $result = $uut->str2int('0b1010'), # actual results
     10, # expected results
     "",
     "str2int(\'0b1010\')");

#  ok:  4

ok(  $result = $uut->str2int('255'), # actual results
     255, # expected results
     "",
     "str2int(\'255\')");

#  ok:  5

ok(  $result = $uut->str2int('hello'), # actual results
     undef, # expected results
     "",
     "str2int(\'hello\')");

#  ok:  6

ok(  [my ($string, @integers) = str2int('78 45 25', '512 1024', '100000 hello world')], # actual results
     ['hello world',78,45,25,512,1024,100000], # expected results
     "",
     "str2int('78 45 25', '512 1024', '100000 hello world')");

#  ok:  7

   # Perl code from C:
my ($format, $integers) = pack_num('I',@integers);

ok(  $format, # actual results
     'U4', # expected results
     "",
     "pack_num('I', 78 45 25 512 1024 100000)");

#  ok:  8

ok(  unpack('H*',$integers), # actual results
     '0000004e0000002d000000190000020000000400000186a0', # expected results
     "",
     "packed 78 45 25 512 1024 100000");

#  ok:  9

ok(  ref(my $int_array = unpack_num('U4',$integers)), # actual results
     'ARRAY', # expected results
     "",
     "unpack_num('U4', 78 45 25 512 1024 100000)");

#  ok:  10

ok(  $int_array, # actual results
     [78, 45, 25, 512, 1024, 100000], # expected results
     "",
     "unpack_num number array");

#  ok:  11

   # Perl code from C:
($format, my $numbers, $string) = pack_num('I', '78 45 25', '512 1024', '100000 hello world');

ok(  $format, # actual results
     'U4', # expected results
     "",
     "pack_num('I', '78 45 25', '512 1024', '100000 hello world')");

#  ok:  12

ok(  $string, # actual results
     'hello world', # expected results
     "",
     "pack_num string");

#  ok:  13

ok(  unpack('H*', $numbers), # actual results
     '0000004e0000002d000000190000020000000400000186a0', # expected results
     "",
     "pack_num numbers");

#  ok:  14


=head1 comment out

# does not work with debugger
CARP_DIE:
    if ($croak_die_error || $confess_die_error) {
        print $Test::TESTOUT = "not ok $Test::ntest\n";
        $Test::ntest++;
        print $Test::TESTERR $croak_die_error . $confess_die_error;
        $croak_die_error = '';
        $confess_die_error = '';
        skip_tests(1, 'Test invalid because of Carp die.');
    }
    no warnings;
    *Carp::croak = $restore_croak;    
    *Carp::confess = $restore_confess;
    use warnings;
=cut

    finish();

__END__

=head1 NAME

secspack.t - test script for Data::SecsPack

=head1 SYNOPSIS

 secspack.t -log=I<string>

=head1 OPTIONS

All options may be abbreviated with enough leading characters
to distinguish it from the other options.

=over 4

=item C<-log>

secspack.t uses this option to redirect the test results 
from the standard output to a log file.

=back

=head1 COPYRIGHT

copyright © 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

\=over 4

\=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

\=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

\=back

SOFTWARE DIAMONDS, http://www.SoftwareDiamonds.com,
PROVIDES THIS SOFTWARE 
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE,DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF
ADVISED OF NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

## end of test script file ##

