#!perl
#
# The copyright notice and plain old documentation (POD)
# are at the end of this file.
#
package  Data::SecsPack;

use strict;
use 5.001;
use warnings;
use warnings::register;

use Math::BigInt;

use vars qw( $VERSION $DATE $FILE);
$VERSION = '0.02';
$DATE = '2004/04/23';
$FILE = __FILE__;

use vars qw(@ISA @EXPORT_OK $max_places);
require Exporter;
@ISA=('Exporter');
@EXPORT_OK = qw(bytes2int config float2binary 
                ifloat2binary int2bytes 
                pack_float pack_int pack_num  
                str2float  str2int
                unpack_float unpack_int unpack_num);

my $secs_default = new Data::SecsPack;


#######
# Object used to set default, startup, options values.
#
sub new
{

   ####################
   # $class is either a package name (scalar) or
   # an object with a data pointer and a reference
   # to a package name. A package name is also the
   # name of a class
   #
   my ($class, @args) = @_;
   $class = ref($class) if( ref($class) );
   my $self = bless {}, $class;

   ######
   # Make Test variables visible to tech_config
   #  
   $self->{binary_fraction_bytes} = 10;
   $self->{extra_decimal_fraction_digits} = 5;
   $self->{decimal_fraction_digits} = 20;
   $self->{decimal_integer_digits} = 20;

   $self;

}

use SelfLoader;

1

__DATA__


###########
# Transform integer to bytes
#
sub bytes2int
{
     shift if UNIVERSAL::isa($_[0],__PACKAGE__);
     my @integer_bytes = @_;
   
     my $integer = '0';
     my $big_integer = Math::BigInt->new('0');
     foreach (@integer_bytes) {   
         $big_integer = Math::BigInt->new($big_integer->blsft(8)); 
         $big_integer = Math::BigInt->new($big_integer->bior($_)); 
     }
     $big_integer =~ s/^\+//;
     $big_integer;
}

######
# Provide a way to module wide configure
#
sub config
{
     $core_secs = Data::SecsPack->new() unless $core_secs;
     my $self = UNIVERSAL::isa($_[0],__PACKAGE__) ? shift :  $core_secs;
     my ($key, $new_value) = @_;
     my $old_value = $self->{$key};
     $self->{$key} = $new_value if $new_value;
     $old_value;
}


#####
#
#
sub float2binary
{ 
     $secs_default = Data::SecsPack->new() unless ref($secs_default);
     my $self = UNIVERSAL::isa($_[0],__PACKAGE__) ? shift : $secs_default;
     return (undef,"No inputs\n") unless defined($_[0]);
     $self = ref($self) ? $self : $secs_default;

     my ($magnitude,$exponent,@options) = @_;

     (my $sign,$magnitude) = ($1,$2) if $magnitude =~ /^\s*([+-]?)\s*(\d+)/;
     return $sign . '0', -100000 unless $magnitude;
     $exponent = $1 if $exponent =~ /^\s*(\d+)/;

     #######
     # Pick up any options
     #
     my %options = %$self;
     my %options_override;
     if(@options) {
         if(ref($options[0]) eq 'HASH') {
             %options_override = %{$options[0]};
         }
         elsif(ref($options[0]) eq 'ARRAY') {
             %options_override = @{$options[0]};
         }
         else {
             %options_override = @options;
         }
     }
     foreach (keys %options_override) {
         $options{$_} = $options_override{$_};
     }


     ########
     # Choose the exponent for the ifloat to minimize the float exponent.
     # For some floats, the entire conversion is done with straingth forward
     # integer arith multiplies, divides and shifts. There is a practical
     # resource limitation for large positive exponents. Limit the resources
     # to exponents under 20. 
     #
     my $ifloat_exponent = 0;
     if(0 < $exponent) {
         my $int_digits = $options{decimal_integer_digits};
         $ifloat_exponent = ($exponent <= $int_digits) ? $exponent : $int_digits;
         $exponent -= $ifloat_exponent;
     }
     elsif( $exponent < 0) {
         my $frac_digits = $options{extra_decimal_fraction_digits};
         $ifloat_exponent = ($exponent >= -$frac_digits) ? $exponent : -$frac_digits;
         $options{decimal_fraction_digits} -= $ifloat_exponent * 2; # - - is a plus
         $exponent -= $ifloat_exponent;
     }

     ########
     # The decimal $integer and $fraction to binary simple float with the first byte
     # of the $binary_magnitude equal to 1 and the binary decimal point between the
     # first and second byte.
     #
     my ($binary_magnitude, $binary_exponent) = 
             ifloat2binary($magnitude, $ifloat_exponent,\%options);

     ############
     # Process big decimal exponents. Convert them into integer $exponent_binary_power
     # $exponent_binary_magnitude
     # 
     #
     # 10^$exp = 2^$bin_exp = $bin_exp = $exp * ln(10) / ln(2);
     #
     # ln(10) / ln(2) = 3.32192809488736
     #
     my $exponent_conversion_error;
     if($exponent) {

          my $exponent_binary_power = $exponent * 3.32192809488736;

          #########################
          # Parse the binary power into integral and fraction part
          # Adding the integral to the binary exponent from the
          # magnitude. The decimal part rasing to power of 2 and
          # directly multipying with the magnitude for a factor
          # between 1/2 and 2.
          #
          my $exponent_factor_magnitude;
          if($exponent_binary_power =~ /([-+]?\d+)(\.\d+)/ ) {
              $exponent_binary_power = $1;
              if( 0 < $exponent_binary_power ) {
                  $exponent_factor_magnitude = 2 ** $2;
              }
              else {
                  $exponent_factor_magnitude = 2 ** -$2;
              }
          }

          #################
          # 
          $binary_exponent += $exponent_binary_power;

          #######
          # Debug purposes
          #
          $exponent_conversion_error =  10 ** $exponent -  
                    (2 ** $exponent_binary_power) * $exponent_factor_magnitude;         

          ########
          # Multiply the conversin from power of base 10 to base 2
          # fractional base2 exponent factor with the magnitude.
          # Both are binary floats.
          #
          my $exponent_factor_exponent = index($exponent_factor_magnitude,'.')-1;
          $exponent_factor_magnitude =~ s/\.//;

          ($exponent_factor_magnitude, $exponent_factor_exponent) = 
                 ifloat2binary($exponent_factor_magnitude, $exponent_factor_exponent);

          #############
          # Float multipy the conversion correction and the magnitude
          # 
          ($binary_magnitude,$binary_exponent) = float_multiply( 
                      $binary_magnitude,$binary_exponent,
                      $exponent_factor_magnitude,$exponent_factor_exponent);

     }
     $binary_magnitude =~ s/^\+//;
     ($sign . $binary_magnitude, $binary_exponent);
}


######
#
#
sub float_multiply
{
     my ($magnitude1, $exponent1, $magnitude2, $exponent2) = @_;
     
     $exponent1 += $exponent2;
     $magnitude1 = Math::BigInt->new($magnitude1)->bmul($magnitude2);

     #########
     # 1.[0-98888+] * 1.[0-99999+]   = [1.0-4.0]
     #
     # Test to see if the multiplication produce integer bits other than 1 and if
     # so move the binary decimal point so that the integer part is 1
     # 
     my @bytes = int2bytes($magnitude1);
     my $shift;
     if( $bytes[0] > 4 ) {
         $shift = 2;  # should not occure unless have terrible accuracy problem
     }
     elsif( $bytes[0] > 2) {
         $shift = 1;
     }
     if($shift) {
         $magnitude1 = Math::BigInt->new($magnitude1)->brsft($shift);
         $exponent1 += $shift;
     }

     ($magnitude1,$exponent1);
}



