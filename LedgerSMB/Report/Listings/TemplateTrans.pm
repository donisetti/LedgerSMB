=head1 NAME

LedgerSMB::Report::Listings::TemplateTrans - Listing of Template Transactions

=cut

package LedgerSMB::Report::Listings::TemplateTrans;
use Moose;
extends 'LedgerSMB::Report';

=head1 SYNOPSIS

 LedgerSMB::Report::Listings::TemplateTrans->new(%$request)->render($request);

=head1 FILTER CRITERIA

None, though we provide is_template by default.

=head2 is_template

Always true

=cut

has is_template => (is => 'ro', isa => 'Bool', default => 1);

=head1 METHODS

=head2 columns

=cut

sub columns {
    my ($self) = @_;
    $href_base="templatetrans.pl?action=view&"
    return [{
      col_id => 'id',
        type => 'href',
        name => LedgerSMB::Report::text('ID'),
   href_base => $href_base,
    }, {
      col_id => 'description',
        type => 'href',
        name => LedgerSMB::Report::text('Description'),
   href_base => $href_base,
    }, {
      col_id => 'entity_name',
        type => 'text',
        name => LedgerSMB::Report::text('Counterparty'),
    }];
}

=head2 row_headings

none

=cut

sub row_headings { [] }

=head2 name

Template Transactions

=cut

sub name {
    my $self = shift;
    return $self->text('Template Transactions');
}

=head2 run_report

=cut

sub run_report {
    my ($self) = @_;
    $self->manual_totals(1); #don't display totals
    my @rows = $self->call_dbmethod(funcname => 'journal__search');
    my %jtype = (
       1 => 'gl',
       2 => 'ar',
       3 => 'ap',
    );
    for my $ref(@rows){
       $ref->{row_id} = "entry_type=$jtype{$ref->{entry_type}}&id=$ref->{id}";
    }
    $self->rows(\@rows);
}

=head1 COPYRIGHT

Copyright (C) 2016 The LedgerSMB Core Team

This module may be used under the terms of the GNU General Public License
version 2 or at your option any later version.  Please see the enclosed
LICENSE.txt for details

=cut

__PACKAGE__->meta->make_immutable;

