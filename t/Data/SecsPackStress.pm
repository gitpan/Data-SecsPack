#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  t::Data::SecsPackStress;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '0.01';
$DATE = '2004/04/23';
$FILE = __FILE__;

########
# The Test::STDmaker module uses the data after the __DATA__ 
# token to automatically generate the this file.
#
# Don't edit anything before __DATA_. Edit instead
# the data after the __DATA__ token.
#
# ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
#
# the next time Test::STDmaker generates this file.
#
#


=head1 TITLE PAGE

 Detailed Software Test Description (STD)

 for

 Perl Data::SecsPack Program Module

 Revision: -

 Version: 

 Date: 2004/04/22

 Prepared for: General Public 

 Prepared by:  http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com

 Classification: None

=head1 SCOPE

This detail STD and the 
L<General Perl Program Module (PM) STD|Test::STD::PerlSTD>
establishes the tests to verify the
requirements of Perl Program Module (PM) L<Data::SecsPack|Data::SecsPack>

The format of this STD is a tailored L<2167A STD DID|Docs::US_DOD::STD>.
in accordance with 
L<Detail STD Format|Test::STDmaker/Detail STD Format>.

#######
#  
#  4. TEST DESCRIPTIONS
#
#  4.1 Test 001
#
#  ..
#
#  4.x Test x
#
#

=head1 TEST DESCRIPTIONS

The test descriptions uses a legend to
identify different aspects of a test description
in accordance with
L<STD FormDB Test Description Fields|Test::STDmaker/STD FormDB Test Description Fields>.

=head2 Test Plan

 T: 84^

=head2 ok: 1


  C:
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
     my ($actual_result, $tolerance_result);
 ^
  N: UUT Loaded^
  R: L<DataPort::DataFile/general [1] - load>^
  S: $loaded^

  C:
    my $errors = $fp->load_package($uut, 
        qw(bytes2int float2binary 
           ifloat2binary int2bytes   
           pack_float pack_int pack_num  
           str2float str2int 
           unpack_float unpack_int unpack_num) );
 ^
  A: $errors^
 SE: ''^
 ok: 1^

=head2 ok: 2,4,6,8,10,12


  C:
  sub binary2hex
  {
      my $magnitude = shift;
      my $sign = $1 if $magnitude =~ s/^^(\-)\s*//;
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
   $ifloat_name = "ifloat2binary($ifloat_test_mag, $ifloat_test_exp)";
 ^
  N: $ifloat_name magnitude^
  C: @ifloats = ifloat2binary($ifloat_test_mag,$ifloat_test_exp)^
  A: binary2hex($ifloats[0])^
  E: $ifloat_expected_mag^
 ok: 2,4,6,8,10,12^

=head2 ok: 3,5,7,9,11,13

  N: $ifloat_name exponent^
  A: $ifloats[1]^
  E: $ifloat_expected_exp^
 ok: 3,5,7,9,11,13^

=head2 ok: 14,20,26,32,38,44,50,56,62,68,74

  C: };^

  C:
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
 #
 ^
  N: pack_float('F4', [$float_int,$float_exp]) format^
  C: ($format, $numbers) = pack_float('F4', [$float_int,$float_exp])^
  A: $format^
  E: 'F4'^
 ok: 14,20,26,32,38,44,50,56,62,68,74^

=head2 ok: 15,21,27,33,39,45,51,57,63,69,75

  N: pack_float('F4', [$float_int,$float_exp]) float^
  A: unpack('H*', $numbers)^
  E: $f4_float_hex^
 ok: 15,21,27,33,39,45,51,57,63,69,75^

=head2 ok: 16,22,28,34,40,46,52,58,64,70,76

  N: unpack_float('F4',$f4_float_hex) float^

  C:
      $actual_result = ${unpack_float('F4',$numbers)}[0];
      $tolerance_result = tolerance($actual_result,$f4_float);
 ^
 DM: got: $actual_result, expected: $f4_float\nactual tolerance: $tolerance_result, expected tolerance: $F4_criteria^
  A: pass_fail_tolerance($tolerance_result, $F4_criteria)^
  E: 1^
 ok: 16,22,28,34,40,46,52,58,64,70,76^

=head2 ok: 17,23,29,35,41,47,53,59,65,71,77

  N: pack_float('F8', [$float_int,$float_exp]) format^
  C: ($format, $numbers) = pack_float('F8', [$float_int,$float_exp])^
  A: $format^
  E: 'F8'^
 ok: 17,23,29,35,41,47,53,59,65,71,77^