#####
#
#
sub ifloat2binary
{   
     $secs_default = Data::SecsPack->new() unless ref($secs_default);
     my $self = UNIVERSAL::isa($_[0],__PACKAGE__) ? shift : $secs_default;
     return (undef,"No inputs\n") unless defined($_[0]);
     $self = ref($self) ? $self : $secs_default;

     my ($magnitude,$exponent,@options) = @_;

     my $sign = $magnitude =~ s/^([+-])// ? $1 : '';
     return $sign . '0', -100000 unless $magnitude;

     #######
     # Pick up any options
     #
     my %options = %$self;
     my %options_override;
     if(@options) {
         if(ref($options[0]) eq 'HASH') {
             %options_override = %{$options[0]};
         }
         elsif(ref($options[0]) eq 'ARRAY') {
             %options_override = @{$options[0]};
         }
         else {
             %options_override = @options;
         }
     }
     foreach (keys %options_override) {
         $options{$_} = $options_override{$_};
     }

     ######
     # Break up the magnitude into integer and decimal parts
     #
     # Decimal point placed so one significant decimal digit
     # Move the decimal point to comply to the exponent;
     #
     $magnitude = $1 if $magnitude =~ /^\s*(\S+)/; # comments, leading, trailing white space
     $exponent = $1 if $exponent =~ /^\s*(\S+)/;
     my $decimal_fraction_digits =  $options{decimal_fraction_digits}; 
     $decimal_fraction_digits = 20 unless $decimal_fraction_digits;  # Beyond quad accuracy
  
     $exponent++;
     my ($integer,$fraction) = (0,$magnitude);
     if(0 < $exponent) {
         if($exponent <= length($magnitude)) {
             $integer = substr($magnitude,0,$exponent);
             $fraction = substr($magnitude,$exponent);
         }
         else {
             $integer .= $magnitude . '0'x ($exponent-length($magnitude));
             $fraction = 0;
         }
     }
     elsif($exponent < 0) {
         $exponent = -$exponent;
         return undef,"The exponent, $exponent, is out of range for $magnitude.\n"
                 unless $exponent <= ($decimal_fraction_digits/2) ;
         $integer = 0;
         $fraction = ('0' x $exponent) . $fraction;
     }
     $fraction .= '0' x ($decimal_fraction_digits - length($fraction)) if $fraction;
        
     ########
     # Get the bytes of the integer.
     #
     my @integer_bytes = int2bytes($integer); # MSB first

     #######
     # Determine the bytes for the fraction
     #
     my @fraction_bytes = ();
     if($fraction) {
         my $max_bytes = $options{binary_fraction_bytes};
         my $base_divider = '1' . '0' x $decimal_fraction_digits;
         $fraction =~ s/^\s*\.?//;  # strip any leadhing dots spaces
         $max_bytes = 8 unless $max_bytes;

         my ($i,$quo,$rem);
             for($i=0; $i < $max_bytes; $i++) {
             $fraction = Math::BigInt->new($fraction)->blsft(8);
             ($quo,$fraction) = Math::BigInt->new($fraction)->bdiv($base_divider);
             $quo =~ s/^\+//;
             push @fraction_bytes,$quo;
             last if (!$fraction || $fraction =~ /^(\+0|\-0|0)/);
         } 
     }

     #######
     # Shift the binary decimal point so that the magnitude, $integer most
     # significant bit is 1
     # 
     while(@integer_bytes && $integer_bytes[0] == 0) {
         shift @integer_bytes;
     }
     while(@fraction_bytes && $fraction_bytes[-1] == 0) {
          pop @fraction_bytes;
     }

     #######
     # Move the binary decimal point so that the decimal point is just after
     # the first byte and the first byte has bits.
     #
     my $binary_exponent = 0;
     if(@integer_bytes) {
         $binary_exponent = (scalar @integer_bytes - 1) << 3;   
     }

     ########
     # Left Shift
     # 
     elsif(@fraction_bytes) {
         while( $fraction_bytes[0] == 0 ) {
             shift @fraction_bytes;
             $binary_exponent -= 8;
         }
     }

     #######
     # Shift right until the last bit of the first byte is 1
     # and all the leading bits are 0. The decimal point is
     # between the first and 2nd bytes.
     #
     my $shift = 0;
     if(@integer_bytes) {
         my $test_byte = $integer_bytes[0];
         while($test_byte && $test_byte ne 1) {
             $test_byte = $test_byte >> 1;
             $test_byte &= 0x7F; # case the shift is arith
             $shift++;
         }
         $binary_exponent += $shift;
          
     }
     else {
         my $test_byte = $fraction_bytes[0];
         while($test_byte && $test_byte ne 1) {
             $test_byte = $test_byte >> 1;
             $test_byte &= 0x7F; # case the shift is arith
             $shift++;
         }
         $binary_exponent += ($shift - 8);
          
     }

     #######
     # Add enough 0 to ensure do not drop bits into the bit bucket and enough
     # space for a extra or two right shifts.
     #
     my $binary_magnitude = bytes2int(@integer_bytes,@fraction_bytes,'0','0');
     $binary_magnitude = Math::BigInt->new($binary_magnitude)->brsft($shift) if $shift;
     $binary_magnitude =~ s/^\+//; # drop BigInt + sign
     ($sign . $binary_magnitude, $binary_exponent);

}




###########
# Transform integer to bytes
#
sub int2bytes
{
     shift if UNIVERSAL::isa($_[0],__PACKAGE__);
     my $integer = shift;
   
     #######
     # Break the integer up into byes
     # 
     my @integer_bytes = ();
    
     if ($integer == 0) {
         push @integer_bytes, 0;
     }
     elsif ($integer == -1) {
         push @integer_bytes, -1;
     }
     else { 

         ##########
         # There is big problem with Math::BitInt shifting multi-byte 
         # negative numbers. In the equivalent of the below
         # fails:
         #
         #    (-32767) >> 8     is 128 under Perl
         #
         #    Math::BigInt->new(-32767)->brsft(8) is 127
         #
         # The right shift in Math::BitInt is not a true right shift.
         # It is a simple divide of the number being shifted by the
         # the power of 2 of the shift. This does not work with negative
         # numbers. So need to convert a signed number to a unsigned 
         # number equivalent on a twos complement scale.
         #
         if( Math::BigInt->new($integer)->bcmp(0) < 0) {
             my $twos_complement = 256;
             my $signed_integer;
             do {
                 $signed_integer = Math::BigInt->new($integer)->badd($twos_complement);
                 $twos_complement = Math::BigInt->new($twos_complement)->bmul($twos_complement);
             } while( Math::BigInt->new($signed_integer)->bcmp(0) < 0);
             $integer = $signed_integer;
         }

         my $byte;
         while(Math::BigInt->new($integer)->bcmp(0) ne 0  ) {   
             $byte = Math::BigInt->new($integer)->band(0xFF);
             $byte =~ s/^\+//;
             push @integer_bytes,$byte;
             $integer = Math::BigInt->new($integer)->brsft(8); 
         }
     }
     reverse @integer_bytes; # MSB first
}


