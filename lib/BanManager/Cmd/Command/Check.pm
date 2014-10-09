package BanManager::Cmd::Command::Check;
# ABSTRACT: accepts a mail from stdin and checks it

use Moose;
use BanManager::Schema qw();
use Data::Dumper;
use Email::Simple;
use v5.10;
use Tie::Hash::Regex;
use Log::Log4perl::Level;


with 'MooseX::Log::Log4perl::Easy';

extends qw(MooseX::App::Cmd::Command);

sub description {
	return 'Checks a mail from stdin';
}

has debug => (
	traits => [qw(Getopt)],
	isa => 'Bool',
	cmd_aliases => 'd',
	documentation => 'Add debugging',
	is => 'rw',
);

sub _debug {
	my ($self, $debug) = @_;
	$self->logger->level($DEBUG);
}

sub execute {
	my ($self, $opt, $args) = @_;
	my $schema = BanManager::Schema->connect('dbi:SQLite:sql/test.db', undef, undef, { on_connect_call => 'use_foreign_keys' });

	my $listposted = shift @{$args};

	my @text = <STDIN>;
	my $email = Email::Simple->new(join("", @text));

	# get all not expired bans
	my $bans = $schema->resultset('Ban')->search (
		{ expires => { '>', \'date(\'now\')' }},
		);

	# build a searchable tree
	my $tree;
	while( my $ban = $bans->next()) {
		#get lists
		my @lists = map { $_->pattern; } $ban->lists->all();
		

		#get patterns
		my @patterns = map {
			{ field => $_->field , pattern =>  $_->pattern } 
		} $ban->patterns->all();

		
		foreach my $listpattern ( @lists ) { 
			$self->log->debug("Compare '$listposted' with '$listpattern'");
			next unless $listposted =~ qr/$listpattern/;
			$self->log->debug("Listpattern $listpattern matched");
			foreach my $pattern (@patterns) {
				my $field = $pattern->{field};
				my $pat = $pattern->{pattern};
				$tree->{$field}->{$pat} ||= [];
				push @{ $tree->{$field}->{$pat} }, $ban->id;
			}
		}
	}
	
	my @matches;
	foreach my $field ( keys(%$tree) ) {
		my $header = $email->header("$field");
		if (! $header) {
			$self->log->debug("Header field $field not found");
			next;
		}

		foreach my $pattern ( keys(%{ $tree->{$field} }) ) {
			if ($header =~ qr/$pattern/) {
				$self->log->debug("$header matched against $pattern. (Rule(s) " . join(',', @{ $tree->{$field}->{$pattern} }) .  ")");
				push @matches, @{ $tree->{$field}->{$pattern} };
			} else {
				$self->log->debug("$header did not matched $pattern (Rule(s) " . join(',', @{ $tree->{$field}->{$pattern} }) . ")");
			}
		}

	}

	if (keys(@matches)) {
		$self->log->info("The following rules matched: " . join(",", @matches));
		exit 1;
	} else {
		$self->log->debug("No rules matched");
		exit 0;
	}
}

1;