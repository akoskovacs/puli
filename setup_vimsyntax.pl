#!/usr/bin/env/perl 

&detect_vim;

sub detect_vim {
    my $vim_version;
    my $major;
    my $minor;
    my $vim;

    if (($vim_version = `vim --version` or $vim_version = `vi --version`) eq "") {
        die "Vim not found!";
    } 
    
    $vim_version =~ m/IMproved\s+(\d+)\.(\d+)/;
    $major = $1;
    $minor = $2;

    print "Detected Vim version $major.$minor...\n";
   
    $vim = &get_vimdir($major, $minor); 
}

sub get_vimdir($$) {
    my $major = shift;
    my $minor = shift;
    my @dirs = (
        "/usr/share/vim/vim$major$minor",
        "/usr/local/share/vim/vim$major$minor");

    foreach my $dir (@dirs) {
        if (-d $dir) {
            print "Detected Vim directory at $dir...\n";
            return $dir;
        }
    }
    die "Vim directory cannot found!";
}
