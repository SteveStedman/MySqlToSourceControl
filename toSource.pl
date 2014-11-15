#!/usr/bin/perl -w 
use DBI;
my ($database, $user, $pass, $path) = @ARGV;

$dbh = DBI->connect('dbi:mysql:' . $database, $user, $pass) or die "Connection Error: $DBI::errstr\n";


#First Save tables.
$sql = "show tables;";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) 
{ 
	$sql2 = "show create table " . $row[0] . "\n";
	$sth2 = $dbh->prepare($sql2);
	$sth2->execute or die "SQL Error: $DBI::errstr\n";
	if (@row2 = $sth2->fetchrow_array) 
	{ 
		$filename = $path . '/' . $row2[0] . ".table.sql";
		open(DATA, ">" . $filename) or die "Couldn't open file file.txt, $!";
		print DATA $row2[1] . ";\n";
		close DATA;
		print "saved: " . $filename . "\n";
	}
}

#now dump the views
$sql = "SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) 
{ 
	$sql2 = "show create view " . $row[0] . "\n";
	$sth2 = $dbh->prepare($sql2);
	$sth2->execute or die "SQL Error: $DBI::errstr\n";
	if (@row2 = $sth2->fetchrow_array) 
	{ 
		$filename = $path . '/' . $row2[0] . ".view.sql";
		open(DATA, ">" . $filename) or die "Couldn't open file file.txt, $!";
		print DATA $row2[1] . ";\n";
		close DATA;
		print "saved: " . $filename . "\n";
	}
}

#now procedures
$sql = "SHOW PROCEDURE STATUS;";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) 
{ 
	$sql2 = "show create procedure " . $row[1] . "\n";
	$sth2 = $dbh->prepare($sql2);
	$sth2->execute or die "SQL Error: $DBI::errstr\n";
	if (@row2 = $sth2->fetchrow_array) 
	{ 
		$filename = $path . '/' . $row2[0] . ".procedure.sql";
		open(DATA, ">" . $filename) or die "Couldn't open file file.txt, $!";
		print DATA $row2[2] . ";\n";
		close DATA;
		print "saved: " . $filename . "\n";
	}
}

#and functions
$sql = "SHOW FUNCTION STATUS;";
$sth = $dbh->prepare($sql);
$sth->execute or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) 
{ 
	$sql2 = "show create function " . $row[1] . "\n";
	$sth2 = $dbh->prepare($sql2);
	$sth2->execute or die "SQL Error: $DBI::errstr\n";
	if (@row2 = $sth2->fetchrow_array) 
	{ 
		$filename = $path . '/' . $row2[0] . ".function.sql";
		open(DATA, ">" . $filename) or die "Couldn't open file file.txt, $!";
		print DATA $row2[2] . ";\n";
		close DATA;
		print "saved: " . $filename . "\n";
	}
}

