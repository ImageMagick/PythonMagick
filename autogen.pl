#!/usr/bin/perl -w
# -*- perl -*-
eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
my $VERSION = "0.2.8";
# Copyright (C) 2005-2007 - Carl Fürstenberg
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


#############################################################################
# @PROGRAMS is the probably the only thing you need to edit, set programs,  #
# it's argument, and eventually minimum version. You can also connect a     #
# chain of alternatives if program is not found.                            #
# All fields except 'name' is optional                                      #
#                                                                           #
# Change %CONFIG if you want to tune the apperance, (can be done from the   #
# command line, see '--help' for more information).                         #
#                                                                           #
# $EXTRAPATH can be used to extend enviromental variable $PATH              #
#                                                                           #
# %MESSAGES can contain additional messages to print                        #
#                                                                           #
# sub PRE and sub POST can contain extra code to be executed if needed      #
#############################################################################

my @PROGRAMS =
(
    {
        name        => 'aclocal',
        version     => '1.10',
        argument    => '--force -I m4',
    },
	{
		name        => 'autoheader',
		version     => '2.61',
		argument    => '--force',
	},
	{
		name		=> 'libtoolize',
		version		=> '1.5.22',
		argument	=> '--force --copy'
	},
    {
        name        => 'automake',
        version     => '1.10',
        argument    => '--add-missing --copy --force --include-deps --foreign',
    },
    {
        name        => 'autoconf',
        version     => '2.61',
        argument    => '--force',
    },
);

# Extra path to search in addition of $PATH (separate with ':')
my $EXTRAPATH="$ENV{'PWD'}/scripts";

# Dirs not to be traversed when clean
my %KEEPDIR = (
	'.svn'	=> 1,
	'CVS'	=> 1,
);

# Static configuration options
my %CONFIG = (
    'USE_COLORS'        => 1, # use colors in output?
    'DEBUG'             => 0, # se output from programs executed?
    'CHECK'             => 1, # check for programs?
    'EXEC'              => 1, # execute programs?
);


# Add some messages here if you want...
my %MESSAGES = (
    'PRE'   => "Preparing to preconfigure pythonmagick\n",
    CHECK   => {
        PRE     => "",
        POST    => "",
    },
    EXEC    => {
        PRE     => "",
        POST    => "",
    },
    'POST'   => "Preconfiguration done,\nremember now to run ./configure for configuration of your package\n",
);

# If you need to run some extra code before or after main code is run, you can
# add that here.
sub PRE {
    # Extra code to be run before everything else
}
sub POST {
    # Extra code to be run after everything else
}


#########################################################################
# CORE PROGRAM BELOW, DO NOT EDIT UNLESS YOU KNOW WHAT YOU ARE DOING :) #
#########################################################################

use File::Spec; # TODO remove dependency? i.e. can it be done without File::Spec?

##############
# Prototypes #
##############

# sub errout($error_msg);
sub errout($);

# sub check(%data);
sub check(%);

# sub execute(%data)
sub execute(%);

# sub clean()
sub clean();

# sub help()
# return $helpText
sub help();

# sub ver()
# return $versionText
sub ver();

# sub list($basedir)
# return list of files
sub list($);

# sub which($executable)
# return string if files
sub which($);




SWITCH: foreach(@ARGV) 
{
    /--help/        and do {print help                  ; exit 0        };
    /--version/     and do {print ver                   ; exit 0        };
    /--clean/       and do {$CONFIG{'CLEAN'} = 1        ; next SWITCH   };
    /--colors/      and do {$CONFIG{'USE_COLORS'} = 1   ; next SWITCH   };
    /--nocolors/    and do {$CONFIG{'USE_COLORS'} = 0   ; next SWITCH   };
    /--verbose/     and do {$CONFIG{'DEBUG'} = 1        ; next SWITCH   };
    /--silent/      and do {$CONFIG{'DEBUG'} = 0        ; next SWITCH   };
    /--nocheck/     and do {$CONFIG{'CHECK'} = 0        ; next SWITCH   };
    /--noexec/      and do {$CONFIG{'EXEC'} = 0         ; next SWITCH   };
    # default:
    print "$0: illigal argument '$_'\n"; exit 1;
}

my @c = $CONFIG{'USE_COLORS'} ? ("\e[0m","\e[1m") : ("","");

clean if $CONFIG{'CLEAN'};