=head2 ok: 18,24,30,36,42,48,54,60,66,72,78

  N: pack_float('F8', [$float_int,$float_exp]) float^
  A: unpack('H*', $numbers)^
  E: $f8_float_hex^
 ok: 18,24,30,36,42,48,54,60,66,72,78^

=head2 ok: 19,25,31,37,43,49,55,61,67,73,79

  N: unpack_float('F8',$f8_float_hex) float^

  C:
     $actual_result = ${unpack_float('F8',$numbers)}[0];
     $tolerance_result = tolerance($actual_result,$f8_float);
 ^
 DM: got: $actual_result, expected: $f8_float\n#actual tolerance: $tolerance_result, expected tolerance: $F8_criteria^
  A: pass_fail_tolerance($tolerance_result, $F8_criteria)^
  E: 1^
 ok: 19,25,31,37,43,49,55,61,67,73,79^

=head2 ok: 80


  C:
  ######
  # End of the Floating Point Test Loop
  #######
  };
 ^

  C:
     
  my @pack_in_test =  (
    [                                                           
      ['78 45 25', '512 1024 100000 hello world']            ,  # test_strings
      'I'                                                    ,  # test_format
      'U4'                                                   ,  # expected_format
      '0000004e0000002d000000190000020000000400000186a0'     ,  # expected_numbers  
      ['hello world']                                        ,  # expected_strings  
      [78, 45, 25, 512, 1024, 100000]                        ,  # expected_unpack      
    ],
 );

     my ($test_strings, @test_strings,$test_string_text,$test_format, $expected_format,
         $expected_numbers,$expected_strings, $expected_unpack);
     my ($format, $numbers, @strings);
     ($test_strings,$test_format, $expected_format,
         $expected_numbers,$expected_strings, $expected_unpack) = $pack_in_test[0];
      @test_strings = @$test_strings;
      $test_string_text = join ' ',@test_strings;
 ^
  N: pack_num($test_format, $test_string_text) format^
  C: ($format, $numbers, @strings) = pack_num('I',@test_strings)^
  A: $format^
  E: $expected_format^
 ok: 80^

=head2 ok: 81

  N: pack_num($test_format, $test_string_text) numbers^
  A: unpack('H*',$numbers)^
  E: $expected_numbers^
 ok: 81^

=head2 ok: 82

  N: pack_num($test_format, $test_string_text) \@strings^
  A: [@strings]^
  E: $expected_strings^
 ok: 82^

=head2 ok: 83

  N: unpack_num($expected_format, $test_string_text) error check^
  A: ref(my $unpack_numbers = unpack_num($expected_format,$numbers))^
  E: 'ARRAY'^
 ok: 83^

=head2 ok: 84

  N: unpack_num($expected_format, $test_string_text) numbers^
  A: $unpack_numbers^
  E: $expected_unpack^
 ok: 84^



#######
#  
#  5. REQUIREMENTS TRACEABILITY
#
#

=head1 REQUIREMENTS TRACEABILITY

  Requirement                                                      Test
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<DataPort::DataFile/general [1] - load>                         L<t::Data::SecsPackStress/ok: 1>


  Test                                                             Requirement
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<t::Data::SecsPackStress/ok: 1>                                 L<DataPort::DataFile/general [1] - load>


=cut

#######
#  
#  6. NOTES
#
#

=head1 NOTES

copyright © 2003 Software Diamonds.

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code, modified or unmodified
must retain the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

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

#######
#
#  2. REFERENCED DOCUMENTS
#
#
#

=head1 SEE ALSO

L<Data::SecsPack>

=back

=for html
<hr>
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

__DATA__

File_Spec: Unix^
UUT: Data::SecsPack^
Revision: -^
End_User: General Public^
Author: http://www.SoftwareDiamonds.com support@SoftwareDiamonds.com^
Detail_Template: ^
STD2167_Template: ^
Version: ^
Classification: None^
Temp: temp.pl^
Demo: SecsPackStress.d^
Verify: SecsPackStress.t^


 T: 84^


 C:
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
    my ($actual_result, $tolerance_result);
