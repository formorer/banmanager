package BanManager::Cmd::Command::List;
# ABSTRACT: list bans in the database

use Moose;
use BanManager::Schema qw();
use Data::Dumper;
use v5.10;
use Text::ASCIITable;
use Log::Log4perl::Level;

extends qw(MooseX::App::Cmd::Command);

sub  description {
	return 'List bans in the database';
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
	my $schema = BanManager::Schema->connect('dbi:SQLite:sql/test.db');

	my $ban_resultset = $schema->resultset('Ban');
	my $t = Text::ASCIITable->new();
	$t->setCols('Id','Description', 'Expiration', 'Pattern', 'List', 'References');
	foreach my $ban ($ban_resultset->all()) {
		my @lists = map {
			$_->pattern;
		} $ban->lists->all();

		my @references = map {
			$_->reference;
		} $ban->refs->all();

		my @patterns = map {
			sprintf('%s=%s', $_->field, $_->pattern);
		} $ban->patterns->all();

		$t->addRow($ban->id, $ban->description, $ban->expires, join("\n", @patterns), join("\n", @lists), join("\n", @references) );
	}
	print $t;
}

1;