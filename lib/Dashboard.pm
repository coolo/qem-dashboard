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

package Dashboard;
use Mojo::Base 'Mojolicious', -signatures;

use Mojo::Pg;
use Dashboard::Model::Incidents;
use Dashboard::Model::Jobs;
use Dashboard::Model::Settings;
use Dashboard::Model::AMQP;

# This method will run once at server start
sub startup ($self) {

  # Custom config file for qem2 deployment
  my $custom_file = '/home/lurklur/dashboard.yml';

  # Load configuration from config file
  my $file   = $ENV{DASHBOARD_CONF} || (-r $custom_file ? $custom_file : 'dashboard.yml');
  my $config = $self->plugin(NotYAMLConfig => {file => $file});
  $self->secrets($config->{secrets});

  # Short logs for systemd
  if ($self->mode eq 'production') {
    $self->log->short(1);

    # All interesting log messages are "info" or higher
    $self->log->level('info');
    $self->hook(
      before_routes => sub ($c) {
        my $req     = $c->req;
        my $method  = $req->method;
        my $url     = $req->url->to_abs->to_string;
        my $started = [Time::HiRes::gettimeofday];
        $c->tx->on(
          finish => sub ($tx, @args) {
            my $code    = $tx->res->code;
            my $elapsed = Time::HiRes::tv_interval($started, [Time::HiRes::gettimeofday()]);
            my $rps     = $elapsed == 0 ? '??' : sprintf '%.3f', 1 / $elapsed;
            $self->log->info(qq{$method $url -> $code (${elapsed}s, $rps/s)});
          }
        );
      }
    );
  }

  # Application specific commands
  push @{$self->commands->namespaces}, 'Dashboard::Command';

  $self->plugin('Dashboard::Plugin::JSON');
  $self->plugin('Dashboard::Plugin::Helpers');
  $self->plugin(Webpack => {process => [qw(js css sass vue)]});

  # Compress dynamically generated content
  $self->renderer->compress(1);

  # Model
  $self->helper(pg        => sub { state $pg        = Mojo::Pg->new($config->{pg})->max_connections(1) });
  $self->helper(incidents => sub { state $incidents = Dashboard::Model::Incidents->new(pg => shift->pg) });
  $self->helper(jobs      => sub { state $jobs     = Dashboard::Model::Jobs->new(pg => shift->pg, log => $self->log) });
  $self->helper(settings  => sub { state $settings = Dashboard::Model::Settings->new(pg => shift->pg) });
  $self->helper(amqp      => sub { state $amqp = Dashboard::Model::AMQP->new(log => $self->log, jobs => shift->jobs) });

  # Status plugin
  my $public = $self->routes;
  if (my $status = $config->{status}) {
    my $admin = $public->under(
      '/status' => sub ($c) {
        return 1 if $c->req->url->to_abs->userinfo eq "admin:$status";
        $c->res->headers->www_authenticate('Basic');
        $c->render(text => 'Authentication required!', status => 401);
        return undef;
      }
    );
    $self->plugin('Status' => {route => $admin});
  }

  # Migrations
  my $path = $self->home->child('migrations', 'dashboard.sql');
  $self->pg->auto_migrate(1)->migrations->name('dashboard')->from_file($path);

  # Authentication
  my $token = $public->under('/')->to('Auth::Token#check');

  # Dashboard UI JSON
  my $json = $public->any('/json' => [format => ['json']])->to(format => undef);
  $json->get('/list')->to('overview#list');
  $json->get('/blocked')->to('overview#blocked');
  $json->get('/repos')->to('overview#repos');
  $json->get('/incident/<incident:num>')->to('overview#incident');
  $public->get('/*whatever' => [whatever => qr/.*/])->to('overview#index')->name('index');

  # API
  my $api = $token->any('/api');
  $api->get('/incidents/<incident:num>')->to('API::Incidents#show');
  $api->get('/incidents')->to('API::Incidents#list');
  $api->patch('/incidents/<incident:num>')->to('API::Incidents#update');
  $api->patch('/incidents')->to('API::Incidents#sync');
  $api->get('/incident_settings/<incident:num>')->to('API::Settings#get_incident_settings');
  $api->put('/incident_settings')->to('API::Settings#add_incident_settings');
  $api->get('/update_settings/<incident:num>')->to('API::Settings#get_update_settings');
  $api->get('/update_settings')->to('API::Settings#search_update_settings');
  $api->put('/update_settings')->to('API::Settings#add_update_settings');
  $api->get('/jobs/<job_id:num>')->to('API::Jobs#show');
  $api->put('/jobs')->to('API::Jobs#add');
  $api->get('/jobs/incident/<incident_settings:num>')->to('API::Jobs#incidents');
  $api->get('/jobs/update/<update_settings:num>')->to('API::Jobs#updates');
}

1;

=encoding utf8

=head1 NAME

qem-dashboard

=head1 SYNOPSIS

  use Dashboard;

=head1 AUTHORS

=over 2

Sebastian Riedel, C<sriedel@suse.de>

Stephan Kulow, C<coolo@suse.de>

=back

=head1 COPYRIGHT AND LICENSE

 Copyright (C) 2020 SUSE Linux GmbH

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along
 with this program; if not, see <http://www.gnu.org/licenses/>.

=cut