^

 N: UUT Loaded^
 R: L<DataPort::DataFile/general [1] - load>^
 S: $loaded^

 C:
   my $errors = $fp->load_package($uut, 
       qw(bytes2int float2binary 
          ifloat2binary int2bytes   
          pack_float pack_int pack_num  
          str2float str2int 
          unpack_float unpack_int unpack_num) );
^

 A: $errors^
SE: ''^
ok: 1^

N: int2bytes(-32768)^
A: [int2bytes(-32768)]^
E: [128,0]^

N: int2bytes(-32767)^
A: [int2bytes(-32767)]^
E: [128,1]^

 C:
 sub binary2hex
 {
     my $magnitude = shift;
     my $sign = $1 if $magnitude =~ s/^^(\-)\s*//;
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
  $ifloat_name = "ifloat2binary($ifloat_test_mag, $ifloat_test_exp)";
^

 N: $ifloat_name magnitude^
 C: @ifloats = ifloat2binary($ifloat_test_mag,$ifloat_test_exp)^
 A: binary2hex($ifloats[0])^
 E: $ifloat_expected_mag^
ok: 2,4,6,8,10,12^

 N: $ifloat_name exponent^
 A: $ifloats[1]^
 E: $ifloat_expected_exp^
ok: 3,5,7,9,11,13^

 C: };^

 C:
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
#
^

 N: pack_float('F4', [$float_int,$float_exp]) format^
 C: ($format, $numbers) = pack_float('F4', [$float_int,$float_exp])^
 A: $format^
 E: 'F4'^
ok: 14,20,26,32,38,44,50,56,62,68,74^

 N: pack_float('F4', [$float_int,$float_exp]) float^
 A: unpack('H*', $numbers)^
 E: $f4_float_hex^
ok: 15,21,27,33,39,45,51,57,63,69,75^

 N: unpack_float('F4',$f4_float_hex) float^

 C:
     $actual_result = ${unpack_float('F4',$numbers)}[0];
     $tolerance_result = tolerance($actual_result,$f4_float);
^

DM: got: $actual_result, expected: $f4_float\nactual tolerance: $tolerance_result, expected tolerance: $F4_criteria^
 A: pass_fail_tolerance($tolerance_result, $F4_criteria)^
 E: 1^
ok: 16,22,28,34,40,46,52,58,64,70,76^

 N: pack_float('F8', [$float_int,$float_exp]) format^
 C: ($format, $numbers) = pack_float('F8', [$float_int,$float_exp])^
 A: $format^
 E: 'F8'^
ok: 17,23,29,35,41,47,53,59,65,71,77^

 N: pack_float('F8', [$float_int,$float_exp]) float^
 A: unpack('H*', $numbers)^
 E: $f8_float_hex^
ok: 18,24,30,36,42,48,54,60,66,72,78^

 N: unpack_float('F8',$f8_float_hex) float^

 C:
    $actual_result = ${unpack_float('F8',$numbers)}[0];
    $tolerance_result = tolerance($actual_result,$f8_float);
^

DM: got: $actual_result, expected: $f8_float\n#actual tolerance: $tolerance_result, expected tolerance: $F8_criteria^
 A: pass_fail_tolerance($tolerance_result, $F8_criteria)^
 E: 1^
ok: 19,25,31,37,43,49,55,61,67,73,79^


 C:
 ######
 # End of the Floating Point Test Loop
 #######

 };
^


 C:
    
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
     $test_string_text = join ' ',@test_strings;
^

 N: pack_num($test_format, $test_string_text) format^
 C: ($format, $numbers, @strings) = pack_num('I',@test_strings)^
 A: $format^
 E: $expected_format^
ok: 80^

 N: pack_num($test_format, $test_string_text) numbers^
 A: unpack('H*',$numbers)^
 E: $expected_numbers^
ok: 81^

 N: pack_num($test_format, $test_string_text) \@strings^
 A: [@strings]^
 E: $expected_strings^
ok: 82^

 N: unpack_num($expected_format, $test_string_text) error check^
 A: ref(my $unpack_numbers = unpack_num($expected_format,$numbers))^
 E: 'ARRAY'^
ok: 83^

 N: unpack_num($expected_format, $test_string_text) numbers^
 A: $unpack_numbers^
 E: $expected_unpack^
ok: 84^

 C:
 ######
 # End of the pack int Test Loop
 #######

 };
^


See_Also: L<Data::SecsPack>^

Copyright:
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
^


HTML:
<hr>
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>
^



~-~
