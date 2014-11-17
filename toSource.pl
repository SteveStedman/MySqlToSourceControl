#!/usr/bin/perl -w 
use strict;
use DBI;
my ($database, $user, $pass, $path) = @ARGV;

sub writeFileIfDifferent
{
	my($filename, $fileContents) = @_;
	open(DATA, ">" . $filename) or die "Couldn't open file file.txt, $!";
	print DATA $fileContents . ";\n";
	close DATA;
	print "saved: " . $filename . "\n";
}
sub saveTables
{
	my($dbh) = @_;
	my $sql = "show tables;";
	my $sth = $dbh->prepare($sql);
	$sth->execute or die "SQL Error: $DBI::errstr\n";
	while (my @row = $sth->fetchrow_array) 
	{ 
		my $sql2 = "show create table " . $row[0] . "\n";
		my $sth2 = $dbh->prepare($sql2);
		$sth2->execute or die "SQL Error: $DBI::errstr\n";
		if (my @row2 = $sth2->fetchrow_array) 
		{ 
			my $filename = $path . '/' . $row2[0] . ".table.sql";
			my $table = $row2[1];
			$table =~ s/ AUTO_INCREMENT=/\r\nAUTO_INCREMENT=/g;
			$table =~ s/ DEFAULT CHARSET=/\r\nDEFAULT CHARSET=/g;
			writeFileIfDifferent($filename, $table);
		}
	}
}
sub saveViews
{
	my($dbh) = @_;
	my $sql = "SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';";
	my $sth = $dbh->prepare($sql);
	$sth->execute or die "SQL Error: $DBI::errstr\n";
	while (my @row = $sth->fetchrow_array) 
	{ 
		my $sql2 = "show create view " . $row[0] . "\n";
		my $sth2 = $dbh->prepare($sql2);
		$sth2->execute or die "SQL Error: $DBI::errstr\n";
		if (my @row2 = $sth2->fetchrow_array) 
		{ 
			my $filename = $path . '/' . $row2[0] . ".view.sql";
			writeFileIfDifferent($filename, $row2[1]);
		}
	}
}
sub saveProcedures
{
	my($dbh) = @_;
	my $sql = "SHOW PROCEDURE STATUS;";
	my $sth = $dbh->prepare($sql);
	$sth->execute or die "SQL Error: $DBI::errstr\n";
	while (my @row = $sth->fetchrow_array) 
	{ 
		my $sql2 = "show create procedure " . $row[1] . "\n";
		my $sth2 = $dbh->prepare($sql2);
		$sth2->execute or die "SQL Error: $DBI::errstr\n";
		if (my @row2 = $sth2->fetchrow_array) 
		{ 
			my $filename = $path . '/' . $row2[0] . ".procedure.sql";
			writeFileIfDifferent($filename, $row2[2]);
		}
	}
}
sub saveFunctions
{
	my($dbh) = @_;
	my $sql = "SHOW FUNCTION STATUS;";
	my $sth = $dbh->prepare($sql);
	$sth->execute or die "SQL Error: $DBI::errstr\n";
	while (my @row = $sth->fetchrow_array) 
	{ 
		my $sql2 = "show create function " . $row[1] . "\n";
		my $sth2 = $dbh->prepare($sql2);
		$sth2->execute or die "SQL Error: $DBI::errstr\n";
		if (my @row2 = $sth2->fetchrow_array) 
		{ 
			my $filename = $path . '/' . $row2[0] . ".function.sql";
			writeFileIfDifferent($filename, $row2[2]);
		}
	}
}
my $dbh = DBI->connect('dbi:mysql:' . $database, $user, $pass) or die "Connection Error: $DBI::errstr\n";
saveTables($dbh);
saveViews($dbh);
saveProcedures($dbh);
saveFunctions($dbh);