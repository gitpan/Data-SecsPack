#!perl
#
#
use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '0.01';   # automatically generated file
$DATE = '2004/04/23';


##### Demonstration Script ####
#
# Name: SecsPackStress.d
#
# UUT: Data::SecsPack
#
# The module Test::STDmaker generated this demo script from the contents of
#
# t::Data::SecsPackStress 
#
# Don't edit this test script file, edit instead
#
# t::Data::SecsPackStress
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
    use Test::Tech qw(demo is_skip plan skip_tests tech_config );

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
\ \ \ \ my\ \(\$result\,\@result\)\;\
\
\ \ \ \ \#\#\#\#\#\#\#\#\#\
\ \ \ \ \#\ Subroutines\ to\ test\ that\ actual\ values\ are\ within\
\ \ \ \ \#\ and\ expected\ tolerance\ of\ the\ expected\ value\
\ \ \ \ \#\
\ \ \ \ sub\ tolerance\
\ \ \ \ \{\
\ \ \ \ \ \ \ \ my\ \(\$actual\,\$expected\)\ \=\ \@_\;\
\ \ \ \ \ \ \ \ 2\ \*\ \(\$expected\ \-\ \$actual\)\ \/\ \(\$expected\ \+\ \$actual\)\;\
\ \ \ \ \}\
\
\ \ \ \ sub\ pass_fail_tolerance\
\ \ \ \ \{\ \ \ my\ \(\$actual\,\$expected\)\ \=\ \@_\;\
\ \ \ \ \ \ \ \ \ \(\-\$expected\ \<\ \$actual\)\ \&\&\ \(\$actual\ \<\ \$expected\)\ \?\ 1\ \:\ 0\;\
\ \ \ \ \}\
\ \ \ \ my\ \(\$actual_result\,\ \$tolerance_result\)\;"); # typed in command           
          use File::Package;
    my $fp = 'File::Package';

    my $uut = 'Data::SecsPack';
    my $loaded;

    my ($result,@result);

    #########
    # Subroutines to test that actual values are within
    # and expected tolerance of the expected value
    #
    sub tolerance
    {
        my ($actual,$expected) = @_;
        2 * ($expected - $actual) / ($expected + $actual);
    }

    sub pass_fail_tolerance
    {   my ($actual,$expected) = @_;
         (-$expected < $actual) && ($actual < $expected) ? 1 : 0;
    }
    my ($actual_result, $tolerance_result);; # execution

print << 'EOF';

 => ##################
 => # UUT Loaded
 => # 
 => ###

EOF

demo( "\ \ \ my\ \$errors\ \=\ \$fp\-\>load_package\(\$uut\,\ \
\ \ \ \ \ \ \ qw\(bytes2int\ float2binary\ \
\ \ \ \ \ \ \ \ \ \ ifloat2binary\ int2bytes\ \ \ \
\ \ \ \ \ \ \ \ \ \ pack_float\ pack_int\ pack_num\ \ \
\ \ \ \ \ \ \ \ \ \ str2float\ str2int\ \
\ \ \ \ \ \ \ \ \ \ unpack_float\ unpack_int\ unpack_num\)\ \)\;"); # typed in command           
         my $errors = $fp->load_package($uut, 
       qw(bytes2int float2binary 
          ifloat2binary int2bytes   
          pack_float pack_int pack_num  
          str2float str2int 
          unpack_float unpack_int unpack_num) );; # execution

demo( "\$errors", # typed in command           
      $errors # execution
) unless     $loaded; # condition for execution                            

print << 'EOF';

 => ##################
 => # int2bytes(-32768)
 => # 
 => ###

EOF

demo( "\[int2bytes\(\-32768\)\]", # typed in command           
      [int2bytes(-32768)]); # execution


print << 'EOF';

 => ##################
 => # int2bytes(-32767)
 => # 
 => ###

EOF

demo( "\[int2bytes\(\-32767\)\]", # typed in command           
      [int2bytes(-32767)]); # execution


