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
        <RepoLine v-for="(repo, name) in repos" :repo="repo" :name="name" :key="name" />
      </tbody>
    </table>
    <div v-else><i class="fas fa-sync fa-spin"></i> Loading repos...</div>
    <RepoIncidentDialog ref="incidentsDialog"></RepoIncidentDialog>
  </div>
</template>

<script>
import Refresh from '../mixins/refresh.js';
import RepoIncidentDialog from './RepoIncidentDialog.vue';
import RepoLine from './RepoLine.vue';

export default {
  name: 'PageRepos',
  mixins: [Refresh],
  components: {RepoIncidentDialog, RepoLine},
  data() {
    return {
      repos: null,
      refreshUrl: '/app/api/repos'
    };
  },
  methods: {
    refreshData(data) {
      this.repos = data.repos;
    }
  }
};
</script>
