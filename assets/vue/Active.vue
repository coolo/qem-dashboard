<template>
  <table class="table" v-if="incidents">
    <thead>
      <tr>
        <th>Incident</th>
        <th>State</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="incident in testing_incidents" :key="incident.number">
        <td><incident-link :incident="incident" /></td>
        <td>
          <a :href="'/blocked#' + incident.number">
            <span class="badge badge-primary">testing</span>
          </a>
        </td>
      </tr>
      <tr v-for="incident in staged_incidents" :key="incident.number">
        <td><incident-link :incident="incident" /></td>
        <td><span class="badge badge-secondary">staged</span></td>
      </tr>
      <tr v-for="incident in approved_incidents" :key="incident.number">
        <td><incident-link :incident="incident" /></td>
        <td><span class="badge badge-success">approved</span></td>
      </tr>
    </tbody>
  </table>
  <div v-else>Loading incidents...</div>
</template>

<script>
import IncidentLinkComponent from './IncidentLink.vue';
import axios from 'axios';

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
    approved_incidents: function () {
      return this.incidents.filter(incident => incident.approved == 1);
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
