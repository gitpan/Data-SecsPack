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
$DATE = '2004/04/13';
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

 Date: 2004/04/13

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

 T: 14^

=head2 ok: 1


  C:
     use File::Package;
     my $fp = 'File::Package';
     my $uut = 'Data::SecsPack';
     my $loaded;
     my ($result,@result)
 ^
  N: UUT Loaded^
  R: L<DataPort::DataFile/general [1] - load>^
  S: $loaded^
  C: my $errors = $fp->load_package($uut, qw(pack_int pack_num str2int unpack_num))^
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

  N: str2int('78 45 25', '512 1024', '100000 hello world')^
  A: [my ($string, @integers) = str2int('78 45 25', '512 1024', '100000 hello world')]^
  E: ['hello world',78,45,25,512,1024,100000]^
 ok: 7^

=head2 ok: 8

  N: pack_num('I', 78 45 25 512 1024 100000)^
  C: my ($format, $integers) = pack_num('I',@integers)^
  A: $format^
  E: 'U4'^
 ok: 8^

=head2 ok: 9

  N: packed 78 45 25 512 1024 100000^
  A: unpack('H*',$integers)^
  E: '0000004e0000002d000000190000020000000400000186a0'^
 ok: 9^

=head2 ok: 10

  N: unpack_num('U4', 78 45 25 512 1024 100000)^
  A: ref(my $int_array = unpack_num('U4',$integers))^
  E: 'ARRAY'^
 ok: 10^

=head2 ok: 11

  N: unpack_num number array^
  A: $int_array^
  E: [78, 45, 25, 512, 1024, 100000]^
 ok: 11^

=head2 ok: 12

  N: pack_num('I', '78 45 25', '512 1024', '100000 hello world')^
  C: ($format, my $numbers, $string) = pack_num('I', '78 45 25', '512 1024', '100000 hello world')^
  A: $format^
  E: 'U4'^
 ok: 12^

=head2 ok: 13

  N: pack_num string^
  A: $string^
  E: 'hello world'^
 ok: 13^

=head2 ok: 14

  N: pack_num numbers^
  A: unpack('H*', $numbers)^
  E: '0000004e0000002d000000190000020000000400000186a0'^
 ok: 14^



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
Demo: secspack.d^
Verify: secspack.t^


 T: 14^


 C:
    use File::Package;
    my $fp = 'File::Package';

    my $uut = 'Data::SecsPack';
    my $loaded;

    my ($result,@result)
^

 N: UUT Loaded^
 R: L<DataPort::DataFile/general [1] - load>^
 S: $loaded^
 C: my $errors = $fp->load_package($uut, qw(pack_int pack_num str2int unpack_num))^
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

 N: str2int('78 45 25', '512 1024', '100000 hello world')^
 A: [my ($string, @integers) = str2int('78 45 25', '512 1024', '100000 hello world')]^
 E: ['hello world',78,45,25,512,1024,100000]^
ok: 7^

 N: pack_num('I', 78 45 25 512 1024 100000)^
 C: my ($format, $integers) = pack_num('I',@integers)^
 A: $format^
 E: 'U4'^
ok: 8^

 N: packed 78 45 25 512 1024 100000^
 A: unpack('H*',$integers)^
 E: '0000004e0000002d000000190000020000000400000186a0'^
ok: 9^

 N: unpack_num('U4', 78 45 25 512 1024 100000)^
 A: ref(my $int_array = unpack_num('U4',$integers))^
 E: 'ARRAY'^
ok: 10^

 N: unpack_num number array^
 A: $int_array^
 E: [78, 45, 25, 512, 1024, 100000]^
ok: 11^

 N: pack_num('I', '78 45 25', '512 1024', '100000 hello world')^
 C: ($format, my $numbers, $string) = pack_num('I', '78 45 25', '512 1024', '100000 hello world')^
 A: $format^
 E: 'U4'^
ok: 12^

 N: pack_num string^
 A: $string^
 E: 'hello world'^
ok: 13^

 N: pack_num numbers^
 A: unpack('H*', $numbers)^
 E: '0000004e0000002d000000190000020000000400000186a0'^
ok: 14^


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
