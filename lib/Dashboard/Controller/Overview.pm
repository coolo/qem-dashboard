# Copyright (C) 2020 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

package Dashboard::Controller::Overview;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub blocked ($self) {
  $self->respond_to(json => {json => $self->incidents->blocked}, any => sub { $self->render; });
}

sub index ($self) {
  $self->respond_to(
    json => {json => $self->incidents->find},
    any  => sub {
      $self->render;
    }
  );
}

sub incident ($self) {
  my $number    = $self->param('incident');
  my $incidents = $self->incidents;
  my $incident  = $incidents->incident_for_number($number);

  my $jobs = $incidents->openqa_summary_only_aggregates($incident);
  $self->respond_to(
    json => {json => {jobs => $jobs, incident => $incident}},
    any  => sub {
      $self->render(jobs => $jobs, incident => $incident);
    }
  );
}

sub repos ($self) {
  $self->respond_to(
    json => {json => $self->incidents->repos},
    any  => sub {
      $self->render;
    }
  );
}

sub vue ($self) {

}
1;
