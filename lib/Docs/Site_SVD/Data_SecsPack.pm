#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  Docs::Site_SVD::Data_SecsPack;

use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE $FILE );
$VERSION = '0.02';
$DATE = '2004/04/23';
$FILE = __FILE__;

use vars qw(%INVENTORY);
%INVENTORY = (
    'lib/Docs/Site_SVD/Data_SecsPack.pm' => [qw(0.02 2004/04/23), 'new'],
    'MANIFEST' => [qw(0.02 2004/04/23), 'generated new'],
    'Makefile.PL' => [qw(0.02 2004/04/23), 'generated new'],
    'README' => [qw(0.02 2004/04/23), 'generated new'],
    'lib/Data/SecsPack.pm' => [qw(0.02 2004/04/23), 'new'],
    't/Data/SecsPack.d' => [qw(0.01 2004/04/23), 'new'],
    't/Data/SecsPack.pm' => [qw(0.01 2004/04/23), 'new'],
    't/Data/SecsPack.t' => [qw(0.01 2004/04/23), 'new'],
    't/Data/SecsPackStress.d' => [qw(0.01 2004/04/23), 'new'],
    't/Data/SecsPackStress.pm' => [qw(0.01 2004/04/23), 'new'],
    't/Data/SecsPackStress.t' => [qw(0.01 2004/04/23), 'new'],
    't/Data/File/Package.pm' => [qw(1.16 2004/04/23), 'new'],
    't/Data/Test/Tech.pm' => [qw(1.2 2004/04/23), 'new'],
    't/Data/Data/Secs2.pm' => [qw(1.17 2004/04/23), 'new'],

);

########
# The ExtUtils::SVDmaker module uses the data after the __DATA__ 
# token to automatically generate this file.
#
# Don't edit anything before __DATA_. Edit instead
# the data after the __DATA__ token.
#
# ANY CHANGES MADE BEFORE the  __DATA__ token WILL BE LOST
#
# the next time ExtUtils::SVDmaker generates this file.
#
#



=head1 Title Page

 Software Version Description

 for

 Data::SecsPack - pack and unpack numbers in accordance with SEMI E5-94

 Revision: -

 Version: 0.02

 Date: 2004/04/23

 Prepared for: General Public 

 Prepared by:  SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>

 Copyright: copyright � 2003 Software Diamonds

 Classification: NONE

=head1 1.0 SCOPE

This paragraph identifies and provides an overview
of the released files.

=head2 1.1 Identification

This release,
identified in L<3.2|/3.2 Inventory of software contents>,
is a collection of Perl modules that
extend the capabilities of the Perl language.

=head2 1.2 System overview

The "L<Data::SecsPack|Data::SecsPack>" module extends the Perl language (the system).

The subroutines in the C<Data::SecsPack> module packs and unpacks
numbers in accordance with SEMI E5-94. The E5-94 establishes the
standard for communication between the equipment used to fabricate
semiconductors and the host computer that controls the fabrication.
The equipment in a semiconductor factory (fab) or any other fab
contains every conceivable known microprocessor and operating system
known to man. And there are a lot of specialize real-time embedded 
processors and speciallize real-time embedded operating systems
in addition to the those in the PC world.

The communcication between host and equipment used packed
nested list data structures that include arrays of characters,
integers and floats. The standard has been in place and widely
used in China, Germany, Korea, Japan, France, Italy and
the most remote places on this planent for decades.
The SEMI E5 standard was first finalized in 1985 and has
not changed much over the decades.
The basic data structure and packed data formats have not
changed for decades. 
This stands in direct contradiction to common conceptions
of many in the Perl snail-time community that
there is no standard for transferring such things as
binary floats between machines little less sending
nested list data as small compact binary.

The C<Data::Str2int> module translates an scalar string to a scalar integer.
Perl itself has a documented function, '0+$x', that converts a scalar to
so that its internal storage is an integer
(See p.351, 3rd Edition of Programming Perl).
If it cannot perform the conversion, it leaves the integer 0.
Surprising not all Perls, some Microsoft Perls in particular, may leave
the internal storage as a scalar string.

The <str2int> function is basically the same except if it cannot perform
the conversion to an integer, it returns an "undef" instead of a 0.
Also, if the string is a decimal or floating point, it will return an undef.
This makes it not only useful for forcing an integer conversion but
also for testing a scalar to see if it is in fact an integer scalar.

=head2 1.3 Document overview.

This document releases Data::SecsPack version 0.02
providing a description of the inventory, installation
instructions and other information necessary to
utilize and track this release.

=head1 3.0 VERSION DESCRIPTION

All file specifications in this SVD
use the Unix operating
system file specification.

=head2 3.1 Inventory of materials released.

This document releases the file 

 Data-SecsPack-0.02.tar.gz

found at the following repository(s):

  http://www.softwarediamonds/packages/
  http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/

Restrictions regarding duplication and license provisions
are as follows:

=over 4

=item Copyright.

copyright � 2003 Software Diamonds

