#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  t::Data::SecsPack;

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

 T: 23^

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
     my $tolerance_result;
     my $float_tolerance = 1E-10;
 ^
  N: UUT Loaded^
  R: L<DataPort::DataFile/general [1] - load>^
  S: $loaded^

  C:
    my $errors = $fp->load_package($uut, 
        qw(bytes2int config float2binary 
           ifloat2binary int2bytes   
           pack_float pack_int pack_num  
           str2float str2int 
           unpack_float unpack_int unpack_num) );
 ^
  A: $errors^
 SE: ''^
 ok: 1^

=head2 ok: 2

  N: str2int(\'033\')^
  A: $result = $uut->str2int('033')^
  E: 27^
 ok: 2^

=head2 ok: 3

  N: str2int(\'0xFF\')^
  A: $result = $uut->str2int('0xFF')^
  E: 255^
 ok: 3^

=head2 ok: 4

  N: str2int(\'0b1010\')^
  A: $result = $uut->str2int('0b1010')^
  E: 10^
 ok: 4^

=head2 ok: 5

  N: str2int(\'255\')^
  A: $result = $uut->str2int('255')^
  E: 255^
 ok: 5^

=head2 ok: 6

  N: str2int(\'hello\')^
  A: $result = $uut->str2int('hello')^
  E: undef^
 ok: 6^

=head2 ok: 7

  N: str2int(' 78 45 25', ' 512E4 1024 hello world') \@numbers^
  C: my ($strings, @numbers) = str2int(' 78 45 25', ' 512E4 1024 hello world')^
  A: [@numbers]^
  E: [78,45,25,]^
 ok: 7^

=head2 ok: 8

  N: str2int(' 78 45 25', ' 512E4 1024 hello world') \@strings^
  A: join( ' ', @$strings)^
  E: '512E4 1024 hello world'^
 ok: 8^

=head2 ok: 9

  N: str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') numbers^
  C: ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')^
  A: [@numbers]^
  E: [[78,1], [-24,-6], [25,-3],[512,6]]^
 ok: 9^

=head2 ok: 10

  N: str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') \@strings^
  C: ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')^
  A: join( ' ', @$strings)^
  E: 'hello world'^
 ok: 10^

=head2 ok: 11


  C:
      my @test_strings = ('78 45 25', '512 1024 100000 hello world');
      my $test_string_text = join ' ',@test_strings;
      my $test_format = 'I';
      my $expected_format = 'U4';
      my $expected_numbers = '0000004e0000002d000000190000020000000400000186a0';
      my $expected_strings = ['hello world'];
      my $expected_unpack = [78, 45, 25, 512, 1024, 100000];
      my ($format, $numbers, @strings) = pack_num('I',@test_strings);
 ^
  N: pack_num($test_format, $test_string_text) format^
  A: $format^
  E: $expected_format^
 ok: 11^

=head2 ok: 12

  N: pack_num($test_format, $test_string_text) numbers^
  A: unpack('H*',$numbers)^
  E: $expected_numbers^
 ok: 12^

=head2 ok: 13

  N: pack_num($test_format, $test_string_text) \@strings^
  A: [@strings]^
  E: $expected_strings^
 ok: 13^

=head2 ok: 14

  N: unpack_num($expected_format, $test_string_text) error check^
  A: ref(my $unpack_numbers = unpack_num($expected_format,$numbers))^
  E: 'ARRAY'^
 ok: 14^

=head2 ok: 15

  N: unpack_num($expected_format, $test_string_text) numbers^
  A: $unpack_numbers^
  E: $expected_unpack^
 ok: 15^

=head2 ok: 16


  C:
  
      @test_strings = ('78 4.5 .25', '6.45E10 hello world');
      $test_string_text = join ' ',@test_strings;
      $test_format = 'I';
      $expected_format = 'F8';
      $expected_numbers = '405380000000000040120000000000003fd0000000000000422e08ffca000000';
      $expected_strings = ['hello world'];
      my @expected_unpack = (78, 4.5, 0.25,6.45E10);
      ($format, $numbers, @strings) = pack_num('I',@test_strings);
 ^
  N: pack_num($test_format, $test_string_text) format^
  A: $format^
  E: $expected_format^
 ok: 16^

=head2 ok: 17

  N: pack_num($test_format, $test_string_text) numbers^
  A: unpack('H*',$numbers)^
  E: $expected_numbers^
 ok: 17^

=head2 ok: 18

  N: pack_num($test_format, $test_string_text) \@strings^
  A: [@strings]^
  E: $expected_strings^
 ok: 18^

=head2 ok: 19

  N: unpack_num($expected_format, $test_string_text) error check^
  A: ref($unpack_numbers = unpack_num($expected_format,$numbers))^
  E: 'ARRAY'^
 ok: 19^

=head2 ok: 20

 DO: ^
  A: $unpack_numbers^
  E: [@expected_unpack]^
 VO: ^
  N: unpack_num($expected_format, $test_string_text) float 0^
  C: $tolerance_result = tolerance(${$unpack_numbers}[0],$expected_unpack[0]);^

 DM:
 got: ${$unpack_numbers}[0], expected: $expected_unpack[0]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
 ^
  A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
  E: 1^
 ok: 20^

=head2 ok: 21

 VO: ^
  N: unpack_num($expected_format, $test_string_text) float 1^
  C: $tolerance_result = tolerance(${$unpack_numbers}[1],$expected_unpack[1]);^

 DM:
 got: ${$unpack_numbers}[1], expected: $expected_unpack[1]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
 ^
  A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
  E: 1^
 ok: 21^

=head2 ok: 22

 VO: ^
  N: unpack_num($expected_format, $test_string_text) float 2^
  C: $tolerance_result = tolerance(${$unpack_numbers}[2],$expected_unpack[2]);^

 DM:
 got: ${$unpack_numbers}[2], expected: $expected_unpack[2]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
 ^
  A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
  E: 1^
 ok: 22^

=head2 ok: 23

 VO: ^
  N: unpack_num($expected_format, $test_string_text) float 3^
  C: $tolerance_result = tolerance(${$unpack_numbers}[3],$expected_unpack[3]);^

 DM:
 got: ${$unpack_numbers}[3], expected: $expected_unpack[3]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
 ^
  A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
  E: 1^
 ok: 23^



#######
#  
#  5. REQUIREMENTS TRACEABILITY
#
#

=head1 REQUIREMENTS TRACEABILITY

  Requirement                                                      Test
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<DataPort::DataFile/general [1] - load>                         L<t::Data::SecsPack/ok: 1>


  Test                                                             Requirement
 ---------------------------------------------------------------- ----------------------------------------------------------------
 L<t::Data::SecsPack/ok: 1>                                       L<DataPort::DataFile/general [1] - load>


=cut

#######
#  
#  6. NOTES
#
#

=head1 NOTES

copyright � 2003 Software Diamonds.

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
Demo: SecsPack.d^
Verify: SecsPack.t^


 T: 23^


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

    my $tolerance_result;
    my $float_tolerance = 1E-10;
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

 N: str2int(\'033\')^
 A: $result = $uut->str2int('033')^
 E: 27^
ok: 2^

 N: str2int(\'0xFF\')^
 A: $result = $uut->str2int('0xFF')^
 E: 255^
ok: 3^

 N: str2int(\'0b1010\')^
 A: $result = $uut->str2int('0b1010')^
 E: 10^
ok: 4^

 N: str2int(\'255\')^
 A: $result = $uut->str2int('255')^
 E: 255^
ok: 5^

 N: str2int(\'hello\')^
 A: $result = $uut->str2int('hello')^
 E: undef^
ok: 6^

 N: str2int(' 78 45 25', ' 512E4 1024 hello world') \@numbers^
 C: my ($strings, @numbers) = str2int(' 78 45 25', ' 512E4 1024 hello world')^
 A: [@numbers]^
 E: [78,45,25,]^
ok: 7^

 N: str2int(' 78 45 25', ' 512E4 1024 hello world') \@strings^
 A: join( ' ', @$strings)^
 E: '512E4 1024 hello world'^
ok: 8^

 N: str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') numbers^
 C: ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')^
 A: [@numbers]^
 E: [[78,1], [-24,-6], [25,-3],[512,6]]^
ok: 9^

 N: str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') \@strings^
 C: ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')^
 A: join( ' ', @$strings)^
 E: 'hello world'^
ok: 10^


 C:
     my @test_strings = ('78 45 25', '512 1024 100000 hello world');
     my $test_string_text = join ' ',@test_strings;
     my $test_format = 'I';
     my $expected_format = 'U4';
     my $expected_numbers = '0000004e0000002d000000190000020000000400000186a0';
     my $expected_strings = ['hello world'];
     my $expected_unpack = [78, 45, 25, 512, 1024, 100000];

     my ($format, $numbers, @strings) = pack_num('I',@test_strings);
^

 N: pack_num($test_format, $test_string_text) format^
 A: $format^
 E: $expected_format^
ok: 11^

 N: pack_num($test_format, $test_string_text) numbers^
 A: unpack('H*',$numbers)^
 E: $expected_numbers^
ok: 12^

 N: pack_num($test_format, $test_string_text) \@strings^
 A: [@strings]^
 E: $expected_strings^
ok: 13^

 N: unpack_num($expected_format, $test_string_text) error check^
 A: ref(my $unpack_numbers = unpack_num($expected_format,$numbers))^
 E: 'ARRAY'^
ok: 14^

 N: unpack_num($expected_format, $test_string_text) numbers^
 A: $unpack_numbers^
 E: $expected_unpack^
ok: 15^


 C:
 
     @test_strings = ('78 4.5 .25', '6.45E10 hello world');
     $test_string_text = join ' ',@test_strings;
     $test_format = 'I';
     $expected_format = 'F8';
     $expected_numbers = '405380000000000040120000000000003fd0000000000000422e08ffca000000';
     $expected_strings = ['hello world'];
     my @expected_unpack = (78, 4.5, 0.25,6.45E10);

     ($format, $numbers, @strings) = pack_num('I',@test_strings);
^

 N: pack_num($test_format, $test_string_text) format^
 A: $format^
 E: $expected_format^
ok: 16^

 N: pack_num($test_format, $test_string_text) numbers^
 A: unpack('H*',$numbers)^
 E: $expected_numbers^
ok: 17^

 N: pack_num($test_format, $test_string_text) \@strings^
 A: [@strings]^
 E: $expected_strings^
ok: 18^

 N: unpack_num($expected_format, $test_string_text) error check^
 A: ref($unpack_numbers = unpack_num($expected_format,$numbers))^
 E: 'ARRAY'^
ok: 19^

DO: ^
 A: $unpack_numbers^
 E: [@expected_unpack]^
VO: ^
 N: unpack_num($expected_format, $test_string_text) float 0^
 C: $tolerance_result = tolerance(${$unpack_numbers}[0],$expected_unpack[0]);^

DM:
got: ${$unpack_numbers}[0], expected: $expected_unpack[0]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
^

 A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
 E: 1^
ok: 20^

VO: ^
 N: unpack_num($expected_format, $test_string_text) float 1^
 C: $tolerance_result = tolerance(${$unpack_numbers}[1],$expected_unpack[1]);^

DM:
got: ${$unpack_numbers}[1], expected: $expected_unpack[1]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
^

 A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
 E: 1^
ok: 21^

VO: ^
 N: unpack_num($expected_format, $test_string_text) float 2^
 C: $tolerance_result = tolerance(${$unpack_numbers}[2],$expected_unpack[2]);^

DM:
got: ${$unpack_numbers}[2], expected: $expected_unpack[2]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
^

 A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
 E: 1^
ok: 22^

VO: ^
 N: unpack_num($expected_format, $test_string_text) float 3^
 C: $tolerance_result = tolerance(${$unpack_numbers}[3],$expected_unpack[3]);^

DM:
got: ${$unpack_numbers}[3], expected: $expected_unpack[3]\nactual tolerance: $tolerance_result, allowed tolerance: $float_tolerance
^

 A: pass_fail_tolerance($tolerance_result, $float_tolerance)^
 E: 1^
ok: 23^


See_Also: L<Data::SecsPack>^

Copyright:
copyright � 2003 Software Diamonds.

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
