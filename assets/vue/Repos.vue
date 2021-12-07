<template>
  <div>
    <table class="table" v-if="repos">
      <thead>
        <tr>
          <th>Group</th>
          <th>Tests</th>
        </tr>
      </thead>
      <tbody>
        <tr is="repo-line" v-for="(repo, name) in repos" v-bind:repo="repo" v-bind:name="name" v-bind:key="name"></tr>
      </tbody>
    </table>
    <div v-else>Loading repos...</div>
    <repo-incidents-dialog ref="incidentsDialog" />
  </div>
</template>

<script>
import RepoIncidentDialogComponent from './RepoIncidentDialog.vue';
import RepoLineComponent from './RepoLine.vue';
import axios from 'axios';

export default {
  name: 'ReposComponent',
  components: {'repo-incidents-dialog': RepoIncidentDialogComponent, 'repo-line': RepoLineComponent},
  created() {
    this.loadData();
  },
  data() {
    return {repos: null};
  },
  methods: {
    loadData: function () {
      axios.get('/secret/api/repos').then(response => {
        this.repos = response.data;
      });
    }
  }
};
</script>