#####
#
#
sub pack_float
{

     shift if UNIVERSAL::isa($_[0],__PACKAGE__);
     return ("No inputs\n",undef) unless defined($_[0]);

     my $format = shift;
     my $format_length;
     unless($format eq 'F4' || $format eq 'F8' || $format eq 'F') {
         return (undef,"Data::SecsPack::pack_int. Format $format is not a floating point format.\n");
     }

     ######
     # Do not use $_ off a @_ array. If do, then modify
     # the input symbol in the calling subroutine name 
     # space. Very hard to predict the outcome.
     #
     my @string_float = @_;
     my @floats = ();
     my $bytes_per_cell = '4';
     my ($sign,$magnitude,$exponent_sign,$exponent);
     foreach (@string_float) {

         ($magnitude, $exponent) = float2binary( @$_ );
         return ($magnitude, $exponent) unless defined $magnitude; # error trap      


         if($format eq 'F') {

             #####
             # magnitude is decimal digits
             #
             if($exponent < -128 || $exponent > 128 || length($magnitude) > 10) {
                 $bytes_per_cell = 8;
             }

         }

         push @floats,[$magnitude,$exponent];

    }

    ######
    # Pack the floating points.
    #
    $format = $format . $bytes_per_cell if ($format eq 'F');
    my (@float_bytes);
    my $floats = '';
    my $exponent_excess;
    foreach  (@floats) {

         ($magnitude,$exponent) = @$_;
         $exponent =~ s/^\+//;
         $sign = $magnitude =~ s/^([+-])// ? $1 : '';

         ########
         # Pack the sign, magitude(integer) and exponent
         # (Actually the machine dependent part. So here what can
         # do is something like File::Spec to support the different
         # platforms.)
         # 
         # Will be replacing the leading 1 of the magnitude with the sign
         # bit. Thus shift right one to get the magnitude to line up properly
         # for the F4, F8 IEEE format.
         #

         #########
         # Pack the exponent
         #
         if($format eq 'F4') {
             
             #######
             # There are sign bit and eight exp bits in front of
             # of the $magnitude. The first byte contains only a
             # 1 that need to be drop. Shifting one to the right
             # lines up the magitude, not counting the leading one
             # correctly
             #
             $magnitude = Math::BigInt->new($magnitude)->brsft(1);
             @float_bytes = int2bytes($magnitude);
             unshift @float_bytes,0;

             #######
             # Using only four bytes
             # 
             while( @float_bytes < 4) {
                 push @float_bytes,0;
             }             

             ######
             # Zero out the leading sign and exponent fields.
             #  
             $float_bytes[0] &= 0x0;
             $float_bytes[1] &= 0x7F;

             ######
             # Or in the sign bit
             #                  
             $float_bytes[0] |= 0x80 if ($sign eq '-');

             ######
             # Or in the exponent
             # 
             $exponent_excess = 127 + $exponent;
             if($magnitude == 0) {
                 $float_bytes[1] = 0;
                 $float_bytes[2] = 0;
                 $float_bytes[3] = 0;
             }
             elsif(256 < $exponent_excess) {  # overflow
                 $float_bytes[0] = 0x7F;
                 $float_bytes[1] = 0xff;
                 $float_bytes[2] = 0xff;
                 $float_bytes[3] = 0xff;
             }
             elsif($exponent_excess < 0) {  # underflow
                 $float_bytes[0] = 0x80;
                 $float_bytes[1] = 0;
                 $float_bytes[2] = 0;
                 $float_bytes[3] = 0;
             }
             else {
                 $float_bytes[1] |= ($exponent_excess & 0x01) << 7;
                 $float_bytes[0] |= ($exponent_excess >>1) & 0x7F;
             }
             $floats .= pack 'C4',@float_bytes;
         }             

         #######
         # F8 exponent is 11 bits 2^11 = 2048
         #
         else {

             $magnitude = Math::BigInt->new($magnitude)->brsft(4);
             $magnitude =~ s/^\+//;
             @float_bytes = int2bytes($magnitude);
             unshift @float_bytes,0;

             while( @float_bytes < 8) {
                 push @float_bytes,0;
             }             

             ######
             # Zero out the leading sign and exponent fields.
             #  
             $float_bytes[0] &= 0x00;
             $float_bytes[1] &= 0x0F;

             ######
             # Or in the sign bit
             #                  
             $float_bytes[0] |= 0x80 if ($sign eq '-');

             $exponent_excess = 1023 + $exponent;
             if($magnitude == 0) {
                 $float_bytes[1] = 0;
                 $float_bytes[2] = 0;
                 $float_bytes[3] = 0;
                 $float_bytes[4] = 0;
                 $float_bytes[5] = 0;
                 $float_bytes[6] = 0;
                 $float_bytes[7] = 0;
             }
             elsif(2048 < $exponent_excess) {  # overflow
                 $float_bytes[0] = 0x7F;
                 $float_bytes[1] = 0xF0;
                 $float_bytes[2] = 0;
                 $float_bytes[3] = 0;
                 $float_bytes[4] = 0;
                 $float_bytes[5] = 0;
                 $float_bytes[6] = 0;
                 $float_bytes[7] = 0;
             }
             elsif($exponent_excess < 0) {  # underflow
                 $float_bytes[0] = 0x80;
                 $float_bytes[1] = 0;
                 $float_bytes[2] = 0;
                 $float_bytes[3] = 0;
                 $float_bytes[4] = 0;
                 $float_bytes[5] = 0;
                 $float_bytes[6] = 0;
                 $float_bytes[7] = 0;
            }
             else {
                 $float_bytes[1] |= ($exponent_excess & 0x0F) << 4;
                 $float_bytes[0] |= ($exponent_excess >> 4) & 0x7F;
             }
             $floats .= pack 'C8',@float_bytes;
         }
     }
 
     ($format, $floats);
}




#####
# Pack a list of integers, twos complement, MSB first order.
# Assumming the native computer does two's arith.
#
sub pack_int
{
     shift if UNIVERSAL::isa($_[0],__PACKAGE__);
     return ("No inputs\n",undef) unless defined($_[0]);

     my $format = shift;
     my $format_length;
     ($format,$format_length) = $format =~ /([SUIT])(\d+)?/;
     unless($format && !($format eq 'T' && $format_length)) {
         return (undef,"Data::SecsPack::pack_int. Format $format is not an integer format.\n");
     }

     ######
     # Do not use $_ off a @_ array. If do, then modify
     # the input symbol in the calling subroutine name 
     # space. Very hard to predict the outcome.
     #
     my @string_integer = @_;

     my @integers=();
     my ($max_bytes, $pos_range) = (0,0);
     my @bytes;
     my($str_format,$integer,$num_bytes);
     use integer;
     foreach (@string_integer) {
         $str_format = Math::BigInt->new($_)->bcmp(0) < 0 ? 'S' : 'U';
         if ($str_format eq 'S') {
             return (undef,"Data::SecsPack::pack_int. Signed number when unsigned specified\n") if $format eq 'U';
             $format = 'S';
         }
         if (Math::BigInt->new($_)->bcmp(0) == 0) {
             push @integers, [0];
             next;
         }
         if (Math::BigInt->new($_)->bcmp(-1) == 0) {
             push @integers, [0xFF];
             next;
         }
         @bytes = int2bytes($_);

         #######
         # Positive number in negative number range
         #
         if($format eq 'S' && Math::BigInt->new($_)->bcmp($pos_range) > 0) {
              my $i = $max_bytes;
              while($i--) {
                  unshift @bytes, '0';
              }           
         }
         $num_bytes = scalar(@bytes);
         if($max_bytes < $num_bytes) {
             $max_bytes = $num_bytes;
             if($format eq 'S') {
                 $pos_range = Math::BigInt->new(1)->blsft(($max_bytes << 3) - 1);
                 $pos_range = Math::BigInt->new($pos_range)->bsub(1);
             }
         }
         push @integers, [@bytes];
     }
     return (undef,'Data::SecsPack::pack_int. No integers in input.') unless @integers;

     ####
     # Round up the max length to the nearest power of 2 boundary.
     #
     if( $max_bytes  <= 1) {
         $max_bytes  = 1; 
     }
     elsif( $max_bytes  <= 2) {
         $max_bytes  = 2; 
     }
     elsif( $max_bytes  <= 4) {
         $max_bytes  = 4; 
     }
     elsif( $max_bytes  <= 8) {
         $max_bytes  = 8; 
     }
     else {
         return ("Integer or float out of SECS-II range.\n",undef);
     }
     if ($format_length) {
         if( $format_length < $max_bytes ) {
             return (undef, "Integer bigger than format length of $max_bytes bytes.\n");
         }
         $max_bytes  = $format_length;
     }

     $format = 'U' if $format eq 'I';
     my $signed = $format eq 'S' ? 1 : 0;
     my ($i, $fill, $length, $integers);
     foreach (@integers) {
         @bytes = @{$_};
         $length = $max_bytes - scalar @bytes;
         if($length) {
             $fill =  $signed && $bytes[0] >= 128 ? 0xFF : 0;
             for($i=0; $i< $length; $i++) {
                 unshift @bytes,$fill;
             }
         }
         $integers .= pack ("C$max_bytes",  @bytes);
     }
     $format .= $max_bytes;
     no integer;

     ($format, $integers);
}


#####
#  Pack a list of integers, twos complement, MSB first order.
#  Assumming the native computer does two's arith.
#
sub pack_num
{
     $secs_default = Data::SecsPack->new() unless ref($secs_default);
     my $self = UNIVERSAL::isa($_[0],__PACKAGE__) ? shift : $secs_default;
     return (undef,"No inputs\n") unless defined($_[0]);
     $self = ref($self) ? $self : $secs_default;

     #######
     # Pick up any options
     #
     my %options = %$self;
     my %options_override;
     if(ref(ref($_[-1])) eq 'HASH') {
         %options_override = %{$_[-1]};
         pop @_;
     }
     elsif(ref($_[-1]) eq 'ARRAY') {
         %options_override = @{$_[-1]};
         pop @_;
     }
     
     foreach (keys %options_override) {
         $options{$_} = $options_override{$_};
     }

     my $format = shift;
     ($format, my $format_length) = $format =~ /([FSUIT])(\d)?/;
     unless($format) {
         return (undef, "Only integer and floating point formats supported.\n");
     }

     my ($str,@nums,$nums);
     if($format =~ /^F/) {
         ($str, @nums) = str2float(@nums, $str);
         $nums = pack_float($format, @nums);  
     }
     else {
         ($str, @nums) = str2int(@_);
         my $format_hint = $format;
         ($format, $nums) = pack_int($format, @nums);

         if($format_hint eq 'I') {
             if((!$options{nomix} && @$str != 0 && ${$str}[0] =~ /^\s*-?\s*\d+[\.E]/) ||
                     0 == @nums) {
                 my ($float_str, @float_nums) = str2float(@nums, @$str);
                 my ($float_format,$float_nums) = pack_float('F', @float_nums);
                 if( $float_format && $float_format =~ /^F/ &&  $float_nums) {
                     $format = $float_format;
                     $nums = $float_nums;
                     $str = $float_str;
                 }
             }
         } 
     }
     ($format,$nums,@$str);
}




