use utf8;
package BanManager::Schema::Result::List;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

BanManager::Schema::Result::List

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<lists>

=cut

__PACKAGE__->table("lists");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 bans_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 pattern

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "bans_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "pattern",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 ban

Type: belongs_to

Related object: L<BanManager::Schema::Result::Ban>

=cut

__PACKAGE__->belongs_to(
  "ban",
  "BanManager::Schema::Result::Ban",
  { id => "bans_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-10-09 22:22:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1LI9w/RGdb3oQZe7HPE6AA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
