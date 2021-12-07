<template>
  <div v-if="incidents">
    <div class="float-right">
      <input type="checkbox" id="checkbox" v-model="groupFlavors" />
      <label for="checkbox">Group Flavors</label>
    </div>
    <table class="table">
      <thead>
        <tr>
          <th>Incident</th>
          <th>Groups</th>
        </tr>
      </thead>
      <tbody>
        <tr
          is="blocked-incident"
          v-for="incident in incidents"
          v-bind:key="incident.incident.number"
          v-bind:incident="incident.incident"
          v-bind:incidentResults="incident.incident_results"
          v-bind:updateResults="incident.update_results"
          v-bind:groupFlavors="groupFlavors"
        ></tr>
      </tbody>
    </table>
  </div>
  <div v-else>Loading incidents...</div>
</template>

<script>
import axios from 'axios';
import BlockedIncidentComponent from './BlockedIncident.vue';

export default {
  name: 'BlockedComponent',
  components: {'blocked-incident': BlockedIncidentComponent},
  data() {
    return {
      incidents: null,
      groupFlavors: true
    };
  },
  created() {
    this.loadData();
  },
  watch: {
    $route: 'loadData'
  },
  methods: {
    loadData() {
      axios.get('/secret/api/blocked').then(response => (this.incidents = response.data));
    }
  }
};
</script>
