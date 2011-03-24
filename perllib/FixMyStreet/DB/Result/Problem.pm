package FixMyStreet::DB::Result::Problem;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("FilterColumn");
__PACKAGE__->table("problem");
__PACKAGE__->add_columns(
    "id",
    {
        data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
        sequence          => "problem_id_seq",
    },
    "postcode",
    { data_type => "text", is_nullable => 0 },
    "council",
    { data_type => "text", is_nullable => 1 },
    "areas",
    { data_type => "text", is_nullable => 0 },
    "category",
    { data_type => "text", default_value => "Other", is_nullable => 0 },
    "title",
    { data_type => "text", is_nullable => 0 },
    "detail",
    { data_type => "text", is_nullable => 0 },
    "photo",
    { data_type => "bytea", is_nullable => 1 },
    "used_map",
    { data_type => "boolean", is_nullable => 0 },
    "name",
    { data_type => "text", is_nullable => 0 },
    "anonymous",
    { data_type => "boolean", is_nullable => 0 },
    "created",
    {
        data_type     => "timestamp",
        default_value => \"ms_current_timestamp()",
        is_nullable   => 0,
    },
    "confirmed",
    { data_type => "timestamp", is_nullable => 1 },
    "state",
    { data_type => "text", is_nullable => 0 },
    "lang",
    { data_type => "text", default_value => "en-gb", is_nullable => 0 },
    "service",
    { data_type => "text", default_value => "", is_nullable => 0 },
    "cobrand",
    { data_type => "text", default_value => "", is_nullable => 0 },
    "cobrand_data",
    { data_type => "text", default_value => "", is_nullable => 0 },
    "lastupdate",
    {
        data_type     => "timestamp",
        default_value => \"ms_current_timestamp()",
        is_nullable   => 0,
    },
    "whensent",
    { data_type => "timestamp", is_nullable => 1 },
    "send_questionnaire",
    { data_type => "boolean", default_value => \"true", is_nullable => 0 },
    "latitude",
    { data_type => "double precision", is_nullable => 0 },
    "longitude",
    { data_type => "double precision", is_nullable => 0 },
    "user_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
    "user",
    "FixMyStreet::DB::Result::User",
    { id            => "user_id" },
    { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-03-24 17:36:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+a9n7IKg3yFdgxNIbo3SGg

=head2 check_for_errors

    $error_hashref = $problem->check_for_errors();

Look at all the fields and return a hashref with all errors found, keyed on the
field name. This is intended to be passed back to the form to display the
errors.

TODO - ideally we'd pass back error codes which would be humanised in the
templates (eg: 'missing','email_not_valid', etc).

=cut

sub check_for_errors {
    my $self = shift;

    my %errors = ();

    $errors{title} = _('Please enter a subject')
      unless $self->title =~ m/\S/;

    $errors{detail} = _('Please enter some details')
      unless $self->detail =~ m/\S/;

    $errors{council} = _('No council selected')
      unless $self->council
          && $self->council =~ m/^(?:-1|[\d,]+(?:\|[\d,]+)?)$/;

    if ( $self->name !~ m/\S/ ) {
        $errors{name} = _('Please enter your name');
    }
    elsif (length( $self->name ) < 5
        || $self->name !~ m/\s/
        || $self->name =~ m/\ba\s*n+on+((y|o)mo?u?s)?(ly)?\b/i )
    {
        $errors{name} = _(
'Please enter your full name, councils need this information - if you do not wish your name to be shown on the site, untick the box'
        );
    }

    if (   $self->category
        && $self->category eq _('-- Pick a category --') )
    {
        $errors{category} = _('Please choose a category');
        $self->category(undef);
    }
    elsif ($self->category
        && $self->category eq _('-- Pick a property type --') )
    {
        $errors{category} = _('Please choose a property type');
        $self->category(undef);
    }

    return \%errors;
}