=item Copyright holder contact.

 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

=item License.

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

=back

=head2 3.2 Inventory of software contents

The content of the released, compressed, archieve file,
consists of the following files:

 file                                                         version date       comment
 ------------------------------------------------------------ ------- ---------- ------------------------
 lib/Docs/Site_SVD/Data_SecsPack.pm                           0.02    2004/04/23 new
 MANIFEST                                                     0.02    2004/04/23 generated new
 Makefile.PL                                                  0.02    2004/04/23 generated new
 README                                                       0.02    2004/04/23 generated new
 lib/Data/SecsPack.pm                                         0.02    2004/04/23 new
 t/Data/SecsPack.d                                            0.01    2004/04/23 new
 t/Data/SecsPack.pm                                           0.01    2004/04/23 new
 t/Data/SecsPack.t                                            0.01    2004/04/23 new
 t/Data/SecsPackStress.d                                      0.01    2004/04/23 new
 t/Data/SecsPackStress.pm                                     0.01    2004/04/23 new
 t/Data/SecsPackStress.t                                      0.01    2004/04/23 new
 t/Data/File/Package.pm                                       1.16    2004/04/23 new
 t/Data/Test/Tech.pm                                          1.2     2004/04/23 new
 t/Data/Data/Secs2.pm                                         1.17    2004/04/23 new


=head2 3.3 Changes

Changes are as follows:

=over 4

=item Data::SecsPack 0.01

Originated

=item Data::SecsPack 0.02

Adding support for packing and unpacking
floats and flushing out to provide full
support for packing and unpacking all
SEMI E5-94 SECSII numeric formats.

=back

=head2 3.4 Adaptation data.

This installation requires that the installation site
has the Perl programming language installed.
There are no other additional requirements or tailoring needed of 
configurations files, adaptation data or other software needed for this
installation particular to any installation site.

=head2 3.5 Related documents.

There are no related documents needed for the installation and
test of this release.

=head2 3.6 Installation instructions.

Instructions for installation, installation tests
and installation support are as follows:

=over 4

=item Installation Instructions.

To installed the release file, use the CPAN module
pr PPM module in the Perl release
or the INSTALL.PL script at the following web site:

 http://packages.SoftwareDiamonds.com

Follow the instructions for the the chosen installation software.

If all else fails, the file may be manually installed.
Enter one of the following repositories in a web browser:

  http://www.softwarediamonds/packages/
  http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/

Right click on 'Data-SecsPack-0.02.tar.gz' and download to a temporary
installation directory.
Enter the following where $make is 'nmake' for microsoft
windows; otherwise 'make'.

 gunzip Data-SecsPack-0.02.tar.gz
 tar -xf Data-SecsPack-0.02.tar
 perl Makefile.PL
 $make test
 $make install

On Microsoft operating system, nmake, tar, and gunzip 
must be in the exeuction path. If tar and gunzip are
not install, download and install unxutils from

 http://packages.softwarediamonds.com

=item Prerequistes.

 None.


=item Security, privacy, or safety precautions.

None.

=item Installation Tests.

Most Perl installation software will run the following test script(s)
as part of the installation:

 t/Data/SecsPack.t
 t/Data/SecsPackStress.t

=item Installation support.

If there are installation problems or questions with the installation
contact

 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>

=back

=head2 3.7 Possible problems and known errors

There is still much work needed to ensure the quality 
of this module as follows:

=over 4

=item *

Increase the accuracy of packing floats with
large exponents and unpacking floats.

=item *

State the functional requirements for each method 
including not only the GO paths but also what to
expect for the NOGO paths

=item *

All the tests are GO path tests. Should add
NOGO tests.

=item *

Add the requirements addressed as I<# R: >
comment to the tests


=back

=head1 4.0 NOTES

The following are useful acronyms:

=over 4

=item .d

extension for a Perl demo script file

=item .pm

extension for a Perl Library Module

=item .t

extension for a Perl test script file

=back

=head1 2.0 SEE ALSO

=over 4

=item L<Data::SecsPack|Data::SecsPack> 

=item L<Docs::US_DOD::SVD|Docs::US_DOD::SVD> 

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
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

1;

__DATA__

DISTNAME: Data-SecsPack^
REPOSITORY_DIR: packages^

VERSION : 0.02^
FREEZE: 1^
PREVIOUS_DISTNAME: 0.01^
PREVIOUS_RELEASE:  ^
REVISION: -^


AUTHOR  : SoftwareDiamonds.com E<lt>support@SoftwareDiamonds.comE<gt>^
ABSTRACT: pack and unpack numbers in accordance with SEMI E5-94^
TITLE   : Data::SecsPack - pack and unpack numbers in accordance with SEMI E5-94^
END_USER: General Public^
COPYRIGHT: copyright � 2003 Software Diamonds^
CLASSIFICATION: NONE^
TEMPLATE:  ^
CSS: help.css^
SVD_FSPEC: Unix^

