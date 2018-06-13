#!/usr/bin/perl -l

# ########################################### DOX

# $db->{CMDS}->[0] # drush cr
# $db->{CMDS}->[1] # drush ard @sites -y
# $db->{CMDS}->[2] # drush up -y
# $db->{CMDS}->[3] # drush updb -y
# $db->{CMDS}->[4] # drush entup -y

# &run_cmd($cmd) # Put command in

# ########################################### PRAGMAS

use strict;
use warnings;
use Data::Dumper;
$|++;

# ########################################### GLOBAL VARS

my $db = {};

# ########################################### INIT

while (<DATA>)
{
	
	chomp;
	next if m!^\#|^$!;
	
	if (m~(?i)^PATH(?=:)~)
	{
		
		$db->{ ((split m~:~, $_)[0]) } 
			= ((split m~:~, $_)[1])
		
	}
	elsif (m~(?i)^SITES(?=:)~) 
	{
		
		$db->{ ((split m~:~, $_)[0]) } 
			= [split m~\|~, ((split m~:~, $_)[1])]
		
	}
	else 
	{
		push @{$db->{CMDS}}, $_
	}
	
}

# BEGIN COMMANDS

GO: 
{
	
	# Clear cache
	&run_cmd(qq~cd ~ . $db->{PATH} . qq~ && ~ . $db->{CMDS}->[0]);
	
	# Backup all sites / databases
	&run_cmd(qq~cd ~ . $db->{PATH} . qq~ && ~ . $db->{CMDS}->[1]);
	
	# Backup all sites / databases
	&run_cmd(qq~cd ~ . $db->{PATH} . qq~ && ~ . $db->{CMDS}->[2]);
	
	# Entity / Database updates of all sites 
	for (@{$db->{SITES}})
	{
		
		# Database
		&run_cmd(qq~cd ~ . $db->{PATH} . $_ . qq~ && ~ . $db->{CMDS}->[3]);
		
		# Entity
		&run_cmd(qq~cd ~ . $db->{PATH} . $_ . qq~ && ~ . $db->{CMDS}->[4]);
		
	}
	
}

# print Dumper $db; # Debug

# ########################################### SUBS

sub press_any_key
{
	
	print qq~Press any key to continue...~;
	<>;
	
}

sub run_cmd
{
	
	my $cmd = shift;

	print qq~> CMD: ${cmd}~;
	
	# &press_any_key();
	
	eval { system $cmd };
	
	die qq~Somthing went wrong!\n> $cmd\nError code: $?\n~ if $?;
	
}


# ########################################### DATA

__END__
PATH:/var/www/drupal/8/
SITES:sites/iits|sites/cde|sites/forms|sites/patient|sites/default

# Clear Cache
drush cr

# Backup all sites
drush ard @sites -y

# Update drupal core + contrib
drush up -y 

# Backup database
drush updb -y

# Entity update
drush entup -y

# ############# EXAMPLES

# To un-install
# drush pmu ds -y

# To Download
# drush dl ds-8.x-3.1 -y

# To install
# drush en ds -y 

############# LIST OF ALL COMMANDS
# > CMD: cd /var/www/drupal/8/ && drush cr
# > CMD: cd /var/www/drupal/8/ && drush ard @sites -y
# > CMD: cd /var/www/drupal/8/ && drush updb -y
# > CMD: cd /var/www/drupal/8/sites/iits && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/iits && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/cde && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/cde && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/forms && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/forms && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/patient && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/patient && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/default && drush entup -y
# > CMD: cd /var/www/drupal/8/sites/default && drush entup -y