######
# Covert a string to floats.
#
sub str2float
{
     shift @_ if UNIVERSAL::isa($_[0],__PACKAGE__);
     return '',() unless @_;

     #########
     # Drop leading empty strings
     #
     my @strs = @_;
     while (@strs && $strs[0] !~ /^\s*\S/) {
          shift @strs;
     }
     @strs = () unless(@strs); # do not shift @strs out of existance

     my @floats = ();
     my $early_exit unless wantarray;
     my ($sign,$integer,$fraction,$exponent);
     foreach $_ (@strs) {
         while ( length($_) ) {

             ($sign, $integer,$fraction,$exponent) = ('','','',0);
             #######
             # Parse the integer part
             #
             ($sign,$integer) = ($1,$2) if $_ =~ s/^\s*(-?)\s*([0-9]+)\s*[,;:\n]?//;

             ######
             # Parse the decimal part
             # 
             $fraction = $1 if $_ =~ s/^\.([0-9]+)\s*[,;:\n]?// ;

             ######
             # Parse the exponent part
             $exponent = $1 . $2 if $_ =~ s/^E(-?)([0-9]+)\s*[,;:\n]?//;

             goto LAST unless $integer || $fraction || $exponent;

             ############
             # Normalize decimal float so that there is only one digit to the
             # left of the decimal point.
             # 
             if( $integer ) {
                 $exponent += length($integer) - 1;
             }
             else {
                 while($fraction && substr($fraction,0,1) == 0) {
                     $fraction = substr($fraction,1);
                     $exponent--;
                 }
                 $exponent--;
             }
             push @floats,[$sign . $integer . $fraction,  $exponent];
             goto LAST if $early_exit;
         }
         last if $early_exit;
     }
LAST:
     #########
     # Drop leading empty strings
     #
     while (@strs && $strs[0] !~ /^\s*\S/) {
          shift @strs;
     }
     @strs = () unless(@strs); # do not shift @strs out of existance

     return (\@strs, @floats) unless $early_exit;
     ($integer,$fraction,$exponent) = @{$floats[0]};
     "${integer}${fraction}E${exponent}"
}


######
# Convert number (oct, bin, hex, decimal) to decimal
#
sub str2int
{
     shift @_ if UNIVERSAL::isa($_[0],__PACKAGE__);
     unless( wantarray ) {
         return undef unless(defined($_[0]));
         my $str = $_[0];
         return 0+oct($1) if($str =~ /^\s*(-?\s*0[0-7]+|0?b[0-1]+|0x[0-9A-Fa-f]+)\s*[,;:\n]?$/);
         return 0+$1 if ($str =~ /^\s*(-?\s*[0-9]+)\s*[,;:\n]?$/ );
         return undef;
     }

     #######
     # Pick up input strings
     #
     return [],() unless @_;
     my @strs = @_;

     #########
     # Drop leading empty strings
     #
     while (@strs && $strs[0] !~ /^\s*\S/) {
          shift @strs;
     }
     @strs = () unless(@strs); # do not shift @strs out of existance

     my ($int,$num);
     my @integers = ();
     foreach $_ (@strs) {
         while ( length($_) ) {
             if($_  =~ s/^\s*(-?)s\*(0[0-7]+|0?b[0-1]+|0x[0-9A-Fa-f]+)\s*[,;:\n]?//) {
                 $int = $1 . $2;
                 $num = 0+oct($int);
             }
             elsif ($_ =~ s/^\s*(-?)\s*([0-9]+)\s*[,;:\n]?// ) {
                 $int = $1 . $2;
                 $num = 0+$int;
 
             }
             else {
                 goto LAST;
             }

             #######
             # If the integer is so large that Perl converted it to a float,
             # repair the str so that the large integer may be dealt as a string
             # or converted to a float. The using routine may be using Math::BigInt
             # instead of using the native Perl floats and this automatic conversion
             # would cause major damage.
             # 
             if($num =~ /\s*[\.E]\d+/) {
                 $_ = $int;
                 goto LAST;
             }
 
             #######
             # If there is a string float instead of an int  repair the str to 
             # perserve the float. The using routine may decide to use str2float
             # to parse out the float.
             # 
             elsif($_ =~ /^\s*[\.E]\d+/) {
                 $_ = $int . $_;
                 goto LAST;
             }
             push @integers,$num;
         }
     }
LAST:
     #########
     # Drop leading empty strings
     #
     while (@strs && $strs[0] !~ /^\s*\S/) {
          shift @strs;
     }
     @strs = () unless(@strs); # do not shift @strs out of existance

     (\@strs, @integers);
}


#####
#  Unpack a list of floats, IEEC 754-1985, sign bit first.
#
sub unpack_float
{
     shift @_ if UNIVERSAL::isa($_[0],__PACKAGE__);
     return undef unless defined($_[0]);

     my $format_in = shift;
     my ($format, $format_length) = $format_in =~ /(F)(\d)?/;
     $format = 'F';
     return "Format $format_in not supported.\n" unless $format;
     my @bytes;
     my @floats = ();
     my ($binary_magnitude,$sign,$binary_exponent,$decimal_magnitude,$binary_divider);
     my $secsii_floats = shift @_;
     while ($secsii_floats) {
         @bytes = unpack "C$format_length",$secsii_floats;
         $secsii_floats = substr($secsii_floats,$format_length);
         $sign = $bytes[0] & 0x80 ? '-' : '';
         $bytes[0] &= 0x7F;
         if($format_length == 4) {
             $binary_exponent = (bytes2int($bytes[0],$bytes[1]) >> 7) - 127;
             shift @bytes;
             $bytes[0] &= 0x7F;
             $binary_magnitude = bytes2int(@bytes);
             $binary_magnitude <<= 1;
             $binary_divider =  2 ** 24; # decode into 3 bytes, not 23 bits

         }
         else {
             $binary_exponent = (bytes2int($bytes[0],$bytes[1]) >> 4) - 1023;
             shift @bytes;
             $bytes[0] &= 0x0F;
             $binary_magnitude = bytes2int(@bytes);
             $binary_magnitude = Math::BigInt->new($binary_magnitude)->blsft(4);
             $binary_divider = '72057594037927036';  # 2 ** 56  -  bytes integer too big for Perl
         }

         if($binary_magnitude) {
             $decimal_magnitude = $binary_magnitude . '0'x20; # twenty digit decimal results
             $decimal_magnitude = Math::BigInt->new(bytes2int($decimal_magnitude))->bdiv($binary_divider);
             $decimal_magnitude =~ s/^\+//;
         }
         else {
             $decimal_magnitude = 0;
         }

         #########
         # Let Perl do the arith, doing an automatic convert to float if needed.
         # The accuracy suffers again if Perl must convert to float to get the answer.
         #  
         push @floats, "${sign}1.$decimal_magnitude" * (2 ** $binary_exponent);
     }
     no integer;
     \@floats;
}


#####
#  Unpack a list of integers, twos complement, MSB first order.
#  Assumming the native computer does two's arith.
#
sub unpack_int
{
     shift @_ if UNIVERSAL::isa($_[0],__PACKAGE__);
     return undef unless defined($_[0]);

     my $format_in = shift;
     my ($format, $format_length) = $format_in =~ /([TSU])(\d)?/;
     return "Format $format_in not supported.\n" unless $format && !($format eq 'T' && $format_length);
     $format_length = 1 if $format eq 'T';
     my $signed = $format =~ /S/ ? 1 : 0;
     my ($twos_complement, @bytes, $int);
     my @integers = ();
     my $secsii_ints = shift @_;
     if($signed) {
         $twos_complement = Math::BigInt->new(1)->blsft($format_length << 3);
     }
     while ($secsii_ints) {
         @bytes = unpack "C$format_length",$secsii_ints;
         $secsii_ints = substr($secsii_ints,$format_length);
         $int = bytes2int(@bytes);
         if($signed) {
             if(128 <= $bytes[0]) {       
                 $int = Math::BigInt->new($int)->bsub($twos_complement);
             }
         }         
         push @integers, $int;
     }
     \@integers;
}



#####
#  Unpack a list of numbers, twos complement, MSB first order.
#  Assumming the native computer does two's arith.
#
sub unpack_num
{
     shift @_ if UNIVERSAL::isa($_[0],__PACKAGE__);
     return undef unless defined($_[0]);

     return unpack_float(@_) if($_[0] =~ /^F/);
     unpack_int(@_);
}


1

__END__


=head1 NAME

Data::SecsPack - pack and unpack numbers in accordance with SEMI E5-94

