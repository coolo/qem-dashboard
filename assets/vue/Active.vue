<template>
  <table class="table" v-if="incidents">
    <thead>
      <tr>
        <th>Incident</th>
        <th>State</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="incident in testing_incidents" v-bind:blocked_url="blocked_url" v-bind:key="incident.number">
        <td><incident-link v-bind:incident="incident"></incident-link></td>
        <td>
          <a v-bind:href="blocked_url + '#' + incident.number">
            <span class="badge badge-primary">testing</span>
          </a>
        </td>
      </tr>
      <tr v-for="incident in staged_incidents" v-bind:key="incident.number">
        <td><incident-link v-bind:incident="incident"></incident-link></td>
        <td><span class="badge badge-secondary">staged</span></td>
      </tr>
    </tbody>
  </table>
  <div v-else>Loading incidents...</div>
</template>

<script>
import axios from 'axios';
import IncidentLinkComponent from './IncidentLink.vue';

export default {
  name: 'ActiveComponent',
  data: function () {
    return {
      incidents: null
    };
  },
  components: {'incident-link': IncidentLinkComponent},
  computed: {
    testing_incidents: function () {
      return this.incidents.filter(incident => incident.rr_number > 0 && incident.approved == 0);
    },
    staged_incidents: function () {
      return this.incidents.filter(incident => !incident.rr_number && incident.approved == 0);
    },
    blocked_url: function () {
      return blocked_url;
    }
  },
  created() {
    this.loadData();
  },
  methods: {
    loadData: function () {
      axios.get('/secret/api/list').then(response => (this.incidents = response.data));
    }
  }
};
</script>