$ENV{'PATH'} .= ":".$EXTRAPATH;

# aliases for common programs
my $alias =
{
    'aclocal' => 'aclocal-1.4 aclocal-1.5 aclocal-1.6 aclocal-1.7 aclocal-1.8 aclocal-1.9 aclocal-1.10',
    'autoreconf' => 'autoreconf2.13 autoreconf2.50',
    'autoconf' => 'autoconf2.13 autoconf2.50',
    'autoheader' => 'autoheader2.13 autoheader2.50',
    'automake' => 'automake-1.4 automake-1.5 automake-1.6 automake-1.7 automake-1.8 automake-1.9 automake-1.10',
    'cvs2cl' => 'cvs2cl.pl',
};
if(not -f "autogen.log" and $CONFIG{'EXEC'})
{
    my $list = join "\0", &list(File::Spec->rel2abs(File::Spec->curdir));
    open(FILE, '>', 'autogen.log') or die "$!";
    print FILE $list;
    close FILE;
}

####################
# BEGIN MAIN LOOPS #
####################
print "$MESSAGES{'PRE'}";
&PRE;
print "$MESSAGES{'CHECK'}{'PRE'}"   if $CONFIG{'CHECK'};
do {check $_ foreach @PROGRAMS}     if $CONFIG{'CHECK'}; # Check
print "$MESSAGES{'CHECK'}{'POST'}"  if $CONFIG{'CHECK'};
print "$MESSAGES{'EXEC'}{'PRE'}"    if $CONFIG{'EXEC'};
do {execute $_ foreach @PROGRAMS}   if $CONFIG{'EXEC'};  # Execute
print "$MESSAGES{'EXEC'}{'POST'}"   if $CONFIG{'EXEC'};
&POST;
print "$MESSAGES{'POST'}";

##################
# END MAIN LOOPS #
##################

#######################
# Internal subs below #
#######################

sub help()
{
    return 
    "Usage: $0 [OPTIONS] ...\n".
    "\n".
    "Checks and execute various programs used for preconfiguring sources\n".
    "\n".
    "  --color             show colors in output\n".
    "  --nocolor           no colors in output\n".
    "  --verbose           show output from programs executed\n".
    "  --silent            show no output\n".
    "  --nocheck           do not run any check\n".
    "  --noexec            do not execute any program\n".
    "  --version           show version and exit\n".
    "  --help              show this help\n".
    "  --clean             clean generated files (hopefully)\n";
}

sub ver()
{
    return 
    "autogen.pl $VERSION\n".
    "\n".
    "Copyright (C) 2007 - Carl Fürstenberg.\n".
    "This is free software; see the source for copying conditions.  There is NO\n".
    "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n".
    "\n".
    "Written by Carl Fürstenberg <azatoth\@gmail.com>\n";
}

sub execute(%)
{
    ${$_[0]}{'argument'} = '' unless exists ${$_[0]}{'argument'};
    print "executing $c[1]${$_[0]}{name}$c[0] ${$_[0]}{argument}\n";
    my $err = system "${$_[0]}{name} ${$_[0]}{argument} 1>.autogen_pl_tmp1 2>.autogen_pl_tmp2";
    if($CONFIG{'DEBUG'}) {
        open(FILE, ".autogen_pl_tmp1");
        print <FILE>;
        close FILE;
    }
    if($CONFIG{'DEBUG'} or $err >> 8) {
        open(FILE2, ".autogen_pl_tmp2");
        print <FILE2>;
        close FILE2;
    }
    unlink ".autogen_pl_tmp1", ".autogen_pl_tmp2";
    exit $err >> 8 if $err >> 8;
}