=head1 SYNOPSIS

 #####
 # Subroutine interface
 #  
 use Data::SecsPack qw(bytes2int config float2binary 
                    ifloat2binary int2bytes   
                    pack_float pack_int pack_num  
                    str2float str2int 
                    unpack_float unpack_int unpack_num);

 $big_integer = bytes2int( @bytes );

 $old_value = config( $option );
 $old_value = config( $option => $new_value);

 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, @options); 
 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, [@options]); 
 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, {@options}); 
 
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, @options);
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, [@options]);
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, {@options});

 @bytes = int2bytes( $big_integer );

 ($format, $floats) = pack_float($format, @string_integers);

 ($format, $integers) = pack_int($format, @string_integers);

 ($format, $numbers, @string) = pack_num($format, @strings);

 $float = str2float($string);
 (\@strings, @floats) = str2float(@strings);

 $integer = str2int($string);
 (\@strings, @integers) = str2int(@strings);

 \@ingegers = unpack_int($format, $integer_string); 
 \@floats   = unpack_float($format, $float_string); 
 \@numbers  = unpack_num($format, $number_string); 

 #####
 # Class interface
 #
 use Data::SecsPack;

 $big_integer = bytes2int( @bytes );

 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, @options); 
 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, [@options]); 
 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, {@options}); 

 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, @options);
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, [@options]);
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, {@options});

 @bytes = int2bytes( $big_integer );

 $secspack = new Data::Secs2( @options );
 $secspack = new Data::Secs2( [@options] );
 $secspack = new Data::Secs2( {options} );

 ($format, $floats) = Data::SecsPack->pack_float($format, @string_integers);

 ($format, $integers) = Data::SecsPack->pack_int($format, @string_integers);

 ($format, $numbers, @strings) = Data::SecsPack->pack_num($format, @strings);

 $integer = Data::SecsPack->str2int($string)
 (\@strings, @integers) = Data::SecsPack->str2int(@strings);

 $float = Data::SecsPack->str2float($string);
 (\@strings, @floats) = Data::SecsPack->str2float(@strings);

 \@ingegers = Data::SecsPack->unpack_int($format, $integer_string); 
 \@floats   = Data::SecsPack->unpack_float($format, $float_string); 
 \@numbers  = Data::SecsPack->unpack_num($format, $number_string); 

=head1 DESCRIPTION

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
used in china, germany, korea, japan, france, italy and
the most remote places on this planent for decades.
The basic data structure and packed data formats have not
changed for decades. 

This stands in direct contradiction to common conceptions
of many in the Perl community. The following quote is taken from
page 761, I<Programming Perl> third edition, discussing the 
C<pack> subroutine:

"Floating-point numbers are in the native machine format only.
Because of the variety of floating format and lack of a standard 
"network" represenation, no facility for interchange has been
made. This means that packed floating-point data written
on one machine may not be readable on another. That is
a problem even when both machines use IEEE floating-point arithmetic, 
because the endian-ness of memory representation is not part
of the IEEE spec."

SEMI E5-94 and their precessors do standardize the endian-ness of
floating point, the packing of nested data, used in many programming
languages, and much, much more. The nested data has many performance
advantages over the common SQL culture of viewing and representing
data. The automated fabs of the world make use of nested 
data not only for communication between machines but also for local
processing at the host and equipment.

The endian-ness of SEMI E5-94 is the first MSB byte. Maybe this
is because it makes it easy to spot numbers in a packed data
structure.

Does this standard communications protocol ensure that
everything goes smoothly without any glitches with this wild
mixture of hardware and software talking to each other
in real time?
Of course not. Bytes get reverse. Data gets jumbled from
point A to point B. Machine time is non-existance.
Big ticket, multi-million dollar fab equipment has to
work to earn its keep. And, then there is the everyday
business of suiting up, with humblizing hair nets,
going through air and other
showers just to get in to the clean room.
And make sure not to do anything that will damage
a little cassette containing a million dollars 
worth of product.
It is totally amazing that the product does
get out the door.

=head2 SECSII Format

The L<Data::SecsPack|Data::SecsPack> suroutines 
packs and unpacks numbers in accordance with 
L<SEMI|http://http://www.semiconductor-intl.org> E5-94, 
Semiconductor Equipment Communications Standard 2 (SECS-II),
avaiable from
 
 Semiconductor Equipment and Materials International
 805 East Middlefield Road,
 Mountain View, CA 94043-4080 USA
 (415) 964-5111
 Easylink: 62819945
 http://www.semiconductor-intl.org
 http://www.reed-electronics.com/semiconductor/
 
The format of SEMI E5-94 numbers are established
by below Table 1. 

               Table 1 Item Format Codes

 unpacked   binary  octal  hex   description
 ---------------------------------------------------------
 T          001001   11    0x24  Boolean
 S8         011000   30    0x60  8-byte integer (signed)
 S1         011001   31    0x62  1-byte integer (signed)
 S2         011010   32    0x64  2-byte integer (signed)
 S4         011100   34    0x70  4-byte integer (signed)
 F8         100000   40    0x80  8-byte floating
 F4         100100   44    0x90  4-byte floating
 U8         101000   50    0xA0  8-byte integer (unsigned)
 U1         101001   51    0xA4  1-byte integer (unsigned)
 U2         101010   52    0xA8  2-byte integer (unsigned)
 U4         101100   54    0xB0  4-byte integer (unsigned)

Table 1 complies to SEMI E5-94 Table 1, p.94, with an unpack text 
symbol and hex columns added. The hex column is the upper 
Most Significant Bits (MSB) 6 bits
of the format code in the SEMI E5-94 item header (IH)

In accordance with SEMI E5-94 6.2.2,

=over 4

=item 1

the Most Significat Byte
(MSB) of numbers for formats S2, S4, S8, U2, U4, U8 is
sent first

=item 2

the signed bit for formats F4 and F8 are
sent first. 

=item 3

Signed integer formats S1, S2, S4, S8 are two's complement

=back

The memory layout for Data::SecsPack is the SEMI E5-94
"byte sent first" has the lowest memory address.

The SEMI E5-94 F4 format complies to IEEE 754-1985 float and
the F8 format complies to IEEE 754-1985 double.
The IEEE 754-1985 standard is available from:

 IEEE Service Center
 445 Hoe Lane,
 Piscataway, NJ 08854
  
The SEMI E5-94 F4, IEEE 754-1985 float, is 32 bits
with the bits assigned follows:   
 
 S EEE EEEE EMMM MMMM MMMM MMMM MMMM MMMM

where  S = sign bit, E = 8 exponent bits  M = 23 mantissa bits

The format of the float S, E, and M are as follows:

=over 4

=item Sign of the number

The sign is one bit, 0 for positive and 1 for negative.

=item  exponent

The exponent is 8 bits and may be positive or negative.   
The IEEE 754 exponent uses excess-127 format.
The excess-127 format adds 127 to the exponent.
The exponent is re-created by subtracting 127
from the exponent.

=item Magnitude of the number

The magnitude or mantissa is a 23 bit unsigned binary number
where the radix is adjusted to make the magnitude fall between
1 and 2. The magnitude is stored ignoring the 1 and
filling in the trailing bits until there are
23 of them.

=back

The SEMI E5-94 F4, IEEE 754-1985 double, is 64 bits
with S,E,M as follows: S = sign bit, E = 11 exponent bits
M = 52 mantissa bits

The format of the float S, E, and M are as follows:

=over 4

=item Sign of the number

The sign is one bit, 0 for positive and 1 for negative.

=item  exponent

The exponent is 8 bits and may be positive or negative.   
The IEEE 754 exponent uses excess-1027 format.
The excess-1027 format adds 1027 to the exponent.
The exponent is re-created by subtracting 1027
from the exponent.

=item Magnitude of the number

The magnitude or mantissa is a 52 bit unsigned binary number
where the radix is adjusted to make the magnitude fall between
1 and 2. The magnitude is stored ignoring the 1 and
filling in the trailing bits until there are
52 of them.


=back

For example, to find the IEEE 754-1985 float of -10.5

=over 4

=item *

Convert -10.5 decimal to -1010.1 binary

=item *

Move the radix so magitude is between 1 and 2,
-1010. binary to -1.0101 * 2^ +3

=item *

IEEE 754-1985 sign is 1

=item *

The magnitude dropping the one and filling
in with 23 bits is

 01010000000000000000000

=item *

Add 127 to the exponent of 3 to get

 130 decimal converted to 8 bit binary 

 10000010

=item *

Combining into IEEE 754-1985 format: 

 11000001001010000000000000000000

 1100 0001 0010 1000 0000 0000 0000 0000

 C128 0000 hex

=back

=head2 bytes2int subroutine

 $big_integer = bytes2int( @bytes );

The C<bytes2int> subroutine counvers a C<@bytes> binary number with the
Most Significant Byte (MSB) $byte[0] to a decimal string number C<$big_integer>
using the C<Data::BigInt> program module. As such, the only limitations
on the number of binary bytes and decimal digits is the resources of the 
computer.

