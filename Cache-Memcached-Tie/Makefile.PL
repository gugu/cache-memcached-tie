use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Cache::Memcached::Tie',
    VERSION_FROM      => 'lib/Cache/Memcached/Tie.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Cache/Memcached/Tie.pm', # retrieve abstract from module
       AUTHOR         => 'Andrew Kostenko <gugu@cpan.org>') : ()),
);
