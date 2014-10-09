package BanManager::Cmd::Command::Delete;
# ABSTRACT: delete bans in the database

use Moose;
use BanManager::Schema qw();
use Data::Dumper;
use v5.10;
use Text::ASCIITable;
use Log::Log4perl::Level;

extends qw(MooseX::App::Cmd::Command);

sub  description {
	return 'delete bans in the database';
}

sub execute {
	my ($self, $opt, $args) = @_;
	my $schema = BanManager::Schema->connect('dbi:SQLite:sql/test.db', undef, undef, { on_connect_call => 'use_foreign_keys' });

	if (! @{$args} ) {
		say STDERR "No ids given - nothing to delete. Usage: delete id [id id]";
		return 1;
	}
	foreach my $id (@{$args}) {
		if ($id !~ /^\d+$/) {
			say STDERR "$id does not look like an id - skipping";
			next;
		}
		my $ban = $schema->resultset('Ban')->find({ id => $id });
		if (!$ban) {
			say STDERR "no ban with id $id found - skipping";
		} else {
			$ban->delete();
			say "ban $id deleted";
		}

	}
}