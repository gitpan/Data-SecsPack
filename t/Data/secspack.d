#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2004/04/13';


##### Demonstration Script ####
#
# Name: secspack.d
#
# UUT: Data::SecsPack
#
# The module Test::STDmaker generated this demo script from the contents of
#
# t::Data::SecsPack 
#
# Don't edit this test script file, edit instead
#
# t::Data::SecsPack
#
#	ANY CHANGES MADE HERE TO THIS SCRIPT FILE WILL BE LOST
#
#       the next time Test::STDmaker generates this script file.
#
#

######
#
# The working directory is the directory of the generated file
#
use vars qw($__restore_dir__ @__restore_inc__ );

BEGIN {
    use Cwd;
    use File::Spec;
    use FindBin;
    use Test::Tech qw(tech_config plan demo skip_tests);

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

    unshift @INC, File::Spec->catdir( cwd(), 'lib' ); 

}

END {

    #########
    # Restore working directory and @INC back to when enter script
    #
    @INC = @lib::ORIG_INC;
    chdir $__restore_dir__;

}

print << 'MSG';

 ~~~~~~ Demonstration overview ~~~~~
 
Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

MSG

demo( "\ \ \ \ use\ File\:\:Package\;\
\ \ \ \ my\ \$fp\ \=\ \'File\:\:Package\'\;\
\
\ \ \ \ my\ \$uut\ \=\ \'Data\:\:SecsPack\'\;\
\ \ \ \ my\ \$loaded\;\
\
\ \ \ \ my\ \(\$result\,\@result\)"); # typed in command           
          use File::Package;
    my $fp = 'File::Package';

    my $uut = 'Data::SecsPack';
    my $loaded;

    my ($result,@result); # execution

demo( "my\ \$errors\ \=\ \$fp\-\>load_package\(\$uut\,\ qw\(pack_int\ pack_num\ str2int\ unpack_num\)\)"); # typed in command           
      my $errors = $fp->load_package($uut, qw(pack_int pack_num str2int unpack_num)); # execution

demo( "\$errors", # typed in command           
      $errors # execution
) unless     $loaded; # condition for execution                            

demo( "\$result\ \=\ \$uut\-\>str2int\(\'033\'\)", # typed in command           
      $result = $uut->str2int('033')); # execution


demo( "\$result\ \=\ \$uut\-\>str2int\(\'0xFF\'\)", # typed in command           
      $result = $uut->str2int('0xFF')); # execution


demo( "\$result\ \=\ \$uut\-\>str2int\(\'0b1010\'\)", # typed in command           
      $result = $uut->str2int('0b1010')); # execution


demo( "\$result\ \=\ \$uut\-\>str2int\(\'255\'\)", # typed in command           
      $result = $uut->str2int('255')); # execution


demo( "\$result\ \=\ \$uut\-\>str2int\(\'hello\'\)", # typed in command           
      $result = $uut->str2int('hello')); # execution


demo( "\[my\ \(\$string\,\ \@integers\)\ \=\ str2int\(\'78\ 45\ 25\'\,\ \'512\ 1024\'\,\ \'100000\ hello\ world\'\)\]", # typed in command           
      [my ($string, @integers) = str2int('78 45 25', '512 1024', '100000 hello world')]); # execution


demo( "my\ \(\$format\,\ \$integers\)\ \=\ pack_num\(\'I\'\,\@integers\)"); # typed in command           
      my ($format, $integers) = pack_num('I',@integers); # execution

demo( "\$format", # typed in command           
      $format); # execution


demo( "unpack\(\'H\*\'\,\$integers\)", # typed in command           
      unpack('H*',$integers)); # execution


demo( "ref\(my\ \$int_array\ \=\ unpack_num\(\'U4\'\,\$integers\)\)", # typed in command           
      ref(my $int_array = unpack_num('U4',$integers))); # execution


demo( "\$int_array", # typed in command           
      $int_array); # execution


demo( "\(\$format\,\ my\ \$numbers\,\ \$string\)\ \=\ pack_num\(\'I\'\,\ \'78\ 45\ 25\'\,\ \'512\ 1024\'\,\ \'100000\ hello\ world\'\)"); # typed in command           
      ($format, my $numbers, $string) = pack_num('I', '78 45 25', '512 1024', '100000 hello world'); # execution

demo( "\$format", # typed in command           
      $format); # execution


demo( "\$string", # typed in command           
      $string); # execution


demo( "unpack\(\'H\*\'\,\ \$numbers\)", # typed in command           
      unpack('H*', $numbers)); # execution



=head1 NAME

secspack.d - demostration script for Data::SecsPack

=head1 SYNOPSIS

 secspack.d

=head1 OPTIONS

None.

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

## end of test script file ##

=cut