=head2 config subroutine

 $old_value = config( $option );
 $old_value = config( $option => $new_value);
 (@all_options) = config( );

The C<config> subroutine reads and writes the
default, startup options for the subroutines in
the C<Data::Secs2> program module and package.
The options are as follows:
                                                  values  
 subroutine             option                    default 1sts
 ----------------------------------------------------------
 bytes2int 

 float2binary           decimal_integer_digits          20
                        extra_decimal_fraction_digits    5 

 ifloat2binary          decimal_fraction_digits         20
                        binary_fraction_bytes           10

 int2bytes   
 pack_float 
 pack_int 

 pack_num               nomix                            0
 
 str2float
 str2int 
 unpack_float
 unpack_int
 unpack_num

For those folks who are not object orientated purist,
creating and object with the C<new> subroutine produces
a object whose underlying hash is the options above
and may be directly modified. 
Is there really in sense in providing a simple added
subroutine layer for just reading and writing a
simple variable? The object orientated purist 
will say yes.

=head2 float2binary subroutine

 ($binary_magnitude, $binary_exponent) = float2binary($magnitude, $exponent, @options); 

The C<ifloat2binary> subroutine converts a decimal float with a base ten
C<$magnitude> and C<$exponent> to a binary float
with a base two C<$binary_magnitude> and C<$binary_exponent>.

The C<ifloat2binary> assumes that the decimal point is set by
C<ixpeonent> so that there is one decimal integer digit in C<imagnitude>
The C<ifloat2binary> produces a C<$binary_exponent> so that the first
byte of C<$binary_magnitude> is 1 and the rest of the bytes are
a base 2 fraction.

The C<float2binary> subroutine uses the C<ifloat2binary> for small
$exponents part and the native float routines to correct the
C<ifloat2binary> for the base ten exponent factor outside the range
of the C<ifoat2binary> subroutine.

The C<float2binary> subroutine uses the options C<decimal_integer_digits>,
C<$decial_fraction_digits>, C<extra_decimal_fraction_digits> in determining
the C<$iexponent> passed to the C<ifloat2binary> subroutine. 
The option C<decimal_integer_digits>
is the largest positive base ten C<$iexponent> 
while smallest C<$ixponent> is
the half C<$decial_fraction_digits> + C<extra_decimal_fraction_digits>.
The C<float2binary> subroutine C<extra_decimal_fraction_digits> only
for negative C<$iexponent>.
The C<float2binary> subroutine uses any base ten C<$exponent> from C<$iexponent>
breakout to adjust the C<ifloat2binary> subroutine results using 
native float arith.

=head2 ifloat2binary subroutine
 
 ($binary_magnitude, $binary_exponent) = ifloat2binary($imagnitude, $iexponent, @options);

The C<$ifloat2binary> subroutine converts a decimal float with a base ten
C<$imagnitude> and C<$iexponent> using the C<Math::BigInt> program
module to a binary float with a base two C<$binary_magnitude> and a base
two C<$binary_exponent>.
The C<$ifloat2binary> assumes that the decimal point is set by
C<ixpeonent> so that there is one decimal integer digit in C<imagnitude>
The C<ifloat2binary> produces a C<$binary_exponent> so that the first
byte of C<$binary_magnitude> is 1 and the rest of the bytes are
a base 2 fraction.

Since all the calculations use basic integer arith, there are 
practical limits on the computer resources.  Basically the limit is that
with a zero exponent, the decimal point is within the significant 
C<imagnitude> digits. Within these limitations, the accuracy, by 
chosen large enough limits for the binary fraction, is perfect.

The first step of the C<ifloat2binary> subroutine is zero out 
C<iexponent> by breaking up the 
C<imagnitude> into an integer part C<integer> and fractional part C<fraction>
consist with the C<iexponent>. 
The c<ifloat2binary> will add as many significant decimal zeros to the
right of C<integer> in order to zero out C<iexponent>; likewise it will
add as many decimal zeros to the left of C<integer> to zero out
C<exponent> within the limit set by the option C<decimal_fraction_digits>.
If C<ifloat2binary> cannot zero out C<iexponent> without violating the
C<decimal_fraction_digits>,  C<ifloat2binary> will discontinue processing
and return an C<undef> C<$binary_magnitude> with and error message in
C<$binary_exponent>.  

This design is based on the fact that the conversion of integer decimal
to binary decimal is one to one, while the conversion of fractional decimal
to binary decimal is not.
When converting from decimal fractions with finite digits to binary fractions
repeating binary fractions of infinity size are possible, 
and do happen quite frequently. 
An unlimited repeating binary fraction will quickly use all computer
resources.  The C<binary_fraction_bytes> option provides this ungraceful
event by limiting the number of fractional binary bytes.
The default limits of 20 C<decimal_fraction_digits> and
C<binary_fraction_bytes> 10 bytes provides a full range of 0 - 255 for
each binary byte. The ten bytes are three more bytes then are ever
used in the largest F8 SEMI float format.

The the following example illustrates the method used by C<ifloat2binary>
to convert decimal fracional digits to binary fractional bytes.
Convert a 6 digit decimal fraction string into
a binary fraction as follows:

 N[0-999999]      
 -----------  =  
   10^6          

 byte0    byte1   byte2    256         R2
 ----- +  ----- + ----- + ----- * ------------
 256^1    256^2   256^3   256^4     10 ^ 6

Six digits was chosen so that the integer arith,
using a 256 base, does not over flow 32 bit
signed integer arith

 256 *   99999     =   25599744
 256 *  999999     =  255999744
 signed 32 bit max = 2147483648 / 256 = 8377608
 256 * 9999999     = 2559999744

Note with quad arith this technique would yield 16 decimal
fractional digits as follows:

 256 * 9999999999999999  =  2559999999999999744
 signed 64 bit max       =  9223372036854775808 / 256 = 36028797018963868
 256 * 99999999999999999 = 25599999999999999744

 Thus, need to get quad arith running.

 Basic step

  1      256 * N[0-999999]     1                     R0[0-999744]
 --- *   ----------------  =  ---- ( byte0[0-255] + ------------ ) 
 256         10 ^ 6           256                     10^6

The results will have a range of 

  1
 ---- ( 0.000000 to 255.999744)
 256 

The fractional part, R0 is a six-digit decimal. 
Repeating the basic step three types gives the
desired results. QED.

 2nd Iteration

  1      256 * R0[0-999744]       1                   R1[0-934464]
 --- *   --------------      =  ---- ( byte1[0-255] + ------------) 
 256         10 ^ 6              256                    10^6

 3rd Iteration

  1      256 * R1[0-934464]       1                   R2[0-222784]
 --- *   --------------      =  ---- ( byte2[0-239] + ------------) 
 256         10 ^ 6              256                    10^6

Taking this out to ten bytes the first six decimal digits N[0-999999]
yields bytes in the following ranges:

 byte    power      range    10^6 remainder
 ------------------------------------------ 
   0     256^-1     0-255    [0-999744]
   1     256^-2     0-255    [0-934464]
   2     256^-3     0-239    [0-222784]
   3     256^-4     0-57     [0-032704]
   4     256^-5     0-8      [0-372224]
   5     256^-6     0-95     [0-293440]
   6     256^-7     0-75     [0-120640]
   7     256^-8     0-30     [0-883840]
   8     256^-9     0-226    [0-263040]
   9     256^-10    0-67     [0-338249]

The first two binary fractional bytes have full range. The rest except for
byte 9 are not very close. This makes one wonder about the accuracy loss
in translating from binary fractions to decimal fractions. One wonders
just why have all theses problems with not just binary and decimal factions
but fractions in general. Isn't mathematics wonderful.

For example in convert from decimal to binary fractions there is no clean
one to one conversion as for integers. For example, look at the below table
of conversions: 
   
 -1    -2     -3     -4     -5     binary power as a decimal   
 0.5   0.25  0.125 0.0625 0.03125  decimal power 
                                   decimal 
  0     0      0      0      0     0.00000
  0     0      0      0      1     0.03125
  0     0      0      1      1     0.0625
  0     0      1      0      0     0.125
  0     0      1      0      1     0.15625
  0     0      1      1      0     0.1875
  0     0      1      1      1     0.21875
  1     0      0      0      0     0.50000

=head2 int2bytes subroutine

 @bytes = int2bytes( $big_integer );

The C<int2bytes> subroutine uses the C<Data:BigInt> program module to 
convert an integer text string C<$bit_integer> into a byte array, 
C<@bytes>, the Most Significant Byte (MSB) being C<$bytes[0]>. There is
no limits on the size of C<$big_integer> or C<@bytes> except for
the resources of the computer.

