PERL_VERSION=`echo $VERSION | awk -F "." '{print $1"."$2}'`

sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Duseshrplib                                \
             -Dprivlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
             -Darchlib=/usr/lib/perl5/$PERL_VERSION/core_perl     \
             -Dsitelib=/usr/lib/perl5/$PERL_VERSION/site_perl     \
             -Dsitearch=/usr/lib/perl5/$PERL_VERSION/site_perl    \
             -Dvendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl


make

make install
