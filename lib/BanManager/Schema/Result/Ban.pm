use utf8;
package BanManager::Schema::Result::Ban;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BanManager::Schema::Result::Ban

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<bans>

=cut

__PACKAGE__->table("bans");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 expires

  data_type: 'datetime'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "expires",
  { data_type => "datetime", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 lists

Type: has_many

Related object: L<BanManager::Schema::Result::List>

=cut

__PACKAGE__->has_many(
  "lists",
  "BanManager::Schema::Result::List",
  { "foreign.bans_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 patterns

Type: has_many

Related object: L<BanManager::Schema::Result::Pattern>

=cut

__PACKAGE__->has_many(
  "patterns",
  "BanManager::Schema::Result::Pattern",
  { "foreign.bans_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 refs

Type: has_many

Related object: L<BanManager::Schema::Result::Ref>

=cut

__PACKAGE__->has_many(
  "refs",
  "BanManager::Schema::Result::Ref",
  { "foreign.bans_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-10-09 22:22:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JkKxZOaKKX/UiuiuvY+TCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
