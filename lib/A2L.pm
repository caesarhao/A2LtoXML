package A2L;

use strict;
use warnings;
use File::Basename;
use Data::Dumper;

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
	local $/ = "\r\n";
	while (my $row = <$fh>) {
    	chomp $row;
    	push $self->{lines}, $row;
    	if ($row =~ /^ASAP2_VERSION\ .*/){
  			my @words = split / /, $row;
  			shift @words;
  			$self->set_version(join(' ', @words));
  		}
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
    print $fh "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    foreach my $row (@{$self->{lines}}) {
    	chomp($row);
    	$row =~ s/\"/&quot;/g;
    	if ($row =~ /ASAP2_VERSION\ .*/){
    		my @words = split / /, $row;
    		print $fh "<?", $words[0];
    		shift @words;
    		if (scalar(@words) > 0){
    			print $fh " property=\"", join(' ', @words), "\"?>";
    		}
    		else{
    			print $fh "?>";
    		}
    	}
    	elsif ($row =~ /\s*\/begin\ .*/){
    		my $pos_begin = index $row, "\/begin";
    		for (my $i = 0; $i < $pos_begin; $i++) {
       			print $fh " ";
    		}
    		my @words = split / /, (substr $row, $pos_begin);
    		# print Dumper(@words);
    		shift @words;
    		print $fh "<", $words[0];
    		shift @words;
    		if (scalar(@words) > 0){
    			print $fh " property=\"", join(' ', @words), "\">";
    		}
    		else{
    			print $fh ">";
    		}
    		
    	}
    	elsif ($row =~ /\s*\/end\ .*/){
    		my $pos_end = index $row, "\/end";
    		for (my $i = 0; $i < $pos_end; $i++) {
       			print $fh " ";
    		}
    		my @words = split / /, (substr $row, $pos_end);
    		shift @words;
    		print $fh "<\/", $words[0], ">";
    	}
    	else{
    		print $fh $row;
    	}
    	print $fh "\n";
    }
    close($fh);
    return 0;
}

1;