=head2 int2bytes subroutine

 @bytes = int2bytes( $big_integer );

The C<int2bytes> subroutine uses the C<Data:BigInt> program module to 
convert a byte array, C<@bytes>, the most significant byte being C<$bytes[0]>
into an integer text string C<$bit_integer> i 
There is no limits on the size of C<$big_integer> or C<@bytes>.

=head2 new subroutine

 $secspack = new Data::Secs2( @options );
 $secspack = new Data::Secs2( [@options] );
 $secspack = new Data::Secs2( {options} );

The C<new> subroutine provides a method to set local options
once for any of the other subroutines. 
The options may be modified at any time by
C<$secspack->config($option => $new_value)>.
Calling any of the subroutines as a
C<$secspack> method will perform that subroutine
with the options saved in C<secspack>.

=head2 pack_float subroutine

 ($format, $floats) = pack_float($format, @string_integers);

The C<pack_int> subroutine takes an array of strings, <@string_integers>,
and a float format code, as specifed in the above C<Item Format Code Table>,
and packs all the integers, decimals and floats as a float
 the C<$format> in accordance with C<SEMI E5-94>.
The C<pack_int> subroutine also accepts the format code C<F>
and format codes with out the bytes-per-element number and packs the
numbers in the format using the less space. 
In any case, the C<pack_int> subroutine returns
the correct C<$format> of the packed C<$integers>.

When the C<pack_float> encounters an error, it returns C<undef> for C<$format> and
a description of the error as C<$floats>.

=head2 pack_int subroutine

 ($format, $integers) = pack_int($format, @string_integers);

The C<pack_int> subroutine takes an array of strings, <@string_integers>,
and a format code, as specifed in the above C<Item Format Code Table>
and packs the integers, C<$integers> in the C<$format> in accordance with C<SEMI E5-94>.
The C<pack_int> subroutine also accepts the format code C<I I1 I2 I8>
and format codes with out the bytes-per-element number and packs the
numbers in the format using the less space, with unsigned preferred over
signed. In any case, the C<pack_int> subroutine returns
the correct C<$format> of the packed C<$integers>.

When the C<pack_int> encounters an error, it returns C<undef> for C<$format> and
a description of the error as C<$integers>. All the C<@string_integers> must
be valid Perl numbers. 

=head2 pack_num subroutine

 ($format, $numbers, @strings) = pack_num($format, @strings);

The C<pack_num> subroutine takes leading numbers in C<@strings> and
packs them in the C<$format> in accordance with C<SEMI E5-94>.
The C<pack_num> subroutine returns the stripped C<@strings>
data naked of all leading numbers in C<$format>.

The C<pack_num> subroutine also accepts C<$format> of C<I I1 I2 I4 F>
For these format codes, C<pack_num> is extremely liberal and accepts
processes all numbers consistence with the C<$format> and packs one
or more numbers in the C<SEMI E5-94> format that takes the least
space. In this case, the return $format is changed to the C<SEMI E5-94>
from the C<Item FOrmat Code Table> of the packed numbers.

For the C<I> C<$format>,
if the C<nomix> option is set option, the C<pack_num> subroutine will 
pack all leading, integers, decimals and floats as multicell float
with the smallest space; otherwise, it will stop at the first
decimal or float encountered and just pack the integers. 

The C<pack_num> subroutine processes C<@strings> in two steps.
In the first step, the
C<pack_num> subroutine uses C<str2int> and/or C<str2float> 
subroutines to parse the leading
numbers from the C<@strings> as follows:

 ([@strings], @integers) = str2int(@strings); 
 ([@strings], @floats) = str2float(@strings); 

In the second step, 
the C<pack_num> subroutine uses C<pack_int> and/or C<pacK_float>
to pack the parsed numbers.

=head2 str2float subroutine

 $float = str2float($string);
 (\@strings, @floats) = str2float(@strings);

The C<str2float> subroutine, in an array context, supports converting multiple run of
integers, decimals or floats in an array of strings C<@strings> to an array
of integers, decimals or floats, C<@floats>.
It keeps converting the strings, starting with the first string in C<@strings>,
continuing to the next and next until it fails an conversion.
The C<str2int> returns the stripped string data, naked of all integers,
in C<@strings> and the array of integers C<@integers>.

In a scalar context, it parse out any type of $number in the leading C<$string>.
This is especially useful for C<$string> that is certain to have a single number.

=head2 str2int subroutine

 $integer = str2int($string);
 (\@strings, @integers) = str2int(@strings); 

In a scalar context,
the C<Data::SecsPack> program module translates an scalar string to a scalar integer.
Perl itself has a documented function, '0+$x', that converts a scalar to
so that its internal storage is an integer
(See p.351, 3rd Edition of Programming Perl).
If it cannot perform the conversion, it leaves the integer 0.
Surprising not all Perls, some Microsoft Perls in particular, may leave
the internal storage as a scalar string.

The scalar C<str2int> subroutine is basically the same except if it cannot perform
the conversion to an integer, it returns an "undef" instead of a 0.
Also, if the string is a decimal or floating point, it will return an undef.
This makes it not only useful for forcing an integer conversion but
also for testing a scalar to see if it is in fact an integer scalar.
The scalar C<str2int> is the same and supercedes C&<Data::SecsPack::str2int>.
The C<Data::SecsPack> program module superceds the C<Data::SecsPack> program module. 

The C<str2int> subroutine, in an array context, supports converting multiple run of
integers in an array of strings C<@strings> to an array of integers, C<@integers>.
It keeps converting the strings, starting with the first string in C<@strings>,
continuing to the next and next until it fails a conversion.
The C<str2int> returns the remaining string data in C<@strings> and
the array of integers C<@integers>.

=head2 unpack_float subroutine

 \@floats   = unpack_float($format, $float_string);

The C<unpack_num> subroutine unpacks an array of floats C<$float_string>
packed in accordance with SEMI-E5 C<$format>. 
A valid C<$format>, in accordance with the above C<Item Format Code Table>,
is C<F4 F8>.

The C<unpack_num> returns a reference, C<\@floats>, to the unpacked float array
or scalar error message C<$error>. To determine a valid return or an error,
check that C<ref> of the return exists or is 'C<ARRAY>'.
 
=head2 unpack_int subroutine

 \@integers = unpack_int($format, $integer_string); 

The C<unpack_num> subroutine unpacks an array of numbers C<$string_numbers>
packed in accordance with SEMI-E5 C<$format>. 
A valid C<$format>, in accordance with the above C<Item Format Code Table>,
is C<S1 S2 S4 U1 U2 U4 T>.

The C<unpack_num> returns a reference, C<\@integers>, to the unpacked integer array
or scalar error message C<$error>. To determine a valid return or an error,
check that C<ref> of the return exists or is 'C<ARRAY>'.

=head2 unpack_num subroutine

 \@numbers  = unpack_num($format, $number_string); 

The C<unpack_num> subroutine unpacks an array of numbers C<$number_string>
packed in accordance with SEMI-E5 C<$format>. 
A valid C<$format>, in accordance with the above C<Item Format Code Table>,
is C<S1 S2 S4 U1 U2 U4 F4 F8 T>.
The C<unpack_num> subroutine uses either C<unpack_float> or C<unpack_int>
depending upon C<$format>.

The C<unpack_num> returns a reference, C<\@numbers>, to the unpacked number array
or scalar error message C<$error>. To determine a valid return or an error,
check that C<ref> of the return exists or is 'C<ARRAY>'.

=head1 REQUIREMENTS

Coming soon.

