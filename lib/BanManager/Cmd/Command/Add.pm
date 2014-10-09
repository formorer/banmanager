package BanManager::Cmd::Command::Add;
# ABSTRACT: add a new ban to the database
use Moose::Util::TypeConstraints;
use Time::Duration::Parse;
use DateTime;
use Data::Dumper;
use DateTime;
use Moose;
use Try::Tiny;
use BanManager::Schema qw();

extends qw(MooseX::App::Cmd::Command);

has expiration => (
	traits => [qw(Getopt)],
	isa => 'Str',
	cmd_aliases => 'e',
	documentation => 'Expiration time',
	is => 'rw',
	required => 1,
	);

has bandescription => (
	traits => [qw(Getopt)],
	isa => 'Str',
	is => 'rw',
	cmd_aliases => 'd',
	documentation => 'description of the ban',
	required => 1,
	);

has reference => (
	traits => [qw(Getopt)],
	isa => 'ArrayRef[Str]',
	is => 'rw',
	cmd_aliases => 'r',
	documentation => 'references for the ban',
	default => sub { [] }
	);

has lists => (
	traits => [qw(Getopt)],
	isa => 'ArrayRef[Str]',
	is => 'rw',
	cmd_aliases => 'l',
	default => sub { [] },
	documentation => 'listregexes that match the ban',
	required => 1,
	);

has pattern => (
	traits => [qw(Getopt)],
	isa => 'ArrayRef[Str]',
	is => 'rw',
	cmd_aliases => 'l',
	
	documentation => 'regex patterns to match against. Defaults to From header, you can use header=pattern to choose a different header.',
	required => 1,
	);

sub description {
	return "add a new ban to the database";	
}

sub execute {
	my ($self, $opt, $args) = @_;
	my $duration;

	try {
		$duration = parse_duration( $self->expiration );
	} catch {
		BanManager::Cmd::Error->throw('Could not load parse expiration duration:' . $_);
	};

	my $dt = DateTime->now;
	$dt->add( seconds => $duration );

	my $schema = BanManager::Schema->connect('dbi:SQLite:sql/test.db');

	my $l = $self->lists;
	my @lists;
	map { push @lists, { pattern => $_ } } @$l;

	my @references;
	my $r = $self->reference;
	map { push @references, {  reference => $_ } } @$r;

	my $p = $self->pattern;
	my @patterns;
	map { 
		my $header = 'From';
		my $pattern;
		if ($_ =~ /=/) {
			($header, $pattern) = split ('=', $_, 2);
		} else {
			$pattern = $_;
		}
		push @patterns, { field => $header, pattern => $pattern };
	} @$p; 
	
	my $ban = $schema->resultset('Ban')->create({
		description => $self->bandescription,
		expires => $dt,
		lists => \@lists,
		patterns => \@patterns,
		refs => \@references,
		})
}

1;