REPOSITORY: 
  http://www.softwarediamonds/packages/
  http://www.perl.com/CPAN-local/authors/id/S/SO/SOFTDIA/
^

COMPRESS: gzip^
COMPRESS_SUFFIX: gz^

RESTRUCTURE:  ^
CHANGE2CURRENT:  ^

AUTO_REVISE: 
lib/Data/SecsPack.pm
t/Data/SecsPack.*
t/Data/SecsPackStress.*
lib/File/Package.pm => t/Data/File/Package.pm
lib/Test/Tech.pm => t/Data/Test/Tech.pm
lib/Data/Secs2.pm => t/Data/Data/Secs2.pm
^

PREREQ_PM:  ^
README_PODS: lib/Data/SecsPack.pm^

TESTS:
t/Data/SecsPack.t
t/Data/SecsPackStress.t
^

EXE_FILES:  ^

CHANGES: 
Changes are as follows:

\=over 4

\=item Data::SecsPack 0.01

Originated

\=item Data::SecsPack 0.02

Adding support for packing and unpacking
floats and flushing out to provide full
support for packing and unpacking all
SEMI E5-94 SECSII numeric formats.

\=back
^

DOCUMENT_OVERVIEW:
This document releases ${NAME} version ${VERSION}
providing a description of the inventory, installation
instructions and other information necessary to
utilize and track this release.
^

CAPABILITIES:
The "L<Data::SecsPack|Data::SecsPack>" module extends the Perl language (the system).

The subroutines in the C<Data::SecsPack> module packs and unpacks
numbers in accordance with SEMI E5-94. The E5-94 establishes the
standard for communication between the equipment used to fabricate
semiconductors and the host computer that controls the fabrication.
The equipment in a semiconductor factory (fab) or any other fab
contains every conceivable known microprocessor and operating system
known to man. And there are a lot of specialize real-time embedded 
processors and speciallize real-time embedded operating systems
in addition to the those in the PC world.

The communcication between host and equipment used packed
nested list data structures that include arrays of characters,
integers and floats. The standard has been in place and widely
used in China, Germany, Korea, Japan, France, Italy and
the most remote places on this planent for decades.
The SEMI E5 standard was first finalized in 1985 and has
not changed much over the decades.
The basic data structure and packed data formats have not
changed for decades. 
This stands in direct contradiction to common conceptions
of many in the Perl snail-time community that
there is no standard for transferring such things as
binary floats between machines little less sending
nested list data as small compact binary.

The C<Data::Str2int> module translates an scalar string to a scalar integer.
Perl itself has a documented function, '0+$x', that converts a scalar to
so that its internal storage is an integer
(See p.351, 3rd Edition of Programming Perl).
If it cannot perform the conversion, it leaves the integer 0.
Surprising not all Perls, some Microsoft Perls in particular, may leave
the internal storage as a scalar string.

The <str2int> function is basically the same except if it cannot perform
the conversion to an integer, it returns an "undef" instead of a 0.
Also, if the string is a decimal or floating point, it will return an undef.
This makes it not only useful for forcing an integer conversion but
also for testing a scalar to see if it is in fact an integer scalar.

^

PROBLEMS:
There is still much work needed to ensure the quality 
of this module as follows:

\=over 4

\=item *

Increase the accuracy of packing floats with
large exponents and unpacking floats.

\=item *

State the functional requirements for each method 
including not only the GO paths but also what to
expect for the NOGO paths

\=item *

All the tests are GO path tests. Should add
NOGO tests.

\=item *

Add the requirements addressed as I<# R: >
comment to the tests


\=back

^

LICENSE:
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


INSTALLATION:
To installed the release file, use the CPAN module
pr PPM module in the Perl release
or the INSTALL.PL script at the following web site:

 http://packages.SoftwareDiamonds.com

Follow the instructions for the the chosen installation software.

If all else fails, the file may be manually installed.
Enter one of the following repositories in a web browser:

${REPOSITORY}

Right click on '${DIST_FILE}' and download to a temporary
installation directory.
Enter the following where $make is 'nmake' for microsoft
windows; otherwise 'make'.

 gunzip ${BASE_DIST_FILE}.tar.${COMPRESS_SUFFIX}
 tar -xf ${BASE_DIST_FILE}.tar
 perl Makefile.PL
 $make test
 $make install

On Microsoft operating system, nmake, tar, and gunzip 
must be in the exeuction path. If tar and gunzip are
not install, download and install unxutils from

 http://packages.softwarediamonds.com
^

SUPPORT: 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>
^

SUPPORT: 603 882-0846 E<lt>support@SoftwareDiamonds.comE<gt>^

NOTES:
The following are useful acronyms:

\=over 4

\=item .d

extension for a Perl demo script file

\=item .pm

extension for a Perl Library Module

\=item .t

extension for a Perl test script file

\=back
^

SEE_ALSO: 
\=over 4

\=item L<Data::SecsPack|Data::SecsPack> 

\=item L<Docs::US_DOD::SVD|Docs::US_DOD::SVD> 

\=back
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
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>
^
~-~