sub check(%)
{
    my($counter, $version, %result, @checks);
    $counter = 0;

    print "checking for $c[1]${$_[0]}{'name'}$c[0] ";
    if(exists ${$_[0]}{'version'} and ${$_[0]}{'version'} ne "" and
    ${$_[0]}{'version'} ne "0") { 
        print "version >= ${$_[0]}{'version'} ";
    }
    print "... ";
    print "\n" if $CONFIG{'DEBUG'};

    foreach my $check (which ${$_[0]}{'name'}." ".($alias->{${$_[0]}{'name'}}||"")) {
        print "$check\: " if $CONFIG{'DEBUG'};
        if(not exists ${$_[0]}{'version'}
            or ${$_[0]}{'version'} eq "" 
            or ${$_[0]}{'version'} eq "0") { # unless version check, take first possible program
            print "yes".($CONFIG{'DEBUG'}?"\n":" - ($check)\n");
            ${$_[0]}{'name'} = $check;
            return;
        }
        $counter++;

        ($version) = `$check --version | head -n 1` =~ /\s*\S+\s*\(?.*?\)?\ (\d+\.?\d*\.?\d*)/; # 1, 2.13, 1.8.0 etc...
        next unless $version;

        my ($rq_major, $rq_minor, $rq_patch) = split /\./, ${$_[0]}{'version'};
        my ($my_major, $my_minor, $my_patch) = split /\./, $version;

        # if short version (2.13, 4)
        $my_patch = 0 unless defined $my_patch;
        $my_minor = 0 unless defined $my_minor;
        $rq_patch = 0 unless defined $rq_patch;
        $rq_minor = 0 unless defined $rq_minor;

        if(
            $my_major > $rq_major or (                  # if 2.x.x > 1.x.x or
                $my_major == $rq_major and (            # if 2.x.x == 2.x.x and
                    $my_minor > $rq_minor or (          # if X.2.x > X.1.x or
                        $my_minor == $rq_minor and (    # if X.2.x == X.2.x and
                            $my_patch >= $rq_patch      # if X.X.2 >= X.X.2
                        )
                    )
                )
            )
        )
        {
            print "$version yes".($CONFIG{'DEBUG'}?"\n":" - ($check)\n");
            ${$_[0]}{'name'} = $check;
            return;
        }
        else {
        print "$version\n" if $CONFIG{'DEBUG'};
        }
    }
    unless($counter > 0) {
        unless(${$_[0]}{'alt'}) {
            errout "${$_[0]}{'name'} was not found";
        }
        else {
            print "no\n";
            check ${$_[0]}{'alt'};
            $_[0] = ${$_[0]}{'alt'};
            return;
        }
    }
    unless(${$_[0]}{'alt'}) {
        print "$version\n" unless $CONFIG{'DEBUG'};
        errout "need ${$_[0]}{'name'} version ${$_[0]}{'version'} or higher";
    }
    else {
        print "$version " if $version;
        print "no\n";
        check ${$_[0]}{'alt'};
        $_[0] = ${$_[0]}{'alt'};
        return;
    }

}

sub errout($){print"$c[1]error:$c[0] ".(shift)."\n";exit 1;}

sub clean()
{
    if( -f "autogen.log") {
        open(FILE, '<', 'autogen.log') or die "unable to read. $!";
        my @list = split /\0/, <FILE>;
        close FILE;
        my @source = reverse sort &list(File::Spec->rel2abs(File::Spec->curdir));
        my $ptr = 0;
        my $len = $#source - $#list;
        LOOP:
        foreach my $x (@source)
        {
            do {next LOOP if $x =~ /^$_$/} foreach @list;
            $ptr++;
            -f $x and do { print "unlink $c[1]$x$c[0]\n" if $CONFIG{'DEBUG'}; unlink $x};
            -d $x and do { print "rmdir $c[1]$x$c[0]\n" if $CONFIG{'DEBUG'}; rmdir $x};
            printf STDERR "\r%-80s%.2f%s", "#" x (80*($ptr/$len)),($ptr/$len*100),'%' unless $CONFIG{'DEBUG'};
        }
        print STDERR "\n" unless $CONFIG{'DEBUG'};
    }
    else {
        errout "no generated files found";
    }
    exit;
}

sub list($)
{
    my $basedir = shift;
    my @files;
    foreach my $x (<* .*>)
    {
        next if $x =~  /^\.{1,2}$/;
		next if -d $x and exists $KEEPDIR{$x} and $KEEPDIR{$x} == 1;
        push @files, File::Spec->abs2rel($x,$basedir);
        do {chdir $x; push @files, &list($basedir); chdir ".."} if -d $x;
    }

    return @files;
}
sub which($)
{
    my $dir = $ENV{'PWD'};
    my ($result,@return);
    foreach my $path (split ':', $ENV{'PATH'}) {
        chdir $path;
        -x $path.'/'.$_ and -f $path.'/'.$_ and push @{$result->{$_}}, $path.'/'.$_ foreach <*>;
    }
    do {push @return,@{$result->{$_}} if exists $result->{$_}} foreach split ' ', shift;
    chdir $dir;
    return @return;
}

