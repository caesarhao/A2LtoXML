package A2L;

use strict;
use warnings;
use File::Basename;

sub new {
    my $class = shift;

    my $self = {
        if_fullpath	=> shift, # input file name.
        if_path		=> undef,
        if_basename => undef,
        version     => undef,
        lines 		=> [],
    };
	
    bless $self, $class;
    $self->_initialize();
    return $self;
}

sub _initialize {
	my $self = shift;
	my($filename, $dirs, $suffix) = fileparse($self->{if_fullpath});
	open(my $fh, '<', $self->{if_fullpath}) or die "Could not open file '$self->{if_fullpath}' $!";
	$self->{if_path} = $dirs;
	$self->{if_basename} = $filename;
	while (my $row = <$fh>) {
    	chomp $row;
    	push $self->{lines}, $row;
  	}
  	close($fh);
}

sub set_version {
    my $self = shift;
    my $version = shift;
    $self->{version} = $version;
}

sub get_version {
    my $self = shift;
    return $self->{version};
}

sub outputXML {
    my $self = shift;
    my $outputXml = $self->{if_path} . $self->{if_basename} . ".xml";
    open(my $fh, '>', $outputXml) or die "Could not open file '$outputXml' $!";
    foreach my $row (@{$self->{lines}}) {
    	if ($_ =~ /\s*\/begin\ .*/){
    		my $pos_begin = index $_, "/begin";
    		for (my $i = 0; $i < $pos_begin; $i++) {
       			print " ";
    		}
    		my @words = split / /, (substr $str, ($pos_begin + 6));
    		print $fh "<" . $words[0];
    		shift @words;
    		if (scalar(@words) > 1){
    			print $fh " property=\"".join( ' ', @words)."\">";
    		}
    		else{
    			print $fh ">";
    		}
    	}
    	elsif ($_ =~ /\s*\/end\ .*/){
    		my $pos_end = index $_, "/end";
    		for (my $i = 0; $i < $pos_end; $i++) {
       			print " ";
    		}
    		my @words = split / /, (substr $str, ($pos_end + 6));
    		print $fh "</" . $words[0] . ">";
    	}
    	else{
    		print $fh $_;
    	}
    	print $fh "\n";
    }
    close($fh);
    return 0;
}

1;

