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

package Dashboard::Model::Jobs;
use Mojo::Base -base, -signatures;

has [qw(pg log)];

sub add ($self, $job) {
  my $db = $self->pg->db;
  $db->query(
    'INSERT INTO openqa_jobs (incident_settings, update_settings, name, job_group, job_id, group_id, status, distri,
      flavor, version, arch, build) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
     ON CONFLICT (distri, flavor, arch, version, build, name)
     DO UPDATE SET job_group = EXCLUDED.job_group, job_id = EXCLUDED.job_id, group_id = EXCLUDED.group_id,
       status = EXCLUDED.status, updated = NOW()', $job->{incident_settings}, $job->{update_settings}, $job->{name},
    $job->{job_group}, $job->{job_id}, $job->{group_id}, $job->{status}, $job->{distri}, $job->{flavor},
    $job->{version},   $job->{arch},   $job->{build}
  );
}

sub get ($self, $job_id) {
  return $self->pg->db->query(
    'SELECT incident_settings, update_settings, name, job_group, job_id, group_id, status, distri, flavor, version,
       arch, build
     FROM openqa_jobs where job_id = ? LIMIT 1', $job_id
  )->hash;
}

sub get_incident_settings ($self, $incident_settings) {
  return $self->pg->db->query(
    'SELECT incident_settings, update_settings, name, job_group, job_id, group_id, status, distri, flavor, version,
       arch, build
     FROM openqa_jobs where incident_settings = ?', $incident_settings
  )->hashes->to_array;
}

sub get_update_settings ($self, $update_settings) {
  return $self->pg->db->query(
    'SELECT incident_settings, update_settings, name, job_group, job_id, group_id, status, distri, flavor, version,
       arch, build
     FROM openqa_jobs where update_settings = ?', $update_settings
  )->hashes->to_array;
}

sub latest_update ($self) {
  return undef
    unless my $array
    = $self->pg->db->query('SELECT EXTRACT(EPOCH FROM updated) FROM openqa_jobs ORDER BY updated DESC LIMIT 1')->array;
  return $array->[0];
}

sub update_result ($self, $id, $result) {
  my $normalized = _normalize_result($result);

  return unless my $res = $self->pg->db->query(
    'UPDATE openqa_jobs
     SET status = ?, updated = NOW()
     WHERE job_id = ?
     RETURNING job_id', $normalized, $id
  )->hash;
  $self->log->info("$id: $normalized ($result)");
}

sub restart_job ($self, $old_id, $new_id) {
  $self->log->info("restart $old_id -> $new_id");
  $self->pg->db->query("UPDATE openqa_jobs set job_id=?, status='waiting' where job_id=?", $new_id, $old_id);
}

sub _normalize_result ($result) {
  return 'passed'  if $result eq 'passed' || $result eq 'softfailed';
  return 'waiting' if $result eq 'none';
  return 'stopped'
    if grep { $result eq $_ }
    qw(timeout_exceeded incomplete obsoleted parallel_failed skipped parallel_restarted user_cancelled user_restarted);
  return 'failed' if $result eq 'failed';
  return 'failed';
}

1;