demo( "\ sub\ binary2hex\
\ \{\
\ \ \ \ \ my\ \$magnitude\ \=\ shift\;\
\ \ \ \ \ my\ \$sign\ \=\ \$1\ if\ \$magnitude\ \=\~\ s\/\^\(\\\-\)\\s\*\/\/\;\
\ \ \ \ \ \$magnitude\ \=\ \ unpack\ \'H\*\'\,pack\(\'C\*\'\,\ int2bytes\(\$magnitude\)\)\;\
\ \ \ \ \ \"\$sign\$magnitude\"\;\
\ \}\;\
\
\ my\ \@ifloat_test\ \=\ \ \(\
\ \ \ \ \#\ \ \ \ \ \ test\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ expected\
\ \ \ \ \#\ \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\ \ \ \ \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\ \ \ \ \
\ \ \ \ \#\ magnitude\ \ \ \ \ exp\ \ \ \ \ \ \ magnitude\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ exp\ \
\ \ \ \ \#\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\
\ \ \ \ \[\ \ \ \ \ \ \ \ \ \ \ 5\ \,\ \ \ \-1\,\ \ \ \ \ \ \'010000\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \-1\ \]\,\
\ \ \ \ \[\ \ \ \ 59101245\ \,\ \ \ \-1\,\ \ \ \ \ \ \'012e992f108ec37cc1f27e00\'\,\ \-1\ \]\,\
\ \ \ \ \[\ \ \ \ \ \ \ \ 3125\ \,\ \ \ \-2\,\ \ \ \ \ \ \'010000\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \-5\ \]\,\
\ \ \ \ \[\ \ \ \ \ \ \ \ \ 105\ \,\ \ \ \ 1\,\ \ \ \ \ \ \'01500000\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ 3\ \]\,\
\ \ \ \ \[\ \ \ \ \ \ \ \ \-105\ \,\ \ \ \ 1\,\ \ \ \ \ \'\-01500000\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ 3\ \]\,\
\ \ \ \ \[\ \ \ \ \ \ \ \ \-105\ \,\ \ \ \-1\,\ \ \ \ \ \'\-01ae147ae147ae147ae14000\'\,\ \-4\ \]\,\
\ \ \ \ \
\ \ \)\;\
\
\ \ my\ \(\@ifloats\,\ \$ifloat_name\,\ \
\ \ \ \ \ \$ifloat_test_mag\,\ \$ifloat_test_exp\,\ \$ifloat_expected_mag\,\ \$ifloat_expected_exp\ \)\;\
\
\#\#\#\#\#\#\#\#\
\#\ Start\ of\ the\ floating\ point\ test\ loop\
\#\ \
\#\
foreach\(\@ifloat_test\)\ \{\
\
\ \ \(\$ifloat_test_mag\,\ \$ifloat_test_exp\,\ \$ifloat_expected_mag\,\ \$ifloat_expected_exp\ \)\ \=\ \@\$_\;\
\ \ \$ifloat_name\ \=\ \"ifloat2binary\(\$ifloat_test_mag\,\ \$ifloat_test_exp\)\"\;"); # typed in command           
       sub binary2hex
 {
     my $magnitude = shift;
     my $sign = $1 if $magnitude =~ s/^(\-)\s*//;
     $magnitude =  unpack 'H*',pack('C*', int2bytes($magnitude));
     "$sign$magnitude";
 };

 my @ifloat_test =  (
    #      test               expected
    # --------------------    ------------------------------    
    # magnitude     exp       magnitude                  exp 
    #--------------------------------------------------------
    [           5 ,   -1,      '010000'                  , -1 ],
    [    59101245 ,   -1,      '012e992f108ec37cc1f27e00', -1 ],
    [        3125 ,   -2,      '010000'                  , -5 ],
    [         105 ,    1,      '01500000'                ,  3 ],
    [        -105 ,    1,     '-01500000'                ,  3 ],
    [        -105 ,   -1,     '-01ae147ae147ae147ae14000', -4 ],
    
  );

  my (@ifloats, $ifloat_name, 
     $ifloat_test_mag, $ifloat_test_exp, $ifloat_expected_mag, $ifloat_expected_exp );

########
# Start of the floating point test loop
# 
#
foreach(@ifloat_test) {

  ($ifloat_test_mag, $ifloat_test_exp, $ifloat_expected_mag, $ifloat_expected_exp ) = @$_;
  $ifloat_name = "ifloat2binary($ifloat_test_mag, $ifloat_test_exp)";; # execution

print << 'EOF';

 => ##################
 => # $ifloat_name magnitude
 => # 
 => ###

EOF

demo( "\@ifloats\ \=\ ifloat2binary\(\$ifloat_test_mag\,\$ifloat_test_exp\)"); # typed in command           
      @ifloats = ifloat2binary($ifloat_test_mag,$ifloat_test_exp); # execution

demo( "binary2hex\(\$ifloats\[0\]\)", # typed in command           
      binary2hex($ifloats[0])); # execution


print << 'EOF';

 => ##################
 => # $ifloat_name exponent
 => # 
 => ###

EOF

demo( "\$ifloats\[1\]", # typed in command           
      $ifloats[1]); # execution


demo( "\}\;"); # typed in command           
      };; # execution