=head1 DEMONSTRATION

 #########
 # perl SecsPack.d
 ###

 ~~~~~~ Demonstration overview ~~~~~

Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

 =>     use File::Package;
 =>     my $fp = 'File::Package';

 =>     my $uut = 'Data::SecsPack';
 =>     my $loaded;

 =>     my ($result,@result);

 =>     #########
 =>     # Subroutines to test that actual values are within
 =>     # and expected tolerance of the expected value
 =>     #
 =>     sub tolerance
 =>     {
 =>         my ($actual,$expected) = @_;
 =>         2 * ($expected - $actual) / ($expected + $actual);
 =>     }

 =>     sub pass_fail_tolerance
 =>     {   my ($actual,$expected) = @_;
 =>          (-$expected < $actual) && ($actual < $expected) ? 1 : 0;
 =>     }

 =>     my $tolerance_result;
 =>     my $float_tolerance = 1E-10;

 => ##################
 => # UUT Loaded
 => # 
 => ###

 =>    my $errors = $fp->load_package($uut, 
 =>        qw(bytes2int float2binary 
 =>           ifloat2binary int2bytes   
 =>           pack_float pack_int pack_num  
 =>           str2float str2int 
 =>           unpack_float unpack_int unpack_num) );
 => $errors
 ''

 => ##################
 => # str2int(\'033\')
 => # 
 => ###

 => $result = $uut->str2int('033')
 '27'

 => ##################
 => # str2int(\'0xFF\')
 => # 
 => ###

 => $result = $uut->str2int('0xFF')
 '255'

 => ##################
 => # str2int(\'0b1010\')
 => # 
 => ###

 => $result = $uut->str2int('0b1010')
 '10'

 => ##################
 => # str2int(\'255\')
 => # 
 => ###

 => $result = $uut->str2int('255')
 '255'

 => ##################
 => # str2int(\'hello\')
 => # 
 => ###

 => $result = $uut->str2int('hello')
 undef

 => ##################
 => # str2int(' 78 45 25', ' 512E4 1024 hello world') \@numbers
 => # 
 => ###

 => my ($strings, @numbers) = str2int(' 78 45 25', ' 512E4 1024 hello world')
 => [@numbers]
 [
           '78',
           '45',
           '25'
         ]

 => ##################
 => # str2int(' 78 45 25', ' 512E4 1024 hello world') \@strings
 => # 
 => ###

 => join( ' ', @$strings)
 '512E4 1024 hello world'

 => ##################
 => # str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') numbers
 => # 
 => ###

 => ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')
 => [@numbers]
 [
           [
             '78',
             '1'
           ],
           [
             '-24',
             '-6'
           ],
           [
             '025',
             -3
           ],
           [
             '512',
             '6'
           ]
         ]

 => ##################
 => # str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') \@strings
 => # 
 => ###

 => ($strings, @numbers) = str2float(' 78 -2.4E-6 0.0025', ' 512E4 hello world')
 => join( ' ', @$strings)
 'hello world'

 =>      my @test_strings = ('78 45 25', '512 1024 100000 hello world');
 =>      my $test_string_text = join ' ',@test_strings;
 =>      my $test_format = 'I';
 =>      my $expected_format = 'U4';
 =>      my $expected_numbers = '0000004e0000002d000000190000020000000400000186a0';
 =>      my $expected_strings = ['hello world'];
 =>      my $expected_unpack = [78, 45, 25, 512, 1024, 100000];

 =>      my ($format, $numbers, @strings) = pack_num('I',@test_strings);

 => ##################
 => # pack_num($test_format, $test_string_text) format
 => # 
 => ###

 => $format
 'U4'

 => ##################
 => # pack_num($test_format, $test_string_text) numbers
 => # 
 => ###

 => unpack('H*',$numbers)
 '0000004e0000002d000000190000020000000400000186a0'

 => ##################
 => # pack_num($test_format, $test_string_text) \@strings
 => # 
 => ###

 => [@strings]
 [
           'hello world'
         ]

 => ##################
 => # unpack_num($expected_format, $test_string_text) error check
 => # 
 => ###

 => ref(my $unpack_numbers = unpack_num($expected_format,$numbers))
 'ARRAY'

 => ##################
 => # unpack_num($expected_format, $test_string_text) numbers
 => # 
 => ###

 => $unpack_numbers
 [
           78,
           45,
           25,
           512,
           1024,
           100000
         ]

 =>  
 =>      @test_strings = ('78 4.5 .25', '6.45E10 hello world');
 =>      $test_string_text = join ' ',@test_strings;
 =>      $test_format = 'I';
 =>      $expected_format = 'F8';
 =>      $expected_numbers = '405380000000000040120000000000003fd0000000000000422e08ffca000000';
 =>      $expected_strings = ['hello world'];
 =>      my @expected_unpack = (78, 4.5, 0.25,6.45E10);

 =>      ($format, $numbers, @strings) = pack_num('I',@test_strings);

 => ##################
 => # pack_num($test_format, $test_string_text) format
 => # 
 => ###

 => $format
 'F8'

 => ##################
 => # pack_num($test_format, $test_string_text) numbers
 => # 
 => ###

 => unpack('H*',$numbers)
 '405380000000000040120000000000003fd0000000000000422e08ffca000000'

 => ##################
 => # pack_num($test_format, $test_string_text) \@strings
 => # 
 => ###

 => [@strings]
 [
           'hello world'
         ]

 => ##################
 => # unpack_num($expected_format, $test_string_text) error check
 => # 
 => ###

 => ref($unpack_numbers = unpack_num($expected_format,$numbers))
 'ARRAY'

 => $unpack_numbers
 [
           '78.0000000000002',
           '4.50000000000001',
           '0.25',
           '64500000000.0004'
         ]


=head1 QUALITY ASSURANCE

=head2 Test Report

  => perl SecsPack.t
 
 1..23
 # Running under perl version 5.006001 for MSWin32
 # Win32::BuildNumber 635
 # Current time local: Thu Apr 22 14:04:19 2004
 # Current time GMT:   Thu Apr 22 18:04:19 2004
 # Using Test.pm version 1.24
 # Test::Tech    : 1.2
 # Data::Secs2   : 1.17
 # Data::SecsPack: 0.02
 # =cut 
 ok 1 - UUT Loaded 
 ok 2 - str2int('033') 
 ok 3 - str2int('0xFF') 
 ok 4 - str2int('0b1010') 
 ok 5 - str2int('255') 
 ok 6 - str2int('hello') 
 ok 7 - str2int(' 78 45 25', ' 512E4 1024 hello world') @numbers 
 ok 8 - str2int(' 78 45 25', ' 512E4 1024 hello world') @strings 
 ok 9 - str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') numbers 
 ok 10 - str2float(' 78 -2.4E-6 0.25', ' 512E4 hello world') @strings 
 ok 11 - pack_num(I, 78 45 25 512 1024 100000 hello world) format 
 ok 12 - pack_num(I, 78 45 25 512 1024 100000 hello world) numbers 
 ok 13 - pack_num(I, 78 45 25 512 1024 100000 hello world) @strings 
 ok 14 - unpack_num(U4, 78 45 25 512 1024 100000 hello world) error check 
 ok 15 - unpack_num(U4, 78 45 25 512 1024 100000 hello world) numbers 
 ok 16 - pack_num(I, 78 4.5 .25 6.45E10 hello world) format 
 ok 17 - pack_num(I, 78 4.5 .25 6.45E10 hello world) numbers 
 ok 18 - pack_num(I, 78 4.5 .25 6.45E10 hello world) @strings 
 ok 19 - unpack_num(F8, 78 4.5 .25 6.45E10 hello world) error check 
 ok 20 - unpack_num(F8, 78 4.5 .25 6.45E10 hello world) float 0 
 ok 21 - unpack_num(F8, 78 4.5 .25 6.45E10 hello world) float 1 
 ok 22 - unpack_num(F8, 78 4.5 .25 6.45E10 hello world) float 2 
 ok 23 - unpack_num(F8, 78 4.5 .25 6.45E10 hello world) float 3 
 # Passed : 23/23 100%

=head2 Other Tests

The test script C<SecsPackStress.t> provides a more thorough test
and is provided in the distribution package.
The Software Test Description (STD) for C<SecsPackStress>
is C<SecsPackStress.pm> also in the distribution package.
The installation runs both C<SecsPack.t> and C<SecsPackStress.t>.
 
=head2 Test Software

The module "t::Data::SecsPack" is the Software
Test Description(STD) module for the "Data::SecsPack".
module. 

To generate all the test output files, 
run the generated test script,
run the demonstration script and include it results in the "Data::SecsPack" POD,
execute the following in any directory:

 tmake -test_verbose -replace -run  -pm=t::Data::SecsPack

Note that F<tmake.pl> must be in the execution path C<$ENV{PATH}>
and the "t" directory containing  "t::Data::SecsPack" on the same level as the "lib" 
directory that contains the "Data::SecsPack" module.

=head1 NOTES

=head2 AUTHOR

The holder of the copyright and maintainer is

E<lt>support@SoftwareDiamonds.comE<gt>

=head2 COPYRIGHT NOTICE

Copyrighted (c) 2002 Software Diamonds

All Rights Reserved

=head2 BINDING REQUIREMENTS NOTICE

Binding requirements are indexed with the
pharse 'shall[dd]' where dd is an unique number
for each header section.
This conforms to standard federal
government practices, 490A (L<STD490A/3.2.3.6>).
In accordance with the License, Software Diamonds
is not liable for any requirement, binding or otherwise.

=head2 LICENSE

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code must retain
the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http::www.softwarediamonds.com,
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

=head2 SEE_ALSO:

=over 4

=item L<File::Spec|File::Spec>

=item L<Data::SecsPack|Data::SecsPack>

=back

=for html
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
<!-- BLK ID="COPYRIGHT" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut
### end of script  ######