demo( "\ \ \#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\#\
\ \ \#\ \ \ F4\ Not\ Rounded\ \ \
\ \ \#\ \
\ \ \#\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \(without\ implied\ 1\)\ \ \ \ \ \ \ \ \ \ implied\ 1\
\ \ \#\ \ \ Test\ \ \ \ \ \ \ sign\ \ exponent\ \ \ \ significant\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ hex\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
\ \ \#\
\ \ \#\ \ \ \ 10\.5\ \ \ \ \ \ \ 1\ \ \ \ 100\ 0001\ 0\ \ 0101\ 0000\ 0000\ 0000\ 0000\ 000\ 500000\
\ \ \#\ \ \ \-10\.5\ \ \ \ \ \ \ 1\ \ \ \ 100\ 0001\ 0\ \ 0101\ 0000\ 0000\ 0000\ 0000\ 000\ 500000\
\ \ \#\ \ \ 63\.54\ \ \ \ \ \ \ 0\ \ \ \ 100\ 0010\ 0\ \ 1111\ 1100\ 0101\ 0001\ 1110\ 101\ fc51ea\ \
\ \ \#\ \ \ 63\.54E64\ \ \ \ 0\ \ \ \ 111\ 1111\ 1\ \ 0000\ 0000\ 0000\ 0000\ 0000\ 000\ 000000\
\ \ \#\ \ \ 63\.54E36\ \ \ \ 0\ \ \ \ 111\ 1110\ 0\ \ 0111\ 1110\ 0110\ 1010\ 1101\ 111\ 7e6ade\
\ \ \#\ \ \ 63\.54E\-36\ \ \ 0\ \ \ \ 000\ 0110\ 1\ \ 0101\ 0001\ 1101\ 0110\ 0010\ 101\ 51d62a\
\ \ \#\ \ \-63\.54E\-36\ \ \ 1\ \ \ \ 000\ 0110\ 1\ \ 0101\ 0001\ 1101\ 0110\ 0010\ 101\ 51d62a\ \
\ \ \#\ \ \-63\.54E\-306\ \ 1\ \ \ \ 000\ 0000\ 0\ \ 0000\ 0000\ 0000\ 0000\ 0000\ 000\ 000000\
\ \ \#\ \ \ 0\ \ \ \ \ \ \ \ \ \ \ 0\ \ \ \ 000\ 0000\ 0\ \ 0000\ 0000\ 0000\ 0000\ 0000\ 000\ 000000\
\ \ \#\ \ \-0\ \ \ \ \ \ \ \ \ \ \ 1\ \ \ \ 000\ 0000\ 0\ \ 0000\ 0000\ 0000\ 0000\ 0000\ 000\ 000000\
\ \ \#\
\ \ \#\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2\*\*x\ \ \ \ significant\ \
\ \ \#\ \ \ Test\ \ \ \ \ \ \ \ \ Hex\ \ \ \ \ \ \ \ sign\ exponent\ hex\ \ \ \ decimal\
\ \ \#\ \ \ 5\.E\-1\
\ \ \#\ \ \ 5\.9101245E\-1\
\ \ \#\ \ \ 3\.125E\-2\
\ \ \#\ \ \ \ 10\.5\ \ \ \ \ \ \ \ 4128\ 0000\ \ \ 0\ \ \ \ \ \ \ \ \ 3\ \ 500000\ 1\.3125\
\ \ \#\ \ \ \-10\.5\ \ \ \ \ \ \ \ C128\ 0000\ \ \ 1\ \ \ \ \ \ \ \ \ 3\ \ 500000\ 1\.3125\
\ \ \#\ \ \ 63\.54\ \ \ \ \ \ \ \ 427E\ 28F5\ \ \ 0\ \ \ \ \ \ \ \ \ 5\ \ fc51ea\ 1\.9856249\
\ \ \#\ \ \ 63\.54E64\ \ \ \ \ 7F80\ 0000\ \ \ 0\ \ \ \ \ \ \ 128\ \ 000000\ 1\.0\ \ \ \ \ \ \ \ \(infinity\)\ \
\ \ \#\ \ \ 63\.54E36\ \ \ \ \ 7E3F\ 356F\ \ \ 0\ \ \ \ \ \ \ 125\ \ 7e6ade\ 1\.4938182\ \ \ \ \
\ \ \#\ \ \ 63\.54E\-36\ \ \ \ 06A8\ EB15\ \ \ 0\ \ \ \ \ \ \-114\ \ 51d62a\ 1\.3196741\ \
\ \ \#\ \ \-63\.54E\-36\ \ \ \ 86A8\ EB15\ \ \ 1\ \ \ \ \ \ \-114\ \ 51d62a\ 1\.3196741\
\ \ \#\ \ \-63\.54E\-306\ \ \ 8000\ 0000\ \ \ 1\ \ \ \ \ \ \-127\ \ 000000\ 1\.0\ \ \ \ \ \ \ \ \(underflow\)\
\ \ \#\ \ \-63\.54E306\ \ \ \ 7F80\ 0000\ \ \ 1\ \ \ \ \ \ \ 128\ \ 000000\ 1\.0\ \ \ \ \ \ \ \ \(infinity\)\
\ \ \#\ \ \ 0\ \ \ \ \ \ \ \ \ \ \ \ 0000\ 0000\ \ \ 1\ \ \ \ \ \ \-127\ \ 000000\ 1\.0\ \
\ \ \#\ \ \-0\ \ \ \ \ \ \ \ \ \ \ \ 8000\ 0000\ \ \ 1\ \ \ \ \ \ \-127\ \ 000000\ 1\.0\
\ \ \#\ \
\ \ \#\ \ \ F8\ Not\ Rounded\ \
\ \ \#\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2\*\*x\ \
\ \ \#\ \ \ Test\ \ \ \ \ \ \ \ \ Hex\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ sign\ exponent\ significant\
\ \ \#\ \ \ 5\.E\-1\
\ \ \#\ \ \ 5\.9101245E\-1\
\ \ \#\ \ \ 3\.125E\-2\
\ \ \#\ \ \ \ 10\.5\ \ \ \ \ \ \ \ 4025\ 0000\ 0000\ 0000\ 0\ \ \ \ \ \ \ \ \ 3\ \ 1\.3125\ \ \ \
\ \ \#\ \ \ \-10\.5\ \ \ \ \ \ \ \ C025\ 0000\ 0000\ 0000\ 1\ \ \ \ \ \ \ \ \ 3\ \ 1\.3125\
\ \ \#\ \ \ 63\.54\ \ \ \ \ \ \ \ 404F\ C51E\ B851\ EB85\ 0\ \ \ \ \ \ \ \ \ 5\ \ 1\.9856249\
\ \ \#\ \ \ 63\.54E64\ \ \ \ \ 4D98\ 2249\ 9022\ 2814\ 0\ \ \ \ \ \ \ 218\ \ 1\.5083709364139440\ \
\ \ \#\ \ \ 63\.54E36\ \ \ \ \ 47C7\ E6AD\ EF57\ 89B0\ 0\ \ \ \ \ \ \ 125\ \ 1\.4938182210249628\
\ \ \#\ \ \ 63\.54E\-36\ \ \ \ 38D5\ 1D62\ A97A\ 8965\ 0\ \ \ \ \ \ \-114\ \ 1\.3196741695652118\
\ \ \#\ \ \-63\.54E\-36\ \ \ \ B8D5\ 1D62\ A97A\ 8965\ 1\ \ \ \ \ \ \-114\ \ 1\.3196741695652118\
\ \ \#\ \ \-63\.54E\-306\ \ \ 80C6\ 4F45\ 661E\ 6296\ 1\ \ \ \ \ \-1011\ \ 1\.3943532933246040\
\ \ \#\ \ \ 63\.54E306\ \ \ \ 7FD6\ 9EF9\ 420B\ C99B\ 1\ \ \ \ \ \ 1022\ \ 1\.4138119296954758\
\ \ \#\ \ \ 0\ \ \ \ \ \ \ \ \ \ \ \ 0000\ 0000\ 0000\ 0000\ 0\ \ \ \ \ \-1023\ \ 1\.0\
\ \ \#\ \ \-0\ \ \ \ \ \ \ \ \ \ \ \ 8000\ 0000\ 0000\ 0000\ 1\ \ \ \ \ \-1023\ \ 1\.0\
\ \ \#\
\ \ \#\
\ my\ \@float_test\ \=\ \ \(\
\ \ \ \ \#\ pack\ float\ in\ \ \ \ \ \ \ expected\ pack\,\ unpack\ in\ \ \ \ \ \ \ \ \ expected\ unpack\
\ \ \ \ \#\ \-\-\-\-\-\-\-\-\-\-\-\-\-\-\ \ \ \ \ \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\ \ \ \ \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\
\ \ \ \ \#\ magnitude\ \ exp\ \ \ \ \ F4\ pack\ \ \ \ \ \ F8\ pack\ \ \ \ \ \ \ \ \ \ \ \ \ F4\ unpack\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ F8\ unpack\ \
\ \ \ \ \#\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\
\ \ \ \ \[\ \ \'105\'\ \ \,\ \ \ \ \'1\'\,\ \'41280000\'\,\ \'4025000000000000\'\,\ \ \'10\.5\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \'10\.5\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \'\-105\'\ \ \,\ \ \ \ \'1\'\,\ \'c1280000\'\,\ \'c025000000000000\'\,\ \'\-10\.5\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \'\-10\.5\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \ \'6354\'\ \,\ \ \ \ \'1\'\,\ \'427e28f5\'\,\ \'404fc51eb851eb85\'\,\ \ \'63\.54\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \'\ 63\.54\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \ \'6354\'\ \,\ \ \ \'65\'\,\ \'7fffffff\'\,\ \'4d98224990222274\'\,\ \ \'6\.80564693277058e38\'\ \ \ \,\ \ \'6\.354E65\'\ \ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \ \'6354\'\ \,\ \ \ \'37\'\,\ \'7e3f356f\'\,\ \'47c7e6adef5788a2\'\,\ \ \'6\.354E37\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \'6\.354E37\'\ \ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \ \'6354\'\ \,\ \ \'\-35\'\,\ \'06a8eb15\'\,\ \'38d51d62a97a8a8a\'\,\ \ \'6\.354E\-35\'\ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \'6\.354E\-35\'\ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \'\-6354\'\ \,\ \ \'\-35\'\,\ \'86a8eb15\'\,\ \'b8d51d62a97a8a8a\'\,\ \'\-6\.354E\-35\'\ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \'\-6\.354E\-35\'\ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \'\-6354\'\ \,\ \'\-305\'\,\ \'80000000\'\,\ \'80c64f45661e6e8f\'\,\ \'\-5\.8774717175411144e\-39\'\,\ \'\-6\.354E\-305\'\ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \'\ 6354\'\ \,\ \ \'307\'\,\ \'7fffffff\'\,\ \'7fd69ef9420bb88d\'\,\ \ \'6\.80564693277058e38\'\ \ \ \,\ \ \'6\.354E307\'\ \ \ \ \ \ \ \ \ \ \ \]\,\
\ \ \ \ \[\ \ \ \ \ \'0\'\ \,\ \ \'\-36\'\,\ \'00000000\'\,\ \'0000000000000000\'\,\ \ \'5\.8774717175411144e\-39\'\,\ \ \'1\.1125369292536e\-308\'\]\,\
\ \ \ \ \[\ \ \ \ \'\-0\'\ \,\ \ \'\-36\'\,\ \'80000000\'\,\ \'8000000000000000\'\,\ \'\-5\.8774717175411144e\-39\'\,\ \'\-1\.1125369292536e\-308\'\]\,\
\ \ \)\;\
\
my\ \$F4_criteria\ \=\ 1E\-4\;\
my\ \$F8_criteria\ \=\ 1E\-4\;\
\
\#\#\#\#\#\#\#\
\#\ Loop\ the\ above\ values\ for\ both\ a\ F4\ and\ F8\ conversions\
\#\
my\ \(\$float_int\,\ \$float_frac\,\ \$float_exp\,\ \$f4_float_hex\,\ \$f8_float_hex\)\;\
my\ \(\$f4_float\,\ \$f8_float\,\ \$format\,\ \$numbers\)\;\
\
\
\#\#\#\#\#\#\#\#\
\#\ Start\ of\ the\ floating\ point\ test\ loop\
\#\ \
\#\
foreach\ \$_\ \(\@float_test\)\ \{\
\
\ \ \(\$float_int\,\ \$float_exp\,\ \$f4_float_hex\,\ \$f8_float_hex\,\ \$f4_float\,\ \$f8_float\)\ \=\ \@\$_\;\
\
\#\#\#\#\#\
\#\ Filling\ in\ the\ above\ values\ in\ the\ tests\
\#"); # typed in command           
        ###################
  #   F4 Not Rounded  
  # 
  #                                (without implied 1)          implied 1
  #   Test       sign  exponent    significant                  hex               
  #
  #    10.5       1    100 0001 0  0101 0000 0000 0000 0000 000 500000
  #   -10.5       1    100 0001 0  0101 0000 0000 0000 0000 000 500000
  #   63.54       0    100 0010 0  1111 1100 0101 0001 1110 101 fc51ea 
  #   63.54E64    0    111 1111 1  0000 0000 0000 0000 0000 000 000000
  #   63.54E36    0    111 1110 0  0111 1110 0110 1010 1101 111 7e6ade
  #   63.54E-36   0    000 0110 1  0101 0001 1101 0110 0010 101 51d62a
  #  -63.54E-36   1    000 0110 1  0101 0001 1101 0110 0010 101 51d62a 
  #  -63.54E-306  1    000 0000 0  0000 0000 0000 0000 0000 000 000000
  #   0           0    000 0000 0  0000 0000 0000 0000 0000 000 000000
  #  -0           1    000 0000 0  0000 0000 0000 0000 0000 000 000000
  #
  #                                 2**x    significant 
  #   Test         Hex        sign exponent hex    decimal
  #   5.E-1
  #   5.9101245E-1
  #   3.125E-2
  #    10.5        4128 0000   0         3  500000 1.3125
  #   -10.5        C128 0000   1         3  500000 1.3125
  #   63.54        427E 28F5   0         5  fc51ea 1.9856249
  #   63.54E64     7F80 0000   0       128  000000 1.0        (infinity) 
  #   63.54E36     7E3F 356F   0       125  7e6ade 1.4938182    
  #   63.54E-36    06A8 EB15   0      -114  51d62a 1.3196741 
  #  -63.54E-36    86A8 EB15   1      -114  51d62a 1.3196741
  #  -63.54E-306   8000 0000   1      -127  000000 1.0        (underflow)
  #  -63.54E306    7F80 0000   1       128  000000 1.0        (infinity)
  #   0            0000 0000   1      -127  000000 1.0 
  #  -0            8000 0000   1      -127  000000 1.0
  # 
  #   F8 Not Rounded 
  #                                            2**x 
  #   Test         Hex                sign exponent significant
  #   5.E-1
  #   5.9101245E-1
  #   3.125E-2
  #    10.5        4025 0000 0000 0000 0         3  1.3125   
  #   -10.5        C025 0000 0000 0000 1         3  1.3125
  #   63.54        404F C51E B851 EB85 0         5  1.9856249
  #   63.54E64     4D98 2249 9022 2814 0       218  1.5083709364139440 
  #   63.54E36     47C7 E6AD EF57 89B0 0       125  1.4938182210249628
  #   63.54E-36    38D5 1D62 A97A 8965 0      -114  1.3196741695652118
  #  -63.54E-36    B8D5 1D62 A97A 8965 1      -114  1.3196741695652118
  #  -63.54E-306   80C6 4F45 661E 6296 1     -1011  1.3943532933246040
  #   63.54E306    7FD6 9EF9 420B C99B 1      1022  1.4138119296954758
  #   0            0000 0000 0000 0000 0     -1023  1.0
  #  -0            8000 0000 0000 0000 1     -1023  1.0
  #
  #
 my @float_test =  (
    # pack float in       expected pack, unpack in         expected unpack
    # --------------     -----------------------------    ----------------------------------------
    # magnitude  exp     F4 pack      F8 pack             F4 unpack                 F8 unpack 
    #------------------------------------------------------------------------------------------------------
    [  '105'  ,    '1', '41280000', '4025000000000000',  '10.5'                  ,  '10.5'                ],
    [ '-105'  ,    '1', 'c1280000', 'c025000000000000', '-10.5'                  , '-10.5'                ],
    [  '6354' ,    '1', '427e28f5', '404fc51eb851eb85',  '63.54'                 , ' 63.54'               ],
    [  '6354' ,   '65', '7fffffff', '4d98224990222274',  '6.80564693277058e38'   ,  '6.354E65'            ],
    [  '6354' ,   '37', '7e3f356f', '47c7e6adef5788a2',  '6.354E37'              ,  '6.354E37'            ],
    [  '6354' ,  '-35', '06a8eb15', '38d51d62a97a8a8a',  '6.354E-35'             ,  '6.354E-35'           ],
    [ '-6354' ,  '-35', '86a8eb15', 'b8d51d62a97a8a8a', '-6.354E-35'             , '-6.354E-35'           ],
    [ '-6354' , '-305', '80000000', '80c64f45661e6e8f', '-5.8774717175411144e-39', '-6.354E-305'          ],
    [ ' 6354' ,  '307', '7fffffff', '7fd69ef9420bb88d',  '6.80564693277058e38'   ,  '6.354E307'           ],
    [     '0' ,  '-36', '00000000', '0000000000000000',  '5.8774717175411144e-39',  '1.1125369292536e-308'],
    [    '-0' ,  '-36', '80000000', '8000000000000000', '-5.8774717175411144e-39', '-1.1125369292536e-308'],
  );

my $F4_criteria = 1E-4;
my $F8_criteria = 1E-4;

#######
# Loop the above values for both a F4 and F8 conversions
#
my ($float_int, $float_frac, $float_exp, $f4_float_hex, $f8_float_hex);
my ($f4_float, $f8_float, $format, $numbers);


########
# Start of the floating point test loop
# 
#
foreach $_ (@float_test) {

  ($float_int, $float_exp, $f4_float_hex, $f8_float_hex, $f4_float, $f8_float) = @$_;

#####
# Filling in the above values in the tests
#; # execution

print << 'EOF';

 => ##################
 => # pack_float('F4', [$float_int,$float_exp]) format
 => # 
 => ###

EOF

demo( "\(\$format\,\ \$numbers\)\ \=\ pack_float\(\'F4\'\,\ \[\$float_int\,\$float_exp\]\)"); # typed in command           
      ($format, $numbers) = pack_float('F4', [$float_int,$float_exp]); # execution

demo( "\$format", # typed in command           
      $format); # execution


print << 'EOF';

 => ##################
 => # pack_float('F4', [$float_int,$float_exp]) float
 => # 
 => ###

EOF

demo( "unpack\(\'H\*\'\,\ \$numbers\)", # typed in command           
      unpack('H*', $numbers)); # execution


print << 'EOF';

 => ##################
 => # unpack_float('F4',$f4_float_hex) float
 => # 
 => ###

EOF

demo( "\ \ \ \ \ \$actual_result\ \=\ \$\{unpack_float\(\'F4\'\,\$numbers\)\}\[0\]\;\
\ \ \ \ \ \$tolerance_result\ \=\ tolerance\(\$actual_result\,\$f4_float\)\;"); # typed in command           
           $actual_result = ${unpack_float('F4',$numbers)}[0];
     $tolerance_result = tolerance($actual_result,$f4_float);; # execution

demo( "pass_fail_tolerance\(\$tolerance_result\,\ \$F4_criteria\)", # typed in command           
      pass_fail_tolerance($tolerance_result, $F4_criteria)); # execution


print << 'EOF';

 => ##################
 => # pack_float('F8', [$float_int,$float_exp]) format
 => # 
 => ###

EOF

demo( "\(\$format\,\ \$numbers\)\ \=\ pack_float\(\'F8\'\,\ \[\$float_int\,\$float_exp\]\)"); # typed in command           
      ($format, $numbers) = pack_float('F8', [$float_int,$float_exp]); # execution

demo( "\$format", # typed in command           
      $format); # execution


print << 'EOF';

 => ##################
 => # pack_float('F8', [$float_int,$float_exp]) float
 => # 
 => ###

EOF

demo( "unpack\(\'H\*\'\,\ \$numbers\)", # typed in command           
      unpack('H*', $numbers)); # execution


print << 'EOF';

 => ##################
 => # unpack_float('F8',$f8_float_hex) float
 => # 
 => ###

EOF

demo( "\ \ \ \ \$actual_result\ \=\ \$\{unpack_float\(\'F8\'\,\$numbers\)\}\[0\]\;\
\ \ \ \ \$tolerance_result\ \=\ tolerance\(\$actual_result\,\$f8_float\)\;"); # typed in command           
          $actual_result = ${unpack_float('F8',$numbers)}[0];
    $tolerance_result = tolerance($actual_result,$f8_float);; # execution

demo( "pass_fail_tolerance\(\$tolerance_result\,\ \$F8_criteria\)", # typed in command           
      pass_fail_tolerance($tolerance_result, $F8_criteria)); # execution


demo( "\ \#\#\#\#\#\#\
\ \#\ End\ of\ the\ Floating\ Point\ Test\ Loop\
\ \#\#\#\#\#\#\#\
\
\ \}\;"); # typed in command           
       ######
 # End of the Floating Point Test Loop
 #######

 };; # execution

demo( "\ \ \ \ \
\ my\ \@pack_int_test\ \=\ \ \(\
\ \ \ \[\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
\ \ \ \ \ \[\'78\ 45\ 25\'\,\ \'512\ 1024\ hello\ world\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_strings\
\ \ \ \ \ \'I\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_format\
\ \ \ \ \ \'U2\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_format\
\ \ \ \ \ \'004e002d001902000400\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_numbers\ \ \
\ \ \ \ \ \[\'hello\ world\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_strings\ \ \
\ \ \ \ \ \[78\,\ 45\,\ 25\,\ 512\,\ 1024\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_unpack\ \ \ \ \ \ \
\ \ \ \]\,\
\
\ \ \ \[\
\ \ \ \ \ \[\'\-78\ 45\ \-25\'\,\ \'world\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_strings\
\ \ \ \ \ \'I\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_format\
\ \ \ \ \ \'S1\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_format\
\ \ \ \ \ \'b22de7\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_numbers\ \ \
\ \ \ \ \ \[\'world\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_strings\ \ \
\ \ \ \ \ \[\-78\,\ 45\,\ \-25\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_unpack\ \ \ \ \ \ \
\ \ \ \]\,\
\
\ \ \ \[\
\ \ \ \ \ \[\'\-128\ 128\ \-127\ 127\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_strings\
\ \ \ \ \ \'I\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_format\
\ \ \ \ \ \'S2\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_format\
\ \ \ \ \ \'ff800080ff81007f\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_numbers\ \ \
\ \ \ \ \ \[\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_strings\ \ \
\ \ \ \ \ \[\-128\,\ 128\,\ \-127\,\ 127\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_unpack\ \ \ \ \ \ \
\ \ \ \]\,\
\
\ \ \ \[\
\ \ \ \ \ \[\'\-32768\ 32768\ \-32767\ 32767\'\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_strings\
\ \ \ \ \ \'I\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ test_format\
\ \ \ \ \ \'S4\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_format\
\ \ \ \ \ \'ffff800000008000ffff800100007fff\'\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_numbers\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_numbers\ \ \
\ \ \ \ \ \[\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_strings\ \ \
\ \ \ \ \ \[\-32768\,32768\,\-32767\,32767\]\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \,\ \ \#\ expected_unpack\ \ \ \ \ \ \
\ \ \ \]\,\
\
\)\;\
\
\
\ \ \ \ my\ \(\$test_strings\,\ \@test_strings\,\$test_string_text\,\$test_format\,\ \$expected_format\,\
\ \ \ \ \ \ \ \ \$expected_numbers\,\$expected_strings\,\ \$expected_unpack\)\;\
\
\ \ \ \ my\ \(\@strings\)\;\
\
\#\#\#\#\#\#\#\#\
\#\ Start\ of\ the\ pack\ int\ test\ loop\
\#\ \
\#\
foreach\ \$_\ \(\@pack_int_test\)\ \{\
\
\ \ \ \ \(\$test_strings\,\$test_format\,\ \$expected_format\,\
\ \ \ \ \ \ \ \ \$expected_numbers\,\$expected_strings\,\ \$expected_unpack\)\ \=\ \@\$_\;\
\
\ \ \ \ \ \@test_strings\ \=\ \@\$test_strings\;\
\ \ \ \ \ \$test_string_text\ \=\ join\ \'\ \'\,\@test_strings\;"); # typed in command           
          
 my @pack_int_test =  (
   [                                                           
     ['78 45 25', '512 1024 hello world']                   ,  # test_strings
     'I'                                                    ,  # test_format
     'U2'                                                   ,  # expected_format
     '004e002d001902000400'                                 ,  # expected_numbers  
     ['hello world']                                        ,  # expected_strings  
     [78, 45, 25, 512, 1024]                                ,  # expected_unpack      
   ],

   [
     ['-78 45 -25', 'world']                                ,  # test_strings
     'I'                                                    ,  # test_format
     'S1'                                                   ,  # expected_format
     'b22de7'                                               ,  # expected_numbers  
     ['world']                                              ,  # expected_strings  
     [-78, 45, -25]                                         ,  # expected_unpack      
   ],

   [
     ['-128 128 -127 127']                                  ,  # test_strings
     'I'                                                    ,  # test_format
     'S2'                                                   ,  # expected_format
     'ff800080ff81007f'                                     ,  # expected_numbers  
     []                                                     ,  # expected_strings  
     [-128, 128, -127, 127]                                 ,  # expected_unpack      
   ],

   [
     ['-32768 32768 -32767 32767']                          ,  # test_strings
     'I'                                                    ,  # test_format
     'S4'                                                   ,  # expected_format
     'ffff800000008000ffff800100007fff'                     ,  # expected_numbers                                                     ,  # expected_numbers  
     []                                                     ,  # expected_strings  
     [-32768,32768,-32767,32767]                            ,  # expected_unpack      
   ],

);


    my ($test_strings, @test_strings,$test_string_text,$test_format, $expected_format,
        $expected_numbers,$expected_strings, $expected_unpack);

    my (@strings);

########
# Start of the pack int test loop
# 
#
foreach $_ (@pack_int_test) {

    ($test_strings,$test_format, $expected_format,
        $expected_numbers,$expected_strings, $expected_unpack) = @$_;

     @test_strings = @$test_strings;
     $test_string_text = join ' ',@test_strings;; # execution

print << 'EOF';

 => ##################
 => # pack_num($test_format, $test_string_text) format
 => # 
 => ###

EOF

demo( "\(\$format\,\ \$numbers\,\ \@strings\)\ \=\ pack_num\(\'I\'\,\@test_strings\)"); # typed in command           
      ($format, $numbers, @strings) = pack_num('I',@test_strings); # execution

demo( "\$format", # typed in command           
      $format); # execution


print << 'EOF';

 => ##################
 => # pack_num($test_format, $test_string_text) numbers
 => # 
 => ###

EOF

demo( "unpack\(\'H\*\'\,\$numbers\)", # typed in command           
      unpack('H*',$numbers)); # execution


print << 'EOF';

 => ##################
 => # pack_num($test_format, $test_string_text) \@strings
 => # 
 => ###

EOF

demo( "\[\@strings\]", # typed in command           
      [@strings]); # execution


print << 'EOF';

 => ##################
 => # unpack_num($expected_format, $test_string_text) error check
 => # 
 => ###

EOF

demo( "ref\(my\ \$unpack_numbers\ \=\ unpack_num\(\$expected_format\,\$numbers\)\)", # typed in command           
      ref(my $unpack_numbers = unpack_num($expected_format,$numbers))); # execution


print << 'EOF';

 => ##################
 => # unpack_num($expected_format, $test_string_text) numbers
 => # 
 => ###

EOF

demo( "\$unpack_numbers", # typed in command           
      $unpack_numbers); # execution


demo( "\ \#\#\#\#\#\#\
\ \#\ End\ of\ the\ pack\ int\ Test\ Loop\
\ \#\#\#\#\#\#\#\
\
\ \}\;"); # typed in command           
       ######
 # End of the pack int Test Loop
 #######

 };; # execution


=head1 NAME

SecsPackStress.d - demostration script for Data::SecsPack

=head1 SYNOPSIS

 SecsPackStress.d

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

